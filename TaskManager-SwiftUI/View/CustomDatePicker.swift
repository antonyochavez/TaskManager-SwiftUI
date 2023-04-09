//
//  CustomDatePicker.swift
//  TaskManager-SwiftUI
//
//  Created by Antonio Chavez Saucedo on 08/04/23.
//

import SwiftUI


struct CustomDatePicker: View {
    @Binding var currentDate : Date
    @State var currentMonth : Int = 0
    var body: some View {
        VStack(spacing:35){
            // Days
            let days : [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            HStack(spacing : 20) {
                
                VStack(alignment : .leading, spacing: 10){
                    Text(extractDate()[0])
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    Text(extractDate()[1])
                        .font(.title.bold())
                }
                Spacer(minLength: 0)
                Button {
                    withAnimation{
                        currentMonth -= 1
                    }
                } label : {
                    Image(systemName: "chevron.left")
                }
                
                Button {
                    withAnimation{
                        currentMonth += 1
                    }
                } label : {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal)
            //Day View
            HStack(spacing : 0){
                ForEach(days,id : \.self){ day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth : .infinity)
                }
            }
            // Dates
            //Lazy Grid
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            LazyVGrid(columns : columns, spacing: 5){
                ForEach(extractDate()){ value in
                    CardView(value: value)
                        .background(
                            Capsule()
                                .fill(Color.pink)
                                .padding(.horizontal, 8)
                                .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 :0)
                        )
                        .onTapGesture {
                            currentDate = value.date
                        }
                }
            }
        
            VStack(spacing : 15){
                Text("Tasks")
                    .font(.title2.bold())
                    .frame(maxWidth : .infinity, alignment : .leading)
                    .padding(.vertical, 20)
                
                if let taskMetaData = tasksMetaData.first(where: { taks in
                    return isSameDay(date1: taks.taskDate, date2: currentDate)
                }){
                    ForEach(taskMetaData.tasks){ task in
                        VStack(alignment : .leading, spacing: 10){
                            
                            Text(task.time                                .addingTimeInterval(CGFloat.random(in: 0...5000)), style : .time)
                            
                            Text(task.title)
                                .font(.title2.bold())
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .frame(maxWidth : .infinity, alignment : .leading)
                        .background(
                            Color.pink
                                .opacity(0.2)
                                .cornerRadius(10)
                        )
                    }
                }else{
                    Text("No task Found")
                }
            }
            .padding()
            
        }
        .onChange(of: currentMonth) { nreValue in
            currentDate = getCurrectMonth()
        }
    }
    
    @ViewBuilder
    func CardView(value : DateValue) -> some View{
        VStack{
            if value.day != -1 {
                if let task = tasksMetaData.first(where: { task in
                    return isSameDay(date1: task.taskDate, date2: value.date)
                }){
                    let isSame = isSameDay(date1: task.taskDate, date2: currentDate)
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSame ? .white : Color.primary)
                        .frame(maxWidth : .infinity)
                    Spacer()
                    Circle()
                        .fill(isSame ? .white : Color.pink)
                        .frame(width: 8, height: 8)
                } else{
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? .white : Color.primary)
                        .frame(maxWidth : .infinity)
                    Spacer()
                }
            }
        }
        .padding(.vertical, 8)
        .frame(height : 60, alignment: .top)
    }
    
    func isSameDay(date1 : Date, date2 : Date)-> Bool{
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func extractDate() -> [String]{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        let date = formatter.string(from: currentDate)
        return date.components(separatedBy: " ")
    }
    
    func getCurrectMonth()->Date{
        let calendar = Calendar.current
        // Getting Current Month Date
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        return currentMonth
    }
    
    func extractDate() -> [DateValue]{
        let calendar = Calendar.current
        
        // Getting Current Month Date
        let currentMonth = getCurrectMonth()
        
        var days = currentMonth.getAllDates().compactMap{
            date -> DateValue in
            let day = calendar.component(.day, from: date)
            return DateValue(day: day, date: date)
        }
        
        // adding offset days to get exact week day...
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        return days
    }
    
}



extension Date {
    func getAllDates() -> [Date]{
        let calendar = Calendar.current
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        var range = calendar.range(of: .day, in: .month, for: startDate)!
        range.removeLast()
        return range.compactMap{ day -> Date in
            return calendar.date(byAdding: .day, value: day, to: startDate)!
        }
    }
}


struct CustomDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

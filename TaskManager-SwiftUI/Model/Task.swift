//
//  Task.swift
//  TaskManager-SwiftUI
//
//  Created by Antonio Chavez Saucedo on 08/04/23.
//

import SwiftUI


struct Task : Identifiable{
    var id = UUID().uuidString
    var title : String
    var time : Date = Date()
}

struct TaskMetaData : Identifiable{
    var id = UUID().uuidString
    var tasks : [Task]
    var taskDate : Date
}

func getSampleDate(offset : Int) -> Date{
    let caledar = Calendar.current
    let date = caledar.date(byAdding: .day, value: offset, to: Date())
    return date ?? Date()
}

var tasksMetaData : [TaskMetaData] = [
    TaskMetaData(tasks: [
        Task(title: "Talk to iJusnite1"),
        Task(title: "Talk to iJusnite2"),
        Task(title: "Design Iphone 3"),
    ], taskDate: getSampleDate(offset: 1)),
    TaskMetaData(tasks: [
        Task(title: "Talk to iJusnite3"),
        Task(title: "Talk to iJusnite4"),
        Task(title: "Design Iphone 5"),
    ], taskDate: getSampleDate(offset: -2)),
    TaskMetaData(tasks: [
        Task(title: "Talk to iJusnite6"),
        Task(title: "Talk to iJusnite7"),
        Task(title: "Design Iphone 8"),
    ], taskDate: getSampleDate(offset: 3)),
]

//
//  Task.swift
//  ToDo
//
//  Created by Avi Sharma on 11/26/24.
//


import Foundation

struct Task: Identifiable {
    let id = UUID()
    var name: String
    var description: String
    var progress: Double // Between 0.0 and 1.0
    var isCompleted: Bool
}

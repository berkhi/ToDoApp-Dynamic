//
//  Models.swift
//  ToDoApp
//
//  Created by BerkH on 27.04.2023.
//

import Foundation

struct Response: Codable {
    let data: [TodoItem]
    let error, errors: String?
}

struct TodoItem: Codable {
    let id: Int
    let name: String
    let deviceInfo: String
}

struct TodoItemPost: Codable {
    let name: String
    let deviceInfo: String
}

struct TodoListItemResponse: Codable {
    let data: [TodoListItem]
    let error, errors: String?
}

struct TodoListItem: Codable{
    let id: Int
    let name: String
    let description: String
    let todoListId: Int
}

struct TodoListItemPost: Codable {
    let name: String
    let description: String
    let todoListId: Int
}

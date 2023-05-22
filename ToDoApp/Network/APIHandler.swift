//
//  APIHandler.swift
//  ToDoApp
//
//  Created by BerkH on 27.04.2023.
//

import Foundation
import Alamofire

class APIHandler {
    var uuid = UIDevice.current.identifierForVendor!.uuidString
    static let sharedInstance = APIHandler()
    
    func getData(completion: @escaping (Result<Response, Error>) -> Void) {
        let url = "http://localhost:5105/api/Todos/get_todolist?deviceInfo=\(uuid)"
        //print(uuid)
        AF.request(url).responseDecodable(of: Response.self) { response in
            switch response.result {
            case .success(let data):
                print(data)
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getDataListItem(todoListId: Int, completion: @escaping (Result<TodoListItemResponse, Error>) -> Void) {
        let url = "http://localhost:5105/api/Todos/get_todolist_items_by_id?todolistId=\(todoListId)"
        AF.request(url).responseDecodable(of: TodoListItemResponse.self) { response in
            switch response.result {
            case .success(let data):
                print("Success: \(data)")
                completion(.success(data))
            case .failure(let error):
                print("Failure: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func postTodoItem(todoItem: TodoItemPost, completion: @escaping (Result<Data?, Error>) -> Void) {
        let url = "http://localhost:5105/api/Todos/add_todo"
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        
        AF.request(url, method: .post, parameters: todoItem, encoder: JSONParameterEncoder.default, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func postTodoListItem(todoListItem: TodoListItemPost, completion: @escaping (Result<Data?, Error>) -> Void) {
        let url = "http://localhost:5105/api/Todos/add_todolist_item"
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        
        AF.request(url, method: .post, parameters: todoListItem, encoder: JSONParameterEncoder.default, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteTodoList(todoListId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let parameters: [String: Any] = ["todoListId": todoListId]
        AF.request("http://localhost:5105/api/Todos/delete_todolist?todoListId=\(todoListId)", method: .delete, parameters: parameters).response { response in
            switch response.result {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteTodoListItem(todoListItemId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let parameters: [String: Any] = ["todoListId": todoListItemId]
        AF.request("http://localhost:5105/api/Todos/delete_todolist_item?todoListItemId=\(todoListItemId)", method: .delete, parameters: parameters).response { response in
            switch response.result {
            case .success(_):
                print(response.result)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}



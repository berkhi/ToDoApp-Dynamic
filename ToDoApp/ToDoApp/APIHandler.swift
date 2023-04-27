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
}


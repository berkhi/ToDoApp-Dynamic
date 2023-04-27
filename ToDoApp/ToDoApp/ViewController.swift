//
//  ViewController.swift
//  ToDoApp
//
//  Created by BerkH on 25.04.2023.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet var uivMain: UIView!
    
    @IBOutlet var tblList: UITableView!
    @IBOutlet var btnAdd: UIButton!
    
    var tblListConstraint: NSLayoutConstraint?
    var uivMainConstraint: NSLayoutConstraint?
    var todoItem: [TodoItem] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "ToDo:"
        fetchData()
        
        
        tblList.delegate = self
        tblList.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tblListConstraint = tblList.constraints.first { $0.firstAttribute == .height }
        uivMainConstraint = uivMain.constraints.first { $0.firstAttribute == .height }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //tblListConstraint?.constant = 500.0
        if todoItem.count * Int(CGFloat(50.0)) > Int(uivMainConstraint?.constant ?? 0 - 300) {
            tblListConstraint?.constant = 500.0
        } else {
            tblListConstraint?.constant = CGFloat(todoItem.count) * 50.0
        }
    }
    func fetchData() {
        APIHandler.sharedInstance.getData { (result: Result<Response, Error>) in
            switch result {
            case .success(let data):
                print(data.data)
                self.todoItem = data.data
                self.tblList.reloadData()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! tblList
        let currentItem = todoItem[indexPath.row]
        cell.lblTodoItem.text = currentItem.name
        return cell
    }
    
    
}




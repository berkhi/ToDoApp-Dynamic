//
//  TodoListItemVC.swift
//  ToDoApp
//
//  Created by BerkH on 3.05.2023.
//

import UIKit
import Alamofire

class TodoListItemVC: UIViewController {
    
    @IBOutlet var uivListItem: UIView!
    
    @IBOutlet weak var tblListItem: UITableView!
    @IBOutlet var btnAddItem: UIButton!
    
    var tblListItemConstraint: NSLayoutConstraint?
    var uivMainConstraint: NSLayoutConstraint?
    var todoListItem: [TodoListItem] = []
    var todoID = Int()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ToDo List:"
        AnimationManager.shared.setupAnimation(in: view)
        
        tblListItem.delegate = self
        tblListItem.dataSource = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tblListItemConstraint = tblListItem.constraints.first { $0.firstAttribute == .height }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        uivMainConstraint = uivListItem.constraints.first { $0.firstAttribute == .height }
        fetchData()
        
    }
    
    func fetchData() {
        AnimationManager.shared.startAnimation()
        APIHandler.sharedInstance.getDataListItem(todoListId: todoID) { (result: Result<TodoListItemResponse, Error>) in
            switch result {
            case .success(let data):
                self.todoListItem = data.data
                self.tblListItem.reloadData()
                
                if self.todoListItem.count * Int(CGFloat(44.0)) > Int(self.uivMainConstraint!.constant - 300) {
                    self.tblListItemConstraint?.constant = 575.0
                } else {
                    self.tblListItemConstraint?.constant = CGFloat(self.todoListItem.count) * 44.0
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func btnAddItem(_ sender: Any) {
        
        let alert = UIAlertController(title: "Create List", message: nil, preferredStyle: .alert)
        alert.addTextField{ textfielfs in
            textfielfs.placeholder = "Enter your task"
            textfielfs.returnKeyType = .next
            textfielfs.keyboardType = .default
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {action in
            print("continue tapped")
            if let text = alert.textFields?.first?.text,
               let descriptionText = alert.textFields?.last?.text {
                let newTodo = TodoListItemPost(name: text, description: descriptionText, todoListId: self.todoID)
                APIHandler.sharedInstance.postTodoListItem(todoListItem: newTodo) { result in
                    switch result {
                    case .success(let data):
                        print("Data successfully posted \(data)")
                        print(self.todoID)
                        self.fetchData()
                    case .failure(let error):
                        print("Error posting data: \(error.localizedDescription)")
                    }
                }
            }
        }))
        present(alert, animated: true)
    }
    
}

extension TodoListItemVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoListItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoListItemCell", for: indexPath) as! tblListItem
        let currentItem = todoListItem[indexPath.row]
        print(currentItem.name)
        cell.lblTodoListItem.text = currentItem.name
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let currentItem = todoListItem[indexPath.row]
            APIHandler.sharedInstance.deleteTodoListItem(todoListItemId: currentItem.id) { result in
                print(currentItem.id)
                switch result {
                case .success(_):
                    self.todoListItem.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                case .failure(let error):
                    print("Error deleting data: \(error.localizedDescription)")
                }
            }

        }
    }
}

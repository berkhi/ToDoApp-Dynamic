//
//  ViewController.swift
//  ToDoApp
//
//  Created by BerkH on 25.04.2023.
//

import UIKit
import Alamofire
import Lottie

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
        AnimationManager.shared.setupAnimation(in: view)
        fetchData()
        
        
        tblList.delegate = self
        tblList.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tblListConstraint = tblList.constraints.first { $0.firstAttribute == .height }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        uivMainConstraint = uivMain.constraints.first { $0.firstAttribute == .height }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueVCToDetail" {
            if let destinationVC = segue.destination as? TodoListItemVC {
                if let selectedItem = sender as? TodoItem {
                    destinationVC.todoID = selectedItem.id
                }
            }
        }
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        
        let alert = UIAlertController(title: "Create Task", message: nil, preferredStyle: .alert)
        alert.addTextField{ textfields in
            textfields.placeholder = "Enter your task"
            textfields.returnKeyType = .next
            textfields.keyboardType = .default
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {action in
            print("continue tapped")
            if let text = alert.textFields?.first?.text {
                let newTodo = TodoItemPost(name: text, deviceInfo: APIHandler.sharedInstance.uuid)
                APIHandler.sharedInstance.postTodoItem(todoItem: newTodo) { result in
                    switch result {
                    case .success(let data):
                        print("Data successfully posted \(data)")
                        self.fetchData()
                    case .failure(let error):
                        print("Error posting data: \(error.localizedDescription)")
                    }
                }
            }
        }))
        present(alert, animated: true)
    }

    func fetchData() {
        AnimationManager.shared.startAnimation()
        APIHandler.sharedInstance.getData { (result: Result<Response, Error>) in
            switch result {
            case .success(let data):
                print(data.data)
                self.todoItem = data.data
                self.tblList.reloadData()
                
                
                if self.todoItem.count * Int(CGFloat(44.0)) > Int(self.uivMainConstraint!.constant - 300) {
                    self.tblListConstraint?.constant = 500.0
                } else {
                    self.tblListConstraint?.constant = CGFloat(self.todoItem.count) * 44.0
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            //self.stopAnimation()
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = todoItem[indexPath.row]
        performSegue(withIdentifier: "segueVCToDetail", sender: selectedItem)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let currentItem = todoItem[indexPath.row]
            APIHandler.sharedInstance.deleteTodoList(todoListId: currentItem.id) { result in
                print(currentItem.id)
                switch result {
                case .success(_):
                    self.todoItem.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                case .failure(let error):
                    print("Error deleting data: \(error.localizedDescription)")
                }
            }
            
        }
    }
}




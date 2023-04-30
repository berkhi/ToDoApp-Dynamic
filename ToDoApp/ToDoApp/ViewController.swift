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
    var popUp: PopUp!
    
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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        uivMainConstraint = uivMain.constraints.first { $0.firstAttribute == .height }
        
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        
        let alert = UIAlertController(title: "Create Task", message: nil, preferredStyle: .alert)
        alert.addTextField{ textfielfs in
            textfielfs.placeholder = "Enter your task"
            textfielfs.returnKeyType = .next
            textfielfs.keyboardType = .default
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
        
        //        let popupVC = BtnAddPopUp(nibName: "BtnAddPopUp", bundle: nil)
        //        popupVC.modalPresentationStyle = .overFullScreen
        //        popupVC.onDismiss = {
        //            self.fetchData()
        //        }
        //        present(popupVC, animated: true, completion: nil)
        
        
        //        self.popUp = PopUp(frame: self.view.frame)
        //        popUp.btnCreate.addTarget(self, action: #selector(createButtonPressed), for: .touchUpInside)
        //        self.view.addSubview(popUp)
    }
    
    //    @objc func createButtonPressed(){
    //        print("button tapped")
    //        self.popUp.removeFromSuperview()
    //    }
    //
    func fetchData() {
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




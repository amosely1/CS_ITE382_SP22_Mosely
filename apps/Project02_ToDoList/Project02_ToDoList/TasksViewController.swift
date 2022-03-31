//
//  TasksViewController.swift
//  Project02_ToDoList
//
//  Created by Alyson Mosely on 3/27/22.
//

import UIKit

class TasksViewController: UIViewController {
    
    var task: String?
    @IBOutlet var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = task
        
     //   timeLabel.text = time
     //   locLabel.text = loc
        
    //    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(deleteTask))

    }
    
   // @objc func deleteTask(){
        
       // let newCount = count - 1
        
      //  UserDefaults().setValue(newCount, forKey: "count")
       // UserDefaults().setValue(nil, forKey: "task_\(currentPosition")
      
   // }
    

 

}

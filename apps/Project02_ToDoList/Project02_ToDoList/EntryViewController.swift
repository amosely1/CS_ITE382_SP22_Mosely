//
//  EntryViewController.swift
//  Project02_ToDoList
//
//  Created by Alyson Mosely on 3/27/22.
//

import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var field: UITextField!
    
    var update: (() -> Void)?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //have user hit enter to save input
        field.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTask))

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveTask()
        
        return true
    }
    
    @objc func saveTask(){
        
        guard let text = field.text, !text.isEmpty else  {
            return
        }
        
        //using user defaults to save
        
        guard let count = UserDefaults().value(forKey: "count") as? Int else{
            return
        }
    
        let newCount = count + 1
        
        UserDefaults().set(newCount, forKey: "count")
        UserDefaults().set(text, forKey: "task_\(newCount)")
        
        
    }
    


}

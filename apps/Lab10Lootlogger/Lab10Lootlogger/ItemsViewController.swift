//
//  ItemsViewController.swift
//  Lab10Lootlogger
//
//  Created by Alyson Mosely on 3/27/22.
//
import UIKit

class ItemsViewController: UITableViewController {
    var itemStore: ItemStore!
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Create an instance of UITableViewCell with default appearace
       // let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        
        //Get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        
        //Set the text on the cell with the descripton of the item
        //that is at the nth index of items, where n = row this cell
        //will appear in on the table view
        let item = itemStore.allItems[indexPath.row]
        
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = "$\(item.valueInDollars)"
        
        return cell
    }
    
    
    
}

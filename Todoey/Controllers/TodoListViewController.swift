//
//  ViewController.swift
//  Todoey
//
//  Created by XIPHIAS Softwares on 15/03/19.
//  Copyright © 2019 A&M. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let dataFilePAth = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
       print(dataFilePAth)
        
        loadItems()
        
      //  if let items  = defaults.array(forKey: "TodoListArray") as? [String] {
        //    itemArray = items
        //}
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        

     
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
       self.saveItems()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //what will happen once the user clicks the add Item Button on our alert

            let newItem = Item()
            self.saveItems()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            let encoder = PropertyListEncoder()
            do{
                let data = try encoder.encode(self.itemArray)
                try data.write(to: self.dataFilePAth!)
            }catch {
                print("Error encoding the item array, \(error)")
            }
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "creat new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        }
    func saveItems() {
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePAth!)
        }catch {
            print("Error encoding the item array, \(error)")
        }
        
        self.tableView.reloadData()
    }
    func loadItems() {
       if let data = try? Data(contentsOf: dataFilePAth!) {
        let decoder = PropertyListDecoder()
        do{
            itemArray = try decoder.decode([Item].self, from: data)
        }catch {
            print("Error encoding the item array, \(error)")
        }
        }
    }
    
    }

    



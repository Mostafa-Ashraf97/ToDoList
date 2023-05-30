//
//  ViewController.swift
//  ToDoList
//
//  Created by A on 30/05/2023.
//

import UIKit

class ViewController: UIViewController {
    
    var models:[ToDoListItem] = []
    @IBOutlet weak var myTableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
       title = "To Do List"
        getAllItems()
        myTableView.dataSource = self
        myTableView.delegate = self
    
        
    }
    func getAllItems() {
        do {
            models = try context.fetch(ToDoListItem.fetchRequest())
            DispatchQueue.main.async {
                self.myTableView.reloadData()
            }
        } catch{
            print(error.localizedDescription)
        }
        
}
    func creatItem(name: String){
        let newItem = ToDoListItem(context: context)
        newItem.name = name
        newItem.creationDate = Date()
        
        do {
            try context.save()
            getAllItems()
        } catch {
            
        }
        
    }
    func deleteItem(item: ToDoListItem) {
        context.delete(item)
        do {
            try context.save()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateItem(item: ToDoListItem, newName:String) {
        item.name = newName
        do {
            try context.save()
            getAllItems()
            
        } catch {
            
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Task", message: "Enter New Task", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { _ in
            guard let field = alert.textFields?[0], let text = field.text, !text.isEmpty else {return}
            self.creatItem(name: text)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = myTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = models[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
                
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myTableView.deselectRow(at: indexPath, animated: true)
        let model = models[indexPath.row]
        let editAlert = UIAlertController(title: "Edit your item here", message: nil, preferredStyle: .actionSheet)
        
        editAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        editAlert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            
            let alert = UIAlertController(title: "Edit Item", message: "Edit your item", preferredStyle: .alert)
            alert.addTextField()
            alert.textFields?[0].text = model.name
            
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
                guard let field = alert.textFields?[0], let newName = field.text, !newName.isEmpty else {return}
                self.updateItem(item: model, newName: newName)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true)
            }
            
                                         ))
        
        
        editAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.deleteItem(item: model)
            self.getAllItems()
        }))
        present(editAlert, animated: true)
        
    }
}

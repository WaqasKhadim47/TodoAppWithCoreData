//
//  ViewController.swift
//  TodoAppWithCoreData
//
//  Created by Waqas Khadim on 19/08/2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var items = [TodoListItem]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.name
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        let sheet = UIAlertController(title: "Edit", message: nil, preferredStyle: .actionSheet)
        
        
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: {
            [weak self] _ in
            
            let alert = UIAlertController(title: "Edit Item", message: "Edit your Item", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.name
            alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: {
                [weak self] _ in
                guard let field = alert.textFields?.first , let text = field.text, !text.isEmpty else {
                    return
                }
                
                self?.updateTask(item: item, name: text )
            }))
            
            self?.present(alert, animated: true)
            
            
        } ))
        
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {
            [weak self] _ in
            
            self?.deleteTask(item: item)
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(sheet, animated: true)
    }
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let tableView : UITableView = {
        let table = UITableView();
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CoreData TodoList"
        view.addSubview(tableView)
        getAllTask()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
    }
    
    @objc private func didTapAdd(){
        
        let alert = UIAlertController(title: "New Item", message: "Add new Item", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: {
            [weak self] _ in
            guard let field = alert.textFields?.first , let text = field.text, !text.isEmpty else {
                return
            }
            
            self?.createTask(name: text)
        }))
        
        present(alert, animated: true)
        
    }
    
    
    func getAllTask(){
        do {
            items = try context.fetch(TodoListItem.fetchRequest())
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
        catch {
            // error occur
        }
        
        
        
    }
    
    func createTask(name : String){
        let newItem = TodoListItem(context: context)
        newItem.name = name
        newItem.createdAt = Date()
    
        do {
           try context.save()
            getAllTask()
            
        }catch {
            
        }
        
    }
    
    func deleteTask(item: TodoListItem){
        context.delete(item)
        
        do {
            try context.save()
            getAllTask()
            
        }
        catch{
            
        }
        
    }
    
    func updateTask(item: TodoListItem, name : String){
        item.name = name
        do {
            try context.save()
            getAllTask()
        }
        catch{
            
        }
    }
}


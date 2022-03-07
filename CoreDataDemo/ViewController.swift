//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Regina Williams on 3/6/22.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    //  Reference to the managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //this will hold the data for the table
    var items:[Person] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchPeople()
    }
    
    func fetchPeople() {
        //  Fetch the data from the Coredata to display in the tableview
        do {
            self.items = try context.fetch(Person.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch (let error) {
            print("Error happened: \(error.localizedDescription)")
        }
        
    }
    
    @IBAction func addPersonTapped(_ sender: Any) {
        
        //create alert here
        
        let addPersonAlert = UIAlertController(title: "Add Person", message: "Add person details:", preferredStyle: .alert)
        addPersonAlert.addTextField()
       // addPersonAlert.addTextField()
        // addPersonAlert.addTextField()
        
        let submitButton = UIAlertAction(title: "Add", style: .default) { action in
            // get the text field value from the alert
            let textField = addPersonAlert.textFields?.first
            
            //  TODO: Create a person object
            let newPerson = Person(context: self.context)
            newPerson.name = textField?.text
            newPerson.age = 30
            newPerson.gender = "Female"
            
            //  TODO: Save the data
            do {
                try self.context.save()
            } catch (let error) {
                print("Error happened! \(error.localizedDescription)")
            }
            
            //  TODO: Re-fetch the data
            self.fetchPeople()
        }
        
        // add button
        addPersonAlert.addAction(submitButton)
        
        //show alert
        self.present(addPersonAlert, animated: true)
    }
    


}

extension ViewController : UITableViewDelegate {
    
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)
        
        //get person loaded from core data
        let person = self.items[indexPath.row]
        
        cell.textLabel?.text = person.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = self.items[indexPath.row]
        
        //  when user taps display this popup so to edit user
        let editUserAlert = UIAlertController(title: "Edit Person", message: "Edit name:", preferredStyle: .alert)
        editUserAlert.addTextField()
        
        let textField = editUserAlert.textFields?.first
        textField?.text = person.name
        
        let saveButton = UIAlertAction(title: "Edit Person", style: .default ) { action in
            
            //Get modified  user name from text field
            let userEnteredText = editUserAlert.textFields?.first
            
            
            // edit existing user
            person.name = userEnteredText?.text
            
            //Save
            do {
                try self.context.save()
            } catch (let error) {
                print("Error on save: \(error.localizedDescription)")
            }
            
            // refetch??
            self.fetchPeople()
        }
        
        // add button
        editUserAlert.addAction(saveButton)
        
        //  present
        self.present(editUserAlert, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //  create a swipe action
        let action = UIContextualAction(style: .destructive, title: "Delete") { action, view, handler in
            
            // get the person to remove
            let personToRemove = self.items[indexPath.row]
            action.backgroundColor = .systemRed
            
            // remove the person
            self.context.delete(personToRemove)
            
            // TODO: Save the data
            do {
                try self.context.save()
            } catch (let error) {
                print("Error happend on save: \(error.localizedDescription)")
            }
            
            // TODO: Re-fetch the data
            self.fetchPeople()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
}


//
//  MainViewController.swift
//  Students
//
//  Created by Ben Gohlke on 6/17/19.
//  Copyright © 2019 Lambda Inc. All rights reserved.
//

import UIKit

class StudentsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var sortSelector: UISegmentedControl!
    @IBOutlet weak var filterSelector: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private let studentController = StudentController()
    
    private var filteredAndSortedStudents: [Student] = [] {
        didSet {
            tableView.reloadData() // automatically update once the data changes
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //defining the tableview datasource
        tableView.dataSource = self
        // call the function that loads the data at the start of the app before anything.
        studentController.loadFromPersistentStore(completion: { students, error in
            // its called completion because this is work we want it to run when the work is finished
            // 1st lets findout if there was any problem or error while loading the data
            if let error = error {
                print("Error loading students: \(error)")
            }
            //now if it doesn't catch an error we want it to if the data exists unwrap it, store it in this constant, then store it in the tableView
            DispatchQueue.main.async { // All UI updates must be performed on the main queue. if your on another queue run this on the main queue asyncrhonously
                if let students = students {
                    self.filteredAndSortedStudents = students // now the data we pulled form the JSOn is availalbe to the res of this view to use and load into the tableview.
                }
            }
        })
    }
    
    // MARK: - Action Handlers
    
    @IBAction func sort(_ sender: UISegmentedControl) {
    }
    
    @IBAction func filter(_ sender: UISegmentedControl) {
    }
    
    // MARK: - Private
}

extension StudentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredAndSortedStudents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        
        // Configure cell
        
        let aStudent = filteredAndSortedStudents[indexPath.row]
        cell.textLabel?.text = aStudent.name
        cell.detailTextLabel?.text = aStudent.course
        
        return cell
    }
}

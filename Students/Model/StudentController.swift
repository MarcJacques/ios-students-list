//
//  StudentController.swift
//  Students
//
//  Created by Ben Gohlke on 6/17/19.
//  Copyright © 2019 Lambda Inc. All rights reserved.
//

import Foundation

enum TrackType: Int {
    case none
    case iOS
    case Web
    case UX
}

enum SortOptions: Int {
    case firstName
    case lastName
}

class StudentController {
    
    private var students: [Student] = []
    
    private var persistentFileURL: URL? {
        guard let filePath = Bundle.main.path(forResource: "students", ofType: "json") else { return nil }
        return URL(fileURLWithPath: filePath)
    }
    
    func loadFromPersistentStore(completion: @escaping ([Student]?, Error?) -> Void)
        //this is a closure, an anonymous function, the only argument it accepts is one called a completion, the type is everythinig from "@escaping to Error?", this closure does not return anything. Closures are required to specify a return this is an example of it returning nothing.
    {
        //run this process in the background queue
        let bgQueue = DispatchQueue(label: "studentQueue", attributes: .concurrent)
        bgQueue.async {// we want this to run on the background.
            // were trying to load the data from the file
            let fm = FileManager.default
            guard let url = self.persistentFileURL,
                fm.fileExists(atPath: url.path) else { return }// does this file exist? if not jump out early
            
            // open the file, read it, decode it
            do {
                let data = try Data(contentsOf: url) // find this data in url and try to store it into data variable
                // make it useful to us by decoding it
                let decoder = JSONDecoder()
                let students = try decoder.decode([Student].self, from: data) //use the data model in a way that matches the format of the JSON and the data that you just created. were telling swift to compare the model to the actual JSON so we can properly decode it. our data model must conform to the JSON to work
                self.students = students
                //now we need a way to send the data to the VC. right now it only exists in this do block
                completion(students, nil)
                //if the do block succeeds we don't need to catch anything. ***** However if it fails to load the data on line 33 or fails to read or decode the data, the compiler will not run line 35. We want it to catch the error so we know why we were unable to get our student data********
            } catch {
                //if either of the steps above in the do block throw an error we catch it by doing the following so we know what happened
                print("Error loading student data: \(error)")
                //if we catch an error students will be nil and we want to pass the error object to our completion
                completion(nil, error)
            }
        }
    }
    func filter(with trackType: TrackType, sortedBy sorter: SortOptions) -> [Student] {
        var updatedStudents: [Student]
        
        switch trackType {
        case .iOS:
            updatedStudents = students.filter { $0.course == "iOS" }
        case .Web:
            updatedStudents = students.filter { $0.course == "Web" }
        case .UX:
            updatedStudents = students.filter { $0.course == "UX" }
        default:
            updatedStudents = students
        }
        
        if sorter == .firstName {
            updatedStudents = updatedStudents.sorted { $0.firstName < $1.firstName }
        } else {
            updatedStudents = updatedStudents.sorted { $0.lastName < $1.lastName }
        }
        
        return updatedStudents
    }
}

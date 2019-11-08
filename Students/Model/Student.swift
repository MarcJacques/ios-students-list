//
//  Student.swift
//  Students
//
//  Created by Andrew R Madsen on 8/5/18.
//  Copyright © 2018 Lambda Inc. All rights reserved.
//

import Foundation

struct Student: Codable {
    var name: String
    var course: String
    
    var firstName: String {
        return String(name.split(separator: " ")[0])//this allows us to split a string based off how all names are written. this will return our first name
    }
    
    var lastName: String {
        return String(name.split(separator: " ").last ?? "")// grab from the separator to the last element in the array we just splint into pieces and return a string. if nothing is there use the empty string. this is the last name string.
    }
}

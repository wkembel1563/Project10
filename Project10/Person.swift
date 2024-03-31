//
//  Person.swift
//  Project10
//
//  Created by Will Kembel on 3/29/24.
//

import UIKit

class Person: NSObject {
    var name: String
    var imageName: String
    
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}

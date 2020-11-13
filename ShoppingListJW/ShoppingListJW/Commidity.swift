//
//  Commidity.swift
//  ShoppingListJW
//
//  Created by njuios on 2020/11/11.
//

import Foundation
import UIKit
import os.log

class Commidity: NSObject, NSCoding {
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
        aCoder.encode(wish, forKey: PropertyKey.wish)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
            
        // Because photo is an optional property of Meal, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
            
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        let wish = aDecoder.decodeObject(forKey: PropertyKey.wish) as? String
            
        // Must call designated initializer.
        self.init(name: name, photo: photo, rating: rating, wish: wish)
    }
    
    
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    var rating: Int
    var wish: String?
    
    //MARK: Archiving Paths
     
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("commidities")
    
    //MARK: Types
     
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
        static let wish = "wish"
    }
    
    
    //MARK: Initialization
     
    init?(name: String, photo: UIImage?, rating: Int, wish: String?) {
        
        // Initialization should fail if there is no name or if the rating is negative.
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
         
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.rating = rating
        self.wish = wish
    }
    
}

//
//  DatabaseHelper.swift
//  Assignment
//
//  Created by Ravi Singh on 16/09/23.
//

import Foundation
import CoreData
import UIKit


class DatabaseHelper {

    static let shared = DatabaseHelper()
    
    lazy var persistentContainer: NSPersistentContainer = {
          let container = NSPersistentContainer(name: "Assignment")
          container.loadPersistentStores(completionHandler: { (_, error) in
              if let error = error as NSError? {
                  fatalError("Unresolved error \(error), \(error.userInfo)")
              }
          })
          return container
      }()
      
      var managedContext: NSManagedObjectContext {
          return persistentContainer.viewContext
      }
    
    
    func getImages() -> [Pets] {
        var images = [Pets]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pets")
        do {
            images = try managedContext.fetch(fetchRequest) as! [Pets]
        } catch let error {
            print(error.localizedDescription)
        }
        return images
        
    }
    
    func saveImage(id: Int, image: Data) {
        let fetchRequest = Pets.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [id])
        do {
            let existingObjects = try managedContext.fetch(fetchRequest)
            if let existingObject = existingObjects.first {
                existingObject.img = image
                existingObject.id = Int64(id)
            } else {
                let newObject = Pets(context: managedContext)
                newObject.img = image
                newObject.id = Int64(id)
            }
            try managedContext.save()
        } catch let error{
            print(error.localizedDescription)
        }
        
    }

}

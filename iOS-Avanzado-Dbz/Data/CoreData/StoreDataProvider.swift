//
//  StoreDataProvider.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 23/10/24.
//

import Foundation
import CoreData

class StoreDataProvider {
    
    static var shared: StoreDataProvider = .init()
    
    private let persistentContainer: NSPersistentContainer
    
    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    init() {
        self.persistentContainer = NSPersistentContainer(name: "Model")
        self.persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Error loading BBDD \(error.localizedDescription)")
            }
        }
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                debugPrint("Error saving context \(error.localizedDescription)")
            }
        }
    }
}


extension StoreDataProvider {
    func add(heroes: [ApiHero]) {
        
        for hero in heroes {
            let newHero = MOHero(context: context)
            newHero.id = hero.id
            newHero.name = hero.name
            newHero.favorite = hero.favorite ?? false
            newHero.photo = hero.photo
            
        }
        save()
    }
    
    func fetchHeroes(filter: NSPredicate?) -> [MOHero] {
        let request = MOHero.fetchRequest()
        request.predicate = filter
        do {
            return try context.fetch(request)
        } catch {
            debugPrint("Error loading heroes \(error.localizedDescription)")
            return []
        }
    }
    
    func add(locations: [ApiLocation]) {
        for location in locations {
            let newLocation = MOLocation(context: context)
            newLocation.id = location.id
            newLocation.latitude = location.latitude
            newLocation.longitude = location.longitude
            newLocation.date = location.date
            
            if let heroId = location.hero?.id {
                let predicate = NSPredicate(format: "id == %@", heroId)
                let hero = fetchHeroes(filter: predicate).first
                newLocation.hero = hero
            }
        }
    }
    
    func add(transformations: [MOTransformation]) {
        for transformation in transformations {
            let newTransformation = MOTransformation(context: context)
            newTransformation.id = transformation.id
            newTransformation.name = transformation.name
            newTransformation.info = transformation.info
            newTransformation.photo = transformation.photo
            
            if let heroId = transformation.hero?.id {
                let predicate = NSPredicate(format: "id == %@", heroId)
                let hero = fetchHeroes(filter: predicate).first
                newTransformation.hero = hero
            }
        }
    }
}
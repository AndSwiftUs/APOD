import CoreData
import UIKit

class MainStorageManager {
    
    static let shared = MainStorageManager()
    
    let coreDataStack = CoreDataStack()
    
    lazy var fetchedResultsController: NSFetchedResultsController<APODInstance> = {
        let fetchRequest = APODInstance.fetchRequest()
        
        let sort = NSSortDescriptor(key: #keyPath(APODInstance.createdAt), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        let fetchedResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: (coreDataStack.managedContext),
            sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultController
    }()
    
    func getAllItems() -> [APODInstance] {
        do {
            let context = coreDataStack.managedContext
            return try context.fetch(APODInstance.fetchRequest())
        } catch {
            print("Couldn't fetch data")
        }
        return []
    }
    
    func saveItem(with apod: APOD, apodImage: UIImage, completion: @escaping (Result<Void, Error>) -> Void)  {
        let context = coreDataStack.managedContext
        
        let newAPOD = APODInstance(context: context)
        newAPOD.title = apod.title
        newAPOD.explanation = apod.explanation
        newAPOD.date = apod.date
        newAPOD.imageData = apodImage.pngData()
        newAPOD.createdAt = Date()
        
        print(#function, " Save APOD: ", newAPOD.date!)
        
        coreDataStack.saveContext()
    }
    
    func deleteItem(with apod: APODInstance) {
        let context = coreDataStack.managedContext
        
        context.delete(apod)
        
        coreDataStack.saveContext()
    }
}

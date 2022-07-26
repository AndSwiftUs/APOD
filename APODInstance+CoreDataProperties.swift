import Foundation
import CoreData


extension APODInstance {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<APODInstance> {
        return NSFetchRequest<APODInstance>(entityName: "APODInstance")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var date: String?
    @NSManaged public var explanation: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var title: String?

}

extension APODInstance : Identifiable {

}

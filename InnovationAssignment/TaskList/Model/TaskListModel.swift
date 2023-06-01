import Foundation
import CoreData
import UIKit

class TaskListModel{
    var id: String = ""
    var taskName: String = ""
    var taskStatus: String = ""
    var taskTime: String = ""
    var taskTimeInDateFormat: Date = Date()
    
    init(){
        
    }
    
    init(id: String,taskName: String, taskStatus: String, taskTime: String) {
        self.id = id
        self.taskName = taskName
        self.taskStatus = taskStatus
        self.taskTime = taskTime
    }
    
    func getManagedContext() -> NSManagedObjectContext {
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return managedObjectContext
    }
    
    func fetchAllTaskList() -> [TaskListModel]{
        var objTaskListArray : [TaskListModel] = []
        let managedObjectContext: NSManagedObjectContext = getManagedContext()
        let fetchRequest   =  NSFetchRequest<NSFetchRequestResult>(entityName: "TaskList")
        
        fetchRequest.returnsObjectsAsFaults = false
        do{
            let fetchedResult = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                let objTaskList = results as? [TaskList] ?? []
                for list in objTaskList {
                    let objTastListModel = TaskListModel(id: list.id ?? "", taskName: list.taskName ?? "", taskStatus: list.taskStatus ?? "N" , taskTime: list.taskTime ?? "")
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "h:mm a"
                    dateFormatter.calendar = Calendar.current
                    dateFormatter.timeZone = TimeZone.current
                    let date = dateFormatter.date(from: list.taskTime ?? "") ?? Date()
                    let strCurrentTime = dateFormatter.string(from: Date())
                    let dateCurrentTime = dateFormatter.date(from: strCurrentTime) ?? Date()
                    if date < dateCurrentTime{
                        objTastListModel.taskStatus = "P"
                    }
                    objTastListModel.taskTimeInDateFormat = date
                    objTaskListArray.append(objTastListModel)
                }
            }
        } catch {
        }
        
        return objTaskListArray
        
    }
    
    func getSortedTimeTime(arrTaskList: [TaskListModel]) -> [TaskListModel]{
        let sortedData = arrTaskList.sorted(by: { $0.taskTimeInDateFormat.compare($1.taskTimeInDateFormat) == .orderedAscending })
        for item in sortedData{
            print(item.id)
        }
        return sortedData
    }
    
    func insertTask(_ taskList: TaskListModel) {
            let saveObject: [String: Any] = ["taskName":taskList.taskName,
                                             "taskTime":taskList.taskTime,
                                             "taskStatus":taskList.taskStatus,
                                             "id":taskList.id
                
            ]
            
        let managedObjectContext = getManagedContext()
        
        //adding new doc and saving in database...
        let content = NSEntityDescription.insertNewObject(forEntityName: "TaskList", into: managedObjectContext)
        content.setValuesForKeys(saveObject)
        do {
            try managedObjectContext.save()
        } catch {
        }
    }
    
    func deleteRecordFromDatabaseForId(id: String) {
       
        let managedObjectContext: NSManagedObjectContext = getManagedContext()
        let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "TaskList")
        fetchRequest.predicate = NSPredicate(format: "id CONTAINS[c] %@", id)
        
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResult = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            for object in fetchedResult! { // Fetching Object
                managedObjectContext.delete(object) // Deleting Object
            }
        } catch {
            print("Failed")
        }
        // Saving the Delete operation
        do {
            try managedObjectContext.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func updateFollowedPatient(id: String, taskStatus: String) {
        let managedObjectContext: NSManagedObjectContext = getManagedContext()
        let fetchRequest   =  NSFetchRequest<NSFetchRequestResult>(entityName: "TaskList")
        
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    result.setValue(taskStatus, forKey: "taskStatus")
                }
            }
        } catch {
        }
        
        do {
            try managedObjectContext.save()
        } catch {
        }
    }
}

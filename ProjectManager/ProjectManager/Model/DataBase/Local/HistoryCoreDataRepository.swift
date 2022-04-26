//
//  HistoryCoreDataRepository.swift
//  ProjectManager
//
//  Created by 1 on 2022/04/24.
//

import Foundation
import CoreData

class HistoryCoreDataRepository: HistoryRepository {

    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Project")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print(error.localizedDescription)
            }
        })
        return container
    }()
    
    private lazy var context = persistentContainer.viewContext
    private var historys: [CDHistory] = []
    var historyCount: Int {
        return historys.count
    }
   
    func readHistory(of inedx: Int) -> [String?: String?]? {
        return ["description": historys[inedx].description, "date": historys[inedx].date]
    }
    
    func createHistory(type: OperationType, of projectIdentifier: String?, title: String?, status: Status?) {
        let newHistory = OperationHistory(type: type,
                                          projectIdentifier: projectIdentifier,
                                          projectTitle: title,
                                          projectStatus: status)
        let cdHistory = CDHistory(context: context)
        cdHistory.descrption = newHistory.historyDescription
        cdHistory.descrption = newHistory.dateDescription
        
        self.save()
    }
    
    private func fetch(of status: Status) -> [CDHistory]? {
        let fetchRequest = CDHistory.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            return try context.fetch(fetchRequest)
        } catch  {
            print(error.localizedDescription)
            return nil
        }
    }
    
    // TODO: - 코어데이터 관련 중복 코드 제거
    private func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

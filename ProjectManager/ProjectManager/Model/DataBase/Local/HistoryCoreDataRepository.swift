//
//  HistoryCoreDataRepository.swift
//  ProjectManager
//
//  Created by 1 on 2022/04/24.
//

import Foundation
import CoreData

class HistoryCoreDataRepository: HistoryRepository {

    private var historys: [CDHistory] = []
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
    
    var historyCount: Int {
        self.fetch()
        return historys.count
    }
   
    func readHistory(of inedx: Int) -> [String?: String?]? {
        self.fetch()
        return ["description": historys[inedx].descrption,
                "date": historys[inedx].date]
    }
    
    func createHistory(type: OperationType, of projectIdentifier: String?, title: String?, status: Status?) {
        let newHistory = OperationHistory(type: type,
                                          projectIdentifier: projectIdentifier,
                                          projectTitle: title,
                                          projectStatus: status)
        let cdHistory = CDHistory(context: self.context)
        cdHistory.descrption = newHistory.historyDescription
        cdHistory.date = newHistory.dateDescription
        
        self.save()
    }
    
    private func fetch() {
        let fetchRequest = CDHistory.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            self.historys = try context.fetch(fetchRequest)
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    // TODO: - 코어데이터 관련 중복 코드 제거
    private func save() {
        if self.context.hasChanges {
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

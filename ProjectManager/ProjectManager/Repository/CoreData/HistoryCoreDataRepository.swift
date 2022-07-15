//
//  HistoryCoreDataRepository.swift
//  ProjectManager
//
//  Created by 1 on 2022/04/24.
//

import Foundation
import CoreData

class HistoryCoreDataRepository: HistoryRepository {
    
    var updateUI: (() -> Void) = {}

    private var historys: [CDHistory] = []
    private let persistentContainer = ProjectPersistentContainer.persistentContainer
    
    private let context = ProjectPersistentContainer.context
    
    var historyCount: Int {
        return historys.count
    }
    
    func fetchHistorys() {
        self.fetch()
    }
    
    func readHistory(of inedx: Int) -> [String?: String?]? {
        return ["description": historys[inedx].descrption,
                "date": historys[inedx].date]
    }
    
    func createHistory(type: OperationType,
                       of projectIdentifier: String?,
                       title: String?,
                       status: Status?) {
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
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            self.historys = try context.fetch(fetchRequest)
        } catch  {
            print(error.localizedDescription)
        }
    }
    
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

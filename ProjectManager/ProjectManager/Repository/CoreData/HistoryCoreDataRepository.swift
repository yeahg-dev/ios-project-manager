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
        historys.count
    }
    
    func fetchHistorys() {
        fetch()
    }
    
    func readHistory(of inedx: Int) -> [String?: String?]? {
       ["description": historys[inedx].descrption,
                "date": historys[inedx].date]
    }
    
    func createHistory(
        type: OperationType,
        of projectIdentifier: String?,
        title: String?,
        status: Status?)
    {
        let newHistory = OperationHistory(
            type: type,
            projectIdentifier: projectIdentifier,
            projectTitle: title,
            projectStatus: status)
        let cdHistory = CDHistory(context: context)
        cdHistory.descrption = newHistory.historyDescription
        cdHistory.date = newHistory.dateDescription
        
        self.save()
    }
    
    private func fetch() {
        let fetchRequest = CDHistory.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            historys = try context.fetch(fetchRequest)
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    private func save() {
        if self.context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

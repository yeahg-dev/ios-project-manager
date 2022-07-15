//
//  HistoryFirestoreRepository.swift
//  ProjectManager
//
//  Created by 1 on 2022/04/24.
//

import Foundation
import Firebase

class HistoryFirestoreRepository: HistoryRepository {
    
    var updateUI: (() -> Void) = {}
    
    struct FirestorePath {
        static let historys = "historys"
    }
    
    private let db = Firestore.firestore()
    var historys = [[String: Any]]()
 
    var historyCount: Int {
        return historys.count
    }
    
    func fetchHistorys() {
        db.collection(FirestorePath.historys).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var datas: [[String: Any]] = []
                for document in querySnapshot!.documents {
                    datas.append(document.data())
                }
                self.historys = datas.sorted(by: { lhs, rhs in
                    (lhs["date"] as! String) < (rhs["date"] as! String)
                })
                DispatchQueue.main.async {
                    self.updateUI()
                }
            }
        }
    }
    
    func readHistory(of inedx: Int) -> [String? : String?]? {
        guard let history = historys[inedx] as? [String: String] else {
            return nil
        }
        return history
    }
    
    func createHistory(type: OperationType,
                       of projectIdentifier: String?,
                       title: String?,
                       status: Status?) {
        let newHistory = OperationHistory(type: type,
                                          projectIdentifier: projectIdentifier,
                                          projectTitle: title,
                                          projectStatus: status)
        let history = ["description": newHistory.historyDescription,
                       "date": newHistory.dateDescription]
        
        db.collection(FirestorePath.historys).document(newHistory.historyDescription).setData(history) { err in
            if let err = err {
                print("☠️Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}

//
//  Repository.swift
//  ProjectManager
//
//  Created by 1 on 2022/07/15.
//

import Foundation

enum Repository {
    
    case inMemory
    case coreData
    case firestore
    
    var userDescription: String {
        switch self {
        case .inMemory:
            return "휘발성"
        case .coreData:
            return "앱"
        case .firestore:
            return "Cloud"
        }
    }
    
}

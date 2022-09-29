//
//  ProjectManagerDelegate.swift
//  ProjectManager
//
//  Created by 1 on 2022/07/15.
//

import Foundation

protocol ProjectManagerDelegate: AnyObject {
    
    func projectManager(didChangedRepositoryWith repositoryType: Repository)
    
}

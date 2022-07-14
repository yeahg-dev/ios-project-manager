//
//  Status.swift
//  ProjectManager
//
//  Created by 1 on 2022/03/06.
//

import Foundation
import UIKit

enum Status: String, Codable {
    
    case todo
    case doing
    case done
}

// MARK: - CustomStringConvertible
extension Status: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .todo:
            return "할 일🌅"
        case .doing:
            return "하는 중🌞"
        case .done:
            return "했음🌄"
        }
    }
    
    var cellBackgroundColor: UIColor? {
        switch self {
        case .todo:
            return ColorPallete.todoCellBackgroundColor
        case .doing:
            return ColorPallete.doingCellBackgroundColor
        case .done:
            return ColorPallete.doneCellBackgroundColor
        }
    }
    
    var signatureColor: UIColor? {
        switch self {
        case .todo:
            return ColorPallete.todoColor
        case .doing:
            return ColorPallete.doingColor
        case .done:
            return ColorPallete.doneColor
        }
    }
}

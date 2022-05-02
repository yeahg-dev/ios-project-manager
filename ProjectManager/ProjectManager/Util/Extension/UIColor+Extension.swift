//
//  UIColor+Extension.swift
//  ProjectManager
//
//  Created by 1 on 2022/05/02.
//

import UIKit

extension UIColor {
    static var shadowColor: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .light {
                    return .systemGray
                } else {
                    return .white
                }
            }
        } else {
            return .systemGray
        }
    }
}

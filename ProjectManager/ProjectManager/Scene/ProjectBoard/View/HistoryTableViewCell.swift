//
//  HistoryTableViewCell.swift
//  ProjectManager
//
//  Created by 1 on 2022/04/27.
//

import UIKit

final class HistoryTableViewCell: UITableViewCell {

    // MARK: - IBOutlet Property
    
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var dateLabel: UILabel?
    
    // MARK: - API
    
    func configureContentWith(description: String?, date: String?) {
        descriptionLabel?.text = description
        dateLabel?.text = date
        descriptionLabel?.textColor = ColorPallete.buttonColor
    }
    
}

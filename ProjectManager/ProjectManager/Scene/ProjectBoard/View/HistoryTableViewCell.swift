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
        self.descriptionLabel?.text = description
        self.dateLabel?.text = date
        self.descriptionLabel?.textColor = ColorPallete.buttonColor
    }
    
}

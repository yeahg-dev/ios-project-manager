//
//  HistoryTableViewCell.swift
//  ProjectManager
//
//  Created by 1 on 2022/04/27.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var dateLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureContentWith(description: String?, date: String?) {
        self.descriptionLabel?.text = description
        self.dateLabel?.text = date
    }
    
}

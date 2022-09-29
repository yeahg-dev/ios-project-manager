//
//  ProjectTableViewHeaderView.swift
//  ProjectManager
//
//  Created by 1 on 2022/03/08.
//

import UIKit

final class ProjectTableViewHeaderView: UIView {

    // MARK: - UI Property
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .left
        return label
    }()
    
    private let projectCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 9
        label.layer.cornerCurve = .circular
        label.layer.masksToBounds = true
        return label
    }()
    
    private lazy var seperator: CALayer = {
        let seperator = CALayer()
        seperator.frame = CGRect(
            x: 0,
            y: self.bounds.height - 0.5,
            width: self.bounds.width,
            height: 3)
        seperator.backgroundColor = ColorPallete.tableViewSeperatorColor?.cgColor
        return seperator
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.configureLayout()
    }
  
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.addSublayer(self.seperator)
    }
    
    // MARK: - Configure Layout
    
    private func configureLayout() {
        self.addSubview(statusLabel)
        self.addSubview(projectCountLabel)
        
        NSLayoutConstraint.activate([
            statusLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            projectCountLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            projectCountLabel.centerYAnchor.constraint(equalTo: self.statusLabel.centerYAnchor),
            self.projectCountLabel.heightAnchor.constraint(equalToConstant: 20),
            self.projectCountLabel.widthAnchor.constraint(equalToConstant: 20)])
    }
    
    // MARK: - API
    
    func setLabelColor(with color: UIColor?) {
        self.statusLabel.textColor = color
        self.projectCountLabel.backgroundColor = color

    }
    
    func configureContent(status: String?, projectCount: Int ) {
        self.statusLabel.text = status
        self.projectCountLabel.text = String(projectCount)
    }
    
}

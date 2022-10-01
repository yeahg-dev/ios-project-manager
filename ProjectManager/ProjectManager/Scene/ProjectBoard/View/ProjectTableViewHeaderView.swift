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
        label.font = Design.statusLabelFont
        label.textAlignment = .left
        return label
    }()
    
    private let projectCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Design.projectCountLabelFont
        label.textColor = Design.projectCountLabelTextColor
        label.textAlignment = .center
        label.layer.cornerRadius = Design.projectCountLabelCornerRadius
        label.layer.cornerCurve = .circular
        label.layer.masksToBounds = true
        return label
    }()
    
    private lazy var seperator: CALayer = {
        let seperator = CALayer()
        seperator.frame = CGRect(
            x: 0,
            y: self.bounds.height - Design.seperatorLeadingMargin,
            width: self.bounds.width,
            height: Design.separatorHeight)
        seperator.backgroundColor = Design.seperatorColor
        return seperator
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.addSublayer(self.seperator)
    }
  
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

// MARK: - Design

private enum Design {
    
    // padding
    static let seperatorLeadingMargin: CGFloat = 0.5
    
    // size
    static let separatorHeight: CGFloat = 3
    // font
    static let statusLabelFont: UIFont = .preferredFont(forTextStyle: .title1)
    static let projectCountLabelFont: UIFont = .preferredFont(forTextStyle: .callout)
    
    // color
    static let projectCountLabelTextColor: UIColor = .white
    static let seperatorColor: CGColor? = ColorPallete.tableViewSeperatorColor?.cgColor
    
    // corner radius
    static let projectCountLabelCornerRadius: CGFloat = 9
}

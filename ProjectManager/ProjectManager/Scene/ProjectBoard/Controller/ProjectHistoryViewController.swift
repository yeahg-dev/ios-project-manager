//
//  ProjectHistoryViewController.swift
//  ProjectManager
//
//  Created by 1 on 2022/04/27.
//

import UIKit

final class ProjectHistoryViewController: UIViewController {

    // MARK: - Property
    
    var historyRepository: HistoryRepository?
    
    // MARK: - UI Property
    
    private let historyTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewLayout()
        self.configureHistoryTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.preferredContentSize.height = self.historyTableView.contentSize.height + Design.topPadding + Design.bottomPadding
    }
    
    private func configureViewLayout() {
        self.view.addSubview(historyTableView)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            historyTableView.topAnchor.constraint(
                equalTo: safeArea.topAnchor,
                constant: Design.topPadding),
            historyTableView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: Design.leadingPadding),
            historyTableView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: -Design.trailingPadding),
            historyTableView.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor,
                constant: -Design.bottomPadding)
        ])
    }
    
    private func configureHistoryTableView(){
        let historyTableViewCellNib = UINib(
            nibName: "HistoryTableViewCell",
            bundle: nil)
        self.historyTableView.register(
            historyTableViewCellNib,
            forCellReuseIdentifier: "HistoryTableViewCell")
        self.historyRepository?.updateUI = { [weak self] in
            self?.historyTableView.reloadData()
        }
        self.historyRepository?.fetchHistorys()
        self.historyTableView.dataSource = self
    }

}

// MARK: - UITableViewDataSource

extension ProjectHistoryViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
       return self.historyRepository?.historyCount ?? .zero
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let historyTableViewCell = self.historyTableView.dequeueReusableCell(
            withIdentifier: "HistoryTableViewCell",
            for: indexPath) as? HistoryTableViewCell else {
            return UITableViewCell(style: .subtitle, reuseIdentifier: nil) }
        
        let history = self.historyRepository?.readHistory(of: indexPath.row)
        let description = history?["description"] ?? ""
        let date = history?["date"] ?? ""
        historyTableViewCell.configureContentWith(description: description, date: date)
        
        self.view.setNeedsLayout()
        
        return historyTableViewCell
    }

}

// MARK: - Design

private enum Design {
    
    // padding
    static let topPadding: CGFloat = 7
    static let leadingPadding: CGFloat = 7
    static let trailingPadding: CGFloat = 7
    static let bottomPadding: CGFloat = 7
    
}

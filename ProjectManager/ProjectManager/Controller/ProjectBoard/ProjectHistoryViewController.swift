//
//  ProjectHistoryViewController.swift
//  ProjectManager
//
//  Created by 1 on 2022/04/27.
//

import UIKit

class ProjectHistoryViewController: UIViewController {

    var historyRepository: HistoryRepository?
    
    private let historyTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewLayout()
        self.configureHistoryTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.sizeToFit()
        print(self.historyTableView.contentSize)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func configureViewLayout() {
        self.view.addSubview(historyTableView)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            historyTableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 7),
            historyTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 7),
            historyTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -7),
            historyTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -7)
        ])
    }
    
    private func configureHistoryTableView(){
        let historyTableViewCellNib = UINib(nibName: "HistoryTableViewCell",
                                            bundle: nil)
        self.historyTableView.register(historyTableViewCellNib,
                                       forCellReuseIdentifier: "HistoryTableViewCell")
        
        self.historyTableView.dataSource = self
    }

}

extension ProjectHistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historyRepository?.historyCount ?? .zero
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let historyTableViewCell = self.historyTableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as? HistoryTableViewCell else {
            return UITableViewCell(style: .subtitle, reuseIdentifier: nil) }
        
        let history = self.historyRepository?.readHistory(of: indexPath.row)
        let description = history?["description"] ?? ""
        let date = history?["date"] ?? ""
        historyTableViewCell.configureContentWith(description: description, date: date)
        
        // FIXME: - 비효율적인 레이아웃 계산같아보임, 위치 수정
        // preferredContentSize를 결정할 때마다 layout을 재 설정함. viewDidLayoutSubviews가 호출됨
        self.preferredContentSize = self.historyTableView.contentSize
        
        return historyTableViewCell
    }

}

//
//  HomeViewController.swift
//  Lucky-Test-burguer
//
//  Created by Miguel Angel Saravia Belmonte on 1/15/23.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Private variables
    private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "HomeViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = HomeViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configSettings()
        setupTableView()
        loadService()
    }
    
    // MARK: Private Functions
    private func configSettings() {
        view.backgroundColor = UIColor.defaultColor
        navigationItem.title = Text.hometitle
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blackText]
        navigationController?.navigationBar.barTintColor = UIColor.grayColor
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: viewModel.nameCell, bundle: nil), forCellReuseIdentifier: viewModel.nameCell)
    }
    
    private func loadService() {
        viewModel.loadService()
        viewModel.filterResult.bind { [weak self] result in
            guard let self = self else { return }
            if let title = result?.title,
                let section = result?.sections,
                !title.isEmpty && !section.isEmpty {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: Delegate and datasource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.countSectionList
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currentCounterSectionList(index: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.nameCell, for: indexPath) as? ListCell else {
            return UITableViewCell()
        }
        
        let model = viewModel.titleItemSection(section: indexPath.section, index: indexPath.row)
        cell.config(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let container = UIView()
        let titleSectionLabel = UILabel()
        titleSectionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(titleSectionLabel)
        
        
        NSLayoutConstraint.activate([
            titleSectionLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20),
            titleSectionLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        ])
        
        let model = viewModel.titleSection(index: section)
        titleSectionLabel.font = UIFont.systemFont(ofSize: 24.0)
        titleSectionLabel.text = model.title
        return container
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
}

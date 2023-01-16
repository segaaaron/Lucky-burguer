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
        
        let header = HeaderView(sizeTitle: 14.0, colorText: .grayText ,title: "offers", titleType: .MEDIUM, offertValue: 124, frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 40))
        tableView.tableHeaderView = header
        
        tableView.register(UINib(nibName: viewModel.nameCell, bundle: nil), forCellReuseIdentifier: viewModel.nameCell)
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
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
        cell.selectionStyle = .none
        cell.config(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = viewModel.titleSection(index: section)
        let headerView = HeaderView(sizeTitle: 24.0, colorText: .blackText, title: model.title ?? "", titleType: .BOLD, frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 50.0))
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

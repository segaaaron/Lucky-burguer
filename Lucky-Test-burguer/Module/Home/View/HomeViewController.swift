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
    private var counterOffert: Int = Value.defaultValue {
        didSet {
            headerSettings(offertValue: self.counterOffert)
        }
    }
    private var dispatch = DispatchQueue.main
    private var dispatchSearch: DispatchWorkItem?
    private var searchController = UISearchController(searchResultsController: nil)
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: Text.nibHome, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = HomeViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingUI()
        createSearchBarButton()
        hideKeyboardWhenTappedAround()
        setupTableView()
        loadService()
        loadDetailList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
        navigationController?.navigationBar.tintColor = UIColor.blackText
    }
    
    // MARK: Private Functions
    private func settingUI() {
        view.backgroundColor = UIColor.defaultColor
        navigationItem.title = Text.hometitle
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blackText]
        navigationController?.navigationBar.barTintColor = UIColor.grayColor
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: Text.cellIdentifier, bundle: nil), forCellReuseIdentifier: Text.cellIdentifier)
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func headerSettings(offertValue: Int) {
        dispatch.async { [weak self] in
            guard let self = self else { return }
            let header = HeaderView(sizeTitle: Value.headerTitleSize, colorText: .grayText ,title: Text.headerHomeTitle, titleType: .LIGHT, offertValue: offertValue, frame: CGRect(x: CGFloat(Value.defaultValue), y: CGFloat(Value.defaultValue), width: self.view.bounds.width, height: Value.headerSize))
            self.tableView.tableHeaderView = header
        }
    }
    
    private func createSearchBarButton() {
        let searchButton = UIButton(frame: CGRect(x: CGFloat(Value.defaultValue), y: CGFloat(Value.defaultValue), width: Value.imageDefaultSize, height: Value.imageDefaultSize))
        
        let likeButtonImage = UIImage(named: "search_icon")
        searchButton.setImage(likeButtonImage, for: .normal)
        
        searchButton.addTarget(self, action: #selector(searchButtonAction), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchButton)
    }
    
    private func searchAppList(with query: String) {
        dispatchSearch?.cancel()
        let fetchList = DispatchWorkItem {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                let searchList = SearchProvider(searchList: self.viewModel.detailSearchList, query: query)
                searchList.callbackList = { (list, isEmptyList) in
                    if isEmptyList {
                        self.counterOffert = Value.defaultValue
                    }
                    self.viewModel.filterResult.value = BurguerModel(title: "Offert", sections: list)
                    self.viewModel.detailList.value = list
                    self.tableView.reloadData()
                }
                searchList.updateView()
            }
        }
        dispatchSearch = fetchList
        guard let dispatchSearch = dispatchSearch else { return }
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(300), execute: dispatchSearch)
    }
    
    private func loadService() {
        viewModel.loadService()
        viewModel.filterResult.bind { [weak self] result in
            guard let self = self else { return }
            if self.viewModel.validateList {
                self.counterOffert = self.viewModel.counterOfferts
                self.dispatch.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func loadDetailList() {
        viewModel.loadDetailMock()
        viewModel.detailList.bind {_ in }
    }
    
    @objc func searchButtonAction(_ sender: UIButton) {
        if #available(iOS 15.0, *) {} else {
            searchAppList(with: " ")
        }
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.keyboardType = UIKeyboardType.asciiCapable

        self.searchController.searchBar.delegate = self
        present(searchController, animated: false, completion: nil)
    }
}

// MARK: Delegate and datasource
extension HomeViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.countSectionList
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currentCounterSectionList(index: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Text.cellIdentifier, for: indexPath) as? ListCell else {
            return UITableViewCell()
        }
        let model = viewModel.listSection(section: indexPath.section, index: indexPath.row)
        let currentFormatLikes = Double(model.favoriteCount ?? Value.defaultValue)
        cell.selectionStyle = .none
        cell.config(model: model, counterLikes: viewModel.currentLikeValue(value: currentFormatLikes))
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = viewModel.titleSection(index: section)
        let headerView = HeaderView(sizeTitle: Value.headerCellTitleSize, colorText: .blackText, title: model.title ?? "", titleType: .MEDIUM, frame: CGRect(x: CGFloat(Value.defaultValue), y: CGFloat(Value.defaultValue), width: view.bounds.width, height: Value.headerCellHeightSize))
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Value.headerSize
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewModel = DetailViewModel()
        let controller = DetailViewController(viewModel: detailViewModel)
        let mockList = viewModel.detailList.value
    
        let objc = mockList?[indexPath.section].items?[indexPath.row] ?? Item()
        controller.viewModel.detailObjc.value = objc
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension HomeViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchController.searchBar.text {
            searchAppList(with: text)
        }
    }
}

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
        setupTableView()
        loadService()
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
        let model = viewModel.titleItemSection(section: indexPath.section, index: indexPath.row)
        let currentFormatLikes = Double(model.favoriteCount ?? 0)
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
        let controller = DetailViewController()
        let objc = viewModel.filterResult.value?.sections?[indexPath.section].items?[indexPath.row] ?? Item()
        let currentObjc = DetailModel(urlImage: objc.imageURL, brand: objc.brand, title: objc.title, favoriteCounter: objc.favoriteCount ?? 0, description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Pretium aenean pharetra magna ac placerat vestibulum lectus. Dictumst quisque sagittis purus sit amet volutpat consequat mauris. Vestibulum mattis ullamcorper velit sed ullamcorper morbi tincidunt ornare. Viverra aliquet eget sit amet tellus. Sit amet justo donec enim diam vulputate ut. Vel facilisis volutpat est velit egestas dui id. A scelerisque purus semper eget. Volutpat commodo sed egestas egestas fringilla phasellus. Urna molestie at elementum eu facilisis sed. Velit ut tortor pretium viverra. Sit amet volutpat consequat mauris nunc congue. Accumsan in nisl nisi scelerisque eu. Duis at consectetur lorem donec massa sapien faucibus et.", oldValue: "EGP500", newValue: "EGP700", expDate: "Exp.28 April 2020", timesRdemtions: "REDEMPTIONS CAP: 8 TIMES")
        controller.descriptionObj = currentObjc
        navigationController?.pushViewController(controller, animated: true)
    }
}

//
//  HomeViewController.swift
//  Lucky-Test-burguer
//
//  Created by Miguel Angel Saravia Belmonte on 1/15/23.
//

import UIKit

final class HomeViewController: UIViewController {
    
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
        loadService()
    }
    
    private func configSettings() {
        view.backgroundColor = UIColor.defaultColor
        navigationItem.title = Text.hometitle
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blackText]
        navigationController?.navigationBar.barTintColor = UIColor.grayColor
    }
    
    private func loadService() {
        viewModel.loadService()
        viewModel.filterResult.bind { result in
            if let title = result?.title,
                let section = result?.sections,
                !title.isEmpty && !section.isEmpty {
                print("***** Result *****", title, section)
            }
        }
    }
}

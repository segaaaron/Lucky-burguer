//
//  HomeViewController.swift
//  Lucky-Test-burguer
//
//  Created by Miguel Angel Saravia Belmonte on 1/15/23.
//

import UIKit

final class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configSettings()
    }
    
    private func configSettings() {
        view.backgroundColor = UIColor.defaultColor
        navigationItem.title = Text.hometitle
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blackText]
        navigationController?.navigationBar.barTintColor = UIColor.grayColor
    }
}

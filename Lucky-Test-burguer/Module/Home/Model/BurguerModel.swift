//
//  BurguerModel.swift
//  Lucky-Test-burguer
//
//  Created by Miguel Angel Saravia Belmonte on 1/15/23.
//

import Foundation

// MARK: - BurguerModel
struct BurguerModel: Codable {
    let title: String?
    let sections: [Section]?
}

// MARK: - Section
struct Section: Codable {
    let title: String?
    let items: [Item]?
    
    init(title: String? = nil, items: [Item]? = nil) {
        self.title = title
        self.items = items
    }
}

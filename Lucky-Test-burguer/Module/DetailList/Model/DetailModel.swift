//
//  DetailModel.swift
//  Lucky-Test-burguer
//
//  Created by Miguel Angel Saravia Belmonte on 1/16/23.
//

import Foundation

struct DetailModel {
    let urlImage: String?
    let brand: String?
    let title: String?
    let favoriteCounter: Int?
    let description: String?
    let oldValue: String?
    let newValue: String?
    let expDate: String?
    let timesRdemtions: String?
}

struct SectionSearch {
    let title: String?
    let items: [Item]?
    
    init(title: String? = nil, items: [Item]? = nil) {
        self.title = title
        self.items = items
    }
}

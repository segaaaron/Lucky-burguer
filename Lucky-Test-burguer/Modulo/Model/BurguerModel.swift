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
}

// MARK: - Item
struct Item: Codable {
    let detailURL, imageURL: String?
    let brand, title: String?
    let tags: String?
    let favoriteCount: Int?

    enum CodingKeys: String, CodingKey {
        case detailURL = "detailUrl"
        case imageURL = "imageUrl"
        case brand, title, tags, favoriteCount
    }
}

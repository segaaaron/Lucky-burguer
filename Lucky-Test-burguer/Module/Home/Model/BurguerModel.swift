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

// MARK: - Item
struct Item: Codable {
    let detailURL, imageURL: String?
    let brand, title: String?
    let tags: String?
    let oldValue, newValue, expDate, description: String?
    let timeRedemptions, favoriteCount: Int?

    enum CodingKeys: String, CodingKey {
        case detailURL = "detailUrl"
        case imageURL = "imageUrl"
        case brand, title, tags, oldValue, newValue, expDate, description, timeRedemptions, favoriteCount
    }
    
    init(detailURL: String? = nil,
         imageURL: String? = nil,
         brand: String? = nil,
         title: String? = nil,
         tags: String? = nil,
         oldValue: String? = nil,
         newValue: String? = nil,
         expDate: String? = nil,
         description: String? = nil,
         timeRedemptions: Int? = nil,
         favoriteCount: Int? = nil) {
        self.detailURL = detailURL
        self.imageURL = imageURL
        self.brand = brand
        self.title = title
        self.tags = tags
        self.oldValue = oldValue
        self.newValue = newValue
        self.expDate = expDate
        self.description = description
        self.timeRedemptions = timeRedemptions
        self.favoriteCount = favoriteCount
    }
}

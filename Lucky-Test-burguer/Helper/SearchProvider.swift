//
//  SearchProvider.swift
//  Lucky-Test-burguer
//
//  Created by Miguel Angel Saravia Belmonte on 1/16/23.
//

import Foundation

final class SearchProvider {
    let searchList: [Section]
    var callbackList: (([Section], Bool) -> Void)?
    var query: String
    private let notificatinoCenter = NotificationCenter.default
    
    init(searchList: [Section], query: String) {
        self.searchList = searchList
        self.query = query
        subcribeToNotifications()
    }
    
    func subcribeToNotifications() {
        notificatinoCenter.addObserver(self,
                                       selector: #selector(updateView),
                                       name: NSNotification.Name("SEARCH_LIST"), object: nil)
    }
    
    @objc func updateView() {
        self.validateSearch()
    }
    
    private func validateSearch() {
        var currentSectionList: [Section] = []
        var itemSearchTopCash: [Item] = []
        var itemSearchPopular: [Item] = []
        searchList.forEach({ element in
            if let title = element.title,
                let item = element.items,
               title == "Top Cashbacks" {
                item.forEach({ ele in
                    if let titleItem = ele.title,
                       titleItem.lowercased().contains(query.lowercased()) {
                        itemSearchTopCash.append(ele)
                    }
                })
            } else if let title = element.title,
                        let item = element.items,
                      title == "Popular" {
                item.forEach({ ele in
                    if let titleItem = ele.title,
                       titleItem.lowercased().contains(query.lowercased()) {
                        itemSearchPopular.append(ele)
                    }
                })
            }
        })
        let sectionsTopCash = Section(title: "Top Cashbacks", items: itemSearchTopCash)
        let sectionPopular = Section(title: "Popular", items: itemSearchPopular)

        if !itemSearchTopCash.isEmpty {
            currentSectionList.append(sectionsTopCash)
        }
        if !itemSearchPopular.isEmpty {
            currentSectionList.append(sectionPopular)
        }

        if query.isEmpty {
            callbackList?(searchList, false)
        } else {
            callbackList?(currentSectionList, currentSectionList.isEmpty)
        }
    }
    
    deinit {
        notificatinoCenter.removeObserver(self)
    }
}

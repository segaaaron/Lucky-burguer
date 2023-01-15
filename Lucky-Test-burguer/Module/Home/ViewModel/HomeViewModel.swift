//
//  HomeViewModel.swift
//  Lucky-Test-burguer
//
//  Created by Miguel Angel Saravia Belmonte on 1/15/23.
//

import Foundation

final class HomeViewModel: NSObject {
    private let service = Network()
    var filterResult: Observable<BurguerModel> = Observable(BurguerModel(title: "", sections: []))
    
    
    var nameCell: String {
        Text.cellIdentifier
    }
    
    var countSectionList: Int {
        if let count = filterResult.value?.sections?.count {
            return count
        }
        return 0
    }
    
    func titleSection(index: Int) -> Section {
        if let model = filterResult.value?.sections?[index] {
            return model
        }
        return Section()
    }
    
    func titleItemSection(section: Int, index: Int) -> Item {
        if let model = filterResult.value?.sections?[section].items?[index] {
            return model
        }
        return Item()
    }
    
    func currentCounterSectionList(index: Int) -> Int {
        if let count = filterResult.value?.sections?[index].items?.count {
            return count
        }
        return 0
    }
    
    func loadService() {
        service.apiService(with: .GET,
                           model: BurguerModel.self,
                           endPoint: .test,
                           params: [:]) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                self.filterResult.value = result
            case .failure(let error):
                print(error.localizedDescription)
            case .none:
                break
            }
        }
    }
}

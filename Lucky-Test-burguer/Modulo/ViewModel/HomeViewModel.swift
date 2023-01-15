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

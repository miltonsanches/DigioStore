//
//  DigioStoreViewModel.swift
//  DigioStore
//
//  Created by Milton Leslie Sanches on 22/08/24.
//

import Foundation

protocol DigioStoreViewModelDelegate: AnyObject {
    func didUpdateData()
    func didFailWithError(error: Error)
}

class DigioStoreViewModel {
    weak var delegate: DigioStoreViewModelDelegate?
    private let networkService: NetworkServiceProtocol
    internal var digioStoreData: DigioStoreData?

    init(networkService: NetworkServiceProtocol = NetworkService(), initialData: DigioStoreData? = nil) {
        self.networkService = networkService
        self.digioStoreData = initialData
    }

    func fetchData() {
        networkService.fetchData { [weak self] result in
            switch result {
            case .success(let data):
                self?.digioStoreData = data
                self?.delegate?.didUpdateData()
            case .failure(let error):
                self?.delegate?.didFailWithError(error: error)
            }
        }
    }
}

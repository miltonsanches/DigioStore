//
//  NetworkService.swift
//  DigioStore
//
//  Created by Milton Leslie Sanches on 22/08/24.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchData(completion: @escaping (Result<DigioStoreData, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    private let urlString = "https://7hgi9vtkdc.execute-api.sa-east-1.amazonaws.com/sandbox/products"

    func fetchData(completion: @escaping (Result<DigioStoreData, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 404, userInfo: nil)))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(DigioStoreData.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}


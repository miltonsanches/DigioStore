//
//  ProductModel.swift
//  DigioStore
//
//  Created by Milton Leslie Sanches on 22/08/24.
//

import Foundation

struct Spotlight: Codable, Equatable {
    let name: String
    let bannerURL: String
    let description: String

    static func == (lhs: Spotlight, rhs: Spotlight) -> Bool {
        return lhs.name == rhs.name && lhs.bannerURL == rhs.bannerURL && lhs.description == rhs.description
    }
}

struct Product: Codable, Equatable {
    let name: String
    let imageURL: String
    let description: String

    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.name == rhs.name && lhs.imageURL == rhs.imageURL && lhs.description == rhs.description
    }
}

struct Cash: Codable {
    let title: String
    let bannerURL: String
    let description: String
}

struct DigioStoreData: Codable {
    let spotlight: [Spotlight]
    let products: [Product]
    let cash: Cash
}

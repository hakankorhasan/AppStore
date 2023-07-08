//
//  HeaderModel.swift
//  AppStore
//
//  Created by Hakan Körhasan on 5.05.2023.
//

import UIKit

struct HeaderModel: Decodable, Hashable {
    let id, name, imageUrl, tagline: String
}

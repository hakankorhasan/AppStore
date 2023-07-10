//
//  AppGroup.swift
//  AppStore
//
//  Created by Hakan Körhasan on 4.05.2023.
//

import UIKit

struct AppGroup: Decodable {
    let feed: Feed
}

struct Feed: Decodable {
    let title: String
    let results: [FeedResult]
}

struct FeedResult: Decodable, Hashable {
    let id, name, artistName, artworkUrl100: String
}

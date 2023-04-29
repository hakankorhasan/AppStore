//
//  SearchResult.swift
//  AppStore
//
//  Created by Hakan Körhasan on 29.04.2023.
//

import Foundation


struct SearchResult: Decodable {
    let resultCount: Int
    let results: [Result]
}

struct Result: Decodable {
    let trackName: String
    let primaryGenreName: String
    var averageUserRating: Float?
    let screenshotUrls: [String]
    let artworkUrl100: String // app icon
}

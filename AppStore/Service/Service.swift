//
//  Service.swift
//  AppStore
//
//  Created by Hakan Körhasan on 29.04.2023.
//

import UIKit

class Service {
    
    static let shared = Service() //Singleton
    
    func fetchApps(searchTerm: String, completion: @escaping ([Result], Error?) -> ()) {
        
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&country=us&entity=software"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion([], nil)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                completion(searchResult.results, nil)
            } catch let err {
                print("json decode error:", err)
                completion([], err)
            }
        }.resume()
    }
    
    func fetchTopFreeApps(completion: @escaping (AppGroup?, Error?) -> ()) {
        let url = "https://rss.applemarketingtools.com/api/v2/us/books/top-free/50/books.json"
        fetchAppsGroup(urlString: url, completion: completion)
    }
    
    func fetchTopChannels(completion: @escaping (AppGroup?, Error?) -> ()) {
         let url = "https://rss.applemarketingtools.com/api/v2/us/audio-books/top/50/audio-books.json"
         fetchAppsGroup(urlString: url, completion: completion)
    }
    
    func fetchTopPodcasts(completion: @escaping (AppGroup?, Error?) -> ()) {
         let url = "https://rss.applemarketingtools.com/api/v2/us/podcasts/top/50/podcasts.json"
         fetchAppsGroup(urlString: url, completion: completion)
    }
    
    func fetchTopSubscriberPodcasts(completion: @escaping (AppGroup?, Error?) -> ()) {
         let url = "https://rss.applemarketingtools.com/api/v2/us/podcasts/top-subscriber/50/podcasts.json"
         fetchAppsGroup(urlString: url, completion: completion)
    }
    
    func fetchAppsGroup(urlString: String, completion: @escaping (AppGroup?, Error?) -> ()) {
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                return
            }
            
            guard let data = data else { return }
            
            do {
                let appGroup = try JSONDecoder().decode(AppGroup.self, from: data)
                completion(appGroup, nil)
            } catch let err {
                completion(nil, err)
                print("failed decode", err)
            }
            
        }.resume()
    }
}


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
    
    func fetchApps(completion: @escaping (AppGroup?, Error?) -> ()) {
        
        //guard let url = URL(string: "https://rss.applemarketingtools.com/api/v2/us/apps/top-free/50/apps.json") else { return }
        
        //guard let url = URL(string: "https://rss.applemarketingtools.com/api/v2/us/audio-books/top/50/audio-books.json") else { return }
        
        guard let url = URL(string: "https://rss.applemarketingtools.com/api/v2/us/books/top-free/50/books.json") else { return }

    
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                return
            }
            
            guard let data = data else { return }
            
            do {
                
                let appGroup = try JSONDecoder().decode(AppGroup.self, from: data)
                appGroup.feed.results.forEach({print($0.name)})
                completion(appGroup, nil)
            } catch let err {
                completion(nil, err)
                print("failed decode", err)
            }
            
        }.resume()
    }
}


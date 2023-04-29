//
//  Service.swift
//  AppStore
//
//  Created by Hakan Körhasan on 29.04.2023.
//

import UIKit

class Service {
    
    static let shared = Service() //Singleton
    
    func fetchApps(completion: @escaping ([Result], Error?) -> ()) {
        
        let urlString = "https://itunes.apple.com/search?term=instagram&country=us&entity=software"
        
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
}

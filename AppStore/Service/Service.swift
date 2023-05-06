//
//  Service.swift
//  AppStore
//
//  Created by Hakan Körhasan on 29.04.2023.
//

import UIKit

class Service {
    
    static let shared = Service() //Singleton
    
    func fetchApps(searchTerm: String, completion: @escaping (SearchResult?, Error?) -> ()) {
        
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&country=us&entity=software"
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func fetchTopFreeApps(completion: @escaping (AppGroup?, Error?) -> ()) {
        let url = "https://rss.applemarketingtools.com/api/v2/us/books/top-free/50/books.json"
        fetchGenericJSONData(urlString: url, completion: completion)
    }
    
    func fetchTopChannels(completion: @escaping (AppGroup?, Error?) -> ()) {
         let url = "https://rss.applemarketingtools.com/api/v2/us/audio-books/top/50/audio-books.json"
         fetchGenericJSONData(urlString: url, completion: completion)
    }
    
    func fetchTopPodcasts(completion: @escaping (AppGroup?, Error?) -> ()) {
         let url = "https://rss.applemarketingtools.com/api/v2/us/podcasts/top/50/podcasts.json"
         fetchGenericJSONData(urlString: url, completion: completion)
    }
    
    func fetchTopSubscriberPodcasts(completion: @escaping (AppGroup?, Error?) -> ()) {
         let url = "https://rss.applemarketingtools.com/api/v2/us/podcasts/top-subscriber/50/podcasts.json"
         fetchGenericJSONData(urlString: url, completion: completion)
    }
    
    func fetchHeaderData(completion: @escaping ([HeaderModel]?, Error?) -> Void) {
        
        let urlString = "https://api.letsbuildthatapp.com/appstore/social"
        
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func fetchGenericJSONData<T: Decodable>(urlString: String, completion: @escaping (T?, Error?) -> ()) {
        
        guard let url = URL(string: urlString) else { return }
        print(T.self)
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let objects = try JSONDecoder().decode(T.self, from: data)
                completion(objects, nil)
            } catch let err {
                completion(nil, err)
            }
        }.resume()
    }
}

class Stack<T: Decodable> {
    var items = [T]()
    func push(item: T) { items.append(item) }
    func pop() -> T? { return items.last }
}

func dummyFunc() {
    
    let stackOfStrings = Stack<String>()
    stackOfStrings.push(item: "has to be string")
    
    let stackOfInts = Stack<Int>()
    stackOfInts.push(item: 1)
}

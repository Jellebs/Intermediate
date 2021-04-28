//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Jesper Bertelsen on 28/04/2021.
//

import Foundation

class NetworkManager {
    private let baseUrlString: String = "https://newsapi.org/v2/"
    private let articleString: String = "everything?q=apple&from=2021-04-27&to=2021-04-27&sortBy=popularity"
    
    func getNews(completion: @escaping (([News]?) -> Void)) {
        let urlString = "\(baseUrlString)\(articleString)&apiKey=\(API.key)"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, let data = data else {
                completion(nil)
                return
            }
            //          NY LØSNING BRUGES
//            do {
//                let newsRes = try JSONDecoder().decode(NewsEnvelope.self, from: data)
//            } catch let decodeError {
//                print(decodeError.localizedDescription)
//            }
//                      Alternativ -> Vil blive brugt mere i swiftUI
            let newsRes = try? JSONDecoder().decode(NewsEnvelope.self, from: data)
            newsRes == nil ? completion(nil) : completion(newsRes?.articles)
        }
        .resume()
    }
    func getImage(urlString: String, completion: @escaping (Data?) -> Void ) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil, let data = data  else {
                completion(nil)
                return
            }
            completion(data)
        }
        .resume()
    }
}

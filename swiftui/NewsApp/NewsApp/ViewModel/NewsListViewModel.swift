//
//  NewsListViewModel.swift
//  NewsApp
//
//  Created by Jesper Bertelsen on 28/04/2021.
//

import Foundation

class NewsListViewModel: ObservableObject {
    @Published var news = [NewsViewModel]()
    @Published var imageData = [String: Data]()


    func loadNews() {
        getNews()
    }
    
    private func getNews() {
        let networkManager = NetworkManager()
        networkManager.getNews { newsArticle in
            guard let news = newsArticle else { return }
            
            let newsVM = news.map(NewsViewModel.init)
            self.getImages(for: newsVM)
            DispatchQueue.main.async {
                self.news = newsVM
            }
        }
    }
    private func getImages(for news: [NewsViewModel]) {
        let nm = NetworkManager()
        news.forEach { n in
            guard !n.urlImage.isEmpty else { return }
            nm.getImage(urlString: n.urlImage) { data in
                guard let data = data else { return }
                
                DispatchQueue.main.async {
                    self.imageData[n.urlImage] = data
                }
            }
        }
        
    }
}

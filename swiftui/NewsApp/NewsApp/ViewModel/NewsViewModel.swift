//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by Jesper Bertelsen on 28/04/2021.
//

import Foundation

struct NewsViewModel {
    let news: News
    
    var author: String {
        return news.author ?? "UNKNOWN MAN, MAAAAN"
    }
    var description: String {
        return news.description ?? "NO DESCRIPTION, MAAAN"
    }
    var title: String {
        return news.title ?? "NO TITLE MAN"
    }
    var url: String {
        return news.url ?? "https://www.instagram.com/p/CNoGhQ-nfuQ/"
    }
    var urlImage: String {
        return news.urlToImage ?? "https://dg31sz3gwrwan.cloudfront.net/actor/108931/64074215_medium-optimized-2.jpg"
    }
}

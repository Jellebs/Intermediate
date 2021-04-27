//
//  NewsListView.swift
//  SwiftUI - Stocks App
//
//  Created by Jesper Bertelsen on 12/04/2021.
//

import SwiftUI
import BetterSafariView

struct NewsListView: View {
    @ObservedObject var newsManager: NewsDownloadManager
    
    static let news = News(title: "Hej", url: "https://twitter.com/DRNyheder/status/1382182840830361603/photo/1", urlToImage: "https://pbs.twimg.com/media/Ey5_-BOVgAISY8Y?format=jpg&name=900x900")
    var new = [NewsListView.news]
   

    @State var showOnSafari: Bool = false
    @State var selectedArticle: News?
    
    var body: some View {
        VStack {
            ScrollView {
                if let articles = newsManager.newsArticles {
                    ForEach(articles, id: \.id) { article in
                        Link(destination: loadNews(for: article)) {
                            VStack(alignment: .leading) {
                                HStack(alignment: .top) {
                                    Text(article.title)
                                        .bold()
                                        .foregroundColor(.white)
                                        .lineLimit(5)
                                        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                    Spacer()
                                    
                                    AsyncImage(url: URL(string: article.imageUrl)!,
                                               placeholder: { RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.2)) },
                                               image: { Image(uiImage: $0).resizable() }
                                                )
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(10)
                                }
                                .contentShape(Rectangle())
    //                            .onTapGesture {
    //                                selectedArticle = article
    //                                showOnSafari.toggle()
    //                                print("Hej")
    //                            }
                                
                                    
                                
                                RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.2))
                                    .padding(.horizontal, 50)
                                    .frame(height: 1)
                            }
                        }
                    }
                }
            }
        }
    }
    private func loadNews(for article: News) -> URL{
        let site = URL(string: article.url.replacingOccurrences(of: "http://", with: "https://"))!
        return site
       
    }
//        sheet(isPresented: $showOnSafari) {
//            loadNews(for: selectedArticle ?? News(title: "Hej", url: "https://www.dr.dk", urlToImage: "https://www.dr.dk/global/logos/dr.png"))
}






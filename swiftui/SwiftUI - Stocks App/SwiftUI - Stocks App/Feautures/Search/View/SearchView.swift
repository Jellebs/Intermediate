//
//  SearchView.swift
//  SwiftUI - Stocks App
//
//  Created by Jesper Bertelsen on 12/04/2021.
//

import SwiftUI

struct SearchView: View {
    @State private var searchTerm: String = "Goog"
    @ObservedObject var searchManager = SearchManager()
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
            Color.black.opacity(0.8)
            VStack {
                HStack {
                    SearchTextView(searchTerm: $searchTerm)
                    Button(action: {
                        searchManager.searchStocks(keyword: searchTerm)
                    }, label: {
                        Image(systemName: "arrowtriangle.right.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                    })
                }
                Spacer()
                ScrollView {
                    ForEach(searchManager.searches) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.symbol)
                                    .font(.title)
                                    .bold()
                                Text(item.type)
                                    .font(.body)
                            }
                            Spacer()
                            Text(item.name)
                            Spacer()
                            Button(action: {
                                userDefaultsManager.shared.set(symbol: item.symbol)
                            }, label: {
                                item.symbol
                                if item.symbol.contains != searchManager.ubekendt || searchManager.udenforUS {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title)
                                }
                            })
                            
                        }.foregroundColor(.white)
                        RoundedRectangle(cornerRadius: 10).fill(Color.white)
                            .frame(height: 1)
                            
                    }
                }
            }.padding(.top,50)
            .padding(.horizontal, 16)
        }.edgesIgnoringSafeArea(.all)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

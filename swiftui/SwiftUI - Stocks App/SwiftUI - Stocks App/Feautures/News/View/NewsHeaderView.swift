//
//  NewsHeaderView.swift
//  SwiftUI - Stocks App
//
//  Created by Jesper Bertelsen on 12/04/2021.
//

import SwiftUI

struct NewsHeaderView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Top News")
                .font(.title)
                .foregroundColor(.white)
            HStack(spacing: 2) {
                Text("From")
                Image(systemName: "applelogo")
                Text("NewsApi")
            }
            .font(.title2)
            .foregroundColor(.gray)
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.gray)
                .frame(height: 1)
        }
        
    }
}

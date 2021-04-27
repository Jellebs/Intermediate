//
//  headerView.swift
//  SwiftUI - Stocks App
//
//  Created by Jesper Bertelsen on 10/04/2021.
//

import SwiftUI

struct HeaderView: View {
    
    private let dateFormatter: DateFormatter? = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd"
        return dateFormatter
    } ()
    
    @Binding var stocks: [String]
    
    @State private var showSearch = false
    
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: -5) {
                Text("Stocks")
                    .foregroundColor(.white)
                    .bold()
                Text("\(Date(), formatter: dateFormatter)")
                    .foregroundColor(.gray)
                    .bold()
            }.font(.title)
            Spacer()
            
            Button {
                showSearch.toggle()
            } label: {
                Image(systemName: "plus")
            }.sheet(isPresented: $showSearch,
                    onDismiss: {
                        self.stocks = userDefaultsManager.shared.savedSymbols
                    }, content: {
                        SearchView()
            })
            
        }.background(Color.black)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(stocks: .constant(["AAPL", "GOOG"]) )
    }
}

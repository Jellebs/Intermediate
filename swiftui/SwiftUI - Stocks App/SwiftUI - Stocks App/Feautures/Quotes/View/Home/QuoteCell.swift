//
//  QuoteCell.swift
//  SwiftUI - Stocks App
//
//  Created by Jesper Bertelsen on 11/04/2021.
//

import SwiftUI

struct QuoteCell: View {
    var quote: Quote
    var body: some View {
        HStack {
            Text(quote.symbol)
                .font(.body)
                .bold()
            Spacer()
            
            Spacer()
            
            VStack {
                Text(quote.price)
                    .bold()
                Text(quote.change).lineLimit(1)
                    .padding(.horizontal)
                    .frame(width: 100)
                    .background(RoundedRectangle(cornerRadius: 5).fill(Double(quote.change)! > 0.0 ? Color.green : Color.red), alignment: .trailing)
            }
        }
    }
}

struct QuoteCell_Previews: PreviewProvider {
    static var previews: some View {
        QuoteCell(quote:
                    Quote(symbol: "AAPL", open: "135,22", high: "140.22", low: "130.21", price: "135,21", change: "0.1", changePercent: "-0.5")
        )
    }
}

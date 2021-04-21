//
//  ContentView.swift
//  Coin Tracker
//
//  Created by Jesper Bertelsen on 19/04/2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel = CoinListViewModel()
    init() {
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        UITableViewCell.appearance().selectionStyle = .none
        viewModel.getCoins()
    }
    var body: some View {
        ZStack(alignment: .top) {
            Color.base
            List {
                VStack(alignment: .center) {
                    Text("Coin Tracker")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.top, 50)
                        .neumorphicShadow()
                        
                    ForEach(viewModel.coins) { coin in
                        CoinCell(coin: coin)
                            .neumorphicShadow()
                            
                    }
                }.listRowBackground(Color.clear)
            }
        }.edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

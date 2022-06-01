//
//  ContentView.swift
//  Set
//
//  Created by Ksenia Surikova on 13.10.2021.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var game: SetGameVM
    
    //Mark: body
    var body: some View {
        AspectVGrid(items: game.model.cardsOnBoard, aspectRatio: DrawingConstants.aspectRatio, minWidth: DrawingConstants.minWidthOfCard) { card in
            cardView(for: card)
        }
        Spacer()
        HStack{
            Button("New game") {
                game.playAgain()
            }
            Spacer()
            // tap on condition
            Button("Deal more cards") {
                game.dealCards()
            }.disabled(!game.canDealMoreCards())
        }
            .padding(.horizontal)
    }
    
    private func cardView(for card: SetCard)-> some View {
        SetCardView(card)
        // to use all path tappable
            .contentShape(Rectangle())
            .padding(DrawingConstants.paddingBetweenCards)
            .onTapGesture{
                game.choose(card)
            }
    }
    
    private struct DrawingConstants {
        static let aspectRatio: CGFloat = 2/3
        static let paddingBetweenCards: CGFloat = 4
        static let minWidthOfCard: CGFloat = 65
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameVM()
        SetGameView(game: game)
    }
}

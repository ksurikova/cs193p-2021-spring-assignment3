//
//  SetGame.swift
//  Set
//
//  Created by Ksenia Surikova on 13.10.2021.
//

import Foundation

struct SetGame {
    static let cardsToDealAndCheckCount = 3
    static let cardsCountForFirstDeal = 12
    
    private(set) var deck: [SetCard]
    private(set) var cardsOnBoard: [SetCard]
    
    private var selectedCardsIndices : [Int] { get {return cardsOnBoard.indices.filter{cardsOnBoard[$0].isSelected}}}
    
    private var isSet : Bool? {
        get { return SetCard.isSet(cardsToCheck: cardsOnBoard.filter{$0.isSelected})}
        set { selectedCardsIndices.forEach{cardsOnBoard[$0].isMatched  = newValue}}
    }
    
    func canDealMoreCards(countToDeal : Int = SetGame.cardsToDealAndCheckCount) -> Bool { deck.count >= countToDeal }
    
    mutating func dealCards(){
        guard canDealMoreCards() else {return }
        if isSet ?? false {
            cardsOnBoard.indices.filter{cardsOnBoard[$0].isMatched == true}.forEach{cardsOnBoard[$0] = deck.removeFirst()}
        }
        else {
            for _ in 0..<SetGame.cardsToDealAndCheckCount {
                cardsOnBoard.append(deck.removeFirst())
            }
        }
    }
  
    mutating func choose(_ card: SetCard) {
        if let indexOfCurrentCard = cardsOnBoard.firstIndex(of: card) {
            switch selectedCardsIndices.count {
            case 0..<SetGame.cardsToDealAndCheckCount-1:
                cardsOnBoard[indexOfCurrentCard].isSelected.toggle()
            case SetGame.cardsToDealAndCheckCount-1:
                cardsOnBoard[indexOfCurrentCard].isSelected.toggle()
                // just add third card, so we can check set!!!
                if cardsOnBoard[indexOfCurrentCard].isSelected {
                    isSet = SetCard.isSet(cardsToCheck: cardsOnBoard.filter{$0.isSelected})
                }
            case SetGame.cardsToDealAndCheckCount:
                if let set = isSet {
                    // match
                    if set {
                        let currentCardWasInMatch = cardsOnBoard[indexOfCurrentCard].isMatched ?? false
                        if canDealMoreCards() {
                            dealCards()
                            cardsOnBoard[indexOfCurrentCard].isSelected = !currentCardWasInMatch
                        }
                        else {
                            // before select, then remove match card, because after removing indexOfCurrentCard will be in another place
                            if !currentCardWasInMatch {
                                cardsOnBoard[indexOfCurrentCard].isSelected = true
                            }
                            cardsOnBoard = cardsOnBoard.filter { $0.isMatched == nil}
                        }
                    }
                    // mismatch
                    else {
                        selectedCardsIndices.forEach{ cardsOnBoard[$0].isSelected = false}
                        cardsOnBoard[indexOfCurrentCard].isSelected = true
                    }
                }
                // else doesn't exist
            default:
                break
            }
        }
    }
    
    init() {
        deck = SetGame.getDeck()
        cardsOnBoard = Array(deck.prefix(SetGame.cardsCountForFirstDeal))
        deck.removeSubrange(0..<SetGame.cardsCountForFirstDeal)
    }
    
    private static func getDeck() -> [SetCard] {
        var deck = [SetCard]()
        for i in Sign.allCases {
            for j in Sign.allCases {
                for k in Sign.allCases {
                    for l in Sign.allCases {
                        let card = SetCard(i,j,k,l)
                        deck.append(card)
                    }
                }
            }
        }
        return deck.shuffled()
    }
}

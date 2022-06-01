//
//  SetGameVM.swift
//  Set
//
//  Created by Ksenia Surikova on 13.10.2021.
//

import Foundation

class SetGameVM: ObservableObject {
    
    @Published private(set) var model: SetGame
    
    
    init() {
        model = SetGame()
    }
    
    //Mark: - Intent(s)
    func choose(_ card: SetCard) {
        // don't need more, because we set @Published directive to model var
        //objectWillChange.send()
        model.choose(card)
    }
    
    func playAgain() {
        model = SetGame()
    }
    
    func dealCards() {
        model.dealCards()
    }
    
    func canDealMoreCards() -> Bool {
        return model.canDealMoreCards()
    }
    

}


//
//  Dice.swift
//  RiskRoller
//
//  Created by James Nunn on 8/1/2024.
//

import SwiftUI

struct Dice:View{
    
    var num: Int
    var colour: Color
    
    var body: some View{
        Image(systemName: "die.face.\(num).fill")
            .font(.system(size: 100))
            .foregroundStyle(colour)
    }
}

#Preview {
    Dice(num: 6, colour: Color.red)
}

//
//  ContentView.swift
//  RiskRoller
//
//  Created by James Nunn on 29/9/2023.
//

import SwiftUI


struct ContentView:View {
    
    @State var attackerTroops = 0
    @State var defenderTroops = 0
    @FocusState var isInputActive: Bool
    
    @State var rolling = false
    
    @State var winner: String?
    
    var body: some View{
        NavigationStack{
            Group{
                if winner == nil {
                    VStack{
                        Text("Troop Count:")
                            .bold()
                        HStack{
                            Spacer()
                            VStack{
                                Text("Attacker")
                                TextField("Troop Count", value: $attackerTroops, format: .number, prompt: Text("9"))
                                    .font(.system(size: 40))
                                    .bold()
                                    .focused($isInputActive)
                                    .keyboardType(.numberPad)
                            }
                            .foregroundStyle(.red)
                            Spacer()
                            VStack{
                                Text("Defender")
                                TextField("Troop Count", value: $defenderTroops, format: .number, prompt: Text("4"))
                                    .font(.system(size: 40))
                                    .bold()
                                    .focused($isInputActive)
                                    .keyboardType(.numberPad)
                            }
                            .foregroundStyle(.blue)
                            Spacer()
                        }
                        .multilineTextAlignment(.center)
                    }
                    Button("Roll"){
                        rolling = true
                        ComputeRoll()
                    }.buttonStyle(.borderedProminent)
                    Spacer()
                }
                if winner != nil {
                    VStack{
                        Text("Results:")
                            .bold()
                        HStack{
                            Spacer()
                            VStack{
                                Text("Winner")
                                Text(winner ?? "Undecided")
                                    .font(.system(size: 40))
                                    .bold()
                            }
                            Spacer()
                            VStack{
                                Text("Troops Left")
                                Text("\(winner == "Attacker" ? attackerTroops : defenderTroops)")
                                    .font(.system(size: 40))
                                    .bold()
                            }
                            Spacer()
                        }
                        .multilineTextAlignment(.center)
                        .foregroundStyle(textColor(p: winner ?? "Attacker"))
                    }
                    if winner == "Defender" {
                        Text("* Attacker still has 1 troop left")
                    }
                    
                    Button("New Attack"){
                        rolling = false
                        attackerTroops = 0
                        defenderTroops = 0
                        winner = nil
                    }.buttonStyle(.borderedProminent)
                    Spacer()
                }
            }
            .fullScreenCover(isPresented: $rolling, content: {RollView()})
            .navigationTitle("Risk Roller")
        }
    }
    
    func textColor(p: String) -> Color {
        if p == "Attacker"{
            return Color.red
        } else {
            return Color.blue
        }
    }
                                 
    func ComputeRoll() {
        
        while winner == nil  {
            let aRoll = attackerRoll()
            let dRoll = defenderRoll()
            if dRoll[0] >= aRoll[0]{
                attackerTroops -= 1
            } else {
                defenderTroops -= 1
            }
            
            if dRoll.count > 1 && aRoll.count > 1{
                if dRoll[1] >= aRoll[1]{
                    attackerTroops -= 1
                } else {
                    defenderTroops -= 1
                }
            }
            
            if defenderTroops <= 0 {
                winner = "Attacker"
            } else if attackerTroops <= 1{
                winner = "Defender"
            }
        }
        
        func attackerRoll() -> [Int]{
            if attackerTroops > 3 {
                let aOne = Int.random(in: 1...6)
                let aTwo = Int.random(in: 1...6)
                let aThree = Int.random(in: 1...6)
                let unsortedAArray = [aOne, aTwo, aThree]
                var aArray = unsortedAArray.sorted(by: {$0 > $1})
                aArray.removeLast()
                return aArray
            } else {
                let aOne = Int.random(in: 1...6)
                let aTwo = Int.random(in: 1...6)
                let unsortedAArray = [aOne, aTwo]
                let aArray = unsortedAArray.sorted(by: {$0 > $1})
                return aArray
            }
        }
        
        func defenderRoll() -> [Int]{
            if defenderTroops >= 2 {
                let dOne = Int.random(in: 1...6)
                let dTwo = Int.random(in: 1...6)
                let unsortedDArray = [dOne, dTwo]
                let dArray = unsortedDArray.sorted(by: {$0 > $1})
                return dArray
            } else {
                let dArray = [Int.random(in: 1...6)]
                return dArray
            }
        }
    }
}

#Preview {
    ContentView()
}

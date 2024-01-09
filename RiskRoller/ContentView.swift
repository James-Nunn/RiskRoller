//
//  ContentView.swift
//  RiskRoller
//
//  Created by James Nunn on 29/9/2023.
//

import SwiftUI

struct RollLog {
    var id = UUID()
    var attackerTroops: Int
    var defenderTroops: Int
    var attackerRoll: [Int]
    var defenderRoll: [Int]
    var attackerLost: Int
    var defenderLost: Int
}

struct ContentView:View {
    
    @State var attackerTroops = 0
    @State var defenderTroops = 0
    @FocusState var isInputActive: Bool
    
    @State var rolling = false
    
    @State var winner: String?
    @State var log: [RollLog] = []
    @State var shownTotal = false
    
    
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
                        .disabled(attackerTroops == 0 || defenderTroops == 0)
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
                        shownTotal = false
                    }.buttonStyle(.borderedProminent)
                    Spacer()
                    VStack{
                        Text("Rolls:")
                            .bold()
                        List{
                            ForEach(Array(log.enumerated()), id: \.0){ index, l in
                                if !shownTotal {
                                    Text("Attacker had \(l.attackerTroops)")
                                    Text("Defender had \(l.defenderTroops)")
                                        .onAppear{
                                            shownTotal = true
                                        }
                                }
                                VStack{
                                    HStack{
                                        Text("Roll \(index + 1): ")
                                        Spacer()
                                        VStack{
                                            HStack{
                                                Dice(num: l.attackerRoll[0], colour: Color.red)
                                                if l.attackerRoll.count >= 2 {
                                                    Dice(num: l.attackerRoll[1], colour: Color.red)
                                                    if l.attackerRoll.count >= 3 {
                                                        Dice(num: l.attackerRoll[2], colour: Color.red)
                                                    }
                                                }
                                            }
                                            .font(.system(size: 20))
                                            HStack{
                                                Dice(num: l.defenderRoll[0], colour: Color.blue)
                                                if l.defenderRoll.count == 2 {
                                                    Dice(num: l.defenderRoll[1], colour: Color.blue)
                                                }
                                            }
                                            .font(.system(size: 20))
                                        }
                                    }
                                    HStack{
                                        Text("Attacker Lost \(l.attackerLost) And ")
                                        Text("Defender Lost \(l.defenderLost)")
                                    }
                                }
                            }
                        }
                    }.padding(.top)
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
        let defenderStart = defenderTroops
        let attackerStart = attackerTroops
        
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
            
            let newLog = RollLog(attackerTroops: attackerStart, defenderTroops: defenderStart, attackerRoll: aRoll, defenderRoll: dRoll, attackerLost: (attackerStart - attackerTroops), defenderLost: (defenderStart - defenderTroops))
            
            log.append(newLog)

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

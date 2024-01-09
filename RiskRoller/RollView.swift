//
//  RollView.swift
//  RiskRoller
//
//  Created by James Nunn on 8/1/2024.
//

import SwiftUI

struct RollView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var a1 = 1
    @State var a2 = 1
    @State var a3 = 1
    
    @State var d1 = 1
    @State var d2 = 1
    
    @State var redDragDistance = CGSize.zero
    @State var blueDragDistance = CGSize.zero
    @State var attackerDegrees = 0.0
    @State var defenderDegrees = 0.0
    
    @State var attackerRolled = false
    @State var title = "Attacker's Roll"
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("Shake or Swipe to Roll").font(.title3)
                Spacer()
                VStack{
                    Dice(num: a3, colour: Color.red).rotationEffect(.degrees(attackerDegrees))
                    HStack{
                        Dice(num: a1, colour: Color.red).rotationEffect(.degrees(attackerDegrees * 0.2))
                        Dice(num: a2, colour: Color.red).rotationEffect(.degrees(attackerDegrees * 0.3))
                    }
                }
                .font(.system(size: 100))
                .offset(x: redDragDistance.width, y: redDragDistance.height)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                if !attackerRolled{
                                    redDragDistance = gesture.translation
                                    attackerDegrees = gesture.velocity.animatableData.magnitudeSquared * 0.2
                                    a1 = Int.random(in: 1...6)
                                    a2 = Int.random(in: 1...6)
                                    a3 = Int.random(in: 1...6)
                                }
                            }
                        
                            .onEnded { gesture in
                                withAnimation(.spring(duration: 1, bounce: 0.3)) {
                                    a1 = Int.random(in: 1...6)
                                    a2 = Int.random(in: 1...6)
                                    a3 = Int.random(in: 1...6)
                                    redDragDistance = CGSize.zero
                                    attackerRolled = true
                                    title = "Defender's Roll"
                                }
                            }
                    )
                
                Spacer()
                
                HStack{
                    Dice(num: d1, colour: Color.blue).rotationEffect(.degrees(defenderDegrees * 0.2))
                    Dice(num: d2, colour: Color.blue).rotationEffect(.degrees(defenderDegrees * 0.3))
                }
                .font(.system(size: 100))
                .offset(x: blueDragDistance.width, y: blueDragDistance.height)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            if attackerRolled{
                                blueDragDistance = gesture.translation
                                defenderDegrees = gesture.velocity.animatableData.magnitudeSquared * 0.2
                                d1 = Int.random(in: 1...6)
                                d2 = Int.random(in: 1...6)
                            }
                        }
                    
                        .onEnded { gesture in
                            withAnimation(.spring(duration: 1.5, bounce: 0.2)) {
                                d1 = Int.random(in: 1...6)
                                d2 = Int.random(in: 1...6)
                                blueDragDistance = CGSize.zero
                            } completion: {
                                dismiss()
                            }
                        }
                )
                
                Spacer()
            }.navigationTitle(title)
        }.onShake{
            if !attackerRolled {
                withAnimation(.bouncy(duration: 1, extraBounce: 0.2)){
                    redDragDistance = CGSize(width: 66, height: -220)
                    attackerDegrees = Double.random(in: 0...360)
                    a1 = Int.random(in: 1...6)
                    a2 = Int.random(in: 1...6)
                    a3 = Int.random(in: 1...6)
                } completion: {
                    redDragDistance = CGSize.zero
                    title = "Defender's Roll"
                    attackerRolled = true
                }
            } else {
                withAnimation(.bouncy(duration: 1, extraBounce: 0.2)){
                    blueDragDistance = CGSize(width: 40, height: -210)
                    defenderDegrees = Double.random(in: 0...360)
                    d1 = Int.random(in: 1...6)
                    d2 = Int.random(in: 1...6)

                } completion: {
                    blueDragDistance = CGSize.zero
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    RollView()
}

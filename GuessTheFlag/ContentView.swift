//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Antonio J Rossi on 01/02/2020.
//  Copyright © 2020 Antonio J Rossi. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var score = 0
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var rotations = [0.0, 0.0, 0.0]
    @State private var opacities = [1.0, 1.0, 1.0]
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                        .animation(nil)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .animation(nil)
                }
                ForEach(0..<3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        FlagImage(name: self.countries[number])
                    }
                    .rotation3DEffect(.degrees(self.rotations[number]), axis: (x: 0, y: 1, z: 0))
                    .opacity(self.opacities[number])
                }
                VStack() {
                    Text("Your score is")
                        .foregroundColor(.white)
                    Text("\(score)")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(score)"), dismissButton: .default(Text("Continue")){
                self.askQuestion()
            })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)) {
                self.rotations[number] += 360
            }
            withAnimation(.default) {
                for(index, _) in opacities.enumerated() {
                    opacities[index] = index == number ? 1.0 : 0.25
                }
            }
            scoreTitle = "Correct"
            score += 1
            askQuestion()
        } else {
            withAnimation() {
                opacities = [0.0, 0.0, 0.0]
            }
            scoreTitle = "Wrong. That's the flag of \(countries[number])"
            score = max(0, score - 5)
            showingScore = true
        }
    }
    
    func askQuestion() {
        withAnimation(.default) {
            opacities = [1.0, 1.0, 1.0]
        }
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct FlagImage: View {
    var name: String
    var body: some View {
        Image(name)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

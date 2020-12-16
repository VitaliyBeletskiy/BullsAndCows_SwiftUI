//
//  ContentView.swift
//  BullsAndCows
//
//  Created by Vitaliy on 2020-11-19.
//

import SwiftUI

struct GameFieldView: View {
    @StateObject private var gameController = GameController()
    private var pickerValues = Array(0...9)
    @State private var selected = Array(0...3)
    @State private var showErrorAlert = false
    @State private var showHelp = false
    
    var body: some View {
        UITableView.appearance().backgroundColor = .background
        
        return ZStack {
            Color.backgroundMain.ignoresSafeArea()
            
            VStack {
                ZStack{ // HEADER
                    HStack {
                        Button(action: { showHelp = true }) {
                            ZStack {
                                Image(systemName: "square.fill")
                                    .font(.system(size: 40.0))
                                    .foregroundColor(.button)
                                Image(systemName: "book.closed")
                                    .font(.system(size: 20.0, weight: .bold, design: .rounded))
                                    .foregroundColor(.buttonText)
                            }
                        }
                        Spacer()
                        Button(action: {
                            gameController.newGame()
                            selected = Array(0...3)
                        }) {
                            ZStack {
                                Image(systemName: "square.fill")
                                    .font(.system(size: 40.0))
                                    .foregroundColor(.button)
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .font(.system(size: 20.0, weight: .bold, design: .rounded))
                                    .foregroundColor(.buttonText)
                            }
                        }
                    }.padding(.horizontal, 3)
                    
                    Group {
                        if gameController.isGameOver {
                            Text("YOU WIN !!!")
                        } else {
                            Text("Bulls & Cows")
                        }
                    }.font(.system(size: 25.0, weight: .bold, design: .rounded)).padding()
                } // HEADER
                
                ScrollViewReader { scrollView in // ATTEMPTS
                    List {
                        ForEach(0..<gameController.attemptLog.count, id: \.self) { i in
                            RowViewHelper(count: i, attempt: gameController.attemptLog[i])
                        }.listRowBackground(Color.backgroundField)
                    }.onChange(of: gameController.attemptLog.count, perform: { _ in
                        withAnimation { scrollView.scrollTo(gameController.attemptLog.count - 1, anchor: .center) }
                    })
                }.padding(.vertical, -8) // TODO: откуда тут взялся padding? // ATTEMPTS
                
                ZStack { // PICKER
                    HStack {
                        ForEach(0..<selected.count) { idx in
                            CustomPicker(selection: $selected[idx], data: pickerValues)
                        }
                        Button("Try!") {
                            tryTapped()
                        }
                        .modifier(TryButtonModifier())
                    }
                    .frame(height: 100)
                    .clipped()
                    .padding(.vertical, 10)
                    .disabled(gameController.isGameOver)
                    
                    if gameController.isGameOver {
                        Color.backgroundField.frame(height: 120)
                    }
                } // PICKER
            }
        }
        .onAppear() {
            gameController.newGame()
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text("Attention!"),
                message: Text("Your Guess must not contain repetitive digits.")
            )
        }
        .sheet(isPresented: $showHelp, content: { HelpView() })
    }
    
    private func tryTapped() {
        if !gameController.isAttemptValid(attemptValues: selected) {
            showErrorAlert = true
            return
        }
        gameController.processNewAttempt(attemptValues: selected)
    }
}

// MARK: - Preview

struct GameFieldView_Previews: PreviewProvider {
    static var previews: some View {
        GameFieldView()
    }
}

// MARK: - View-Helpers

struct RowViewHelper: View {
    var count: Int
    var attempt: Attempt
    
    var body: some View {
        HStack {
            CountViewHelper(value: count + 1)
            Spacer()
            Group {
                DigitViewHelper(value: attempt.attemptValues[0])
                DigitViewHelper(value: attempt.attemptValues[1])
                DigitViewHelper(value: attempt.attemptValues[2])
                DigitViewHelper(value: attempt.attemptValues[3])
            }.padding(.horizontal, -5)
            Spacer()
            Group {
                ResultViewHelper(value: attempt.result[0])
                ResultViewHelper(value: attempt.result[1])
                ResultViewHelper(value: attempt.result[2])
                ResultViewHelper(value: attempt.result[3])
            }.padding(.horizontal, -5)
        }
    }
}

struct CountViewHelper: View {
    var value: Int
    
    var body: some View {
        ZStack {
            Image(systemName: "circle.fill").font(.system(size: 25.0)).foregroundColor(.button)
            Text("\(value)").font(.system(size: 15.0, weight: .bold, design: .rounded))
        }
    }
}

struct DigitViewHelper: View {
    var value: Int
    
    var body: some View {
        ZStack {
            Image(systemName: "square").font(.system(size: 40.0))
            Text("\(value)").font(.system(size: 30.0, weight: .bold, design: .rounded))
        }
    }
}

struct ResultViewHelper: View {
    var value: BullsAndCows
    
    var body: some View {
        HStack {
            switch value {
            case .Bull: Image(systemName: "circle.fill")
            case .Cow: Image(systemName: "circle.fill").foregroundColor(.gray)
            case .Nothing: Image(systemName: "circle")
            }
        }
    }
}

struct CustomPicker: View {
    @Binding var selection: Int
    @State private var pickerSelection: Int = 51
    var data: [Int]
    
    var body: some View {
        ZStack{
            Picker("", selection: $pickerSelection) {
                ForEach(0..<100) {
                    Text(String(format: "%01d", $0 % 10))
                        .font(.system(size: 20.0, weight: .bold, design: .rounded))
                }
            }.onChange(of: pickerSelection, perform: {
                selection = $0 % 10
                pickerSelection = 50 + selection
            })
            .onChange(of: selection, perform: { value in
                pickerSelection = 50 + selection
            })
            .onAppear() {
                pickerSelection = 50 + selection
            }
            .labelsHidden()
            .frame(width: 60)
            .clipped()
            .background(Color(UIColor.picker))
            
            
        }
    }
}

struct HelpView: View {
    var body: some View {
        var text = ""
        
        if let filepath = Bundle.main.path(forResource: "rules", ofType: "txt") {
            do {
                let content = try String(contentsOfFile: filepath)
                text = content
            } catch {
                text = "Contents could not be loaded"
            }
        } else {
            text = "File not found"
        }
        
        return VStack {
            Text("Rules").font(.system(size: 25.0, weight: .bold, design: .rounded))
            ScrollView {
                VStack {
                    Text(text).frame(maxWidth: .infinity)
                }
            }.padding()
        }.padding().background(Color.rulesBackground)
    }
}

// MARK: - Modifiers

struct TryButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .font(.system(size: 20.0, weight: .bold, design: .rounded))
            .frame(width: 60, height: 100)
            .foregroundColor(Color.buttonText)
            .background(Color.button)
            .cornerRadius(10)
    }
}

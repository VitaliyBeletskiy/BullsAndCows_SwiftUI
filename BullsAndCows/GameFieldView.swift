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
            Color.backgroundMain.ignoresSafeArea()  // background color
            
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
                                    .foregroundColor(.text)
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
                                    .foregroundColor(.text)
                            }
                        }
                    }.padding(.horizontal, 8)
                    
                    Group {
                        if gameController.isGameOver {
                            Text("YOU WIN !!!")
                        } else {
                            Text("Just Bulls & Cows")
                        }
                    }
                    .font(.system(size: 25.0, weight: .bold, design: .rounded))
                    .foregroundColor(.text)
                    .padding()
                } // HEADER
                
                ScrollViewReader { scrollView in // ATTEMPTS
                    List {
                        ForEach(0..<gameController.attemptLog.count, id: \.self) { i in
                            RowViewHelper(count: i, attempt: gameController.attemptLog[i])
                        }.listRowBackground(Color.backgroundField)
                        if gameController.attemptLog.count == 0 {
                            HStack{
                                Spacer()
                                Text("Choose 4 digits and tap \"Try\"")
                                    .foregroundColor(.text)
                                Spacer()
                            }.listRowBackground(Color.backgroundField)
                        }
                    }
                    .onChange(of: gameController.attemptLog.count, perform: { _ in
                        withAnimation { scrollView.scrollTo(gameController.attemptLog.count - 1, anchor: .center) }
                    })
                }.padding(.vertical, -8) // TODO: откуда тут взялся padding? // ATTEMPTS
                
                ZStack { // PICKER
                    HStack {
                        ForEach(0..<selected.count) { idx in
                            CustomPicker(selection: $selected[idx], data: pickerValues)
                        }
                        Button("Try") {
                            tryTapped()
                        }
                        .modifier(TryButtonModifier())
                    }
                    .frame(height: 140)
                    .clipped()
                    .padding(.vertical, 10)
                    .disabled(gameController.isGameOver)
                    
                    if gameController.isGameOver {
                        Color.backgroundField.frame(height: 160)
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
        HStack{
            Spacer()
            HStack {
                CountViewHelper(value: count + 1)
                Spacer()
                HStack(spacing: 2.0) {
                    DigitViewHelper(value: attempt.attemptValues[0])
                    DigitViewHelper(value: attempt.attemptValues[1])
                    DigitViewHelper(value: attempt.attemptValues[2])
                    DigitViewHelper(value: attempt.attemptValues[3])
                }
                Spacer()
                HStack(spacing: 2.0) {
                    ResultViewHelper(value: attempt.result[0])
                    ResultViewHelper(value: attempt.result[1])
                    ResultViewHelper(value: attempt.result[2])
                    ResultViewHelper(value: attempt.result[3])
                }
            }.frame(maxWidth: 430)
            Spacer()
        }
    }
}

struct CountViewHelper: View {
    var value: Int
    
    var body: some View {
        ZStack {
            Image(systemName: "circle.fill")
                .font(.system(size: 25.0))
                .foregroundColor(.backgroundMain)
            Text("\(value)")
                .font(.system(size: 15.0, weight: .bold, design: .rounded))
                .foregroundColor(.text)
        }
    }
}

struct DigitViewHelper: View {
    var value: Int
    
    var body: some View {
        ZStack {
            Image(systemName: "square")
                .font(.system(size: 40.0))
                .foregroundColor(.text)
            Text("\(value)")
                .font(.system(size: 30.0, weight: .bold, design: .rounded))
                .foregroundColor(.text)
        }
    }
}

struct ResultViewHelper: View {
    var value: BullsAndCows
    
    var body: some View {
        HStack {
            switch value {
            case .Bull: Image(systemName: "circle.fill").foregroundColor(.text)
            case .Cow: Image(systemName: "circle.fill").foregroundColor(.gray)
            case .Nothing: Image(systemName: "circle").font(Font.body).foregroundColor(.text)
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
                        .foregroundColor(.text)
                }
            }.onChange(of: pickerSelection, perform: {
                selection = $0 % 10
                pickerSelection = 50 + selection
            })
            .onChange(of: selection, perform: { _ in
                pickerSelection = 50 + selection
            })
            .onAppear() {
                pickerSelection = 50 + selection
            }
            .labelsHidden()
            .frame(width: 60)
            .clipped()
            .background(Color.backgroundField)
        }
    }
}

struct HelpView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        let text1 = """
        The goal of the game is to uncover the the secret number with a minimal number of attempts (try with less than ten). \
        The computer indicates the number of matches in your proposition. \
        \n\n \
        - All digits in the secret number are different.\n \
        - If your guess has matching digits on the exact places, they are Bulls (
        """
        let text2 = """
        ).\n - If you have digits from the secret number, but not on the right places, they are Cows (
        """
        let text3 = ")."
        
        return VStack {
            Text("Rules")
                .font(.system(size: 25.0, weight: .bold, design: .rounded))
                .foregroundColor(.text)
            ScrollView {
                HStack {
                    Text(text1)
                        + Text("●").foregroundColor(.black)
                        + Text(text2)
                        + Text("●").foregroundColor(.gray)
                        + Text(text3)
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.text)
            }
            .padding()
            Button("Close") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .font(.system(size: 20.0, weight: .bold, design: .rounded))
            .foregroundColor(Color.text)
            .background(Color.button)
            .cornerRadius(10)
        }
        .padding()
        .background(Color.rulesBackground)
    }
}

// MARK: - Modifiers

struct TryButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .font(.system(size: 20.0, weight: .bold, design: .rounded))
            .frame(width: 60, height: 140)
            .foregroundColor(Color.text)
            .background(Color.button)
            .cornerRadius(10)
    }
}

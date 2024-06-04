//
//  HumanVsAIBoard.swift
//  TicTacToeSwiftUi
//
//  Created by Gokul on 10/07/21.
//

import SwiftUI

struct HumanVsAIBoard: View {
    @StateObject var viewModel = GameViewModel()
    @State var showHomePopup: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { (geometry) in
            ZStack{
                homeButton()
                VStack (alignment: .center, spacing: 20) {
                    Spacer()
                    Text("Tic Tac Toe")
                        .font(.system(size: 30, weight: .heavy, design: .serif))
                        .italic()
                    
                    HStack {
                        Spacer()
                        Text("Human : \(viewModel.ownScore)")
                        Spacer()
                        Text("Computer : \(viewModel.oponentScore)")
                        Spacer()
                    }
                    Spacer()
                    LazyVGrid(columns: viewModel.columns, spacing: 5) {
                        ForEach(0..<9) { i in
                            ZStack {
                                Circle()
                                    .foregroundColor(.red)
                                    .opacity(0.8)
                                    .frame(width: max(geometry.size.width/3 - 15, 0), height: max(geometry.size.width/3 - 15, 0))
                                Button(action: {
                                    viewModel.processPlayerMove(at: i)
                                }, label: {
                                    Image(systemName: viewModel.moves[i]?.markingImage ?? "")
                                        .renderingMode(.original)
                                        .resizable()
                                        .frame(width: max((geometry.size.width/3 - 15)*0.4, 0), height: max((geometry.size.width/3 - 15)*0.4, 0))
                                })
                            }
                        }
                    }
                    Spacer()
                    Button("Reset Game") {
                        viewModel.resetGame()
                    }.buttonStyle(GrowingButton())
                    Spacer()
                    
                }
                .allowsHitTesting(!viewModel.isDisabled)
                .padding()
                .alert(item: $viewModel.alertVariable) { (alertVariable) -> Alert in
                    Alert(title: alertVariable.title,
                          message: alertVariable.message,
                          dismissButton: .default(alertVariable.buttonText, action: {
                        viewModel.resetGame()
                    }))
                }
                if showHomePopup {
                    homePopupDialog()
                }
            }
            .navigationBarHidden(true)
        }
    }
    func homeButton() -> some View {
        HStack {
            VStack {
                Button {
                    showHomePopup.toggle()
                } label: {
                    Image(systemName: "house.fill")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35)
                        .tint(.red)
                        .opacity(0.8)
                }
                Spacer()
            }
            .padding([.leading])
            Spacer()
                
        }
    }
    
    func homePopupDialog() -> some View {
        CustomDialogPopup(
            title: "You Really wanna go Home?",
            subTitle: "Your current match will be terminated!",
            buttons: [
                DialogButton(title: "cancel", action: {
                    showHomePopup.toggle()
                }),
                DialogButton(title: "Go Home", action: {
                    presentationMode.wrappedValue.dismiss()
                })
            ],
            buttonAxis: .horizontal
        )
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HumanVsAIBoard()
    }
}

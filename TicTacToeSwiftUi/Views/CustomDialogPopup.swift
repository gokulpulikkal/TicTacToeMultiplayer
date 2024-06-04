//
//  CustomDialogPopup.swift
//  TicTacToeSwiftUi
//
//  Created by Gokul P on 03/06/24.
//

import SwiftUI

struct CustomDialogPopup: View {
    var title: String
    var subTitle: String?
    var buttons: [DialogButton]
    var buttonAxis: Axis.Set = .vertical
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.7)
            VStack(spacing: 5) {
                Text(title)
                    .font(.title2)
                    .bold()
                if (subTitle != nil) {
                    Text(subTitle ?? "")
                        .font(.title3)
                        .padding()
                }
                if buttonAxis == .horizontal {
                    HStack(spacing: 10) {
                        ForEach(buttons) { button in
                            Button(button.title) {
                                button.action()
                            }
                            .buttonStyle(GrowingButton())
                        }
                    }
                } else {
                    ForEach(buttons) { button in
                        Button(button.title) {
                            button.action()
                        }
                        .buttonStyle(GrowingButton())
                    }
                }
                
            }
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 10)
            
        }.ignoresSafeArea()
    }
}

struct DialogButton: Identifiable {
    let id = UUID()
    let title: String
    let action: () -> Void
}

#Preview {
    CustomDialogPopup(
        title: "This is the title",
        subTitle: "This is the subtitle",
        buttons: [
            DialogButton(title: "Play Again", action: {
                print("Play Again")
            }),
            DialogButton(title: "Go Home", action: {
                print("Go Home")
            })
        ],
        buttonAxis: .horizontal
    )
}

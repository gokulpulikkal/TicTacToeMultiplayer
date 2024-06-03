//
//  Alert.swift
//  TicTacToeSwiftUi
//
//  Created by Gokul on 10/07/21.
//

import Foundation
import SwiftUI

struct Alerts: Identifiable {
    var id = UUID()
    
    var title: Text
    var message: Text
    var buttonText: Text
}

struct AlertContexts {
    static var humanWin = Alerts(title: Text("You won The game"), message: Text("You Beat your own AI"), buttonText: Text("Hell yeah"))
    static var computerWin = Alerts(title: Text("You Lost The game"), message: Text("You Made a badass AI"), buttonText: Text("Rematch"))
    static var drawCase = Alerts(title: Text("Draw!!"), message: Text("Ohh What a battle"), buttonText: Text("Try Again"))
    
    static var homeWin = Alerts(title: Text("You won The game"), message: Text("You Beat your opponent"), buttonText: Text("Hell yeah!! Play again"))
    static var opponentWin = Alerts(title: Text("You Lost The game"), message: Text("Don't you worry it was a tight match"), buttonText: Text("Rematch"))
}

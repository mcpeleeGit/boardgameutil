//
//  ContentView.swift
//  boardgameutil
//
//  Created by kakao on 3/19/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DiceView()
                .tabItem {
                    Label("주사위", systemImage: "die.face.1.fill")
                }
            
            TimerView()
                .tabItem {
                    Label("초시계", systemImage: "timer")
                }
        }
    }
}

#Preview {
    ContentView()
}

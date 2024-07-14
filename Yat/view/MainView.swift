//
//  ContentView.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/12.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
   
    @State private var attributeCon: AttributeContainer = AttributeContainer()
    
    var body: some View {
        VStack {
            TypingGroupView()
                .environment(attributeCon)
        }
    }

}



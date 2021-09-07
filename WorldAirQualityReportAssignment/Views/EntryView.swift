//
//  EntryView.swift
//  WorldAirQualityReportAssignment
//
//  Created by Hung Nguyen on 9/3/21.
//

import SwiftUI

struct EntryView: View {
    @State private var selectedTab = 0
    @State private var showModal = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ContentView()
//                .onTapGesture {
//                    self.selectedTab = 1
//                }
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("One")
                }
                .tag(0)
            
            SingleCityView(showModal: $showModal)
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Two")
                }
                .tag(1)
        }
    }
}


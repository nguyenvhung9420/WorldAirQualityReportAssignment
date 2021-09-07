//
//  ContentView.swift
//  WeatherWithNAB
//
//  Created by Hung Nguyen on 8/28/21.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    @ObservedObject var viewModel = ListViewModel()
    @ObservedObject var searchBar = SearchBar()
    @ObservedObject var keyboardHeightGetter = KeyboardHeightHelper()
    @State var errorMessage: String = ""
    @State var cityName: String = ""
    @State private var showModal = false
    @State private var params: [String] = []
    
    @State private var searchText: String = ""
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationView {
                List(viewModel.list, id: \.self) { each in
                    Button(action:  {
                        self.params.append(each)
                        print("currents to query: \(self.params)")
                        if self.params.count >= 3 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.showModal = true
                                return
                            }
                        }
                        self.viewModel.getLocationList(params: self.params) { error in
                            print("error happend: \(error)")
                            self.errorMessage = error.message == "city not found" ? "\(error.message) \(self.searchBar.text)" : "\(error.message)"
                        }
                    }) {
                        Text(each)
                    }
                }
                .navigationBarTitle("All Cities")
                .onAppear {
                    LocationFetcher.shared.start {
                        self.viewModel.getLocationList(params: self.params) { error in
                            print("error happend: \(error)")
                            self.errorMessage = error.message == "city not found" ? "\(error.message) \(self.searchBar.text)" : "\(error.message)"
                        }
                    }
                }
            }
            .sheet(isPresented: $showModal) {
                SingleCityView(showModal: self.$showModal, params: self.params)
            }
            
            VStack(spacing: 0.0) {
                VStack {
                    Text("\(self.errorMessage)")
                        .foregroundColor(.white)
                        .padding()
                }
                .frame(width: UIScreen.main.bounds.width - 32, alignment: .center)
                .background(SwiftUI.Color.red)
                .cornerRadius(12)
                .padding()
                .opacity(self.errorMessage.trimAllSpaces() == "" ? 0 : 1)
            }
        }
    }
}

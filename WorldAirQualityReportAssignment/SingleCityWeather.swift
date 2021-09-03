//
//  ContentView.swift
//  WeatherWithNAB
//
//  Created by Hung Nguyen on 9/3/21.
//

import SwiftUI
import Kingfisher

struct SingleCityView: View {
    @ObservedObject var viewModel = SingleWeatherViewModel()
    @ObservedObject var searchBar = SearchBar()
    @ObservedObject var keyboardHeightGetter = KeyboardHeightHelper()
    @State var errorMessage: String = ""
    
    @Binding var showModal: Bool
    
    @State private var searchText: String = ""
    
    var params: [String] = []
    
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationView {
                Text(viewModel.weather.toJSON().description)
                .navigationBarTitle(Text(viewModel.weather.cityName ?? "No city"))
                    .navigationBarItems(trailing: Button("Dismiss") {
                        self.showModal.toggle()
                    })
                .onAppear {
                    if params != [] {
                        self.viewModel.getSingleWeatherByName(params: params) { error in
                            print("error happend: \(error)")
                            self.errorMessage = error.message == "Error" ? "\(error.message) \(self.searchBar.text)" : "\(error.message)"
                        }
                    } else {
                        self.viewModel.getSingleWeather { error in
                            print("error happend: \(error)")
                            self.errorMessage = error.message == "Error" ? "\(error.message) \(self.searchBar.text)" : "\(error.message)"
                        }
                    }
                        
                }
            }
            
            VStack(spacing: 0.0) {
                
                VStack(alignment: .trailing) {
                    Image(systemName: "magnifyingglass.circle.fill")
                        .font(.system(size: 26, weight: .regular))
                        .foregroundColor(Color.white)
                        .padding()
                }.background(SwiftUI.Color.blue)
                .cornerRadius(18)
                .padding()
                
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

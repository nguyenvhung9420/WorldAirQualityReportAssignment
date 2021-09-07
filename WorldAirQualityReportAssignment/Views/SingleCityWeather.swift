//
//  ContentView.swift
//  WeatherWithNAB
//
//  Created by Hung Nguyen on 9/3/21.
//

import SwiftUI
import Kingfisher
import MapKit

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
                 
//                Text(viewModel.weather.toJSON().description)
                
                List {
                    PieceView(title: "Country" , content: viewModel.weather.countryName ?? "")
                    PieceView(title: "State" , content: viewModel.weather.stateName ?? "")
                    PieceView(title: "Aqicn" , content: "\(viewModel.weather.pollution?.aqicn ?? 0)")
                    PieceView(title: "Aqius" , content: "\(viewModel.weather.pollution?.aqius ?? 0)")
                    PieceView(title: "Maincn" , content: "\(viewModel.weather.pollution?.maincn ?? 0)")
                    PieceView(title: "Mainus" , content: "\(viewModel.weather.pollution?.mainus ?? 0)")
                }
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
        }.background(Color.white)
    }
}

struct PieceView: View {
    private let title: String
    private let content: String
    @State private var blurRadius: Int = 1
    
    init(title: String, content: String) {
        self.title = title
        self.content = content
    }
    
    var body: some View {
            VStack(alignment: .leading, spacing: 7) {
                Text(title) .font(.system(size: 14))
                Text(content).font(.system(size: 20))
            }.padding()
//            .cornerRadius(10)
//            .padding()
//            .border(Color.gray.opacity(0.5), width: 1)
            
    }
}

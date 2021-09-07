//
//  SearchViewController.swift
//  WorldAirQualityReportAssignment
//
//  Created by Hung Nguyen on 9/3/21.
//

import SwiftUI

struct SearchViewController: View {
    @ObservedObject var viewModel = ListViewModel()
    @ObservedObject var searchBar = SearchBar()
    @ObservedObject var keyboardHeightGetter = KeyboardHeightHelper()
    @State var errorMessage: String = ""
    @State var cityName: String = ""
    
    @State private var searchText: String = ""
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationView {
                List(viewModel.list, id: \.self) { each in
                   Text("hung")
                }
                .modifier(SearchBarModifier(searchBar: searchBar))
                .navigationBarTitle(Text(self.viewModel.currentCityString.trimAllSpaces() != "" ?  self.viewModel.currentCityString.capitalized : "Weather"))
                .onAppear {
                    
                }
            }
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

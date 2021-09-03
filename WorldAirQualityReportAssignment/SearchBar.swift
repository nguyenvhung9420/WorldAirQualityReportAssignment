//
//  SearchBar.swift
//  WeatherWithNAB
//
//  Created by Hung Nguyen on 8/28/21.
//

import Foundation
import SwiftUI

class SearchBar: NSObject, ObservableObject, UISearchResultsUpdating, UISearchBarDelegate {
    @Published var text: String = ""
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    var completionWhenPressSearchButton: ((String)->Void)?
    
    override init() {
        super.init()
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
    }
    
    func addCompletion(_ completion: @escaping (String)->Void) {
        self.completionWhenPressSearchButton = completion
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchBarText = searchController.searchBar.text {
            if searchBarText.count < 3 { return }
            self.text = searchBarText
//            self.searchController.isActive = false
            print(self.text)
            if self.completionWhenPressSearchButton != nil {
                self.completionWhenPressSearchButton!(searchBarText)
            }
        }
    }
     
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchBarText = searchController.searchBar.text {
            self.text = searchBarText
            self.searchController.isActive = false
            print(self.text)
//            if self.completionWhenPressSearchButton != nil {
//                self.completionWhenPressSearchButton!(searchBarText)
//            }
        }
    }
}

struct SearchBarModifier: ViewModifier {
    let searchBar: SearchBar
    func body(content: Content) -> some View {
        content
            .overlay(
                ViewControllerResolver(onResolve: { viewController in
                    viewController.navigationItem.searchController = self.searchBar.searchController
                }).frame(width: 0, height: 0)
            )
    }
}

// --------------------------------------------------

final class ViewControllerResolver: UIViewControllerRepresentable {
    let onResolve: (UIViewController) -> Void  // acts as ViewDidLoad or ViewDidAppear
        
    init(onResolve: @escaping (UIViewController) -> Void) {
        self.onResolve = onResolve
    }
    
    func makeUIViewController(context: Context) -> ParentResolverViewController {
        return ParentResolverViewController(onResolve: onResolve)
    }

    func updateUIViewController(_ uiViewController: ParentResolverViewController, context: Context) { }
}

class ParentResolverViewController: UIViewController {
    
    let onResolve: (UIViewController) -> Void
    
    init(onResolve: @escaping (UIViewController) -> Void) {
        self.onResolve = onResolve
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use init(onResolve:) to instantiate ParentResolverViewController.")
    }
        
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        if let parent = parent {
            onResolve(parent)
        }
    }
}

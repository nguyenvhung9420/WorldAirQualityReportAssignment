//
//  Views.swift
//  WorldAirQualityReportAssignment
//
//  Created by Hung Nguyen on 9/3/21.
//

import Foundation
import SwiftUI
import Kingfisher


extension String {
    func trimAllSpaces() -> String {
        return self.filter { !$0.isWhitespace }
    }
}


struct PieceView: View {
    private let piece: City
    @State private var blurRadius: Int = 1
    
    init(piece: City) {
        self.piece = piece
    }
    
    var body: some View {
        HStack {
           
            VStack(alignment: .leading, spacing: 15) {
                Text(piece.name)
                    .font(.system(size: 18))
                Text("\(piece.name) - \(piece.name)")
                    .font(.system(size: 14))
            }
        }
    }
}

struct ActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

//
//  RecommendedMovieView.swift
//  MoviesTR
//
//  Created by Meharoof Najeeb on 2025-09-02.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecommendedMovieView: View {
    let movie: Movie
    
    var body: some View {
        VStack(spacing: 4) {
            WebImage(url: movie.imageURL) { phase in
                Group {
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .cornerRadius(8)
                    default:
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .scaledToFit()
                            .padding(EdgeInsets(top: 30, leading: 30, bottom: 30, trailing: 30))
                    }
                }
                .frame(width: 100, height: 100)
            }
            
            Text(movie.name)
                .fontWeight(.regular)
                .lineLimit(1)
        }
        .frame(width: 100)
    }
}

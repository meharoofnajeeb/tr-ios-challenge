//
//  RecommendedMoviesView.swift
//  MoviesTR
//
//  Created by Meharoof Najeeb on 2025-09-02.
//

import SwiftUI

struct RecommendedMoviesView: View {
    let movies: [Movie]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach(movies) { movie in
                    RecommendedMovieView(movie: movie)
                }
            }
        }
        .scrollBounceBehavior(.basedOnSize, axes: .horizontal)
    }
}

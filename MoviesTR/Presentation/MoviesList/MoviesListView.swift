//
//  MoviesListView.swift
//  MoviesTR
//
//  Created by Meharoof Najeeb on 2025-08-29.
//

import SwiftUI

struct MoviesListView: View {
    @StateObject var viewModel: MoviesListViewModel
        
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    List(viewModel.movies) { movie in
                        NavigationLink(destination: MovieDetailsView()) {
                            MovieListRow(movie: movie)
                        }
                    }
                }
            }
            .navigationTitle("All movies")
            .task {
                await viewModel.fetchMovies()
            }
        }
    }
}

//
//  MoviesListView.swift
//  MoviesTR
//
//  Created by Meharoof Najeeb on 2025-08-29.
//

import SwiftUI

struct MoviesListView: View {
    @StateObject var viewModel: MoviesListViewModel
    
    var destinationProvider: (Int) -> MovieDetailsView
    
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
                        NavigationLink(destination: destinationProvider(movie.id)) {
                            MovieListRow(movie: movie, isLiked: viewModel.isLiked(movieID: movie.id), onLikeTapped: viewModel.toggleLiked)
                        }
                    }
                }
            }
            .navigationTitle("All movies")
            .toolbar {
                if viewModel.errorMessage != nil {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            Task {
                                await viewModel.fetchMovies()
                            }
                        } label: {
                            if viewModel.isLoading {
                                ProgressView()
                            } else {
                                Image(systemName: "arrow.clockwise")
                            }
                        }
                    }
                }
            }
            .task {
                await viewModel.fetchMovies()
            }
        }
    }
}

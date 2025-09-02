//
//  MoviesTRApp.swift
//  MoviesTR
//
//  Created by Meharoof Najeeb on 2025-08-29.
//

import SwiftUI

@main
struct MoviesTRApp: App {
    private let moviesListViewModel: MoviesListViewModel
    private let getMoviesUseCase: GetMoviesUseCase
    private let getMovieDetailUseCase: GetMovieDetailUseCase
    
    init() {
        let networkService = NetworkService()
        let remoteRepository = RemoteMovieRepository(networkService: networkService)
        getMoviesUseCase = GetMoviesUseCase(fetcher: remoteRepository)
        
        moviesListViewModel = MoviesListViewModel(getMoviesUseCase: getMoviesUseCase)
        
        getMovieDetailUseCase = GetMovieDetailUseCase(fetcher: remoteRepository)
    }
    
    var body: some Scene {
        WindowGroup {
            MoviesListView(viewModel: moviesListViewModel) { id in
                let movieDetailViewModel = MovieDetailViewModel(getMovieDetailsUseCase: getMovieDetailUseCase, getMoviesUseCase: getMoviesUseCase, movieID: id)
                return MovieDetailsView(viewModel: movieDetailViewModel)
            }
        }
    }
}

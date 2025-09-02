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
    private let getLikeStatusUseCase: GetLikeStatusUseCase
    private let toggleLikeUseCase: ToggleLikeUseCase
    
    init() {
        let networkService = NetworkService()
        let remoteRepository = RemoteMovieRepository(networkService: networkService)
        getMoviesUseCase = GetMoviesUseCase(fetcher: remoteRepository)
        
        moviesListViewModel = MoviesListViewModel(getMoviesUseCase: getMoviesUseCase)
        
        getMovieDetailUseCase = GetMovieDetailUseCase(fetcher: remoteRepository)
        
        let likesRepository = UserDefaultsLikesRepository()
        getLikeStatusUseCase = GetLikeStatusUseCase(likesRepository: likesRepository)
        toggleLikeUseCase = ToggleLikeUseCase(likesRepository: likesRepository)
    }
    
    var body: some Scene {
        WindowGroup {
            MoviesListView(viewModel: moviesListViewModel) { id in
                let movieDetailViewModel = MovieDetailViewModel(movieID: id, getMovieDetailsUseCase: getMovieDetailUseCase, getMoviesUseCase: getMoviesUseCase, getLikeStatusUseCase: getLikeStatusUseCase, toggleLikeUseCase: toggleLikeUseCase)
                return MovieDetailsView(viewModel: movieDetailViewModel)
            }
        }
    }
}

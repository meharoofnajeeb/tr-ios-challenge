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
    
    init() {
        let networkService = NetworkService()
        let remoteRepository = RemoteMovieRepository(networkService: networkService)
        let getMoviesUseCase = GetMoviesUseCase(fetcher: remoteRepository)
        
        moviesListViewModel = MoviesListViewModel(getMoviesUseCase: getMoviesUseCase)
    }
    
    var body: some Scene {
        WindowGroup {
            MoviesListView(viewModel: moviesListViewModel)
        }
    }
}

//
//  MoviesListViewModel.swift
//  MoviesTR
//
//  Created by Meharoof Najeeb on 2025-09-01.
//

import Combine

@MainActor
final class MoviesListViewModel: ObservableObject {
    private let getMoviesUseCase: GetMoviesUseCaseProtocol
    
    @Published var movies = [Movie]()
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init(getMoviesUseCase: GetMoviesUseCaseProtocol) {
        self.getMoviesUseCase = getMoviesUseCase
    }
    
    func fetchMovies() async {
        isLoading = true
        errorMessage = nil
        do {
            movies = try await getMoviesUseCase.getMovies(type: .all)
        } catch {
            errorMessage = "Some error occured - \(error.localizedDescription). Please try again."
        }
        isLoading = false
    }
}

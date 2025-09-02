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
    private let getLikeStatusUseCase: GetLikesStatusUseCaseProtocol
    private let toggleLikeUseCase: ToggleLikesUseCaseProtocol
    
    @Published var movies = [Movie]()
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init(getMoviesUseCase: GetMoviesUseCaseProtocol, getLikeStatusUseCase: GetLikesStatusUseCaseProtocol, toggleLikeUseCase: ToggleLikesUseCaseProtocol) {
        self.getMoviesUseCase = getMoviesUseCase
        self.getLikeStatusUseCase = getLikeStatusUseCase
        self.toggleLikeUseCase = toggleLikeUseCase
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
    
    func isLiked(movieID: Int) -> Bool {
        return getLikeStatusUseCase.isLiked(movieID)
    }
    
    func toggleLiked(movieID: Int) {
        toggleLikeUseCase.toggleLike(for: movieID)
        objectWillChange.send()
    }
}

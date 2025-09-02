//
//  MovieDetailsViewModel.swift
//  MoviesTR
//
//  Created by Meharoof Najeeb on 2025-09-01.
//

import Combine

final class MovieDetailViewModel {
    private let getMovieDetailsUseCase: GetMovieDetailsUseCaseProtocol
    private let getMoviesUseCase: GetMoviesUseCaseProtocol
    private let movieID: Int
    
    @Published var movieDetails: MovieDetail?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var recommendedMovies = [Movie]()
    
    init(getMovieDetailsUseCase: GetMovieDetailsUseCaseProtocol, getMoviesUseCase: GetMoviesUseCaseProtocol, movieID: Int) {
        self.getMovieDetailsUseCase = getMovieDetailsUseCase
        self.getMoviesUseCase = getMoviesUseCase
        self.movieID = movieID
    }
    
    func loadContent() async {
        await fetchMovieDetails()
        
        guard movieDetails != nil else { return }
        
        await fetchRecommendedMovies()
    }
    
    private func fetchMovieDetails() async {
        isLoading = true
        errorMessage = nil
        do {
            movieDetails = try await getMovieDetailsUseCase.getMovieDetails(for: movieID)
        } catch {
            errorMessage = "Some error occured - \(error.localizedDescription). Please try again."
        }
        isLoading = false
    }
    
    private func fetchRecommendedMovies() async {
        do {
            recommendedMovies = try await getMoviesUseCase.getMovies(type: .recommended(movieID))
        } catch {
            recommendedMovies = []
        }
    }
}

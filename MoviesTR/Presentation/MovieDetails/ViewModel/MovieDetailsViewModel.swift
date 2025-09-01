//
//  MovieDetailsViewModel.swift
//  MoviesTR
//
//  Created by Meharoof Najeeb on 2025-09-01.
//

import Combine

final class MovieDetailViewModel {
    private let getMovieDetailsUseCase: GetMovieDetailsUseCaseProtocol
    private let movieID: Int
    
    @Published var movieDetails: MovieDetail?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    init(getMovieDetailsUseCase: GetMovieDetailsUseCaseProtocol, movieID: Int) {
        self.getMovieDetailsUseCase = getMovieDetailsUseCase
        self.movieID = movieID
    }
    
    func fetchMovieDetails() async {
        isLoading = true
        errorMessage = nil
        do {
            movieDetails = try await getMovieDetailsUseCase.getMovieDetails(for: movieID)
        } catch {
            errorMessage = "Some error occured - \(error.localizedDescription). Please try again."
        }
        isLoading = false
    }
}

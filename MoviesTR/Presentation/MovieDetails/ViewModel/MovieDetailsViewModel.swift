//
//  MovieDetailsViewModel.swift
//  MoviesTR
//
//  Created by Meharoof Najeeb on 2025-09-01.
//

import Foundation
import Combine

@MainActor
final class MovieDetailViewModel: ObservableObject {
    private let movieID: Int
    private let getMovieDetailsUseCase: GetMovieDetailsUseCaseProtocol
    private let getMoviesUseCase: GetMoviesUseCaseProtocol
    private let getLikeStatusUseCase: GetLikesStatusUseCaseProtocol
    private let toggleLikesUseCase: ToggleLikesUseCaseProtocol
    
    @Published var movieDetails: MovieDetail?
    @Published var isLiked = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var recommendedMovies = [Movie]()
    
    var title: String {
        return movieDetails?.name ?? "Loading..."
    }
    
    var rating: String {
        return movieDetails?.rating ?? "N/A"
    }
    
    var releaseDate: String {
        guard let releaseDate = movieDetails?.releaseDate else { return "N/A" }
        return DateFormatter.movieReleaseDate.string(from: releaseDate)
    }
    
    var description: String {
        return movieDetails?.description ?? ""
    }
    
    var notes: String {
        return movieDetails?.notes ?? ""
    }
    
    var imageURL: URL? {
        movieDetails?.imageURL
    }
    
    init(movieID: Int, getMovieDetailsUseCase: GetMovieDetailsUseCaseProtocol, getMoviesUseCase: GetMoviesUseCaseProtocol, getLikeStatusUseCase: GetLikesStatusUseCaseProtocol, toggleLikeUseCase: ToggleLikesUseCaseProtocol) {
        self.movieID = movieID
        self.getMovieDetailsUseCase = getMovieDetailsUseCase
        self.getMoviesUseCase = getMoviesUseCase
        self.getLikeStatusUseCase = getLikeStatusUseCase
        self.toggleLikesUseCase = toggleLikeUseCase
    }
    
    func loadContent() async {
        await fetchMovieDetails()
        refreshLikeStatus()
        
        guard movieDetails != nil else { return }
        
        await fetchRecommendedMovies()
    }
    
    func likeTapped() {
        toggleLike()
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
    
    private func refreshLikeStatus() {
        isLiked = getLikeStatusUseCase.isLiked(movieID)
    }
    
    private func toggleLike() {
        toggleLikesUseCase.toggleLike(for: movieID)
        isLiked.toggle()
    }
}

private extension DateFormatter {
    static let movieReleaseDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}

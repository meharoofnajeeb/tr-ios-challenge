//
//  LikesUseCaseMock.swift
//  MoviesTR
//
//  Created by Meharoof Najeeb on 2025-09-02.
//

@testable import MoviesTR

class LikesUseCaseMock: GetLikesStatusUseCaseProtocol, ToggleLikesUseCaseProtocol {
    private var likedMovies: Set<Int>
    var toggleLikeCallCount = 0
    var isLikedCallCount = 0
    
    init(likedMovies: Set<Int>) {
        self.likedMovies = likedMovies
    }
    
    func isLiked(_ moviedID: Int) -> Bool {
        isLikedCallCount += 1
        return likedMovies.contains(moviedID)
    }
    
    func toggleLike(for movieID: Int) {
        toggleLikeCallCount += 1
        if likedMovies.contains(movieID) {
            likedMovies.remove(movieID)
        } else {
            likedMovies.insert(movieID)
        }
    }
}

//
//  ToggleLikesUseCase.swift
//  MoviesTR
//
//  Created by Meharoof Najeeb on 2025-09-02.
//

final class ToggleLikeUseCase {
    private let likesRepository: LikesRepository
    
    init(likesRepository: LikesRepository) {
        self.likesRepository = likesRepository
    }
    
    func toggleLike(for movieID: Int) {
        likesRepository.toggleLike(for: movieID)
    }
}

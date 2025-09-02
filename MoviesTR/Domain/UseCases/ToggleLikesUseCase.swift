//
//  ToggleLikesUseCase.swift
//  MoviesTR
//
//  Created by Meharoof Najeeb on 2025-09-02.
//

protocol ToggleLikesUseCaseProtocol {
    func toggleLike(for movieID: Int)
}

final class ToggleLikeUseCase: ToggleLikesUseCaseProtocol {
    private let likesRepository: LikesRepository
    
    init(likesRepository: LikesRepository) {
        self.likesRepository = likesRepository
    }
    
    func toggleLike(for movieID: Int) {
        likesRepository.toggleLike(for: movieID)
    }
}

//
//  GetLikeStatusUseCase.swift
//  MoviesTR
//
//  Created by Meharoof Najeeb on 2025-09-02.
//

protocol GetLikesStatusUseCaseProtocol {
    func isLiked(_ moviedID: Int) -> Bool
}

final class GetLikeStatusUseCase: GetLikesStatusUseCaseProtocol {
    private let likesRepository: LikesRepository
    
    init(likesRepository: LikesRepository) {
        self.likesRepository = likesRepository
    }
    
    func isLiked(_ moviedID: Int) -> Bool {
        return likesRepository.isLiked(movieID: moviedID)
    }
}

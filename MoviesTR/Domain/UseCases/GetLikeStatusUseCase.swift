//
//  GetLikeStatusUseCase.swift
//  MoviesTR
//
//  Created by Meharoof Najeeb on 2025-09-02.
//

final class GetLikeStatusUseCase {
    private let likesRepository: LikesRepository
    
    init(likesRepository: LikesRepository) {
        self.likesRepository = likesRepository
    }
    
    func isLiked(_ moviedID: Int) -> Bool {
        return likesRepository.isLiked(movieID: moviedID)
    }
}

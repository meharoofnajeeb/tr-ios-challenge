//
//  LikesRepository.swift
//  MoviesTR
//
//  Created by Meharoof Najeeb on 2025-09-02.
//

protocol LikesRepository {
    func isLiked(movieID: Int) -> Bool
    func toggleLike(for movieID: Int)
}

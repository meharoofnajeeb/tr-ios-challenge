//
//  UserDefaultsLikesRepository.swift
//  MoviesTR
//
//  Created by Meharoof Najeeb on 2025-09-02.
//

import Foundation

final class UserDefaultsLikesRepository: LikesRepository {
    private let userDefaults: UserDefaults
    private let key = "likedMovieIDs"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func toggleLike(for movieID: Int) {
        var likedIDs = getLikedIDs()
        if likedIDs.contains(movieID) {
            likedIDs.remove(movieID)
        } else {
            likedIDs.insert(movieID)
        }
        userDefaults.set(Array(likedIDs), forKey: key)
    }

    func isLiked(movieID: Int) -> Bool {
        return getLikedIDs().contains(movieID)
    }
    
    //MARK: - Private helpers
    private func getLikedIDs() -> Set<Int> {
        let array = userDefaults.array(forKey: key) as? [Int] ?? []
        return Set(array)
    }
}

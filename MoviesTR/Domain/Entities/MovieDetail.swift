//
//  MovieDetail.swift
//  MoviesTR
//
//  Created by Meharoof Najeeb on 2025-08-30.
//

import Foundation

struct MovieDetail: Identifiable, Equatable {
    let id: Int
    let name: String
    let description: String
    let notes: String
    let rating: String
    let imageURL: URL
    let releaseDate: Date
}

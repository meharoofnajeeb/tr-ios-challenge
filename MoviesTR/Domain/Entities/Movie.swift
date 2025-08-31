//
//  Movie.swift
//  MoviesTR
//
//  Created by Meharoof Najeeb on 2025-08-30.
//

import Foundation

struct Movie: Identifiable, Equatable {
    let id: Int
    let name: String
    let imageURL: URL
    let year: String
}

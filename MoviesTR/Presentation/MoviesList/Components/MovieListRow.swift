//
//  MovieListRow.swift
//  MoviesTR
//
//  Created by Meharoof Najeeb on 2025-09-01.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieListRow: View {
    let movie: Movie
    let isLiked: Bool
    let onLikeTapped: (Int) -> Void
    
    var body: some View {
        HStack {
            WebImage(url: movie.imageURL) { phase in
                Group {
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .cornerRadius(8)
                    default:
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .scaledToFit()
                            .padding(EdgeInsets(top: 30, leading: 30, bottom: 30, trailing: 30))
                    }
                }
                .frame(width: 100, height: 100)
            }
            
            VStack(alignment: .leading) {
                Text(movie.name)
                    .fontWeight(.semibold)
                Text("Released: \(movie.year)")
                    .fontWeight(.light)
                    .font(.system(size: 14))
            }
            
            Spacer()
            
            Button {
                onLikeTapped(movie.id)
            } label: {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .foregroundStyle(isLiked ? .red : .black)
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    MovieListRow(movie: Movie(id: 1, name: "Movie 1", imageURL: URL(string: "http://any-url.com")!, year: "2000"), isLiked: false, onLikeTapped: { _ in })
}

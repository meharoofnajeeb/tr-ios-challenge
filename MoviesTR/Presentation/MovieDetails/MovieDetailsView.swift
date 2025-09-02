//
//  MovieDetailsView.swift
//  MoviesTR
//
//  Created by Meharoof Najeeb on 2025-09-01.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieDetailsView: View {
    @StateObject private var viewModel: MovieDetailViewModel

    init(viewModel: MovieDetailViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.movieDetails != nil {
                content()
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage).foregroundColor(.red).padding()
            } else {
                ContentUnavailableView("Movie Not Found", systemImage: "film")
            }
        }
        .navigationTitle(viewModel.title)
        .toolbar {
            Button {
                viewModel.likeTapped()
            } label: {
                Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                    .foregroundStyle(viewModel.isLiked ? .red : .primary)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadContent()
        }
    }

    private func content() -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                WebImage(url: viewModel.imageURL) { image in
                    image.resizable().aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .cornerRadius(12)
                .shadow(radius: 8)

                VStack(alignment: .leading, spacing: 12) {
                    Text(viewModel.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    infoRow(label: "Release Date", value: viewModel.releaseDate)
                    infoRow(label: "Rating", value: viewModel.rating)
                    
                    Divider()
                    
                    section(title: "Description", content: viewModel.description)
                    section(title: "Notes", content: viewModel.notes)
                    
                    Divider()
                    
                    RecommendedMoviesView(movies: viewModel.recommendedMovies)
                }
            }
            .padding()
        }
    }
    
    func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .fontWeight(.medium)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
    
    @ViewBuilder
    private func section(title: String, content: String) -> some View {
        if !content.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                Text(content)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
    }
}

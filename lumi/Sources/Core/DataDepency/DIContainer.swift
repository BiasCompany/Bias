//
//  DIContainer.swift
//  mindcore
//
//  Created by Adithya Firmansyah Putra on 12/12/24.
//

import SwiftData

final class DIContainer {

    private let modelContainer: ModelContainer
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }

    lazy var localDataSource: LocalDataSource = LocalDataSource(container: modelContainer)
    
    lazy var favoriteRepository: FavoriteRepository = FavoriteRepositoryImpl(localDataSource: localDataSource)
    lazy var notesRepository: NotesRepository = NotesRepositoryImpl(localDataSource: localDataSource)
    lazy var productRepository: ProductRepository = ProductRepositoryImpl(localDataSource: localDataSource)
    lazy var skinAnalysisRepository: SkinAnalysisRepository = SkinAnalysisRepositoryImpl(localDataSource: localDataSource)
    
    lazy var initialService: InitialService = InitialServiceImpl(repo: productRepository)
    lazy var productService: ProductService = ProductServiceImpl(repo: productRepository, skinAnalysisRepo: skinAnalysisRepository)
    lazy var favoriteService: FavoriteService = FavoriteServiceImpl(repo: favoriteRepository)
    lazy var notesService: NotesService = NotesServiceImpl()
    lazy var skinAnalysisService: SkinAnalysisService = SkinAnalysisServiceImpl(repo: skinAnalysisRepository)
    
    // Singleton instance to ensure centralized DI management
    static let shared: DIContainer = {
        // Create a default ModelContainer. On failure (e.g., Previews), fall back to in-memory.

        // Prefer a persistent store
        if let persistentContainer = try? ModelContainer(for: AppData.self, ShadeRecommendation.self, Shade.self, SkinTone.self) {
            return DIContainer(modelContainer: persistentContainer)
        }

        // Fallback for Previews/JIT environments
        let inMemoryConfig = ModelConfiguration(isStoredInMemoryOnly: true)
        let inMemoryContainer = try! ModelContainer(for: AppData.self, ShadeRecommendation.self, Shade.self, SkinTone.self, configurations: inMemoryConfig)
        return DIContainer(modelContainer: inMemoryContainer)
    }()
}

    

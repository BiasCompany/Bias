//
//  DIContainer.swift
//  mindcore
//
//  Created by Adithya Firmansyah Putra on 12/12/24.
//

import SwiftData

@MainActor
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
    lazy var productService: ProductService = ProductServiceImpl(repo: productRepository)
    lazy var favoriteService: FavoriteService = FavoriteServiceImpl()
    lazy var notesService: NotesService = NotesServiceImpl()
    lazy var skinAnalysisService: SkinAnalysisService = SkinAnalysisServiceImpl()
    
    // Singleton instance to ensure centralized DI management
    static let shared: DIContainer = {
        // Create a default ModelContainer on the main actor. Adjust models as needed.
        let schema = Schema([AppData.self, ShadeRecommendation.self, Shade.self, SkinTone.self])
        let configuration = ModelConfiguration(schema: schema)
        let container = try! ModelContainer(for: schema, configurations: [configuration])
        return DIContainer(modelContainer: container)
    }()
}

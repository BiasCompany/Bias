//
//  DIContainer.swift
//  mindcore
//
//  Created by Adithya Firmansyah Putra on 12/12/24.
//

@MainActor
final class DIContainer {

    // Singleton (runs on MainActor)
    static let shared: DIContainer = {
        let mc = try! LocalDataSource.makeDefaultContainer(isStoredInMemory: false)
        let ds = LocalDataSource(container: mc)
        return DIContainer(localDataSource: ds)
    }()

    // MARK: Dependencies
    let localDataSource: LocalDataSource
    let favoriteRepository: FavoriteRepository
    let notesRepository: NotesRepository
    let productRepository: ProductRepository
    let skinAnalysisRepository: SkinAnalysisRepository

    // Private init so everything stays consistent
    private init(localDataSource: LocalDataSource) {
        self.localDataSource = localDataSource
        self.favoriteRepository = FavoriteRepositoryImpl(localDataSource: localDataSource)
        self.notesRepository    = NotesRepositoryImpl(localDataSource: localDataSource)
        self.productRepository  = ProductRepositoryImpl(localDataSource: localDataSource)
        self.skinAnalysisRepository = SkinAnalysisRepositoryImpl(localDataSource: localDataSource)
    }
}

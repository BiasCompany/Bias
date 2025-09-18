//
//  DIContainer.swift
//  mindcore
//
//  Created by Adithya Firmansyah Putra on 12/12/24.
//

class DIContainer {
    static let shared = DIContainer()

    // lazy var authRepository: AuthRepository = AuthRepositoryImpl()
    // lazy var authUsecase: AuthUsecase = AuthUsecaseImpl(authRepository: authRepository)
    // lazy var screenTimeRepository: ScreenTimeRepository = ScreenTimeRepositoryImpl()
    // lazy var screenTimeUsecase: ScreenTimeUseCase = ScreenTimeUseCaseImpl(screenTimeRepository: screenTimeRepository)

    private init() {}
}

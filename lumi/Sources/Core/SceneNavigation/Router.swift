//
//  Router.swift
//  mindcore
//
//  Created by Adithya Firmansyah Putra on 12/12/24.
//
import SwiftUI

class Router: ObservableObject {
    @Published var navigationPath = NavigationPath()
    
    enum Route: Hashable {
        case splash
        // Onboarding Flow
        case onboarding
        
        case brandPreference(isEdit: Bool)
        
        // Choose Undertone Flow
        case chooseUndertone(isEdit: Bool)
        case undertoneQuiz(isEdit: Bool)
        case undertoneQuizResult(isEdit: Bool)
        
        // Skin Tone Flow
        case skinToneTutorial
        case cameraSkinTone
        case skinToneLoading
        case skinToneFailed
        case skinToneResult(image: UIImage)

        // Base Flow
        case base
        case recommendation
        case favorites
        case notes

        // All Shades Flow
        case allShades
        case detailShade(shadeRecommendation: ShadeRecommendation)
        case skinAnalysis
    }

    func navigate(to route: Route) {
        print("Router: Navigating to \(route)")
        navigationPath.append(route)
        print("Router: Navigation path updated")
    }
    
    func navigateBack() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }
    
    func navigateToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
    
    func replaceNavigationPath(with routes: [Route]) {
        navigationPath = NavigationPath()
        for route in routes {
            navigationPath.append(route)
        }
    }
    
    func navigateToMainApp() {
        navigationPath = NavigationPath()
        navigationPath.append(Route.base)
    }
}


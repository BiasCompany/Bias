import SwiftUI
import SwiftData
import FamilyControls

struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    
    @StateObject private var router = Router()
    
    var body: some View {
        NavigationStack(path: $router.navigationPath) {
                        
            OnBoardingView()
                .navigationDestination(for: Router.Route.self) { route in
                    destinationView(for: route)
                }
                .navigationBarHidden(true)
        }
        .environmentObject(router)
    }
    
    @ViewBuilder
    private func destinationView(for route: Router.Route) -> some View {
        switch route {
            case .onboarding:
                OnBoardingView()
            // case .brandPreference:
            //     BrandPreferenceView()
            // case .chooseUndertone:
            //     ChooseUndertoneView()
            // case .undertoneQuiz:
            //     UndertoneQuizView()
            // case .undertoneQuizResult:
            //     UndertoneQuizResultView()
            // case .skinToneTutorial:
            //     SkinToneTutorialView()
            // case .cameraSkinTone:
            //     CameraSkinToneView()
            // case .skinToneLoading:
            //     SkinToneLoadingView()
            // case .skinToneFailed:
            //     SkinToneFailedView()
            // case .skinToneResult:
            //     SkinToneResultView()
            // case .base:
            //     BaseView()
            // case .recommendation:
            //     RecommendationView()
            // case .favorites:
            //     FavoritesView()
            // case .notes:
            //     NotesView()
            // case .allShades:
            //     AllShadesView()
            // case .detailShade:
            //     DetailShadeView()
            // case .skinAnalysis:
            //     SkinAnalysisView()
        default:
            OnBoardingView()
        }
    }
}

#Preview {
    RootView()
}

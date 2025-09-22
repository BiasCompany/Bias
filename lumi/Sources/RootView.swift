import SwiftUI
import SwiftData
import FamilyControls

struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    
    @StateObject private var router = Router()
    @StateObject private var chooseBrandViewModel = ChooseBrandViewModel()
    @StateObject private var splashViewModel = SplashViewModel()
    @StateObject private var chooseUndertoneViewModel = ChooseUndertoneViewModel()
    @StateObject private var quizUndertoneViewModel = QuizUndertoneViewModel()
    @StateObject private var chooseSkintoneViewModel = ChooseSkintoneViewModel()
    @StateObject private var cameraViewModel = CameraViewmodel()
    @StateObject private var detailShadeVM = DetailShadeViewModel()
    @StateObject private var resultAnalyzeViewModel = ResultAnalyzeViewmodel()
    
    var body: some View {
        NavigationStack(path: $router.navigationPath) {
                        
        SplashView()
                .navigationDestination(for: Router.Route.self) { route in
                    destinationView(for: route)
                }
//                .navigationBarHidden(true)
        }
        .environmentObject(router)
        .environmentObject(chooseBrandViewModel)
        .environmentObject(splashViewModel)
        .environmentObject(chooseUndertoneViewModel)
        .environmentObject(quizUndertoneViewModel)
        .environmentObject(cameraViewModel)
        .environmentObject(detailShadeVM)
        .environmentObject(resultAnalyzeViewModel)
        .environmentObject(chooseSkintoneViewModel)
    }
    
    @ViewBuilder
    private func destinationView(for route: Router.Route) -> some View {
        switch route {
            case .onboarding:
                OnBoardingView()
            case .brandPreference:
                ChooseBrandView()
             case .chooseUndertone:
                 ChooseUndertoneView()
             case .undertoneQuiz:
                QuizUndertoneView()
             case .undertoneQuizResult:
                 ResultQuizView()
             case .skinToneTutorial:
                ChooseSkintoneView()
            case .cameraSkinTone:
                 CameraView()
             case .skinToneResult:
                 SkinToneResultView()
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

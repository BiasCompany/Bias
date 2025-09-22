import SwiftUI

struct QuizUndertoneView: View {
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var viewModel: QuizUndertoneViewModel

    var body: some View {
        VStack {
            ProgressView(
                value: Double(viewModel.currentStep + 1), total: Double(viewModel.questions.count)
            )
            .tint(.black)
            .progressViewStyle(.linear)

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(viewModel.questions[viewModel.currentStep].title)
                        .font(.system(size: 22, weight: .bold, design: .monospaced))

                    HStack(spacing: 10) {
                        Image(systemName: "info.circle")
                            .font(.caption.weight(.regular))
                        Text(viewModel.questions[viewModel.currentStep].tip)
                            .font(.caption2.weight(.regular))
                    }
                    .padding(12)
                    .background(Color(ColorResource.creamLabel))
                    .cornerRadius(8)

                    VStack(spacing: 16) {
                        ForEach(viewModel.questions[viewModel.currentStep].options, id: \.self) {
                            option in
                            Button(action: {
                                viewModel.selectAnswer(option)
                            }) {
                                Text(option)
                                    .tint(.black)
                                    .font(.callout.weight(.regular))
                                    .padding(12)
                                    .frame(maxWidth: .infinity)
                                    .overlay(
                                        Rectangle()
                                            .stroke(
                                                Color.black,
                                                lineWidth: viewModel.answers[viewModel.currentStep]
                                                    == option ? 2 : 1)
                                    )
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }

            Spacer()

            CustomButton(
                title: viewModel.currentStep == viewModel.questions.count - 1
                    ? "SEE UNDERTONE RESULT" : "NEXT",
                action: {
                    viewModel.nextStep()
                }, isFilled: true,
                variant: viewModel.answers[viewModel.currentStep].isEmpty ? .disabled : .active
            )
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 20)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Text("Quiz \(viewModel.currentStep + 1) of \(viewModel.questions.count)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.gray)
            }
        }
        .onChange(of: viewModel.showResult) { oldValue, newValue in
            if newValue {
                router.navigate(to: .undertoneQuizResult)
            }
        }
    }
}

#Preview {
    QuizUndertoneView()
}

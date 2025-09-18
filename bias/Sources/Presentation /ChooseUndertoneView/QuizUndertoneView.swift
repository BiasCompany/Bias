import SwiftUI

struct QuizUndertoneView: View {
    @StateObject private var viewModel = ChooseUndertoneViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                ProgressView(value: Double(viewModel.currentStep + 1), total: Double(viewModel.questions.count))
                    .tint(.black)
                    .progressViewStyle(.linear)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(viewModel.questions[viewModel.currentStep].title)
                            .font(.system(size: 22, weight: .bold, design: .monospaced))
                        
                        HStack(spacing: 10) {
                            Image(systemName:"info.circle")
                                .font(.caption.weight(.regular))
                            Text(viewModel.questions[viewModel.currentStep].tip)
                                .font(.caption2.weight(.regular))
                        }
                        .padding(12)
                        .background(Color(ColorResource.creamLabel))
                        .cornerRadius(8)
                        
                        VStack(spacing: 16) {
                            ForEach(viewModel.questions[viewModel.currentStep].options, id: \.self) { option in
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
                                                .stroke(Color.black, lineWidth: viewModel.answers[viewModel.currentStep] == option ? 2 : 1)
                                        )
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer()
                
                CustomButton(
                    title: viewModel.currentStep == viewModel.questions.count - 1 ? "SEE UNDERTONE RESULT" : "NEXT",
                    isFilled: true,
                    action: {
                        viewModel.nextStep()
                    },
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
            .navigationDestination(isPresented: $viewModel.showResult) {
                ResultQuizView(viewModel: viewModel)
            }
        }
    }
}




#Preview {
    QuizUndertoneView()
}

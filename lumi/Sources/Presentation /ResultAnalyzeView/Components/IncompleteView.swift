//
//  IncompleteView.swift
//  lumi
//
//  Created by Muhammad Rifqi Syatria on 9/23/25.
//


import SwiftUI
import Vision

 struct IncompleteView: View {
    @ObservedObject var viewModel: ResultAnalyzeViewmodel
    
    var body: some View {
        SkinToneFailedView(onRetake: {
            viewModel.retakePhoto()
        })
    }
}

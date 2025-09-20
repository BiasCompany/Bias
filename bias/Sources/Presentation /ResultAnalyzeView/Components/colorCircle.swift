//
//  colorCircle.swift
//  bias
//
//  Created by Shafa Tiara Tsabita Himawan on 20/09/25.
//
import SwiftUI

struct circleColor: View {
    var color: Color
    var diameter : CGFloat = 38
    var selectedDot: Bool = false
    
    var body: some View {
        ZStack{
            Circle()
                .fill(color)
            Circle()
                .stroke(.white, lineWidth: selectedDot ? 4 : 2)
        }
        .frame(width: diameter, height: diameter)
        .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 3)
    }
}

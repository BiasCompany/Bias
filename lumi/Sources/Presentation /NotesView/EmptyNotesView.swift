//
//  EmptyStateView.swift
//  lumi
//
//  Created by Muhammad Rifqi Syatria on 9/22/25.
//

import SwiftUI

struct EmptyNotesView: View {

    var body: some View {
        ZStack {

            VStack(alignment: .center, spacing: 20) {

                Image(systemName: "pencil.and.list.clipboard")
                    .foregroundColor(Color(ColorResource.bgGreyLabel))
                    .font(.system(size: 45))
                Text("NO NOTES YET")
                    .foregroundColor(Color(ColorResource.bgGreyLabel))
                    .font(.title2.monospaced())
                    .fontWeight(.semibold)
                Text("Your notes will be listed here.")
                    .font(.callout)
                    .fontWeight(.regular)
                    .foregroundColor(Color(ColorResource.bgGreyLabel))

            }

            .frame(maxWidth: .infinity)
        }

    }
}

#Preview {
    EmptyNotesView()
}

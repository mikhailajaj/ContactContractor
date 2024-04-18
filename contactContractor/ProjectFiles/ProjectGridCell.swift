//
//  ProductGridCell.swift
//  contactContractor
//
//  Created by Mikha2il 3ajaj on 2024-03-29.
//

import SwiftUI
import AmplifyImage
struct ProjectGridCell: View {
    // 1
    let Project: Project
    
    var body: some View {
        // 2
        ZStack(alignment: .bottomLeading) {
            // 3
            AmplifyImage(key: Project.imageKey)
                .scaleToFillWidth()
            // 4
            Text("\(Project.name)")
                .bold()
                .foregroundColor(.white)
                .padding(4)
                .background(Color(white: 0.1, opacity: 0.6))
        }
    }
}

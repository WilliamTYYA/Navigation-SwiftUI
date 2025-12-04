//
//  Sample-ViewThatFits.swift
//  Navigation-SwiftUI
//
//  Created by Thiha Ye Yint Aung on 12/4/25.
//

import SwiftUI

struct UploadProgressView: View {
    var uploadProgress: Double
    
    
    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack {
                Text("\(uploadProgress.formatted(.percent))")
                ProgressView(value: uploadProgress)
                    .frame(width: 100)
            }
            ProgressView(value: uploadProgress)
                .frame(width: 100)
            Text("\(uploadProgress.formatted(.percent))")
        }
    }
}

#Preview {
    VStack {
        UploadProgressView(uploadProgress: 0.75)
            .frame(maxWidth: 150)
//        UploadProgressView(uploadProgress: 0.75)
//            .frame(maxWidth: 200)
//        UploadProgressView(uploadProgress: 0.75)
//            .frame(maxWidth: 200)
    }
}

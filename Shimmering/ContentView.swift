//
//  ContentView.swift
//  Shimmering
//
//  Created by Yi-Hsiu Lee on 2024/7/24.
//

import SwiftUI

/// A view that demonstrates a shimmering effect on an image and text.
///
/// This view showcases the use of a custom `shimmering` modifier to create a loading effect.
/// It displays an image loaded asynchronously and a descriptive text, both of which can be
/// toggled between a loading state (with shimmering effect) and a loaded state.
///
/// - Note: Tap anywhere on the view to toggle the loading state.
struct ContentView: View {
    /// A state variable that determines whether the content is in a loading state.
    @State private var loading = true
    
    var body: some View {
        VStack {
            // AsyncImage view for loading and displaying an image
            AsyncImage(url: URL(string: "https://images.pexels.com/photos/27127406/pexels-photo-27127406/free-photo-of-cartera-beige.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
                    .frame(width: 300, height: 300)
            }
            .clipShape(RoundedRectangle(cornerRadius: 25))
            
            // Descriptive text about the shimmering effect
            Text("Shimmering is a super-light modifier that adds a \"shimmering\" effect to any SwiftUI View, for example, to show that an operation is in progress.")
        }
        // Apply redaction and shimmering effect based on loading state
        .redacted(reason: loading ? .placeholder : [])
        .shimmering(active: loading)
        .padding()
        // Toggle loading state on tap
        .onTapGesture {
            withAnimation {
                loading.toggle()
            }
        }
    }
}

/// A preview provider for ContentView.
///
/// This preview allows you to see the ContentView in Xcode's preview canvas.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

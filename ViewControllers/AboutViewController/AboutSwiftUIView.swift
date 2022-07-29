import SwiftUI

struct AboutSwiftUIView: View {
    
    var body: some View {
        
        VStack {
            
            VStack {
                
                Text("Astronomy\nPicture of the Day")
                    .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
                    .fontWeight(.bold)
                    .foregroundColor(Color.blue)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Text("   Discover the Universe by desktop or mobile   ")
                    .font(.footnote)
                    .foregroundColor(.white)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(8)
                    .shadow(radius: 8)
            }
            .padding(.bottom)
            
            Divider()
            
            ScrollView {
                
                Text("""
Astronomy Picture of the Day (APOD) is being used as an educational resource.

A fun way to explore science for a beginner.

Detailed pictures and explanations of Universe, amazing facts related to space and Earth science, technology, and NASA's missions of discovery.

The largest and most popular platform for people-powered research.

Powered by\nPublic NASA API: https://api.nasa.gov
""")
                .font(.body)
                .fontWeight(.regular)
                .multilineTextAlignment(.center)
                                
                Divider()
                
                Text("Created by ya.apod@icloud.com\nfor https://TeachMeSkills.by")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .padding()
        }
    }
}

//struct AboutSwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        AboutSwiftUIView()
//            .previewInterfaceOrientation(.portrait)
//    }
//}

import SwiftUI

// 読み込み対象のデータからロードして画像を表示するView
struct LoadableImage: View {
    var imageMetadata: Recipe
    
    @Binding var cachedImage: Image?
    @Binding var size: CGSize
    
    var body: some View {
        // 非同期でURLを用いて画像をロードして表示するためのView
        AsyncImage(url: URL(string: imageMetadata.foodImageUrl)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .animation(.default, value: image)
                    .accessibility(hidden: false)
                    .accessibilityLabel(Text(imageMetadata.recipeTitle))
                    .overlay {
                        GeometryReader() { geometry in
                            Color.clear
                            .preference(key: SizePreferenceKey.self, value: geometry.size)
                            .onPreferenceChange(SizePreferenceKey.self) { size = $0 }
                        }
                    }
                let _ = cacheImage(image)
            } else if phase.error != nil {// エラーが発生しているとき
                // エラーが発生したことをユーザに知らせる
                VStack {
                    Image("pandaplaceholder")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 300)
                    Text("The recipes were all busy.")
                        .font(.title2)
                    Text("Please try again.")
                        .font(.title3)
                }
                
            } else { // 読み込み中のとき
                ProgressView()
            }
        }
    }
    
    private func cacheImage(_ image: Image) -> Bool {
        cachedImage = image
        return true
    }
    
    private struct SizePreferenceKey: PreferenceKey {
        static var defaultValue: CGSize = .zero

        static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
            value = nextValue()
        }
    }
}

struct Recipe_Previews: PreviewProvider {
    @State private static var recipeImage: Image?
    @State private static var recipeSize = CGSize.zero
    static var previews: some View {
        LoadableImage(imageMetadata: Recipe.defaultRecipe, cachedImage: $recipeImage, size: $recipeSize)
    }
}

import SwiftUI

struct RecipeView: View {
    let recipe: Recipe
    @State private var recipeImage: Image?
    @State private var recipeSize = CGSize.zero
    @State private var showDetail = false
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text(recipe.recipeTitle)
                .font(.title2)
                .bold()
            // モデルデータから画像を非同期で読み込む
            LoadableImage(imageMetadata: recipe, cachedImage: $recipeImage, size: $recipeSize)
                .frame(maxWidth: 180, maxHeight: 100)
            Text("Show detail")
                .foregroundColor(.blue)
                .onTapGesture {
                    showDetail.toggle()
                }
            if (showDetail) {
                Text(recipe.recipeDescription)
                List(recipe.recipeMaterial, id: \.self) {
                    item in Text(item).listRowBackground(Color(red:0.12, green:0.02, blue:0.02, opacity:0.04))
                }
                .scrollContentBackground(.hidden)
                Spacer()
            }
        }
    }
}

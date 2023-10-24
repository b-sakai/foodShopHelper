import SwiftUI

struct RandomRecipeView: View, Sendable {
    @EnvironmentObject var fetcher: RecipeCollectionFetcher
    @State private var errorMessage = ""
    @State private var recipeImage: Image?
    @State private var recipeSize = CGSize.zero
    @Binding var todayCourse :[Recipe]
    @State private var addTodayCourseMessage = ""

    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text(fetcher.currentRecipe.recipeTitle)
                .font(.title2)
                .bold()
            // レシピ画像を非同期で読み込む
            LoadableImage(imageMetadata: fetcher.currentRecipe, cachedImage: $recipeImage, size: $recipeSize)
            // レシピ説明文
            Text(fetcher.currentRecipe.recipeDescription)
            // レシピ材料
            List(fetcher.currentRecipe.recipeMaterial, id: \.self) {
                item in Text(item).listRowBackground(Color(red:0.12, green:0.02, blue:0.02, opacity:0.04))
            }
            .scrollContentBackground(.hidden)
            
            Spacer()

            HStack {
                // ランダム表示を行うボタン
                Button {
                    // currentRecipeは公開値なので変更されるとLoadableImageビューが自動的にアップデートされる
                    if let randomImage = fetcher.recipeData.result.randomElement() {
                        fetcher.currentRecipe = randomImage
                    }
                    addTodayCourseMessage = ""
                } label: {
                    VStack {
                        Image(systemName: "questionmark.bubble")
                            .font(.largeTitle)
                            .padding(.bottom, 4)
                        Text("Random Recipe")
                    }
                    .frame(maxWidth: 180, maxHeight: .infinity)
                }

                // 今日の料理に追加するためのボタン
                Button {
                    var isAppended = false
                    if (!todayCourse.contains(fetcher.currentRecipe)) {
                        isAppended = true
                        todayCourse.append(fetcher.currentRecipe)
                    }
                    if isAppended {
                        self.addTodayCourseMessage = "Success! This recipe is appended in today`s course"
                    } else {
                        self.addTodayCourseMessage = "Warning! This recipe is already appended in today`s course"
                    }
                } label: {
                    VStack {
                        Image(systemName: "plus.circle")
                            .font(.largeTitle)
                            .padding(.bottom, 4)
                        Text("Today's Course")
                    }
                    .frame(maxWidth: 180, maxHeight: .infinity)
                }
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxHeight: 180, alignment: .center)
            if !errorMessage.isEmpty { // エラーメッセージが存在するとき
                Text(errorMessage)
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { timer in
                            self.errorMessage = ""
                        }          
                    }
            }
            if !addTodayCourseMessage.isEmpty { // 追加した旨を表示するメッセージが存在するとき
                Text(addTodayCourseMessage)
                    .fontWeight(.thin)
                    .foregroundColor(Color.accentColor)
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { timer in
                            self.addTodayCourseMessage = ""
                        }          
                    }
            }
        }
        .padding()
        .task {
            do {
                try await fetcher.fetchData()
            } catch {
                // errorオブジェクトを使って発生したエラーの詳細情報を格納する
                errorMessage = error.localizedDescription
            }
        }
    }
}

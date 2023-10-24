import SwiftUI

// Concurrency環境で安全に送信（共有）できる
struct MemeCreator: View, Sendable {
    @EnvironmentObject var fetcher: PandaCollectionFetcher
    
    @State private var memeText = ""
    @State private var textSize = 60.0
    @State private var textColor = Color.white
    @State private var errorMessage = ""
    
    @State private var memeImage: Image?
    @State private var memeSize = CGSize.zero

    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            // モデルデータから画像を非同期で読み込む
            /*#-code-walkthrough(5.loadableImage)*/
            LoadableImage(imageMetadata: fetcher.currentPanda, cachedImage: $memeImage, size: $memeSize)
                .overlay(alignment: .bottom) {
                    TextField(
                        "Meme Text",
                        text: $memeText,
                        prompt: Text("")
                    )
                    .focused($isFocused)
                    .font(.system(size: textSize, weight: .heavy))
                    .shadow(radius: 10)
                    .foregroundColor(textColor)
                    .padding()
                    .multilineTextAlignment(.center)
                }
                /*#-code-walkthrough(5.overlay)*/
                .frame(minHeight: 150)

            Spacer()
            
            if !memeText.isEmpty {
                VStack {
                    HStack {
                        Text("Font Size")
                            .fontWeight(.semibold)
                        Slider(value: $textSize, in: 20...140)
                    }
                    
                    HStack {
                        Text("Font Color")
                            .fontWeight(.semibold)
                        ColorPicker("Font Color", selection: $textColor)
                            .labelsHidden()
                        Spacer()
                    }
                }
                .padding(.vertical)
                .frame(maxWidth: 325)
                
            }

            HStack {
                Button {
                    // Todo currentPandaは公開値なので変更されるとLoadableImageビューが自動的にアップデートされる
                    if let randomImage = fetcher.imageData.sample.randomElement() {
                        fetcher.currentPanda = randomImage
                    }
                } label: {
                    VStack {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.largeTitle)
                            .padding(.bottom, 4)
                        Text("Shuffle Photo")
                    }
                    .frame(maxWidth: 180, maxHeight: .infinity)
                }

                Button {
                    isFocused = true
                } label: {
                    VStack {
                        Image(systemName: "textformat")
                            .font(.largeTitle)
                            .padding(.bottom, 4)
                        Text("Add Text")
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
        .navigationTitle("Meme Creator")
        .toolbar(content: {
            ShareLink(
                item: snapshot,
                preview: SharePreview(memeText, image: snapshot)
            )
        })
    }
    
    var snapshot: MemeSnapshot {
        MemeSnapshot(image: memeImage ?? Image(systemName: "photo"), size: memeSize, text: memeText, textSize: textSize, textColor: textColor)
    }
}

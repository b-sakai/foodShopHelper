import SwiftUI

// 楽天レシピのWebAPIを用いてRecipeデータを取得するためのクラス
class PandaCollectionFetcher: ObservableObject {
    @Published var imageData = PandaCollection(sample: [Panda.defaultPanda])
    @Published var currentPanda = Panda.defaultPanda
    
    let urlString = "http://playgrounds-cdn.apple.com/assets/pandaData.json"
    
    // JSONデータ取得時のカスタムエラー定義
    enum FetchError: Error, LocalizedError {
        case badResponse
        case failedRequest(status: Int)
        case badJSON(error: Error)
        
        // カスタムエラーごとに読みやすい説明を表示するためのLocalizedErrorプロトコル
        public var errorDescription: String? {
            switch self {
            case .badResponse:
                return "The server returned an unrecognized response."
            case .failedRequest(let status):
                return "The request failed with status code: \(status)"
            case .badJSON(let error):
                return "An error occurred while decoding JSON: \(error)"
            }
        }
    }

    // JSONデータを取得する非同期関数
    func fetchData() async 
    throws {
        // 有効なURLか判定して設定
        guard let url = URL(string: urlString) else { return }

        // URLを用いてデータを取得する
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        
        // レスポンスが取得できたかダウンキャストして確認する
        guard let response = response as? HTTPURLResponse else {
            throw FetchError.badResponse
        }
        
        // HTTPステータスコードを確認する
        guard response.statusCode == 200 else {
            throw FetchError.failedRequest(status: response.statusCode)
        }

        // JSONデータをメインスレッドでデコードする
        try await MainActor.run {
            do {
                imageData = try JSONDecoder().decode(PandaCollection.self, from: data)
            } catch {
                throw FetchError.badJSON(error: error)
            }
        }
    }
    
}

extension PandaCollectionFetcher: @unchecked Sendable {}

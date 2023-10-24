import SwiftUI

// JSONデータを格納するための構造体
struct Panda: Codable {
    var description: String
    var imageUrl: URL?
    
    static let defaultPanda = Panda(description: "Cute Panda",
                                    imageUrl: URL(string: "https://playgrounds-cdn.apple.com/assets/pandas/pandaBuggingOut.jpg"))
}

// Recipeの配列を表す構造体
struct PandaCollection: Codable {
    var sample: [Panda]
}

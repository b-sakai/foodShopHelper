import SwiftUI

// JSONデータを格納するための構造体
struct Recipe: Codable, Hashable {
    let foodImageUrl: String
    let mediumImageUrl: String
    let nickname: String
    let pickup: Int
    let rank: String
    let recipeCost: String
    let recipeDescription: String
    let recipeId: Int
    let recipeIndication: String
    let recipeMaterial: [String]
    let recipePublishday: String
    let recipeTitle: String
    let recipeUrl: String
    let shop: Int
    
    let smallImageUrl: String
    
    static let defaultRecipe = Recipe(
        foodImageUrl: "",
        mediumImageUrl: "",
        nickname: "",
        pickup: 0,
        rank: "",
        recipeCost: "",
        recipeDescription: "Tap Random Recipe Button!",
        recipeId: 0,
        recipeIndication: "",
        recipeMaterial: [""],
        recipePublishday: "",
        recipeTitle: "",
        recipeUrl: "",
        shop: 0,
        smallImageUrl: ""
    )
}

// Recipeの配列を表す構造体
struct RecipeCollection: Codable {
    let result: [Recipe]
}

// RecipeCollectionのための観測オブジェクト

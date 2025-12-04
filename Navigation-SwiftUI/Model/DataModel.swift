//
//  DataModel.swift
//  Navigation-SwiftUI
//
//  Created by Thiha Ye Yint Aung on 12/3/25.
//

import Observation
import Foundation

@Observable
final class DataModel {
    private(set) var recipes: [Recipe]
    
    private var recipesById: [Recipe.ID: Recipe] = [:]
    
    static let shared: DataModel = {
        try! DataModel(contentsOf: dataURL)
    }()
    
    public init(contentsOf url: URL, options: Data.ReadingOptions = .mappedIfSafe) throws {
        let data = try Data(contentsOf: url, options: options)
        let recipes = try JSONDecoder().decode([Recipe].self, from: data)
        
        self.recipesById = Dictionary(uniqueKeysWithValues: recipes.map { recipe in
            (recipe.id, recipe)
        })
        self.recipes = recipes.sorted { $0.name < $1.name }
    }
    
    private static var dataURL: URL {
        get throws {
            let bundle = Bundle.main
            guard let path = bundle.path(forResource: "Recipes", ofType: "json")
            else { throw CocoaError(.fileReadNoSuchFile) }
            return URL(fileURLWithPath: path)
        }
    }
    
    func recipe(in category: Category) -> [Recipe] {
        recipes.filter { $0.category == category }
    }
    
    func recipe(relatedTo recipe: Recipe) -> [Recipe] {
        recipes.filter { recipe.related.contains($0.id) }
    }
    
    subscript(recipeId: Recipe.ID) -> Recipe? {
        recipesById[recipeId]
    }
}

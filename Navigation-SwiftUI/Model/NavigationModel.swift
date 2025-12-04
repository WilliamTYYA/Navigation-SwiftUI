//
//  NavigationModel.swift
//  Navigation-SwiftUI
//
//  Created by Thiha Ye Yint Aung on 12/2/25.
//

import Observation
import SwiftUI

@Observable
final class NavigationModel: Codable {
    var selectedCategory: Category?
    var recipePath: [Recipe]
    
    var columnVisibility: NavigationSplitViewVisibility
    var showExperiencePicker = false
    
    private static let decoder = JSONDecoder()
    private static let encoder = JSONEncoder()
    
    private static var dataURL: URL {
        .cachesDirectory.appending(path: "NavigationData.json")
    }
    
    static let shared: NavigationModel = {
        if let model = try? NavigationModel(contentsOf: dataURL) {
            return model
        } else {
            return NavigationModel()
        }
    }()
    
    init(
        selectedCategory: Category? = nil,
        recipePath: [Recipe] = [],
        columnVisibility: NavigationSplitViewVisibility = .automatic
    ) {
        self.selectedCategory = selectedCategory
        self.recipePath = recipePath
        self.columnVisibility = columnVisibility
    }
    
    private convenience init(
        contentsOf url: URL,
        options: Data.ReadingOptions = .mappedIfSafe
    ) throws {
        let data = try Data(contentsOf: url, options: options)
        let model = try Self.decoder.decode(Self.self, from: data)
        self.init(selectedCategory: model.selectedCategory, recipePath: model.recipePath, columnVisibility: model.columnVisibility)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(selectedCategory, forKey: .selectedCategory)
        try container.encode(recipePath.map(\.id), forKey: .recipePathIds)
        try container.encode(columnVisibility, forKey: .columnVisibility)
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.selectedCategory = try container.decodeIfPresent(Category.self, forKey: .selectedCategory)
        let recipePathIds = try container.decode([Recipe.ID].self, forKey: .recipePathIds)
        self.recipePath = recipePathIds.compactMap { DataModel.shared[$0] }
        self.columnVisibility = try container.decode(NavigationSplitViewVisibility.self, forKey: .columnVisibility)
    }
    
    enum CodingKeys: CodingKey {
        case selectedCategory
        case recipePathIds
        case columnVisibility
    }
    
    func load() throws {
        let model = try NavigationModel(contentsOf: Self.dataURL)
        selectedCategory = model.selectedCategory
        recipePath = model.recipePath
        columnVisibility = model.columnVisibility
    }
    
    func save() throws {
        try jsonData?.write(to: Self.dataURL)
    }
    
    var jsonData: Data? {
        get { try? Self.encoder.encode(self) }
        set {
            guard
                let data = newValue,
                let model = try? Self.decoder.decode(Self.self, from: data)
            else { return }
            selectedCategory = model.selectedCategory
            recipePath = model.recipePath
            columnVisibility = model.columnVisibility
        }
    }
    
    /// The selected recipe; otherwise returns `nil`.
    var selectedRecipe: Recipe? {
        get { recipePath.first }
        set { recipePath = [newValue].compactMap { $0 } }
    }
}

//
//  NameSpace+Text.swift
//  Lucky-Test-burguer
//
//  Created by Miguel Angel Saravia Belmonte on 1/15/23.
//

import Foundation

// MARK: - Text Typealias
/// Typealias used to simplify the access to the Text enum. `Namespace.Text`.
typealias Text = Namespace.Text

extension Namespace {
    
    // MARK: - Text
    
    /// The Text enum allows to define texts used through the app.
    enum Text {
        /// App common title. Value is `Title`.
        static let hometitle = "Title"
    }
}

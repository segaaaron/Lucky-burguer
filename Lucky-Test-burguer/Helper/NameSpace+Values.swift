//
//  NameSpace+Values.swift
//  Lucky-Test-burguer
//
//  Created by Miguel Angel Saravia Belmonte on 1/15/23.
//

import Foundation

// MARK: - Text Typealias
/// Typealias used to simplify the access to the Text enum. `Namespace.Text`.
typealias Value = Namespace.Value

extension Namespace {
    
    // MARK: - Text
    
    /// The Text enum allows to define values used through the app.
    enum Value {
        static let defaultValue = 0
        static let headerTitleSize: CGFloat = 14.0
        static let headerSize: CGFloat = 40.0
        static let headerCellTitleSize: CGFloat =  24.0
        static let headerCellHeightSize: CGFloat = 50.0
        static let imageDefaultSize: CGFloat = 25.0
    }
}

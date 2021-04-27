//
//  CostumeTextField.swift
//  SwiftUI - Stocks App
//
//  Created by Jesper Bertelsen on 10/04/2021.
//

import SwiftUI

struct CustomTextField: View {
    var placeHolder: Text
    
    @Binding var text: String
    
    var editingChanged: (Bool) -> Void = {_ in }
    var commit: () -> Void = {}
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeHolder }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}

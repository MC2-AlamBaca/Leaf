//
//  FocuseableTextField.swift
//  Leaf
//
//  Created by Marizka Ms on 03/07/24.
//

import SwiftUI

struct FocusableTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.text = text
//        textField.borderStyle = .roundedRect
        textField.delegate = context.coordinator
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        if context.environment.isFocused {
            uiView.becomeFirstResponder()
        } else {
            uiView.resignFirstResponder()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: FocusableTextField

        init(_ parent: FocusableTextField) {
            self.parent = parent
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }
}

extension EnvironmentValues {
    var isFocused: Bool {
        get { self[IsFocusedKey.self] }
        set { self[IsFocusedKey.self] = newValue }
    }
}

private struct IsFocusedKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension View {
    func focused(_ isFocused: Bool) -> some View {
        environment(\.isFocused, isFocused)
    }
}


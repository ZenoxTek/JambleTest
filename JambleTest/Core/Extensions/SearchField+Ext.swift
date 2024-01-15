//
//  SearchField+Ext.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import UIKit

// MARK: - UISearchBar Extension

extension UISearchBar {

    /// Returns the search field's UITextField.
    func getTextField() -> UITextField? { return value(forKey: "searchField") as? UITextField }

    /// Sets the text color of the search field.
    func set(textColor: UIColor) { if let textField = getTextField() { textField.textColor = textColor } }

    /// Sets the placeholder text color of the search field.
    func setPlaceholder(textColor: UIColor) { getTextField()?.setPlaceholder(textColor: textColor) }

    /// Sets the background color of the search field.
    func setTextField(color: UIColor) {
        guard let textField = getTextField() else { return }
        textField.backgroundColor = color
        textField.layer.cornerRadius = 18
        textField.clipsToBounds = true
    }

    /// Sets the tint color of the search field's search image.
    func setSearchImage(color: UIColor) {
        guard let imageView = getTextField()?.leftView as? UIImageView else { return }
        imageView.tintColor = color
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
    }
}

// MARK: - UITextField Extension

private extension UITextField {

    /// Custom UILabel class to set placeholder text color.
    private class Label: UILabel {
        private var _textColor = UIColor.lightGray
        override var textColor: UIColor! {
            set { super.textColor = _textColor }
            get { return _textColor }
        }

        init(label: UILabel, textColor: UIColor = .lightGray) {
            _textColor = textColor
            super.init(frame: label.frame)
            self.text = label.text
            self.font = label.font
        }

        required init?(coder: NSCoder) { super.init(coder: coder) }
    }

    /// Returns the placeholder UILabel of the UITextField.
    var placeholderLabel: UILabel? { return value(forKey: "placeholderLabel") as? UILabel }

    /// Sets the placeholder text color of the UITextField.
    func setPlaceholder(textColor: UIColor) {
        guard let placeholderLabel = placeholderLabel else { return }
        let label = Label(label: placeholderLabel, textColor: textColor)
        setValue(label, forKey: "placeholderLabel")
    }
}

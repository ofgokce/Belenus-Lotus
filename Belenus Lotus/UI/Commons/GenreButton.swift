//
//  GenreButton.swift
//  Belenus Lotus
//
//  Created by Ömer Faruk Gökce on 25.05.2021.
//

import UIKit

class GenreButton: UIButton {

    private var input: UIView? = UIView()
    private var inputAccesory: UIView? = UIView()
    
    override var inputView: UIView? {
        get {
            input
        }
        set {
            input = newValue
            addDoneButton()
            becomeFirstResponder()
        }
    }

    override var inputAccessoryView: UIView? {
        get {
            inputAccesory
        }
        set {
            inputAccesory = newValue
        }
    }
    
    override var canBecomeFirstResponder: Bool {
       true
    }
    
    init(_ action: @escaping (GenreButton) -> Void) {
        super.init(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
        setup()
        addAction(action)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup() {
        self.setTitleColor(.black, for: .normal)
        self.contentHorizontalAlignment = .trailing
        self.titleLabel?.font = .systemFont(ofSize: 14)
    }
    
    func addAction(_ handler: @escaping (GenreButton) -> Void) {
        self.addAction(UIAction(handler: { _ in
            handler(self)
        }), for: .touchUpInside)
    }
    
    private func addDoneButton() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.tintColor = .black
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        toolbar.setItems([flexButton, doneButton], animated: false)
        toolbar.backgroundColor = .gray
        self.inputAccessoryView = toolbar
    }
    
    @objc private func doneAction() {
        superview?.endEditing(true)
    }
}

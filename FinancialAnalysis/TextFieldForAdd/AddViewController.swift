//
//  TextFieldForAdd.swift
//  FinancialAnalysis
//
//  Created by Евгения Головкина on 09.10.2022.
//

import Foundation
import UIKit

final class AddViewController: UIViewController {
    
    public var presenter: AddPresenterInput?
    
    private let addView = UIView()
    private let categoryTextField = UITextField()
    private let numberTextField = UITextField()
    private let addButton = UIButton()
    private let separatorCategoryView = UIView()
    private let separatorNumberView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTextField.becomeFirstResponder()
        setupUI()
        
        categoryTextField.placeholder = presenter?.addType.textFieldPlaceholder
        numberTextField.placeholder = "Сумма"
        addButton.setTitle(presenter?.addType.buttonTitle, for: .normal)
    }
    
    func getCategory() -> String {
        return categoryTextField.text ?? ""
    }
    
    func getIncome() -> Double {
        return NumberFormatter().number(from: numberTextField.text ?? "0")?.doubleValue ?? 0
    }
    
    func getNumber() -> String{
        return numberTextField.text  ?? ""
    }
}

private extension AddViewController {
    func setupUI() {
        view.addSubview(addView)
        
        let buttonBottom = view.keyboardLayoutGuide.topAnchor.constraint(equalToSystemSpacingBelow: addView.bottomAnchor, multiplier: 0)
        let buttonTrailing = view.keyboardLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: addView.trailingAnchor, multiplier: 0)
        NSLayoutConstraint.activate([buttonBottom, buttonTrailing])
        
        addView.backgroundColor = .white
        addView.snp.makeConstraints { make in
            if presenter?.addType == .cost {
                make.height.equalTo(232)
            } else {
                make.height.equalTo(168)
            }
            make.width.equalToSuperview()
        }
        
        if presenter?.addType != .income {
            addView.addSubview(categoryTextField)
            categoryTextField.backgroundColor = .white
            categoryTextField.clearButtonMode = .always
            categoryTextField.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview().inset(16)
                make.height.equalTo(64)
            }
            
            addView.addSubview(separatorCategoryView)
            separatorCategoryView.backgroundColor = .systemGray4
            separatorCategoryView.snp.makeConstraints { make in
                make.top.equalTo(categoryTextField.snp.bottom).inset(1)
                make.right.left.equalToSuperview().inset(16)
                make.height.equalTo(0.5)
            }
        }
        
        if presenter?.addType == .cost || presenter?.addType == .income {
            addView.addSubview(numberTextField)
            numberTextField.backgroundColor = .white
            numberTextField.clearButtonMode = .always
            numberTextField.keyboardType = .decimalPad
            numberTextField.snp.makeConstraints { make in
                if presenter?.addType == .cost {
                    make.top.equalTo(separatorCategoryView).inset(1)
                } else {
                    make.top.equalToSuperview()
                }
                make.left.right.equalToSuperview().inset(16)
                make.height.equalTo(64)
            }
            
            addView.addSubview(separatorNumberView)
            separatorNumberView.backgroundColor = .systemGray4
            separatorNumberView.snp.makeConstraints { make in
                make.top.equalTo(numberTextField.snp.bottom).inset(1)
                make.right.left.equalToSuperview().inset(16)
                make.height.equalTo(0.5)
            }
        }
        
        addView.addSubview(addButton)
        addButton.backgroundColor = .blue
        addButton.layer.cornerRadius = 24
        addButton.addTarget(self, action: #selector(addCategoryButtonClick), for: .touchUpInside)
        addButton.snp.makeConstraints { make in
            make.right.left.equalToSuperview().inset(12)
            if presenter?.addType == .cost || presenter?.addType == .income {
                make.top.equalTo(numberTextField.snp.bottom).offset(21)
            } else {
                make.top.equalTo(categoryTextField.snp.bottom).offset(21)
            }
            make.height.equalTo(48)
        }
    }
    
    @objc func addCategoryButtonClick() {
        presenter?.addButtonClick()
    }
}

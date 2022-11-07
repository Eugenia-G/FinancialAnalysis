//
//  AddType.swift
//  FinancialAnalysis
//
//  Created by Евгения Головкина on 07.11.2022.
//

import Foundation

public enum AddType {
    case category
    case income
}

extension AddType {
    var textFieldPlaceholder: String {
        switch self {
        case .category:
            return "Наименование"
        case .income:
            return "Сумма"
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .category:
            return "Добавить категорию расходов"
        case .income:
            return "Добавить доход"
        }
    }
}

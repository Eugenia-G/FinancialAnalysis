//
//  AddPresenterInput.swift
//  FinancialAnalysis
//
//  Created by Евгения Головкина on 05.11.2022.
//

import Foundation

protocol AddPresenterInput {
    var addType: AddType { get }
    
    func addButtonClick()
}

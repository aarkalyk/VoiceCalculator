//
//  Calculator.swift
//  Contactis_Challenge
//
//  Created by ARKALYK AKASH on 7/30/17.
//  Copyright © 2017 ARKALYK AKASH. All rights reserved.
//

import Foundation

class Calculator {
    //MARK: - Algorithm
    private func isOperation(symbol : String) -> Bool{
        return symbol == Operations.addition || symbol == Operations.subtraction || symbol == Operations.multiplication || symbol == Operations.division
    }
    
    private func priorityFor(operation : String) -> Int{
        return operation == Operations.addition || operation == Operations.subtraction ? 1 : operation == Operations.multiplication || operation == Operations.division ? 2 : -1
    }
    
    private func isStringNumber(operandString : String) -> Bool{
        return Double(operandString) != nil ? true : false
    }
    
    private func process(operands : [Double], operation : String) -> [Double]{
        var mutableOperands = operands
        let r = !mutableOperands.isEmpty ? mutableOperands.popLast()! : 0
        let l = !mutableOperands.isEmpty ? mutableOperands.popLast()! : 0
        
        switch operation {
        case Operations.addition: mutableOperands.append(l+r)
        case Operations.subtraction: mutableOperands.append(l-r)
        case Operations.multiplication: mutableOperands.append(l*r)
        case Operations.division: mutableOperands.append(l/r)
        default: break
        }
        
        return mutableOperands
    }
    
    func calculate(inputString : String) -> String{
        var operands : [Double] = []
        var operations : [String] = []
        var characters = arrayFrom(string: inputString)
        characters = characters.filter { isStringNumber(operandString: $0) || isOperation(symbol: $0) || $0 == "."}
        characters = parseNumbersAndOperationsFrom(array: characters)
        
        for character in characters{
            if isOperation(symbol: character) {
                let currentOperation = character
                while !operations.isEmpty && priorityFor(operation: operations.last!) >= priorityFor(operation: character){
                    operands = process(operands: operands, operation: operations.popLast()!)
                }
                operations.append(currentOperation)
            }else{
                if isStringNumber(operandString: character){
                    operands.append(Double(character)!)
                }
            }
        }
        
        while !operations.isEmpty {
            operands = process(operands: operands, operation: operations.popLast()!)
        }
        
        let result = !operands.isEmpty ? operands.popLast()! : 0.0
        return spellNumber(number: result)
    }
    
    //MARK: - Helper methods
    private func parseNumbersAndOperationsFrom(array : [String]) -> [String]{
        var parsedArray = [String]()
        var i = 0
        while i < array.count {
            if i != array.count-1 && isStringNumber(operandString: array[i]) && (isStringNumber(operandString: array[i+1]) || array[i+1] == "." ){
                var firstNumber = array[i]
                while i != array.count-1 && (isStringNumber(operandString: array[i+1]) || array[i+1] == "."){
                    firstNumber += array[i+1]
                    i+=1
                }
                parsedArray.append(firstNumber)
                if i == array.count-1 {
                    break
                }
            }else{
                parsedArray.append(array[i])
            }
            i += 1
        }
        return parsedArray
    }
    
    private func arrayFrom(string : String) -> [String]{
        var array : [String] = []
        for character in string.characters {
            array.append("\(character)")
        }
        return array
    }
    
    private func spellNumber(number : Double) -> String{
        let numberValue = NSNumber(value: number)
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        formatter.locale = Locale(identifier: Locale.current.identifier)
        let spelledNumber = formatter.string(from: numberValue)
        return spelledNumber!
    }
}


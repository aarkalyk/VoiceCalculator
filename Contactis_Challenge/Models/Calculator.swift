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
        return symbol == "+" || symbol == "-" || symbol == "×" || symbol == "÷"
    }
    
    private func priorityFor(operation : String) -> Int{
        return operation == "+" || operation == "-" ? 1 : operation == "×" || operation == "÷" ? 2 : -1
    }
    
    private func isStringNumber(operandString : String) -> Bool{
        return Double(operandString) != nil ? true : false
    }
    
    private func process(operands : [Double], operation : String) -> [Double]{
        var mutableOperands = operands
        let r = !mutableOperands.isEmpty ? mutableOperands.popLast()! : 0
        let l = !mutableOperands.isEmpty ? mutableOperands.popLast()! : 0
        
        switch operation {
        case "+": mutableOperands.append(l+r)
        case "-": mutableOperands.append(l-r)
        case "×": mutableOperands.append(l*r)
        case "÷": mutableOperands.append(l/r)
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
        
        for var i in (0..<characters.count) {
            if isOperation(symbol: characters[i]) {
                let currentOperation = characters[i]
                while !operations.isEmpty && priorityFor(operation: operations.last!) >= priorityFor(operation: characters[i]){
                    operands = process(operands: operands, operation: operations.popLast()!)
                }
                operations.append(currentOperation)
            }else{
                var operandString : String = ""
                while i < characters.count && isStringNumber(operandString: characters[i]){
                    operandString += characters[i]
                    i += 1
                }
                if isStringNumber(operandString: operandString){
                    operands.append(Double(operandString)!)
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


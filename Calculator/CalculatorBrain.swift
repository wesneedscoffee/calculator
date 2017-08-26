//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Wes Backous on 8/17/17.
//  Copyright © 2017 Wes Backous. All rights reserved.
//

import Foundation


struct CalculatorBrain {
    
    
    
    private var accumulator:Double?
    private var resultIsPending: Bool
    private var description: String
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
        case clear
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.constant(Double.pi), //Double.pi,
        "e" : Operation.constant(M_E), //M_E
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "±" : Operation.unaryOperation({ -$0 }),
        "×" : Operation.binaryOperation({$0 * $1}),
        "÷" : Operation.binaryOperation({$0 / $1}),
        "-" : Operation.binaryOperation({$0 - $1}),
        "+" : Operation.binaryOperation({$0 + $1}),
        "=" : Operation.equals,
        "x²" : Operation.unaryOperation({pow($0, 2)}),
        "^" : Operation.binaryOperation({pow($0, $1)}),
        "%" : Operation.unaryOperation({$0 / 100}),
        "C" : Operation.clear
    ]
    
    mutating func performOperation(_ symbol: String)  {
        if let operation = operations[symbol]{
            //accumulator = constant
            switch operation  {
            case .constant(let value):
                accumulator = value
                
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil{
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                    resultIsPending = true
                }
            case .equals:
                performPendingBinaryOperation()
            case .clear:
                performClearOperation()
            }
            
            
            
        }
    }
    
    mutating private func performPendingBinaryOperation()
    {
        if pendingBinaryOperation != nil  && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
            resultIsPending = false;
        }
    }
    
    private mutating func performClearOperation()
    {
        accumulator = 0
        pendingBinaryOperation = nil
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?

    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    private struct PendingBinaryOperation{
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    var result: Double? {
        get{
            return accumulator
        }
    }
}

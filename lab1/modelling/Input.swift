//
//  Input.swift
//  modelling
//
//  Created by Kirill Diordiev on 11.03.2022.
//


import SwiftUI

class FloatFormatter: Formatter {
    let StringCharacterSet = CharacterSet(charactersIn: "-0123456789.")
    private func isValidString(_ value: String) -> Bool {
        guard let invalidStringRange = value.rangeOfCharacter(from: StringCharacterSet.inverted) else {
            return true;
        }
        return invalidStringRange.isEmpty
    }
    
    override func string(for obj: Any?) -> String? {
        guard let string = obj as? String,string.count > 2,
                isValidString(string) else { return nil }
        
        return "\(string)"
    }
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        let floatValue: String
        if string.contains(".") {
            floatValue = string
        } else {
            floatValue = String("0.0")
        }
        
        obj?.pointee = floatValue as AnyObject
        return true
    }
}


struct StringInput: View {
    

    @Binding var param: String
    let label: String
    
    
    var body: some View {
        VStack {
            Text(label)
            TextField(label, value: $param, formatter: FloatFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }

    }
}

struct InputBoard: View {
    
    
    @Binding var xs: String
    @Binding var xe: String
    @Binding var ys: String
    @Binding var h: String
    
    
    
    var body: some View {
        
        
        ZStack {
            VStack {
                Text("Ввод параметров").font(.title)
                HStack {
                    StringInput(param: $xs, label: "xs")
                    StringInput(param: $xe, label: "xe")
                    StringInput(param: $ys, label: "ys")
                    StringInput(param: $h, label: "h")
                }
            }

        }
    }
}



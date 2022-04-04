//
//  Table.swift
//  modelling
//
//  Created by Kirill Diordiev on 10.03.2022.
//

func writeLog(data: Array<Float>, fileName: String) -> Void {
    let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
    let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
    
    
    do {
        try FileManager.default.removeItem(atPath: fileURL.path)
    } catch let error as NSError {
        print("Failed deleting  URL: \(fileURL), Error: " + error.localizedDescription)
    }
    
    var writeString: String = ""
    
    print("FilePath: \(fileURL.path)")
    
    for i in 0..<data.count {
        writeString.append(String(format: "%.5f\n", data[i]))
    }
    
    
    do {
        try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
    } catch let error as NSError {
        print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
    }
}

import SwiftUI

struct FloatCell: View {
    
    let num: Float
    let index: Int
    
    init(index: Int, num: Float) {
        
        self.index = index
        self.num = num
    }
    
    var body: some View {
        let numFormat = String("\(index) \(String(format: "%.5f", num))")
        Text(numFormat)
    }
}

struct Table: View {
    @Binding var values: Array<Float>
    
    var body: some View {
        ForEach(Array(values.enumerated()), id: \.element) { index, val in
            FloatCell(index: index, num: val)
        }
    }
}


struct SpreadSheet: View {
    
    @Binding var xs: String
    @Binding var xe: String
    @Binding var ys: String
    @Binding var h : String
    @State var picard1: Array<Float> = Array<Float>()
    @State var picard2: Array<Float> = Array<Float>()
    @State var picard3: Array<Float> = Array<Float>()
    @State var picard4: Array<Float> = Array<Float>()
    @State var euler: Array<Float> = Array<Float>()
    @State var rungeKutta: Array<Float> = Array<Float>()
    @State var x: Array<Float> = Array<Float>()
    @State var toShow: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    
                    

                    List {
                        Section(header: Text("X")) {
                            Table(values: $x)

                        }
                    }.listStyle(DefaultListStyle())
                        .disabled(true)
                    
                    List {
                        Section(header: Text("Пикард 1")) {
                            Table(values: $picard1)
                        }
                    }.listStyle(DefaultListStyle())
                        .disabled(true)
                    
                    List {
                        Section(header: Text("Пикард 2")) {
                            Table(values: $picard2)
                        }
                    }.listStyle(DefaultListStyle())
                        .disabled(true)
                    
                    List {
                        Section(header: Text("Пикард 3")) {
                            Table(values: $picard3)
                        }
                    }.listStyle(DefaultListStyle())
                        .disabled(true)
                    
                    List {
                        Section(header: Text("Пикард 4")) {
                            Table(values: $picard4)
                        }
                    }.listStyle(DefaultListStyle())
                        .disabled(true)

                    List {
                        Section(header: Text("Рунге")) {
                            Table(values: $rungeKutta)
                        }
                    }.listStyle(DefaultListStyle())
                        .disabled(true)
                    
                    List {
                        Section(header: Text("Эйлер")) {
                            Table(values: $euler)
                        }
                    }.listStyle(DefaultListStyle())
                        .disabled(true)

                    
                }
                
                Button(action: {
                    
                    
                    euler.removeAll()
                    rungeKutta.removeAll()
                    picard1.removeAll()
                    picard2.removeAll()
                    picard3.removeAll()
                    picard4.removeAll()
                    
                    debugPrint(xs, xe, ys)

                    let _xs: Float = (xs as NSString).floatValue
                    let _xe: Float = (xe as NSString).floatValue
                    let _ys: Float = (ys as NSString).floatValue
                    let _h : Float = (h as NSString).floatValue
                    
                    
                    
                    var picard = picardResult(xs: _xs, xe: _xe, ys: _ys, h: _h)
                    euler = eulerResult(xs: _xs, xe: _xe, ys: _ys, h: _h)
                    rungeKutta = rungeKutteKuttaResult(xs: _xs, xe: _xe, ys: _ys, a: 0.5, h: _h)
                    
                    let n: Int = Int(ceil(fabsf(_xe - _xs) / _h))
                    var xn: Float = _xs
                    for _ in 1..<n+1 {
                        x.append(xn)
                        xn += _h
                    }
                    
                    for i in 0..<picard.cols {
                        
                        picard1.append(picard[0,i])
                    }
                    
                    for i in 0..<picard.cols {
                        picard2.append(picard[1,i])
                    }
                    
                    for i in 0..<picard.cols {
                        picard3.append(picard[2,i])
                    }
                    
                    for i in 0..<picard.cols {
                        picard4.append(picard[3,i])
                    }
                    
                    writeLog(data: picard1, fileName: "picard1")
                    writeLog(data: picard2, fileName: "picard2")
                    writeLog(data: picard3, fileName: "picard3")
                    writeLog(data: picard4, fileName: "picard4")
                    writeLog(data: euler, fileName: "euler")
                    writeLog(data: rungeKutta, fileName: "rungeKutta")
                    writeLog(data: x, fileName: "x")



                    
                    picard.grid.removeAll()
                    
 

                    
                    
                }) {
                    Text("Получить результат")
                }
                .padding()
                .buttonStyle(BorderedButtonStyle())
            }

        }
    }
}

//
//  ContentView.swift
//  modelling
//
//  Created by Kirill Diordiev on 10.03.2022.
//

import SwiftUI
import Combine
import swift_algo

struct ContentView: View {

    @State var xs: String = "0.0"
    @State var xe: String = "0.0"
    @State var ys: String = "0.0"
    @State var h: String = "0.0"

    var body: some View {
        ZStack {
            VStack {
                InputBoard(xs: $xs, xe: $xe, ys: $ys, h: $h)
                SpreadSheet(xs: $xs, xe: $xe, ys: $ys, h: $h)
                

            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

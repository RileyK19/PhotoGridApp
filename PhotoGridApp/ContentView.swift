//
//  ContentView.swift
//  PhotoGridApp
//
//  Created by Riley Koo on 5/24/24.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var avatarItem: PhotosPickerItem?
    @State var avatarImage: Image?
    
    @State var rows: String = ""
    @State var cols: String = ""
    
    @State var rowsGrid: Int = 5
    @State var colsGrid: Int = 5
    
    @State var chars: String = "abcdefghijklmnopqrstuvwxyz"
    var body: some View {
        VStack {
            HStack {
                VLabels
                    .frame(height: 300)
                VStack {
                    PhotosPicker("Select photo", selection: $avatarItem, matching: .images)
                    ZStack {
                        avatarImage?
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                        ZStack {
                            vertical
                            horizontal
                        }
                        .frame(width: 300, height: 300)
                    }
                    HLabels
                        .frame(width: 300)
                }
            }
            HStack {
                Spacer()
                TextField("Rows", text: $rows)
                Spacer()
                TextField("Cols", text: $cols)
                Spacer()
            }
            Button {
                update()
            } label: {
                Text("Update")
            }
        }
            .onChange(of: avatarItem) {
                Task {
                    if let loaded = try? await avatarItem?.loadTransferable(type: Image.self) {
                        avatarImage = loaded
                    } else {
                        print("Failed")
                    }
                }
            }
    }
    var vertical: some View {
        HStack {
            ForEach(Array(0..<colsGrid), id:\.self) {x in
                Spacer()
                Divider()
                    .background(.white)
            }
            Spacer()
        }
    }
    var horizontal: some View {
            VStack {
                ForEach(Array(0..<rowsGrid), id:\.self) {x in
                    Spacer()
                    Divider()
                        .background(.white)
                }
                Spacer()
            }
    }
    func update() {
        self.rowsGrid = Int(self.rows) ?? rowsGrid
        self.colsGrid = Int(self.cols) ?? colsGrid
        rows = ""
        cols = ""
    }
    var VLabels: some View {
        VStack {
            ForEach(Array(0..<rowsGrid), id:\.self) {x in
                Spacer()
                Text("\(chars[(rowsGrid - x - 1) % chars.count].uppercased())")
            }
            Spacer()
        }
    }
    var HLabels: some View {
        HStack {
            ForEach(Array(0..<colsGrid), id:\.self) {x in
                Spacer()
                Text("\(x + 1)")
            }
            Spacer()
        }
    }
}

extension String {
    // @https://stackoverflow.com/users/2923345/nalexn on Stack Overflow
    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

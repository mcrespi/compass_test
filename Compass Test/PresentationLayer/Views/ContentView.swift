//
//  ContentView.swift
//  Compass Test
//
//  Created by Martin Crespi on 05/08/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: MainViewModel

    init(viewModel: MainViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            Button(action: {
                viewModel.fetchData()
            }) {
                Text(viewModel.isFetching ? "Fetching data..." : "Fetch Data")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(viewModel.isFetching ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.top)
            }
            .disabled(viewModel.isFetching)
            
            Spacer().frame(height: 20)
            
            VStack(alignment: .leading) {
                Text("Every 10th Character:")
                    .font(.headline)
                    .padding(.bottom, 5)
                ScrollView {
                    Text(viewModel.every10thCharacterResult)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .textSelection(.enabled)
                }
                .frame(maxHeight: .infinity)

                Text("Word Count:")
                    .font(.headline)
                    .padding(.bottom, 5)
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(viewModel.wordCountResult.sorted(by: { $0.value > $1.value }), id: \.key) { word, count in
                            Text("\(word): \(count)")
                                .textSelection(.enabled)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxHeight: .infinity)
            }
            .padding()
            .frame(maxHeight: .infinity)
        }
        .padding()
    }
}

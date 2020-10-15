//
//  ContentView.swift
//  TestRequest
//
//  Created by 古賀貴伍 on 2020/10/15.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Button(action: {
            APIClient().request(ExampleAPI(id: "id", Pass: "pass"), completion: { result in
                switch(result) {
                case let .success(model):
                    guard let s = model else { return }
                    print(s.token)
                
                                
                case let .failure(error):
                    switch error {
                    case let .server(status):
                        print("Error!! StatusCode: \(status)")
                    case .noResponse:
                        print("Error!! No Response")
                    case let .unknown(e):
                        print("Error!! Unknown: \(e)")
                    default:
                        print("Error!! \(error)")
                    }
                }
            })
        }) {
            Text("ログイン")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

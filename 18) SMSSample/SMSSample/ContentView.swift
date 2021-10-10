//
//  ContentView.swift
//  SMSSample
//
//  Created by César on 12/04/21.
//

import SwiftUI

struct ContentView: View {
    @State var destinationNumber = ""
    @State var Message = ""
    
    var body: some View {
        VStack{
            TextField("Enter a Mobile Number: ", text: $destinationNumber)
            TextField("Enter a Message: ", text: $Message)
            Button(action: { sendMessage()}, label: {
                Text("Send Message").font(.title).foregroundColor(Color.blue)
                
            })
        }
    }
    func sendMessage(){
        let sms: String = "sms:\(destinationNumber)&body=\(Message)"
        let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

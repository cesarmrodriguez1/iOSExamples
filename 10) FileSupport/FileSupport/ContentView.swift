//
//  ContentView.swift
//  FileSupport
//
//  Created by gdaalumno on 22/09/21.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var document: MessageDocument = MessageDocument(message: "Hello Document!")
    @State private var isImporting: Bool = false
    @State private var isExporting: Bool = false
    
    
    var body: some View {
        VStack{
            GroupBox(label: Text("Message")){
                TextEditor(text: $document.message)
            }
            GroupBox{
                HStack{
                    Spacer()
                    
                    Button(action:{
                        isImporting = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                            isImporting = true
                        }
                    }, label: {
                        Text("Import")
                    }
                    )
                    
                    Spacer()
                    
                    Button(action:{
                        isExporting = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                            isExporting = true
                        }
                    }, label: {
                        Text("Export")
                    }
                    )
                    Spacer()
                }
            }
        }
        .padding()
        .fileImporter(
        isPresented: $isImporting,
            allowedContentTypes:[UTType.plainText],
            allowsMultipleSelection: false
        ){ result in
            do{
                guard let selectedFile: URL = try result.get().first else{ return }
                
                if(CFURLStartAccessingSecurityScopedResource(selectedFile as CFURL)){
                    guard let message = String(data: try Data(contentsOf: selectedFile), encoding: .utf8) else { return}
                    
                    document.message = message
                    
                    CFURLStopAccessingSecurityScopedResource(selectedFile as CFURL)
                }
                else{
                    print("Permission error!!")
                }
            } catch{
                print(error.localizedDescription)
            }
        }
        .fileExporter(
        isPresented: $isExporting,
            document: document,
            contentType: UTType.plainText,
            defaultFilename: "Message"
        ){
            result in
            if case .success = result {
                print("Upload was ok")
            }
            else{
                print("Something went wrong")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

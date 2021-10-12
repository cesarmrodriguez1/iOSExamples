//
//  ContentView.swift
//  CombineSample
//
//  Created by César on 08/03/21.
//

import SwiftUI
import Combine

struct User: Identifiable, Hashable, Decodable{
    let id: Int
    let name: String
}


final class ViewModel: ObservableObject{
    @Published var time = ""

    private var cancellables = Set<AnyCancellable>()
    
    
    @Published var users = [User]()
        
    let formatter: DateFormatter = {
        let df = DateFormatter()
        df.timeStyle = .medium
        return df
    }()
    
    init(){
        setupPublishers()
    }
    private func setupPublishers(){
        setupTimer()
        
        setupDataTaskPublisher()
        
    }
    
    private func setupDataTaskPublisher(){
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap{ (data, response) in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else{
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type:[User].self, decoder: JSONDecoder() )
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {_ in}) { users in
                self.users = users
            }
            .store(in: &cancellables)
        
        
    }
    
    private func setupTimer(){

        Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .receive(on: RunLoop.main)
            .sink{value in
                self.time = self.formatter.string(from: value)
            }
            .store(in: &cancellables)
    }
}

struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            Text(viewModel.time)
                .padding()
            
            List(viewModel.users, id:\.self){ user in
                Text(user.name)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

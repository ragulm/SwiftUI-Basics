//
//  DependencyInjection.swift
//  PracticeSwiftUI
//
//  Created by Ragul Lakshmanan on 13/07/23.
//

import SwiftUI
import Combine

struct PostData: Identifiable, Codable {
    var userId: Int
    var id: Int
    var title: String
    var body: String
}

class DataManager: NSObject {
    
    static var shared = DataManager()
    
    let url: URL = URL(string: "https://jsonplaceholder.typicode.com/posts")!
    func fetch() -> AnyPublisher<[PostData], Error> {
        let urlsession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        return urlsession.dataTaskPublisher(for: url)
            .map({ $0.data })
            .decode(type: [PostData].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

class DependencyViewModel: ObservableObject {
    @Published var postData: [PostData] = []
    var cancellable = Set<AnyCancellable>()
    
    init() {
//        fetchData()
    }
    
    func fetchData() {
        
        DataManager.shared.fetch()
            .sink(receiveCompletion: { _ in
                print("Data received")
            }, receiveValue: { [weak self] returnedPostData in
                print(returnedPostData)
                self?.postData = returnedPostData
            })
            .store(in: &cancellable)
    }
}

struct DependencyInjection: View {
    
    @StateObject var vm = DependencyViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(vm.postData) { val in
                    Text(val.title)
                }
            }
        }
    }
}

struct DependencyInjection_Previews: PreviewProvider {
    static var previews: some View {
        DependencyInjection()
    }
}

extension DataManager: URLSessionDelegate {

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let trust = challenge.protectionSpace.serverTrust, SecTrustGetCertificateCount(trust) > 0 {
            if let certificate = SecTrustGetCertificateAtIndex(trust, 0) {
                let data = SecCertificateCopyData(certificate) as Data
//                if certificates.contains(data) {
                    completionHandler(.useCredential, URLCredential(trust: trust))
                    return
//                }
            }
        }
        completionHandler(.cancelAuthenticationChallenge, nil)
    }
}

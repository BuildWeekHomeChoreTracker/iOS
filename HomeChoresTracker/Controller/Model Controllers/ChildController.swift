import Foundation
import CoreData

class ChildController {
    private let loginURL = URL(string: "")
    private let choreURL = URL(string: "https://chore-tracker1.herokuapp.com/api/chore")
    private var bearer: Bearer?
    var child: Child?
    
    func login(complete: @escaping NetworkService.CompletionWithError) {
        guard let request = NetworkService.createRequest(url: loginURL, method: .post) else {
            let error = NSError(domain: "ChildController.getChild.requestError", code: NetworkService.NetworkError.badRequest.rawValue)
            complete(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
            response.statusCode != 200 {
                print("bad response code")
                complete(NSError(domain: "ChildController.login.response.statusCode", code: response.statusCode, userInfo: nil))
                return
            }
            if let error = error {
                complete(error)
                return
            }
            
            guard let data = data else {
                print("no data")
                complete(NSError())
                return
            }
            
            guard let bearer = NetworkService.decode(to: Bearer.self, data: data) as? Bearer else {
                let error = NSError(domain: "ChildController.loginChild.decodeBearer", code: NetworkService.NetworkError.badDecode.rawValue)
                complete(error)
                return
            }
            self.bearer = bearer
            
            
            complete(nil)
        }.resume()
    }
    
    /**
     Get a child from the API
     */
    func getChild(complete: @escaping NetworkService.CompletionWithError) {
        guard var request = NetworkService.createRequest(url: choreURL, method: .get, headerType: .contentType, headerValue: .json) else {
            let error = NSError(domain: "ChildController.getChild.requestError", code: NetworkService.NetworkError.badRequest.rawValue)
            complete(error)
            return
        }
        guard let bearer = bearer else {
            let error = NSError(domain: "ChildController.bearer", code: NetworkService.NetworkError.unauth.rawValue)
            complete(error)
            return
        }
        request.setValue(bearer.token, forHTTPHeaderField: NetworkService.HttpHeaderType.authorization.rawValue)
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                complete(error)
                return
            }
            guard let data = data,
                let childRep = NetworkService.decode(to: Child.self, data: data) as? ChildRepresentation
            else {
                let error = NSError(domain: "ChildController.getChild.decodeData", code: NetworkService.NetworkError.badDecode.rawValue)
                complete(error)
                return
            }
            self.child = Child(representation: childRep)
            //TODO: Check for existing child in coredata, save if not
            complete(nil)
        }
    }
    
    func getChores(complete: @escaping NetworkService.CompletionWithError) {
        
    }
    
    
    /**
     Get an array of chores from a Child Managed Object
     */
    func getChoresFromChild(child: Child) -> [Chore]? {
        guard let chores = child.chores else {return nil}
        return Array(chores) as? [Chore]
    }
    
}

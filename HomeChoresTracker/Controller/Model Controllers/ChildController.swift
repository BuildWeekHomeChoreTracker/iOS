import Foundation
import CoreData
import FirebaseStorage

class ChildController {
    private let loginURL = URL(string: "https://chore-tracker1.herokuapp.com/api/auth/login/child")
    private let choreURL = URL(string: "https://chore-tracker1.herokuapp.com/api/auth/child")
    private let updateURL = URL(string: "https://chore-tracker1.herokuapp.com/api/chore")
    private let mainContext = CoreDataStack.shared.mainContext
    let storageRef = Storage.storage().reference()
    var bearer: Bearer?
    var chores = [ChoreRepresentation]()
    let networkLoader: NetworkDataLoader
    
    init(networkLoader: NetworkDataLoader = URLSession.shared) {
        self.networkLoader = networkLoader
    }
    
    // MARK: - Auth
    func login(with username: String, and password: String, complete: @escaping NetworkService.CompletionWithError = { error in }) {
        guard let request = createRequestAndEncodeUser(user: User(username: username, password: password),
                                                       url: loginURL,
                                                       method: .post,
                                                       headerType: .contentType,
                                                       headerValue: .json) else {
                                                        let error = NSError(domain: "ChildController.login.requestError", code: NetworkService.NetworkError.badRequest.rawValue)
                                                        complete(error)
                                                        return
        }
        
        networkLoader.loadData(using: request) { data, response, error in
            if let response = response,
                response.statusCode != 200 {
                print("bad response code")
                DispatchQueue.main.async {
                    complete(NSError(domain: "ChildController.login.response.statusCode", code: response.statusCode, userInfo: nil))
                }
                return
            }
            if let error = error {
                DispatchQueue.main.async {
                    complete(error)
                }
                return
            }
            
            guard let data = data else {
                print("no data")
                DispatchQueue.main.async {
                    complete(NSError())
                }
                return
            }
            
            guard let bearer = NetworkService.decode(to: Bearer.self, data: data) as? Bearer else {
                let error = NSError(domain: "ChildController.loginChild.decodeBearer", code: NetworkService.NetworkError.badDecode.rawValue)
                DispatchQueue.main.async {
                    complete(error)
                }
                return
            }
            self.bearer = bearer
            DispatchQueue.main.async {
                complete(nil)
            }
        }
    }
    
    // MARK: - Create
    func createMOCChore(representation: ChoreRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        Chore(representation: representation, context: context)
        try? CoreDataStack.shared.save(context)
    }
    
    // MARK: - Read
    func getChores(complete: @escaping NetworkService.CompletionWithError  = { error in }) {
        guard let bearer = bearer else {
            let error = NSError(domain: "ChildController.bearer", code: NetworkService.NetworkError.unauth.rawValue)
            complete(error)
            return
        }
        
        let childChoreURL = choreURL?.appendingPathComponent(bearer.id)
        guard var request = NetworkService.createRequest(url: childChoreURL, method: .get, headerType: .contentType, headerValue: .json) else {
            let error = NSError(domain: "ChildController.getChores.requestError", code: NetworkService.NetworkError.badRequest.rawValue)
            complete(error)
            return
        }
        
        request.setValue(bearer.token, forHTTPHeaderField: NetworkService.HttpHeaderType.authorization.rawValue)
        networkLoader.loadData(using: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    complete(error)
                }
                return
            }
            
            if let response = response, response.statusCode != 200 {
                let error = NSError(domain: "ChildController.getChores.responseError", code: response.statusCode)
                DispatchQueue.main.async {
                    complete(error)
                }
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "ChildController.getChild.noData", code: NetworkService.NetworkError.notFound.rawValue)
                DispatchQueue.main.async {
                    complete(error)
                }
                return
            }
            
            guard let jsonChores = NetworkService.decode(to: AllChores.self, data: data) as? AllChores else {
                let error = NSError(domain: "ChildController.getChild.decodeData", code: NetworkService.NetworkError.badDecode.rawValue)
                DispatchQueue.main.async {
                    complete(error)
                }
                return
            }
            
            let context = CoreDataStack.shared.backgroundContext
            context.performAndWait {
                do {
                    //get array of ids for searching in CoreData
                    let apiChoreIds = jsonChores.chores.compactMap { $0.id }
                    //create fetchRequest and assign predicate as searched id
                    let fetchRequest: NSFetchRequest<Chore> = Chore.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "id IN %@", apiChoreIds)
                    //create array of matching chores (these are chores on disk, and on the API)
                    let savedChoresInSearch = try context.fetch(fetchRequest)
                    var apiChoreDict = Dictionary(uniqueKeysWithValues: zip(apiChoreIds, jsonChores.chores))
                    
                    //update just those chores
                    var choreReps = [ChoreRepresentation]()
                    for chore in savedChoresInSearch {
                        guard let rep = chore.choreRepresentation else {
                            let error = NSError(domain: "GetChores.updateChores.createChoreReps", code: 999)
                            complete(error)
                            return
                        }
                        choreReps.append(rep)
                        apiChoreDict.removeValue(forKey: rep.id)
                    }
                    //update the API chores
                    self.updateMOCChores(representations: choreReps)
                    //Create Managed Objects out of the rest of chores
                    for (_, chore) in apiChoreDict {
                        Chore(representation: chore, context: context)
                    }
                    try? context.save()
                    
                    
                    DispatchQueue.main.async {
                        complete(nil)
                    }
                } catch {
                    NSLog("Error decoding JSON data: \(error)")
                    complete(error)
                }
            }
        }
    }
    
    func fetchImage(for chore: ChoreRepresentation, completion: @escaping (UIImage?) -> Void) {
        guard let image = chore.image, let url = URL(string: image) else { return }
        networkLoader.loadData(using: url) { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            if let response = response, response.statusCode != 200 {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(UIImage(data: data))
            }
        }
    }
    
    // MARK: - Helper Methods
    /**
     Unwraps createRequest() and encodeUser()
     */
    private func createRequestAndEncodeUser(user: User,
                                            url: URL?,
                                            method: NetworkService.HttpMethod,
                                            headerType: NetworkService.HttpHeaderType,
                                            headerValue: NetworkService.HttpHeaderValue) -> URLRequest? {
        guard let request = NetworkService.createRequest(url: url, method: method, headerType: headerType, headerValue: headerValue) else {
            print(NSError(domain: "BadRequest", code: 400))
            return nil
        }
        let encodingStatus = NetworkService.encode(from: user, request: request)
        if let encodingError = encodingStatus.error {
            print(encodingError)
            return nil
        }
        guard let postRequest = encodingStatus.request else {
            print("post request error!")
            return nil
        }
        return postRequest
    }
    
    
    // MARK: - Update
    func updateMOCChores(representations: [ChoreRepresentation]) {
        func updateEntries(with representations: [ChoreRepresentation]) {
            let fetchRequest: NSFetchRequest<Chore> = Chore.fetchRequest()
            let identifiers = representations.map { $0.id }
            var repDict = Dictionary(uniqueKeysWithValues: zip(identifiers, representations))
            
            fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiers)
            let context = CoreDataStack.shared.container.newBackgroundContext()
            context.perform {
                do {
                    let chores = try context.fetch(fetchRequest)
                    for chore in chores {
                        guard let representation = repDict[Int(chore.id)] else { continue }
                        self.updateChore(chore: chore, choreRep: representation)
                        repDict.removeValue(forKey: Int(chore.id))
                    }
                    for rep in repDict.values {
                        Chore(representation: rep)
                    }
                } catch {
                    print(error)
                }
            }
            try? CoreDataStack.shared.save(context)
        }
    }
    
    func updateChore(chore: Chore, choreRep: ChoreRepresentation) {
        chore.completed = Int16(choreRep.completed)
        chore.image = choreRep.image
        chore.comments = choreRep.comments
        chore.dueDate = choreRep.dateFromString
        if let bonusPoints = choreRep.bonusPoints {
            chore.bonusPoints = Int16(bonusPoints)
        }
        if let cleanStreak = choreRep.cleanStreak {
            chore.cleanStreak = Int16(cleanStreak)
        }
    }
    
    /**
     Update chore on the API
     */
    func updateAPIChore(_ chore: ChoreRepresentation, complete: @escaping NetworkService.CompletionWithError  = { error in }) {
        guard let bearer = bearer else {
            let error = NSError(domain: "ChildController.bearer", code: NetworkService.NetworkError.unauth.rawValue)
            complete(error)
            return
        }
        
        let updateChoreURL = updateURL?.appendingPathComponent(String(chore.id))
        guard var request = NetworkService.createRequest(url: updateChoreURL, method: .put, headerType: .contentType, headerValue: .json) else {
            let error = NSError(domain: "ChildController.updateChore: \(String(describing: chore.title)).requestError", code: NetworkService.NetworkError.badRequest.rawValue)
            complete(error)
            return
        }
        request.setValue(bearer.token, forHTTPHeaderField: NetworkService.HttpHeaderType.authorization.rawValue)
        
        let encodingStatus = NetworkService.encode(from: chore, request: request)
        if let error = encodingStatus.error {
            complete(error)
            return
        }
        
        guard let encodeRequest = encodingStatus.request else { return }
        networkLoader.loadData(using: encodeRequest) { _, response, error in
            if let error = error {
                complete(error)
                return
            }
            
            if let response = response {
                print(response.statusCode)
            }
            
            complete(nil)
        }
    }
    
    func uploadImage(for chore: ChoreRepresentation, image: Data, completion: @escaping (URL?) -> Void) {
        storageRef.child("choreImages/\(chore.title)\(chore.id).jpg") .putData(image, metadata: nil) { _, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            self.storageRef.child("choreImages/\(chore.title)\(chore.id).jpg").downloadURL { url, error in
                guard error == nil else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }
                DispatchQueue.main.async {
                    completion(url)
                }
            }
        }
    }
    
    func completeChore(_ chore: Chore, with url: URL? = nil, completion: @escaping () -> Void) {
        chore.completed = 1
        if let url = url {
            chore.image = url.absoluteString
        }
        updateChore(chore)
        completion()
    }
    
    private func updateMOCChore(_ context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        do {
            try CoreDataStack.shared.save(context)
        } catch {
            print(error)
        }
    }
    
    private func updateChore(_ chore: Chore, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        if let rep = chore.choreRepresentation {
            updateAPIChore(rep)
        }
        updateMOCChore(context)
    }
    
}

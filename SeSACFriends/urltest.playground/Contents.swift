import UIKit
import Alamofire


struct UserAPI {
    static let scheme = "http"
    static let host = "test.monocoding.com"
    static let port = 35484
    static let path = "/user"
    
    func getUser() -> URLComponents {
        
        var components = URLComponents()
        components.scheme = UserAPI.scheme
        components.host = UserAPI.host
        components.port = UserAPI.port
        components.path = UserAPI.path
        
        return components
    }
}


let user = UserAPI()
let header: HTTPHeaders = [ "Content-Type": "application/json"
                            , "idtoken" : "" ]






print(user.getUser().url!)



//
//
//struct APIResult {
//    let data : Any?
//    let status : Strig
//
//    init(data: Any , status: APIStatus) {
//        self.data = data
//        self.status = status
//    }
//}
//
//
//a = APIResult(data: nil, status: .success)
//print(a)

let aa: Any? = nil

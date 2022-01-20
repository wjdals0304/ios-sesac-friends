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




class UserNetwork {
    
    private let idtoken : String
    
    let userApi = UserAPI()
    let header: HTTPHeaders
    
    init(idtoken: String) {
        self.idtoken = idtoken
        self.header =  [ "Content-Type": "application/json"
                          , "idtoken" : self.idtoken ]
    }
    
    func getUser(  ) {
        
        let url = userApi.getUser().Re
        
        AF.request(url, method: .get, parameters: nil, encoder: <#T##ParameterEncoder#>, headers: header, interceptor: <#T##RequestInterceptor?#>, requestModifier: <#T##Session.RequestModifier?##Session.RequestModifier?##(inout URLRequest) throws -> Void#>)
        
        

    }
    
    
}

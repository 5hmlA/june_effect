#import "June3dPlugin.h"
#if __has_include(<june_3d/june_3d-Swift.h>)
#import <june_3d/june_3d-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "june_3d-Swift.h"
#endif

@implementation June3dPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftJune3dPlugin registerWithRegistrar:registrar];
}
@end

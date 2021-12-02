#import "JuneEffectPlugin.h"
#if __has_include(<june_effect/june_effect-Swift.h>)
#import <june_effect/june_effect-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "june_effect-Swift.h"
#endif

@implementation JuneEffectPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftJuneEffectPlugin registerWithRegistrar:registrar];
}
@end

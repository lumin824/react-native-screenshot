
#import "RCTBridgeModule.h"
#import "RCTUIManager.h"

@interface ScreenshotModule: NSObject<RCTBridgeModule>

@property(nonatomic, weak) UIView* rootView;
@end

@implementation ScreenshotModule

- (instancetype) init{
    self = [super init];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOpenURL:) name:@"RCTUIManagerDidRegisterRootViewNotification" object:nil];
    }


    return self;
}

- (void)handleOpenURL:(NSNotification *)note
{
    self.rootView = note.userInfo[@"RCTUIManagerRootViewKey"];
}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(capture:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {

    if(self.rootView == nil){
        reject(@"error", @"error", nil);
        return;
    }
    UIView* view = self.rootView;

    CGRect rect = view.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext: context];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    NSString* fileName = @"tmp/1.png";
    NSString* filePath = [NSHomeDirectory() stringByAppendingPathComponent:fileName];

    NSData* imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:filePath atomically:YES];
    resolve(filePath);
}

@end

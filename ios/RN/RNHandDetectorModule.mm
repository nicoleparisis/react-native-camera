#import "RNHandDetectorModule.h"
#import "RNFileSystem.h"
#import "RNImageUtils.h"

static const NSString *kModeOptionName = @"mode";
static const NSString *kDetectLandmarksOptionName = @"detectLandmarks";
static const NSString *kRunClassificationsOptionName = @"runClassifications";

@implementation RNHandDetectorModule

static NSFileManager *fileManager = nil;
static NSDictionary *defaultDetectorOptions = nil;

- (instancetype)init
{
    self = [super init];
    if (self) {
        fileManager = [NSFileManager defaultManager];
    }
    return self;
}

RCT_EXPORT_MODULE(RNHandDetector);

@synthesize bridge = _bridge;

- (void)setBridge:(RCTBridge *)bridge
{
    _bridge = bridge;
}

+ (BOOL)requiresMainQueueSetup
{
    return NO;
}

- (NSDictionary *)constantsToExport
{
    return [HandDetectorManager constants];
}

RCT_EXPORT_METHOD(detectHand:(nonnull NSDictionary *)options
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    NSString *uri = options[@"uri"];
    if (uri == nil) {
        reject(@"E_HAND_DETECTION_FAILED", @"You must define a URI.", nil);
        return;
    }
    
    NSURL *url = [NSURL URLWithString:uri];
    NSString *path = [url.path stringByStandardizingPath];
    
    @try {
        if (![fileManager fileExistsAtPath:path]) {
            reject(@"E_HAND_DETECTION_FAILED", [NSString stringWithFormat:@"The file does not exist. Given path: `%@`.", path], nil);
            return;
        }
        FIRVisionHandDetectorOptions *newOptions = [[FIRVisionHandDetectorOptions alloc] init];
        if (options[kDetectLandmarksOptionName]) {
            newOptions.landmarkMode = [options[kDetectLandmarksOptionName] integerValue];
        }
        
        if (options[kModeOptionName]) {
            newOptions.performanceMode = [options[kModeOptionName] integerValue];
        }
        
        if (options[kRunClassificationsOptionName]) {
            newOptions.classificationMode = [options[kRunClassificationsOptionName] integerValue];
        }

        UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
        UIImage *rotatedImage = [RNImageUtils forceUpOrientation:image];

        Class handDetectorManager = NSClassFromString(@"HandDetectorManager");
        id handDetector = [[handDetectorManager alloc] init];
        [handDetector findHandInFrame:rotatedImage scaleX:1 scaleY:1 completed:^(NSArray * hand) {
            resolve(@{
                        @"hand" : hand,
                        @"image" : @{
                                @"uri" : options[@"uri"],
                                @"width" : @(image.size.width),
                                @"height" : @(image.size.height),
                                @"orientation" : @([self exifOrientationFor:image.imageOrientation])
                                }
                        });
            }];
    } @catch (NSException *exception) {
        reject(@"E_HAND_DETECTION_FAILED", [exception description], nil);
    }
}


// https://gist.github.com/steipete/4666527
- (int)exifOrientationFor:(UIImageOrientation)orientation
{
    switch (orientation) {
        case UIImageOrientationUp:
            return 1;
        case UIImageOrientationDown:
            return 3;
        case UIImageOrientationLeft:
            return 8;
        case UIImageOrientationRight:
            return 6;
        case UIImageOrientationUpMirrored:
            return 2;
        case UIImageOrientationDownMirrored:
            return 4;
        case UIImageOrientationLeftMirrored:
            return 5;
        case UIImageOrientationRightMirrored:
            return 7;
    }
}

@end
#else
@implementation RNHandDetectorModule

@synthesize bridge = _bridge;

- (void)setBridge:(RCTBridge *)bridge
{
    _bridge = bridge;
}

+ (BOOL)requiresMainQueueSetup
{
    return NO;
}

- (NSDictionary *)constantsToExport
{
    return @{};
}

RCT_EXPORT_MODULE(RNHandDetector);

@end
#endif

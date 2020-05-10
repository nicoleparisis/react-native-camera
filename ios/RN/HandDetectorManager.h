#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif
#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/imgproc.hpp>
#import <opencv2/video/video.hpp>
#import <opencv2/videoio/videoio.hpp>
#import <opencv2/imgcodecs/ios.h>

@interface HandDetectorManager : NSObject <RCTBridgeModule>
typedef void (^postRecognitionBlock)(NSArray *hand);

- (instancetype)init;

- (BOOL)isRealDetector;
- (void)setTracking:(id)json queue:(dispatch_queue_t)sessionQueue;
- (void)setLandmarksMode:(id)json queue:(dispatch_queue_t)sessionQueue;
- (void)setPerformanceMode:(id)json queue:(dispatch_queue_t)sessionQueue;
- (void)setClassificationMode:(id)json queue:(dispatch_queue_t)sessionQueue;
- (void)findHandInFrame:(UIImage *)image scaleX:(float)scaleX scaleY:(float)scaleY completed:(postRecognitionBlock)completed;
+ (NSDictionary *)constants;

@end

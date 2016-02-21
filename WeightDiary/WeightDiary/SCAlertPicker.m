//
//  SCAlertPicker.m
//  WeightDiary
//
//  Created by 罗思成 on 16/2/12.
//
//

#import "SCAlertPicker.h"
#import "UIColor+HexString.h"
#import "Config.h"

// Generate Shadow Backgournd
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

@implementation SCAlertPicker

/**
 *  init with normal picker
 *
 *  @param buttonTitle button text
 *  @param pickerData  2d-array stores picker data
 *  @param pickerIndex picker's first position
 *  @param delegate    action when button was clicked
 *
 *  @return SCAlertPicker with normal picker
 */
- (instancetype)initWithButtonTitle:(NSString *)buttonTitle
                         pickerData:(NSArray *)pickerData
                        pickerIndex:(NSArray *)pickerIndex
                           delegate:(id<SCAlertPickerDelegte>)delegate {
    self = [super init];
    
    if (self) {
        // setup size and position
        CGFloat viewWidth = CGRectGetWidth([UIScreen mainScreen].bounds) * 2 / 3;
        CGFloat viewHeight = 300;
        CGFloat viewLeft = viewWidth / 2 / 2;
        CGFloat viewTop = (CGRectGetHeight([UIScreen mainScreen].bounds) - viewHeight) / 2 - 30;
        
        CGFloat buttonHeight = 50;
        
        self.frame = CGRectMake(viewLeft, viewTop, viewWidth, viewHeight);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.layer.shadowOffset = CGSizeMake(1, 1);
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.5;
        self.clipsToBounds = YES;
        
        self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight - buttonHeight)];
        self.picker.dataSource = self;
        self.picker.delegate = self;
        [self addSubview:self.picker];
        
        self.submitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, viewHeight - buttonHeight, viewWidth, buttonHeight)];
        [self.submitButton setTitle:buttonTitle forState:UIControlStateNormal];
        
        UIImage *submitButtonBackGround = [Config imageFromColor:[UIColor colorWithHexString:@"#7cbf6f"]];
        UIImage *submitButtonBackgroundHighlighted = [Config imageFromColor:[UIColor colorWithHexString:@"#7f000000"]];
        [self.submitButton setBackgroundImage:submitButtonBackGround forState:UIControlStateNormal];
        [self.submitButton setBackgroundImage:submitButtonBackgroundHighlighted forState:UIControlStateHighlighted];
        
        [self.submitButton addTarget:self action:@selector(actionSubmit) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.submitButton];
        
        self.pickerData = pickerData;
        self.picker.backgroundColor = [UIColor clearColor];
        self.valueIndex = [[NSMutableArray alloc] initWithArray:pickerIndex];
        
        for (int i = 0; i < [self.valueIndex count]; i++) {
            NSInteger index = [self.valueIndex[i] integerValue];
            [self.picker selectRow:index inComponent:i animated:NO];
        }
        
        self.delegate = delegate;
    }
    
    return self;
}

- (instancetype)initWithButtonTitle:(NSString *)buttonTitle
                     datePickerMode:(UIDatePickerMode)datePickerMode
                           delegate:(id<SCAlertPickerDelegte>)delegate {
    self = [super init];
    
    if (self) {
        NSLog(@"%.lf", CGRectGetWidth([UIScreen mainScreen].bounds));
        // setup size and position
        CGFloat viewWidth = MAX(CGRectGetWidth([UIScreen mainScreen].bounds) * 4 / 5, 300);
        CGFloat viewHeight = 300;
        CGFloat viewLeft = (CGRectGetWidth([UIScreen mainScreen].bounds) - viewWidth) / 2;
        CGFloat viewTop = (CGRectGetHeight([UIScreen mainScreen].bounds) - viewHeight) / 2 - 30;
        
        CGFloat buttonHeight = 50;
        
        self.frame = CGRectMake(viewLeft, viewTop, viewWidth, viewHeight);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.layer.shadowOffset = CGSizeMake(1, 1);
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.5;
        self.clipsToBounds = YES;
        
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight - buttonHeight)];
        self.datePicker.datePickerMode = datePickerMode;
        [self addSubview:self.datePicker];
        
        self.submitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, viewHeight - buttonHeight, viewWidth, buttonHeight)];
        [self.submitButton setTitle:buttonTitle forState:UIControlStateNormal];
        
        UIImage *submitButtonBackGround = [Config imageFromColor:[UIColor colorWithHexString:@"#7cbf6f"]];
        UIImage *submitButtonBackgroundHighlighted = [Config imageFromColor:[UIColor colorWithHexString:@"#7f000000"]];
        [self.submitButton setBackgroundImage:submitButtonBackGround forState:UIControlStateNormal];
        [self.submitButton setBackgroundImage:submitButtonBackgroundHighlighted forState:UIControlStateHighlighted];
        
        [self.submitButton addTarget:self action:@selector(actionSubmit) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.submitButton];
        
        self.datePicker.backgroundColor = [UIColor clearColor];
        self.delegate = delegate;
    }
    
    return self;
}

#pragma - Picker Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return [self.pickerData count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.pickerData[component] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([self.pickerData[component][row] isKindOfClass:[NSString class]]) {
        return self.pickerData[component][row];
    } else {
        return @"";
    }
}

#pragma - Picker Delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.valueIndex[component] = [NSNumber numberWithInteger:row];
}

#pragma - Show View

- (void)show {
    self.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.alertWindow.backgroundColor = [UIColor clearColor];
    self.alertWindow.windowLevel = UIWindowLevelAlert;
    [self.alertWindow addGestureRecognizer:({
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        tap;
    })];
    
    // create effect
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    // add effect to an effect view
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = self.alertWindow.frame;
    
    [self.alertWindow addSubview:effectView];
    [self.alertWindow addSubview:self];
    [self.alertWindow makeKeyAndVisible];
    self.alertWindow.alpha = 0;
    self.alpha = 0;
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alertWindow.alpha = 1;
        self.alpha = 1;
    } completion:nil];
}

#pragma - Click Submit Button

- (void)actionSubmit {
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0;
        self.alertWindow.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.alertWindow.hidden = YES;
        self.alertWindow = nil;
    }];
    
    NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:[self.valueIndex count]];
    
    for (int i = 0; i < [self.valueIndex count]; i++) {
        NSInteger index = [self.valueIndex[i] integerValue];
        [values addObject:self.pickerData[i][index]];
    }
    
    if (self.picker && [self.delegate respondsToSelector:@selector(SCAlertPicker:ClickWithValues:)]) {
        [self.delegate SCAlertPicker:self ClickWithValues:[values copy]];
    }
    
    if (self.datePicker && [self.delegate respondsToSelector:@selector(SCAlertPicker:ClickWithDate:)]) {
        [self.delegate SCAlertPicker:self ClickWithDate:[self.datePicker date]];
    }
}

#pragma - View Dismiss

- (void)dismiss {
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0;
        self.alertWindow.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.alertWindow.hidden = YES;
        self.alertWindow = nil;
    }];
}

#pragma - Blur Screen Effect

- (UIImage *)screenshot {
    CGSize imageSize = [UIScreen mainScreen].bounds.size;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0f && UIInterfaceOrientationIsLandscape(orientation)) {
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 2.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0f) {
            if (orientation == UIInterfaceOrientationLandscapeLeft) {
                CGContextRotateCTM(context, M_PI_2);
                CGContextTranslateCTM(context, 0, -imageSize.width);
            } else if (orientation == UIInterfaceOrientationLandscapeRight) {
                CGContextRotateCTM(context, -M_PI_2);
                CGContextTranslateCTM(context, -imageSize.height, 0);
            } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
                CGContextRotateCTM(context, M_PI);
                CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
            }
        }
        
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        } else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)bluredImage:(UIImage *)origin {
    uint32_t boxSize = 0.15 * 100;
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef image = origin.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    CGDataProviderRef inProvider = CGImageGetDataProvider(image);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    inBuffer.width = CGImageGetWidth(image);
    inBuffer.height = CGImageGetHeight(image);
    inBuffer.rowBytes = CGImageGetBytesPerRow(image);
    inBuffer.data = (void *)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(image) * CGImageGetHeight(image));
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(image);
    outBuffer.height = CGImageGetHeight(image);
    outBuffer.rowBytes = CGImageGetBytesPerRow(image);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, CGImageGetBitmapInfo(image));
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *bluredImage = [UIImage imageWithCGImage:imageRef];
    
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return bluredImage;
}

@end

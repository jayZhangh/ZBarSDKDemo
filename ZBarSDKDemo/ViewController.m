//
//  ViewController.m
//  ZBarSDKDemo
//
//  Created by ZhangLiang on 15/9/21.
//  Copyright (c) 2015年 tentinet. All rights reserved.
//

#import "ViewController.h"
#import "ZBarSDK.h"

@interface ViewController () <ZBarReaderDelegate, ZBarReaderViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, strong) ZBarReaderView *readerView;

- (IBAction)scan:(id)sender;
- (IBAction)vc_scan:(UIBarButtonItem *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    [self setupSubviewsFrame];
    [self setupSubviewsData];
    
}

/**
 *  初始化子控件
 */
- (void)setupSubviews {
    
}

/**
 *  初始化子控件Frame
 */
- (void)setupSubviewsFrame {
    
}

/**
 *  初始化子控件Data
 */
- (void)setupSubviewsData {
    
}

- (IBAction)scan:(id)sender {
    [self setupZBarView];
    
}

- (IBAction)vc_scan:(UIBarButtonItem *)sender {
    [self setupZBarVC];
}

- (CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds {
    CGFloat x, y, width, height;
    
    x = rect.origin.x / readerViewBounds.size.width;
    y = rect.origin.y / readerViewBounds.size.height;
    width = rect.size.width / readerViewBounds.size.width;
    height = rect.size.height / readerViewBounds.size.height;
    
    return CGRectMake(x, y, width, height);
}

/**
 *  自定义扫码界面View
 */
- (void)setupZBarView {
    if (!self.readerView) {
        self.readerView = [[ZBarReaderView alloc] init];
        
        self.readerView.readerDelegate = self;
        // 关闭闪光灯
        self.readerView.torchMode = 0;
        // 扫描区域
        CGRect scanMaskRect = CGRectMake(60, CGRectGetMidY(self.readerView.frame) - 126, 200, 200);
        UIView *coverView = [[UIView alloc] initWithFrame:scanMaskRect];
        coverView.layer.borderColor = [[UIColor redColor] CGColor];
        coverView.layer.borderWidth = 1.0;
        [self.readerView addSubview:coverView];
        
        // 处理模拟器
        if (TARGET_IPHONE_SIMULATOR) {
            ZBarCameraSimulator *cameraSimulator = [[ZBarCameraSimulator alloc] initWithViewController:self];
            cameraSimulator.readerView = self.readerView;
        }
        
        [self.view addSubview:self.readerView];
        // 扫描区域计算
        self.readerView.scanCrop = [self getScanCrop:scanMaskRect readerViewBounds:self.readerView.bounds];
    }
    
    [self.readerView start];
}

/**
 *  弹出扫码控制器
 */
- (void)setupZBarVC {
    ZBarReaderViewController * reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    ZBarImageScanner * scanner = reader.scanner;
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    
    reader.showsZBarControls = YES;
    
    [self presentViewController:reader animated:YES completion:nil];
}

#pragma mark - ZBarReaderDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol * symbol;
    for(symbol in results)
        break;
    
    _imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    _label.text = symbol.data;
}

#pragma mark - ZBarReaderViewDelegate
- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image {
    ZBarSymbol *symbol = nil;
    for (symbol in symbols) return;
    
    NSLog(@"%@", symbol.data);
    
    [self.readerView stop];
}

@end

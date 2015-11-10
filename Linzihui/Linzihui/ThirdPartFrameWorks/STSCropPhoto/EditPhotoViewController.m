//
//  EditPhotoViewController.m
//  macaics
//
//  Created by gao on 13-7-4.
//  Copyright (c) 2013年 com.hairbobo. All rights reserved.
//


#import "EditPhotoViewController.h"
#import "STScratchView.h"

@interface EditPhotoViewController (){
    
}

@end

@implementation EditPhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.view.backgroundColor = [UIColor whiteColor];
    

    
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGSize imageSize = _sourseImg.size;
    
    CGFloat imageViewWith = screenSize.width - 40;
    
    CGFloat imageViewHeight = imageViewWith * imageSize.height/imageSize.width;
    
    
    _scratchView = [[STScratchView alloc]initWithFrame:CGRectMake(20, 60, imageViewWith, imageViewHeight)];
    

  
    //涂抹大小
    [_scratchView setSizeBrush:20.0];
    
    //涂抹图
    UIImageView *sImg = [[UIImageView alloc] initWithFrame:_scratchView.frame];
    [sImg setImage:_sourseImg];
    [_scratchView setHideView:sImg];
    
    [self.view addSubview:_scratchView];
    
 
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(30, screenSize.height - 80,50,30)];
    
    [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [self.view addSubview:cancelButton];
    
    
    
    UIButton *okButton = [[UIButton alloc]initWithFrame:CGRectMake(screenSize.width - 80, screenSize.height - 80,50,30)];
    
    [okButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [okButton setTitle:@"完成" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    
    [self.view addSubview:okButton];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)viewDidUnload {

  
    [super viewDidUnload];
}


////合成一张
-(UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2
{
    UIGraphicsBeginImageContext(image2.size);
    //Draw image2
    [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
    //Draw image1
//    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    UIImage *resultImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}
//


// 马赛克处理
//- (UIImage *)Mosaic:(UIImage *)inImage Level:(int)level{
//    unsigned char *imgPixel = RequestImagePixelData(inImage);
//    CGImageRef inImageRef = [inImage CGImage];
//    GLuint width = CGImageGetWidth(inImageRef);
//    GLuint height = CGImageGetHeight(inImageRef);
//    unsigned char prev[4] = {0};
//    int bytewidth = width*4;
//    int i,j;
//    int val = level;
//    for(i=0;i<height;i++) {
//        if (((i+1)%val) == 0) {
//            memcpy(imgPixel+bytewidth*i, imgPixel+bytewidth*(i-1), bytewidth);
//            continue;
//        }
//        for(j=0;j<width;j++) {
//            if (((j+1)%val) == 1) {
//                memcpy(prev, imgPixel+bytewidth*i+j*4, 4);
//                continue;
//            }
//            memcpy(imgPixel+bytewidth*i+j*4, prev, 4);
//        }
//    }
//    NSInteger dataLength = width*height* 4;
//    //下面的代码创建要输出的图像的相关参数
//    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imgPixel, dataLength, NULL);
//    // prep the ingredients
//    int bitsPerComponent = 8;
//    int bitsPerPixel = 32;
//    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
//    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
//    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
//    //创建要输出的图像
//    CGImageRef imageRef = CGImageCreate(width, height,
//                                        bitsPerComponent,
//                                        bitsPerPixel,
//                                        bytewidth,
//                                        colorSpaceRef,
//                                        bitmapInfo,
//                                        provider,
//                                        NULL, NO, renderingIntent);
//    UIImage *my_Image = [UIImage imageWithCGImage:imageRef];
//    CFRelease(imageRef);
//    CGColorSpaceRelease(colorSpaceRef);
//    CGDataProviderRelease(provider);
//    return my_Image;
//}

static unsigned char *RequestImagePixelData(UIImage *inImage)
{
    CGImageRef img = [inImage CGImage];
    CGSize size = [inImage size];
    //使用上面的函数创建上下文
    CGContextRef cgctx = CreateRGBABitmapContext(img);
    
    CGRect rect = {{0,0},{size.width, size.height}};
    //将目标图像绘制到指定的上下文，实际为上下文内的bitmapData。
    CGContextDrawImage(cgctx, rect, img);
    unsigned char *data = CGBitmapContextGetData (cgctx);
    //释放上面的函数创建的上下文
    CGContextRelease(cgctx);
    return data;
}

static CGContextRef CreateRGBABitmapContext (CGImageRef inImage)
{
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapData; //内存空间的指针，该内存空间的大小等于图像使用RGB通道所占用的字节数。
    int bitmapByteCount;
    int bitmapBytesPerRow;
    
    size_t pixelsWide = CGImageGetWidth(inImage); //获取横向的像素点的个数
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    bitmapBytesPerRow    = (pixelsWide * 4); //每一行的像素点占用的字节数，每个像素点的ARGB四个通道各占8个bit(0-255)的空间
    bitmapByteCount    = (bitmapBytesPerRow * pixelsHigh); //计算整张图占用的字节数
    
    colorSpace = CGColorSpaceCreateDeviceRGB();//创建依赖于设备的RGB通道
    //分配足够容纳图片字节数的内存空间
    bitmapData = malloc( bitmapByteCount );
    //创建CoreGraphic的图形上下文，该上下文描述了bitmaData指向的内存空间需要绘制的图像的一些绘制参数
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedLast);
    //Core Foundation中通过含有Create、Alloc的方法名字创建的指针，需要使用CFRelease()函数释放
    CGColorSpaceRelease( colorSpace );
    return context;
}

- (void)cancel:(id)sender {
    
      [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (UIImage*)getImageDraw:(UIImage*)toDrawImage
{
    UIGraphicsBeginImageContext(toDrawImage.size);

    [toDrawImage drawInRect:CGRectMake(0, 0, toDrawImage.size.width, toDrawImage.size.height)];
  
    UIImage *resultImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
    
}
- (void)doneAction:(id)sender {
    
    
    UIImage *showPhoto = [_scratchView getEndImg];
    
    UIImage *upLoadPhoto = [self getImageDraw:showPhoto];
    
    [self.delegate doneEditeUpLoadPhoto:upLoadPhoto ];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end

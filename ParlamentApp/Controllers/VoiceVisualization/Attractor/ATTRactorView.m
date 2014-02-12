//
//  ATTRactorView.m
//  AttractorParlamenta
//
//  Created by DenisDbv on 01.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import "ATTRactorView.h"
//#import "CC3GLMatrix.h"
#import <GLKit/GLKit.h>
#import "ATTRactorManager.h"

#import "Novocaine.h"

#define M_TAU (2*M_PI)
#define boris_random(smallNumber, bigNumber) ((((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * (bigNumber - smallNumber)) + smallNumber)

@interface ATTRactorView()
@property (nonatomic, strong) Novocaine *audioManager;
@property (nonatomic, assign) BOOL startVoice;

@property (nonatomic, strong) ATTRactorManager *attrManager;
@end

@implementation ATTRactorView
{
    CADisplayLink* displayLink;
    
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    GLuint _colorRenderBuffer;
    GLuint _depthRenderBuffer;
    GLuint framebuffer;
    GLuint programHandle;
    
    /*GLuint g_vbo;
    GLuint g_cbo;
    
    float index;
    float fade;
    float phase;
    float word;
    float spherize;
    float color[4];
    float tr[16];
    
    int g_side;*/
    
    
    CGFloat rotation_x, rotation_y;
    BOOL isRedColor;
    BOOL takeSnapshot;
    
    NSArray *attractorIndexes;
    NSArray *attractorSides;
    NSArray *attractorPontsSize;
    NSArray *attractorFades;
    NSArray *attractorSperiz;
    NSArray *attractorDeltaTime;
    
    CGFloat components[3];
}
@synthesize audioManager;
@synthesize startVoice;
@synthesize attrManager;
@synthesize snapshotImage;
@synthesize delegate;
@synthesize scale, lastScale;

static int attrIndex = 0;

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (void)setupLayer {
    
    UIColor *ccc = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back_2.png"]];
    
    [self getRGBComponents:components forColor:ccc];
    NSLog(@"-------->%f %f %f", components[0], components[1], components[2]);
    
    _eaglLayer = (CAEAGLLayer*) self.layer;
    _eaglLayer.opaque = YES;
    _eaglLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking : @(NO), kEAGLDrawablePropertyColorFormat:kEAGLColorFormatRGBA8 };
    //_eaglLayer.contentsScale = 2.0;
    
    attrManager = [[ATTRactorManager alloc] init];
    attrIndex = 0;
}

- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 kCGImageAlphaNoneSkipLast);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}

-(void)layoutSubviews
{
    //if(self.frame.size.width >= 1024)   {

        //[_eaglLayer setFrame:self.bounds];
        
        [displayLink invalidate];
        displayLink = nil;
        
        [EAGLContext setCurrentContext:_context];
        
        glDeleteRenderbuffersOES(1, &framebuffer);
        framebuffer = 0;
        glDeleteRenderbuffersOES(1, &_colorRenderBuffer);
        _colorRenderBuffer = 0;
        glDeleteRenderbuffersOES(1, &_depthRenderBuffer);
        _depthRenderBuffer = 0;
        
        [EAGLContext setCurrentContext:_context];
        [self setupDepthBuffer];
        [self setupRenderBuffer];
        [self setupFrameBuffer];
    
        //scale = 1.0;
        //lastScale = 1.0;
        [self setupDisplayLink];
    //}
    
    NSLog(@"%@ and %@", NSStringFromCGRect(_eaglLayer.frame), NSStringFromCGRect(self.frame));
}

-(void) releaseView
{
    [displayLink invalidate];
    displayLink = nil;
    
    if(audioManager != nil) {
        [audioManager pause];
        audioManager = nil;
        NSLog(@"clear audio manager");
    }
    
    [EAGLContext setCurrentContext:_context];
    
    glDeleteBuffers(1, &_colorRenderBuffer);
    glDeleteBuffers(1, &_depthRenderBuffer);
    glDeleteBuffers(1, &framebuffer);
    
    if (programHandle) {
        glDeleteProgram(programHandle);
        programHandle = 0;
    }
    
    if ([EAGLContext currentContext] == _context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    attrManager = nil;
}

-(void) resetAttractors
{
    [attrManager removeAll];
    attrIndex = 0;
    isRedColor = YES;
    takeSnapshot = NO;
}

-(void) setupVBO
{
    isRedColor = YES;
    takeSnapshot = NO;
    
    attractorIndexes = @[[NSNumber numberWithInt:1],
                         [NSNumber numberWithInt:2],
                         [NSNumber numberWithInt:3],
                         [NSNumber numberWithInt:4],
                         [NSNumber numberWithInt:5],
                         [NSNumber numberWithInt:6],
                         [NSNumber numberWithInt:7]];
    
    attractorSides = @[[NSNumber numberWithInt:256],
                       [NSNumber numberWithInt:128],
                       [NSNumber numberWithInt:128],
                       [NSNumber numberWithInt:128],
                       [NSNumber numberWithInt:128],
                       [NSNumber numberWithInt:256],
                       [NSNumber numberWithInt:256]];
    
    attractorPontsSize = @[[NSNumber numberWithFloat:0.6],
                           [NSNumber numberWithFloat:0.5],
                           [NSNumber numberWithFloat:0.4],
                           [NSNumber numberWithFloat:0.4],
                           [NSNumber numberWithFloat:0.3],
                           [NSNumber numberWithFloat:0.7],
                           [NSNumber numberWithFloat:0.2]];
   
    attractorFades = @[[NSNumber numberWithFloat:1.0],
                           [NSNumber numberWithFloat:1.0],
                           [NSNumber numberWithFloat:1.0],
                           [NSNumber numberWithFloat:1.0],
                           [NSNumber numberWithFloat:1.0],
                           [NSNumber numberWithFloat:1.0],
                           [NSNumber numberWithFloat:1.0]];
    /*
    
     attractorFades = @[[NSNumber numberWithFloat:0.2],
     [NSNumber numberWithFloat:0.7],
     [NSNumber numberWithFloat:0.8],
     [NSNumber numberWithFloat:0.9],
     [NSNumber numberWithFloat:1.0],
     [NSNumber numberWithFloat:0.2],
     [NSNumber numberWithFloat:0.4]];
    */
    
    attractorSperiz = @[[NSNumber numberWithFloat:0.96],
                       [NSNumber numberWithFloat:0.94],
                       [NSNumber numberWithFloat:0.96],
                       [NSNumber numberWithFloat:1.2],
                       [NSNumber numberWithFloat:1.0],
                       [NSNumber numberWithFloat:1.0],
                       [NSNumber numberWithFloat:1.9]];
    
    attractorDeltaTime = @[[NSNumber numberWithFloat:0.4],
                        [NSNumber numberWithFloat:0.3],
                        [NSNumber numberWithFloat:0.2],
                        [NSNumber numberWithFloat:0.6],
                        [NSNumber numberWithFloat:0.4],
                        [NSNumber numberWithFloat:0.5],
                        [NSNumber numberWithFloat:0.6]];
    
    /*ATTRactorObject *attr1 = [[ATTRactorObject alloc] init];
    attr1.g_side = 256;
    //[attr1 setHueColor:0.14f];
    attr1.fade = 0.3;
    attr1.pointSize = 0.5;
    [attrManager addAttractor:attr1];
    
    ATTRactorObject *attr2 = [[ATTRactorObject alloc] init];
    attr2.fade = 1.2;
    attr2.phase = 10.0;
    [attr2 setHueColor:0.16f];
    attr2.pointSize = 0.3;
    [attrManager addAttractor:attr2];
    
    /*ATTRactorObject *attr3 = [[ATTRactorObject alloc] init];
    attr3.fade = 0.8;
    [attr3 setHueColor:0.12f];
    attr3.phase = 50.0;
    attr3.pointSize = 0.4;
    [attrManager addAttractor:attr3];
    
    ATTRactorObject *attr4 = [[ATTRactorObject alloc] init];
    attr4.fade = 0.2;
    [attr4 setHueColor:0.12f];
    attr4.phase = 1.0;
    attr4.pointSize = 0.4;
    [attrManager addAttractor:attr4];*/
}

-(void) addAttractorToOpenGlBuffer
{
    NSInteger count = [attrManager attractorsDepth];
    //if(count >= attractorIndexes.count) return;
    
    if(count == 0)  {
        if([delegate respondsToSelector:@selector(createFirstAttractor)])
            [delegate createFirstAttractor];
    }
    
    ATTRactorObject *attr = [[ATTRactorObject alloc] init];
    attr.index = [[attractorIndexes objectAtIndex:attrIndex] integerValue];
    attr.g_side = [[attractorSides objectAtIndex:attrIndex] integerValue];
    //if(!isRedColor) [attr setHueColor:0.14f];
    attr.fade = [[attractorFades objectAtIndex:attrIndex] floatValue];
    attr.pointSize = [[attractorPontsSize objectAtIndex:attrIndex] floatValue];
    attr.phase = [attrManager attractorsDepth] * 10; //(arc4random() % ((unsigned)1000 + 1));
    attr.spherize = [[attractorSperiz objectAtIndex:attrIndex] floatValue];
    attr.dTime = [[attractorDeltaTime objectAtIndex:attrIndex] floatValue];
    
    if(count >= attractorIndexes.count) {
        [attrManager replaceAttractor:attr byIndex:attrIndex];
        //NSLog(@"change %i", attrIndex);
    } else  {
        [attrManager addAttractor:attr];
    }
    
    attrIndex++;
    if(attrIndex >= attractorIndexes.count)
        attrIndex = 0;
    
    //isRedColor = !isRedColor;
}

-(void) changeTRMatrixFar
{
    NSInteger attractorCount = [attrManager attractorsDepth];
    ATTRactorObject *object = [attrManager attractorAccess:attrIndex-1]; //attractorCount-1];
    if(object != nil)   {
        NSLog(@"noice %i attractor", attrIndex);
        [object attractorNoiceFar];
    }
}

-(void) changeTRMatrixNear
{
    NSInteger attractorCount = [attrManager attractorsDepth];
    for(int loop = 0; loop < attractorCount; loop++)
    {
        ATTRactorObject *object = [attrManager attractorAccess:loop];
        if(object != nil)   {
            [object attractorNoiceNear];
        }
    }
}

-(void) voiceListener
{
    __weak ATTRactorView * wself = self;
    startVoice = NO;
    
    audioManager = [Novocaine audioManager];
    
    __block float dBLevel =  0.0;
    __block float one =  0.0;
    [audioManager setInputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels) {
        float copyData[numFrames*numChannels];
        
        vDSP_vsq(data, 1, copyData, 1, numFrames*numChannels);
        float meanVal = 0.0;
        vDSP_meanv(copyData, 1, &meanVal, numFrames*numChannels);
        
        vDSP_vdbcon(&meanVal, 1, &one, &meanVal, 1, 1, 0);
        one = 1.0f;
        
        dBLevel = dBLevel + 0.2*(meanVal - dBLevel);
        
        if (dBLevel != dBLevel) {
            // nan
            dBLevel = -50.0f;
        }
        
        //printf("Decibel level: %f (%f)\n", dBLevel, [wself dBToProcent:dBLevel]);
        
        float dBFloatValue = [wself dBToProcent:dBLevel];
        if(dBFloatValue > 0.1f)
        {
            if(!wself.startVoice && dBFloatValue != 1.0)   {    //Первый проход в цикле dbFloatValue = 1.0000000 поэтому пропускаем создание аттрактора
                dispatch_async(dispatch_get_main_queue(), ^{
                    [wself addAttractorToOpenGlBuffer];
                });
            }
            
            wself.startVoice = YES;
        }
        else    {
            wself.startVoice = NO;
        }
    }];
    
    [self.audioManager play];
}

-(float) dBToProcent:(float)dBValue
{
    float   level;                // The linear 0.0 .. 1.0 value we need.
    float   minDecibels = -80.0f; // Or use -60dB, which I measured in a silent room.
    float   decibels = dBValue;
    if (decibels < minDecibels)
    {
        level = 0.0f;
    }
    else if (decibels >= 0.0f)
    {
        level = 1.0f;
    }
    else
    {
        float   root            = 2.0f;
        float   minAmp          = powf(10.0f, 0.05f * minDecibels);
        float   inverseAmpRange = 1.0f / (1.0f - minAmp);
        float   amp             = powf(10.0f, 0.05f * decibels);
        float   adjAmp          = (amp - minAmp) * inverseAmpRange;
        
        level = powf(adjAmp, 1.0f / root);
    }
    
    return level;
}

- (void)render:(CADisplayLink*)displayLink {
   
    [EAGLContext setCurrentContext:_context];
    
    static float time = 0;
    time += displayLink.duration * attractorIndexes.count*2;
    
    if(startVoice)
        [self changeTRMatrixFar];
    //else
    //    [self changeTRMatrixNear];
    
    //glEnable(GL_DEPTH_TEST);
    glEnable(GL_POINT_SPRITE_OES);
    glEnable(GL_POINT_SMOOTH);
    glEnable(GL_BLEND);
    //glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_COLOR);
    //glBlendFunc(GL_DST_COLOR, GL_ONE_MINUS_SRC_ALPHA);
    glBlendFunc(GL_SRC_COLOR, GL_ONE_MINUS_SRC_COLOR);
    //glBlendFunc(GL_ONE, GL_SRC_COLOR);
    
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glClearColor(1.0, 1.0, 1.0, 0.0);
    
    if(takeSnapshot)    {
        glClearColor(0.270588, 0.588235, 0.741176, 0.0);
    }
    //glClearColor(components[0], components[1], components[2], 0.0);
    //glClearColor(0.0, 0.0, 0.0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    glUseProgram(programHandle);
    
    GLKMatrix4 xRotationMatrix = GLKMatrix4MakeXRotation(((rotation_y*0.3)/ 180.0 * M_PI));
    GLKMatrix4 yRotationMatrix = GLKMatrix4MakeYRotation(((rotation_x*0.3)/ 180.0 * M_PI));
    GLKMatrix4 zRotationMatrix = GLKMatrix4MakeZRotation(0.0);
    GLKMatrix4 scaleMatrix     = GLKMatrix4MakeScale(scale, scale, scale);
    GLKMatrix4 translateMatrix = GLKMatrix4MakeTranslation(0.0, 0.0, 0.0);
    
    GLKMatrix4 modelMatrix = GLKMatrix4Multiply(translateMatrix,
                                                GLKMatrix4Multiply(scaleMatrix, GLKMatrix4Multiply(zRotationMatrix, GLKMatrix4Multiply(yRotationMatrix, xRotationMatrix))));
    GLKMatrix4 viewMatrix = GLKMatrix4MakeLookAt(0, 0, -1, 0, 0, 0, 0, 1, 0);
    
    GLKMatrix4 modelviewMatrix = GLKMatrix4Multiply(viewMatrix, modelMatrix);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(  (( 70.0 ) / 180.0 * M_PI), (float)self.frame.size.width/(float)self.frame.size.height, 0.0, 1000);
    
    glUniformMatrix4fv(glGetUniformLocation(programHandle, "Projection"), 1, GL_FALSE, projectionMatrix.m);
    glUniformMatrix4fv(glGetUniformLocation(programHandle, "Modelview"), 1, GL_FALSE, modelviewMatrix.m);
    
    [attrManager attractorsRender:programHandle withTimeOffset:time context:_context];
    
    if(takeSnapshot)    {
        takeSnapshot = NO;
        snapshotImage = [self snapshot:self];
        //snapshotImage = [self glToUIImage];
    }
    
    [_context presentRenderbuffer:GL_RENDERBUFFER_OES];

}

-(void) pinchGestureCaptured:(UIPinchGestureRecognizer*)gestureRecognizer
{
    CGFloat newScale = lastScale * gestureRecognizer.scale;
    
    if(newScale < 5.0 && newScale > 0.5)    {
        scale = newScale;
        
        if([delegate respondsToSelector:@selector(attractorScaleValue:)])
            [delegate attractorScaleValue:scale];
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)  {
        lastScale = scale;
        return;
    }
    
    NSLog(@"%f", scale);
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* t = [touches anyObject];
    rotation_x += ([t locationInView:self].x - [t previousLocationInView:self].x);
    rotation_y += ([t locationInView:self].y - [t previousLocationInView:self].y);
    
    NSLog(@"X:%f Y:%f",rotation_x, rotation_y);
}

- (void)setupContext {
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _context = [[EAGLContext alloc] initWithAPI:api];
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
}

- (void)setupRenderBuffer {
    glGenRenderbuffersOES(1, &_colorRenderBuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, _colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:_eaglLayer];
}

- (void)setupDepthBuffer {
    glGenRenderbuffersOES(1, &_depthRenderBuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, _depthRenderBuffer);
    glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, self.frame.size.width, self.frame.size.height);
}

- (void)setupFrameBuffer {
    glGenFramebuffersOES(1, &framebuffer);
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, framebuffer);
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, _colorRenderBuffer);
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, _depthRenderBuffer);
}

- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType {
    
    NSString *vertexShaderSource = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:shaderName ofType:@"glsl"] encoding:NSUTF8StringEncoding error:nil];
    const char *vertexShaderSourceCString = [vertexShaderSource cStringUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"%s", vertexShaderSourceCString);
    
    // 1
    NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"glsl"];
    NSError* error;
    NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString) {
        NSLog(@"Error loading shader: %@", error.localizedDescription);
        exit(1);
    }
    
    // 2
    GLuint shaderHandle = glCreateShader(shaderType);
    
    // 3
    const char * shaderStringUTF8 = [shaderString UTF8String];
    int shaderStringLength = [shaderString length];
    glShaderSource(shaderHandle, 1, &vertexShaderSourceCString, NULL);
    //glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    
    // 4
    glCompileShader(shaderHandle);
    
    // 5
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    return shaderHandle;
    
}

- (void)compileShaders {
    
    // 1
    GLuint vertexShader = [self compileShader:@"ifs_vertex" withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"ifs_fragment" withType:GL_FRAGMENT_SHADER];
    
    // 2
    programHandle = glCreateProgram();
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    glLinkProgram(programHandle);
    
    // 3
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    // 4
    glUseProgram(programHandle);
}

- (void)setupDisplayLink {
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

-(void) initialization
{
    [self setupLayer];
    [self setupContext];
    [self setupDepthBuffer];
    [self setupRenderBuffer];
    [self setupFrameBuffer];
    [self compileShaders];
    
    [self setupVBO];
    
    [self initGestureBlock];
    
    [self voiceListener];
    
    [self setupDisplayLink];
}

-(void) awakeFromNib
{
    //[self initialization];
}

-(void) initGestureBlock
{
    scale = 1.0;
    lastScale = 1.0;
    rotation_x = rotation_y = 0.0;
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureCaptured:)];
    [self addGestureRecognizer:pinch];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

- (UIImage*)snapshot:(UIView*)eaglview
{
    GLint backingWidth, backingHeight;
    
    // Bind the color renderbuffer used to render the OpenGL ES view
    // If your application only creates a single color renderbuffer which is already bound at this point,
    // this call is redundant, but it is needed if you're dealing with multiple renderbuffers.
    // Note, replace "_colorRenderbuffer" with the actual name of the renderbuffer object defined in your class.
    //glBindRenderbufferOES(GL_RENDERBUFFER_OES, _colorRenderBuffer);
    
    // Get the size of the backing CAEAGLLayer
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    
    NSInteger x = 0, y = 0, width = backingWidth, height = backingHeight;
    NSInteger dataLength = width * height * 4;
    GLubyte *data = (GLubyte*)malloc(dataLength * sizeof(GLubyte));
    
    // Read pixel data from the framebuffer
    glPixelStorei(GL_PACK_ALIGNMENT, 4);
    glReadPixels(x, y, width, height, GL_RGBA, GL_UNSIGNED_BYTE, data);
    
    // Create a CGImage with the pixel data
    // If your OpenGL ES content is opaque, use kCGImageAlphaNoneSkipLast to ignore the alpha channel
    // otherwise, use kCGImageAlphaPremultipliedLast
    CGDataProviderRef ref = CGDataProviderCreateWithData(NULL, data, dataLength, NULL);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGImageRef iref = CGImageCreate(width, height, 8, 32, width * 4, colorspace, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast,
                                    ref, NULL, true, kCGRenderingIntentDefault);
    
    // OpenGL ES measures data in PIXELS
    // Create a graphics context with the target size measured in POINTS
    NSInteger widthInPoints, heightInPoints;
    if (NULL != UIGraphicsBeginImageContextWithOptions) {
        // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
        // Set the scale parameter to your OpenGL ES view's contentScaleFactor
        // so that you get a high-resolution snapshot when its value is greater than 1.0
        CGFloat scale = eaglview.contentScaleFactor;
        //scale = 2.0;
        widthInPoints = width/ scale;
        heightInPoints = height/ scale;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(widthInPoints, heightInPoints), NO, scale);
    }
    else {
        // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
        widthInPoints = width;
        heightInPoints = height;
        UIGraphicsBeginImageContext(CGSizeMake(widthInPoints, heightInPoints));
    }
    
    CGContextRef cgcontext = UIGraphicsGetCurrentContext();
    
    // UIKit coordinate system is upside down to GL/Quartz coordinate system
    // Flip the CGImage by rendering it to the flipped bitmap context
    // The size of the destination area is measured in POINTS
    CGContextSetBlendMode(cgcontext, kCGBlendModeCopy);
    CGContextDrawImage(cgcontext, CGRectMake(0.0, 0.0, widthInPoints, heightInPoints), iref);
    
    // Retrieve the UIImage from the current context
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    // Clean up
    free(data);
    CFRelease(ref);
    CFRelease(colorspace);
    CGImageRelease(iref);
    
    return image;
}

-(UIImage *) glToUIImage
{
    
    GLint backingWidth, backingHeight;
    
    // Bind the color renderbuffer used to render the OpenGL ES view
    // If your application only creates a single color renderbuffer which is already bound at this point,
    // this call is redundant, but it is needed if you're dealing with multiple renderbuffers.
    // Note, replace "_colorRenderbuffer" with the actual name of the renderbuffer object defined in your class.
    //glBindRenderbufferOES(GL_RENDERBUFFER_OES, _colorRenderBuffer);
    
    // Get the size of the backing CAEAGLLayer
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    
    GLint imageWidth = backingWidth;
    GLint imageHeight = backingHeight;
    
    NSInteger myDataLength = imageWidth * imageHeight * 4;
    
    
    // allocate array and read pixels into it.
    GLubyte *buffer = (GLubyte *) malloc(myDataLength);
    glReadPixels(0, 0, imageWidth, imageHeight, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    
    // gl renders "upside down" so swap top to bottom into new array.
    // there's gotta be a better way, but this works.
    GLubyte *buffer2 = (GLubyte *) malloc(myDataLength);
    for(int y = 0; y < imageHeight; y++)
    {
        for(int x = 0; x < imageWidth * 4; x++)
        {
            buffer2[((imageHeight - 1) - y) * imageWidth * 4 + x] = buffer[y * 4 * imageWidth + x];
        }
    }
    
    // make data provider with data.
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer2, myDataLength, NULL);
    
    // prep the ingredients
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * imageWidth;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    // make the cgimage
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    
    // then make the uiimage from that
    UIImage *myImage = [UIImage imageWithCGImage:imageRef];
    return myImage;
}

-(void) snapShoting
{
    takeSnapshot = YES;
}

@end

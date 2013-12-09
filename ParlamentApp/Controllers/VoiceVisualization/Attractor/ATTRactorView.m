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
}
@synthesize audioManager;
@synthesize startVoice;
@synthesize attrManager;
@synthesize snapshotImage;
@synthesize delegate;
@synthesize scale, lastScale;

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (void)setupLayer {
    
    _eaglLayer = (CAEAGLLayer*) self.layer;
    _eaglLayer.opaque = NO;
    _eaglLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking : @(YES)};
    
    attrManager = [[ATTRactorManager alloc] init];
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
    isRedColor = YES;
    takeSnapshot = NO;
}

-(void) setupVBO
{
    isRedColor = YES;
    takeSnapshot = NO;
    
    attractorIndexes = @[[NSNumber numberWithInt:1],
                         [NSNumber numberWithInt:3],
                         [NSNumber numberWithInt:5],
                         [NSNumber numberWithInt:7],
                         [NSNumber numberWithInt:9],
                         [NSNumber numberWithInt:10],
                         [NSNumber numberWithInt:11]];
    
    attractorSides = @[[NSNumber numberWithInt:256],
                       [NSNumber numberWithInt:128],
                       [NSNumber numberWithInt:128],
                       [NSNumber numberWithInt:128],
                       [NSNumber numberWithInt:128],
                       [NSNumber numberWithInt:256],
                       [NSNumber numberWithInt:256]];
    
    attractorPontsSize = @[[NSNumber numberWithFloat:1.2],
                           [NSNumber numberWithFloat:0.5],
                           [NSNumber numberWithFloat:0.4],
                           [NSNumber numberWithFloat:0.4],
                           [NSNumber numberWithFloat:0.3],
                           [NSNumber numberWithFloat:0.7],
                           [NSNumber numberWithFloat:0.2]];
    
    attractorFades = @[[NSNumber numberWithFloat:0.2],
                           [NSNumber numberWithFloat:0.7],
                           [NSNumber numberWithFloat:0.8],
                           [NSNumber numberWithFloat:0.9],
                           [NSNumber numberWithFloat:1.0],
                           [NSNumber numberWithFloat:0.2],
                           [NSNumber numberWithFloat:0.4]];
    
    attractorSperiz = @[[NSNumber numberWithFloat:0.96],
                       [NSNumber numberWithFloat:0.94],
                       [NSNumber numberWithFloat:0.96],
                       [NSNumber numberWithFloat:1.2],
                       [NSNumber numberWithFloat:1.0],
                       [NSNumber numberWithFloat:0.76],
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
    if(count >= attractorIndexes.count) return;
    
    if(count == 0)  {
        if([delegate respondsToSelector:@selector(createFirstAttractor)])
            [delegate createFirstAttractor];
    }
    
    ATTRactorObject *attr = [[ATTRactorObject alloc] init];
    attr.index = [[attractorIndexes objectAtIndex:count] integerValue];
    attr.g_side = [[attractorSides objectAtIndex:count] integerValue];
    if(!isRedColor) [attr setHueColor:0.14f];
    attr.fade = [[attractorFades objectAtIndex:count] floatValue];
    attr.pointSize = [[attractorPontsSize objectAtIndex:count] floatValue];
    attr.phase = 0;//[attrManager attractorsDepth] * 10; //(arc4random() % ((unsigned)1000 + 1));
    attr.spherize = [[attractorSperiz objectAtIndex:count] floatValue];
    attr.dTime = [[attractorDeltaTime objectAtIndex:count] floatValue];
    [attrManager addAttractor:attr];
    
    isRedColor = !isRedColor;
}

-(void) changeTRMatrixFar
{
    NSInteger attractorCount = [attrManager attractorsDepth];
    ATTRactorObject *object = [attrManager attractorAccess:attractorCount-1];
    if(object != nil)   {
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
    time += displayLink.duration * attractorIndexes.count;
    
    if(startVoice)
        [self changeTRMatrixFar];
    //else
    //    [self changeTRMatrixNear];
    
    glEnable(GL_POINT_SPRITE_OES);
    glEnable(GL_POINT_SMOOTH);
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_COLOR);
    
    //glClearColor(1.0,0.0,0.0,0.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    //glViewport(0, 0, self.frame.size.height, self.frame.size.width);
    
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
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER_OES, _colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:_eaglLayer];
}

- (void)setupDepthBuffer {
    glGenRenderbuffers(1, &_depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER_OES, _depthRenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, self.frame.size.width, self.frame.size.height);
}

- (void)setupFrameBuffer {
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER_OES, framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, _colorRenderBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, _depthRenderBuffer);
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
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, _colorRenderBuffer);
    
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
        widthInPoints = width / scale;
        heightInPoints = height / scale;
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

-(void) snapShoting
{
    takeSnapshot = YES;
}

@end

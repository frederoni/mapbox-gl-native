#import "MGLAnnotationView.h"
#import "MGLAnnotationView_Private.h"
#import "MGLAnnotation_Private.h"
#import "MGLMapView.h"

@interface MGLAnnotationView () <UIGestureRecognizerDelegate> {
    CGPoint dragStartingPoint;
    BOOL allowDrag;
}

@property (nonatomic) id<MGLAnnotation> annotation;
@property (nonatomic, readwrite, nullable) NSString *reuseIdentifier;
@property (nonatomic, weak) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, weak) UILongPressGestureRecognizer *longPressRecognizer;
@end

@implementation MGLAnnotationView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super init];
    
    if (self)
    {
        _reuseIdentifier = [reuseIdentifier copy];
    }
    
    return self;
}

- (void)prepareForReuse
{
    // Intentionally left blank. The default implementation of this method does nothing.
}

- (void)setCenterOffset:(CGVector)centerOffset
{
    _centerOffset = centerOffset;
    self.center = self.center;
}

- (void)setCenter:(CGPoint)center
{
    [self setCenter:center pitch:0];
}

- (void)setCenter:(CGPoint)center pitch:(CGFloat)pitch
{
    center.x += _centerOffset.dx;
    center.y += _centerOffset.dy;
    
    [super setCenter:center];
    
    if (_flat) {
        [self updatePitch:pitch];
    }
}

- (void)updatePitch:(CGFloat)pitch
{
    CATransform3D t = CATransform3DRotate(CATransform3DIdentity, MGLRadiansFromDegrees(pitch), 1.0, 0, 0);
    self.layer.transform = t;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    _selected = selected;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
}

- (void)setDraggable:(BOOL)draggable
{
    _draggable = draggable;
    if (draggable) {
        [self enableDrag];
    } else {
        [self disableDrag];
    }
}

- (void)enableDrag
{
    if (!_longPressRecognizer) {
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        recognizer.delegate = self;
        [self addGestureRecognizer:recognizer];
        _longPressRecognizer = recognizer;
    }
    
    if (!_panGestureRecognizer) {
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        recognizer.delegate = self;
        [self addGestureRecognizer:recognizer];
        _panGestureRecognizer = recognizer;
    }
}

- (void)disableDrag
{
    if (_longPressRecognizer)
    {
        [self removeGestureRecognizer:_longPressRecognizer];
    }
    if (_panGestureRecognizer)
    {
        [self removeGestureRecognizer:_panGestureRecognizer];
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        self.dragState = MGLAnnotationViewDragStateStarting;
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        allowDrag = YES;
        self.dragState = MGLAnnotationViewDragStateDragging;
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        allowDrag = NO;
        self.dragState = MGLAnnotationViewDragStateEnding;
    }
}

- (void)setDragState:(MGLAnnotationViewDragState)dragState
{
    [self setDragState:dragState animated:NO];
}

- (void)setDragState:(MGLAnnotationViewDragState)dragState animated:(BOOL)animated
{
    _dragState = dragState;
    
    NSLog(@"Drag state changed to : %@", [self dragStateNameWithDragState:dragState]);
    
    switch (dragState) {
        case MGLAnnotationViewDragStateNone:
            break;
        case MGLAnnotationViewDragStateStarting:
            [self scaleUp];
            break;
        case MGLAnnotationViewDragStateDragging:
            break;
        case MGLAnnotationViewDragStateCanceling:
            break;
        case MGLAnnotationViewDragStateEnding:
            // TODO: Set the new location
            
            [self scaleDown];
            break;
    }
}

- (void)scaleUp
{
    
}

- (void)scaleDown
{
    
}

// Temporary... remove this
- (NSString *)dragStateNameWithDragState:(MGLAnnotationViewDragState)dragState
{
    switch (dragState) {
        case MGLAnnotationViewDragStateNone:
            return @"None";
        case MGLAnnotationViewDragStateStarting:
            return @"Starting";
        case MGLAnnotationViewDragStateDragging:
            return @"Dragging";
        case MGLAnnotationViewDragStateCanceling:
            return @"Canceling";
        case MGLAnnotationViewDragStateEnding:
            return @"Ending";
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)sender
{
    CGPoint p1 = [sender translationInView:self.superview];
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            dragStartingPoint = self.center;
            break;
        }
        case UIGestureRecognizerStateEnded: {
            dragStartingPoint = CGPointMake(dragStartingPoint.x+p1.x, dragStartingPoint.y+p1.y);
            break;
        }
        case UIGestureRecognizerStateChanged: {
            self.center = CGPointMake(dragStartingPoint.x+p1.x, dragStartingPoint.y+p1.y);
            break;
        }
        case UIGestureRecognizerStateFailed:
            break;
        case UIGestureRecognizerStateCancelled:
            break;
        case UIGestureRecognizerStatePossible:
            break;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:UIPanGestureRecognizer.class] && !(allowDrag)) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event
{
    // Allow mbgl to drive animation of this view’s bounds.
    if ([event isEqualToString:@"bounds"])
    {
        return [NSNull null];
    }
    return [super actionForLayer:layer forKey:event];
}

@end
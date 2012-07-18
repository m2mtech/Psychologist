//
//  FaceView.h
//  Happiness
//
//  Created by Martin Mandl on 17.07.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FaceView; // forward reference

@protocol FaceViewDataSource

- (float)smileForFaceView:(FaceView *)sender;

@end

@interface FaceView : UIView

#define DEFAULT_SCALE 0.9
#define EYE_H 0.35
#define EYE_V 0.35
#define EYE_RADIUS 0.1
#define MOUTH_H 0.45
#define MOUTH_V 0.4
#define MOUTH_SMILE 0.25

@property (nonatomic) CGFloat scale;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@property (nonatomic, weak) IBOutlet id <FaceViewDataSource> dataSource;

@end

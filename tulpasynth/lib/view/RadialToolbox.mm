//
//  RadialToolbox.m
//  tulpasynth
//
//  Created by Colin Sullivan on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RadialToolbox.h"

#import "tulpaViewController.h"

@implementation RadialToolbox

@synthesize active, prototypes;
@synthesize squarePrototype, shooterPrototype;

- (void) setWidth:(float)width {
    [super setWidth:width];
    
    self.shape->m_radius = self.width/2;
}

- (void) setPosition:(b2Vec2*)aPosition {
    [super setPosition:aPosition];
    
    self.squarePrototype.position = new b2Vec2(
                                               self.position->x + 6.5,
                                               self.position->y + 6.5
                                               );
    self.shooterPrototype.position = new b2Vec2(
                                            self.position->x - 6.5,
                                            self.position->y + 6.5
                                            );
}

- (void) initialize {
    
    [super initialize];
    
    self.prototypes = [[NSMutableArray alloc] init];
        
    self.angle = 0.0;
    
    self.active = false;
    
    self.shape = new b2CircleShape();
    b2FixtureDef myShapeFixture;
    myShapeFixture.shape = self.shape;
    myShapeFixture.friction = 0.1f;
    myShapeFixture.density = 0.75f;
    myShapeFixture.restitution = 2.0f;
    
    self.shapeFixture = self.body->CreateFixture(&myShapeFixture);
    
    self.width = 30;
    self.height = 30;
    
    b2Filter filterData;
    filterData.groupIndex = 1;
    self.shapeFixture->SetFilterData(filterData);
    
    // Create object prototypes
    self.squarePrototype = [[BlockObstacle alloc] initWithController:self.controller withModel:NULL];
    self.squarePrototype.width = [[[BlockModel defaultAttributes] valueForKey:@"width"] floatValue];
    self.squarePrototype.height = [[[BlockModel defaultAttributes] valueForKey:@"height"] floatValue];
    self.squarePrototype.shapeFixture->SetFilterData(filterData);
    [self.prototypes addObject:self.squarePrototype];
    
    self.shooterPrototype = [[Shooter alloc] initWithController:self.controller withModel:NULL];
    self.shooterPrototype.width = [[[ShooterModel defaultAttributes] valueForKey:@"width"] floatValue];
    self.shooterPrototype.height = [[[ShooterModel defaultAttributes] valueForKey:@"height"] floatValue];
    self.shooterPrototype.shapeFixture->SetFilterData(filterData);
    [self.prototypes addObject:self.shooterPrototype];
    
}

- (void) dealloc {
//    [self dealloc];
    delete (b2CircleShape*)self.shape;
}

-(void)prepareToDraw {
//    self.effect.useConstantColor = YES;
//    self.effect.constantColor = GLKVector4Make(0.15, 0.88, 0.49, 1.0);
    self.effect.texture2d0.name = self.controller.toolboxTexture.name;
    
    [super prepareToDraw];
}

- (void) draw {
    if (self.active) {
        [super draw];        
    }
}

- (void) postDraw {
    [super postDraw];
    if (self.active) {
        
        for (PhysicsEntity* e in self.prototypes) {
            [e prepareToDraw];
            [e draw];
            [e postDraw];
        }
    }
}

- (void) update {
    [super update];
    
    for (PhysicsEntity* e in self.prototypes) {
        [e update];
    }
}

- (void) handleTapOccurred:(TapEntity*)tap {
    // if tap was in block obstacle prototype
    if ([self.squarePrototype handleTap:tap]) {
        
        // Create new block obstacle obstacle at point
        BlockModel* sm = [[BlockModel alloc] initWithController:self.controller withAttributes:
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithFloat:self.position->x], @"x",
                             [NSNumber numberWithFloat:self.position->y], @"y", nil], @"initialPosition",
                            nil]];

    }
    else if ([self.shooterPrototype handleTap:tap]) {
        // Create new shooter at that point
        ShooterModel* sm = [[ShooterModel alloc] initWithController:self.controller withAttributes:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat:self.position->x], @"x",
                              [NSNumber numberWithFloat:self.position->y], @"y", nil], @"initialPosition",
                             nil]];
    }
    
    self.active = false;
}

@end

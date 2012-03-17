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
@synthesize squarePrototype, shooterPrototype, triPrototype, blackholePrototype;

- (void) setWidth:(float)width {
    [super setWidth:width];
    
    self.shape->m_radius = self.width/2;
}

- (void) setPosition:(b2Vec2*)aPosition {
    [super setPosition:aPosition];
    
    self.squarePrototype.position = new b2Vec2(
                                               self.position->x + 8.5,
                                               self.position->y + 7
                                               );
    self.shooterPrototype.position = new b2Vec2(
                                            self.position->x - 8,
                                            self.position->y + 7
                                            );
    
    self.triPrototype.position = new b2Vec2(self.position->x + 12,
                                            self.position->y + 2);
    
    self.blackholePrototype.position = new b2Vec2(self.position->x - 11,
                                                  self.position->y + 1);
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
    
    self.width = 32;
    self.height = 32;
    
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
    self.shooterPrototype.angle = [[[ShooterModel defaultAttributes] valueForKey:@"angle"] floatValue];
    self.shooterPrototype.shapeFixture->SetFilterData(filterData);
    [self.prototypes addObject:self.shooterPrototype];
    
    self.triPrototype = [[TriObstacle alloc] initWithController:self.controller withModel:NULL];
    [self.triPrototype setWidth:[[[TriObstacleModel defaultAttributes] valueForKey:@"width"] floatValue] withHeight:[[[TriObstacleModel defaultAttributes] valueForKey:@"height"] floatValue]];
    self.triPrototype.angle = [[[TriObstacleModel defaultAttributes] valueForKey:@"angle"] floatValue];
    self.triPrototype.shapeFixture->SetFilterData(filterData);
    [self.prototypes addObject:self.triPrototype];
    
    self.blackholePrototype = [[Blackhole alloc] initWithController:self.controller withModel:NULL];
    self.blackholePrototype.width = [[[BlackholeModel defaultAttributes] valueForKey:@"width"] floatValue];
    self.blackholePrototype.height = [[[BlackholeModel defaultAttributes] valueForKey:@"height"] floatValue];
    self.blackholePrototype.shapeFixture->SetFilterData(filterData);
    [self.prototypes addObject:self.blackholePrototype];
    
    
    self.effect.texture2d0.name = self.controller.toolboxTexture.name;
}

- (void) dealloc {
//    [self dealloc];
    delete (b2CircleShape*)self.shape;
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
    else if ([self.triPrototype handleTap:tap]) {
        // create new tri obstacle
        [[TriObstacleModel alloc] initWithController:self.controller withAttributes:[NSDictionary dictionaryWithKeysAndObjects:
                                                                           @"initialPosition", [NSDictionary dictionaryWithKeysAndObjects:
                                                                                                @"x", [NSNumber numberWithFloat:self.position->x],
                                                                                                @"y", [NSNumber numberWithFloat:self.position->y], nil],
                                                                           nil]];
    }
    else if ([self.blackholePrototype handleTap:tap]) {
        // create new blackhole
        [[BlackholeModel alloc] initWithController:self.controller withAttributes:[NSDictionary dictionaryWithKeysAndObjects:
                                                                                   @"initialPosition", [NSDictionary dictionaryWithKeysAndObjects:
                                                                                                        @"x", [NSNumber numberWithFloat:self.position->x],
                                                                                                        @"y", [NSNumber numberWithFloat:self.position->y], nil]
                                                                                   , nil]];
    }
    
    self.active = false;
}

@end

/**
 *  @file       BlockObstacle.mm
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import "BlockObstacle.h"

#import "tulpaViewController.h"

@implementation BlockObstacle

@synthesize instr;



/**
 *  When width or height is set, change shape.
 **/
- (void)createShape {
    [super createShape];
    
    self.shape->m_radius = 0.5f;
    ((b2PolygonShape*)self.shape)->SetAsBox(
                                            self.width/2.0 - 0.5,
                                            self.height/2.0 - 0.5
                                            );
    
    b2FixtureDef mySquareFixture;
    mySquareFixture.shape = self.shape;
    mySquareFixture.density = 1.0f;
    mySquareFixture.friction = 0.1f;
    mySquareFixture.restitution = 1.0f;
    
    self.shapeFixture = self.body->CreateFixture(&mySquareFixture);
}

- (void) initialize {

    [super initialize];

    b2MassData myBodyMass;
    myBodyMass.mass = 10.0f;
    self.body->SetMassData(&myBodyMass);
    
    self.instr = new instruments::BendingFMPercussion();
    ((instruments::Instrument*)self.instr)->finish_initializing();
//    instr->freq(880);
//    instr->velocity(1.0);
//    instr->duration(0.7);
//    instr->play();

    self.effect.texture2d0.name = self.controller.glowingBoxTexture.name;
}

- (void) dealloc {
    delete (instruments::FMPercussion*)self.instr;
    
//    [super dealloc];
}

- (void) handleCollision:(PhysicsEntity *)otherEntity withStrength:(float)collisionStrength {
    
    [super handleCollision:otherEntity withStrength:collisionStrength];

    BlockModel* model = ((BlockModel*)self.model);
    
    if ([otherEntity class] == [WildBall class]) {
        WildBallModel* ballModel = ((WildBallModel*)otherEntity.model);
        int pitchIndex = [ballModel.pitchIndex intValue];
        if (pitchIndex >= 0) {
            float freq = [[TriObstacle class] pitchIndexToFreq:pitchIndex];
            self.instr->freq(freq/2.0);
            self.instr->velocity(collisionStrength);
            
            // map width of block into duration of bend
            float minDuration = 0.1;
            float maxDuration = 1.25;
            float rangeDuration = maxDuration - minDuration;
            
            float minWidth = [[model class] minWidth];
            float maxWidth = [[model class] maxWidth];
            float rangeWidth = maxWidth - minWidth;
            
            float widthPerc = [model.width floatValue] / rangeWidth;
            float duration = (widthPerc * rangeDuration) + minDuration;
            
            // map angle of block into bend direction
            float maxAngle = stk::TWO_PI;
            float anglePerc = [model.angle floatValue] / maxAngle;
            if (anglePerc < 0.5) {
                self.instr->bendDirection(1.0);
            }
            else {
                self.instr->bendDirection(-1.0);
            }
            
            
            self.instr->duration(duration);
            self.instr->play();
            
            // assume color from ball
            self.color = [[TriObstacle class] pitchIndexToColor:pitchIndex];
        }
    }
}

//- (void)update {
//    [super update];
//
//}

@end

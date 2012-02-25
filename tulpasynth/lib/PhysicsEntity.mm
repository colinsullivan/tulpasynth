/**
 *  @file       PhysicsEntity.mm
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#import "PhysicsEntity.h"

#import "tulpaViewController.h"

@implementation PhysicsEntity

@synthesize body, effect, controller, shape, shapeFixture, model;

@synthesize width, height, angle;

- (const b2Vec2&)position {
    return self.body->GetPosition();
}

- (void)setPosition:(const b2Vec2 &)aPosition {
    self.body->SetTransform(aPosition, -1*self.angle);
}

- (void)setAngle:(float32)anAngle {
    if (anAngle >= M_PI*2) {
        anAngle = anAngle - M_PI*2;
    }
    
    if (self.body) {
        self.body->SetTransform(self.position, -1*anAngle);        
    }

    angle = anAngle;
}

- (id)initWithController:(tulpaViewController *)theController withModel:(PhysicsEntityModel*)aModel {
    if (self = [self init]) {
        
        self.controller = theController;
        self.model = aModel;
        
        // Shader for this object
        self.effect = [[GLKBaseEffect alloc] init];
        self.effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(0, self.controller.view.frame.size.width, self.controller.view.frame.size.height, 0, -1, 1);

//        [self setupDepthBuffer];
//        [self setupRenderBuffer];        
//        [self setupFrameBuffer];     
//        [self compileShaders];
//        [self setupVBOs];


        //        // Vertex buffers
        glGenBuffers(1, &_vertexBuffer);        
        glGenBuffers(1, &_indexBuffer);
        
        self.angle = 0;
        
        // Create static body
        b2BodyDef bodyDef;
        bodyDef.position = b2Vec2([[aModel.initialPosition valueForKey:@"x"] floatValue], [[aModel.initialPosition valueForKey:@"y"] floatValue]);
        bodyDef.type = [self bodyType];
        b2Body* newBody = self.controller.world->CreateBody(&bodyDef);
        self.body = newBody;
        
        self.body->SetUserData(((void*)self));
        
        [[PhysicsEntity Instances] addObject:self];
    }

    return self;
}

+ (NSMutableArray*) Instances {
    static NSMutableArray* instancesList = nil;
    
    if (instancesList == nil) {
        instancesList = [[NSMutableArray alloc] init];
    }
    
    return instancesList;
}

- (b2BodyType) bodyType {
    return b2_staticBody;
}

- (void)prepareToDraw {
//    self.effect.useConstantColor = YES;
//    self.effect.constantColor = GLKVector4Make(1.0, 0.0, 0.0, 1.0);

    [self.effect prepareToDraw];

    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    
    glEnable(GL_BLEND);
    glBlendFunc( GL_ONE, GL_ONE_MINUS_SRC_ALPHA );
}

- (void)draw {
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Position));
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Color));    
}

- (void)postDraw {
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    glDisableVertexAttribArray(GLKVertexAttribColor);
    glDisable(GL_BLEND);
    
}

- (void)update {
    // Width and height are switched here because this app only works when rotated
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(M_TO_PX(self.position.y), M_TO_PX(self.position.x), 0.0);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, self.angle, 0.0, 0.0, 1.0);
    modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, M_TO_PX(self.height/2), M_TO_PX(self.width/2), 1.0f);
    //    GLKMatrix4Translate(modelViewMatrix, _position->y, _position->x, _position->z);
    //    _rotation += 90 * self.timeSinceLastUpdate;
    //    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(_rotation), 0, 0, 1);
    self.effect.transform.modelviewMatrix = modelViewMatrix;    
}

- (void)dealloc {
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_indexBuffer);
    
    self.effect = nil;
}


@end

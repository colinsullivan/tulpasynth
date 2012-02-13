//
//  PhysicsEntity.m
//  tulpasynth
//
//  Created by Colin Sullivan on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhysicsEntity.h"

@implementation PhysicsEntity

@synthesize body, effect, controller, shape;

@synthesize width, height, angle;

- (const b2Vec2&)position {
    return self.body->GetPosition();
}

- (void)setPosition:(const b2Vec2 &)aPosition {
    self.body->SetTransform(aPosition, self.angle);
}

- (void)setAngle:(float32)anAngle {
    if (anAngle >= M_PI*2) {
        anAngle = anAngle - M_PI*2;
    }
    
    if (self.body) {
        self.body->SetTransform(self.position, anAngle);        
    }

    angle = anAngle;
}

- (id)initWithController:(tulpaViewController *)theController withPosition:(b2Vec2)aPosition {
    if (self = [self init]) {
        
        self.controller = theController;
        
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
        bodyDef.position = aPosition;
        bodyDef.type = [self bodyType];
        b2Body* newBody = self.controller.world->CreateBody(&bodyDef);
        self.body = newBody;
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

- (void)draw {
    self.effect.texture2d0.enabled = GL_TRUE;
    self.effect.texture2d0.envMode = GLKTextureEnvModeModulate;
    self.effect.texture2d0.target = GLKTextureTarget2D;
    self.effect.texture2d0.name = self.controller.glowingCircleTexture.name;
    self.effect.useConstantColor = YES;
    self.effect.constantColor = GLKVector4Make(1.0, 0.0, 0.0, 1.0);

    [self.effect prepareToDraw];
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    
    glEnable(GL_BLEND);
    glBlendFunc( GL_ONE, GL_ONE_MINUS_SRC_ALPHA );

    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Position));
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Color));    
}

- (void)update {
    // Width and height are switched here because this app only works when rotated
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(M_TO_PX(self.position.y), M_TO_PX(self.position.x), 0.0);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, self.angle, 0.0, 0.0, 1.0);
    modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, M_TO_PX(self.width), M_TO_PX(self.height), 1.0f);
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

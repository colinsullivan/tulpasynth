//
//  Square.m
//  tulpasynth
//
//  Created by Colin Sullivan on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Square.h"

static Vertex SquareVertices[] = {
    {{1, -1, 0}, {0, 0, 0}},
    {{1, 1, 0}, {0, 0, 0}},
    {{-1, 1, 0}, {0, 0, 0}},
    {{-1, -1, 0}, {0, 0, 0}}
};


const GLubyte SquareIndices[] = {
    0, 1, 2,
    2, 3, 0
};

@implementation Square

/**
 *  When width or height is set, change shape.
 **/
- (void)setHeight:(float)height {
    [super setHeight:height];
    
    if (self.shape) {        
        ((b2PolygonShape*)self.shape)->SetAsBox(self.width, height);    
    }
    
}
- (void)setWidth:(float)width {
    [super setWidth:width];
    
    if (self.shape) {
        ((b2PolygonShape*)self.shape)->SetAsBox(width, self.height);        
    }
    
}

- (id)initWithController:(tulpaViewController *)theController withPosition:(b2Vec2)aPosition {
    
    if (self = [super initWithController:theController withPosition:aPosition]) {

        self.width = 15;
        self.height = 15;



        // Create square polygon
        b2PolygonShape* mySquare = new b2PolygonShape();
        mySquare->SetAsBox(self.width, self.height);
        mySquare->m_radius = self.width/2;
//        mySquare.Set(vertices, 4);
        self.body->CreateFixture(mySquare, 1.0f);
        self.shape = mySquare;
        
        
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(SquareVertices), SquareVertices, GL_STATIC_DRAW);
        
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(SquareIndices), SquareIndices, GL_STATIC_DRAW);        
    }

    return self;
}

- (void)draw {
    [super draw];

    glDrawElements(GL_TRIANGLES, sizeof(SquareIndices)/sizeof(SquareIndices[0]), GL_UNSIGNED_BYTE, 0);
}

//- (void)update {
//    [super update];
//
//}


@end

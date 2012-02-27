//
//  Toolbar.mm
//  tulpasynth
//
//  Created by Colin Sullivan on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Toolbar.h"

static Vertex ToolbarVertices[] = {
    {{1, -1, 0}, {0.15, 0.88, 0.49, 1.0}, {1, 0}},
    {{1, 1, 0}, {0.15, 0.88, 0.49, 1.0}, {1, 1}},
    {{-1, 1, 0}, {0.15, 0.88, 0.49, 1.0}, {0, 1}},
    {{-1, -1, 0}, {0.15, 0.88, 0.49, 1.0}, {0, 0}}    
};

const GLubyte ToolbarIndices[] = {
    0, 1, 2,
    2, 3, 0
};

@implementation Toolbar


@end

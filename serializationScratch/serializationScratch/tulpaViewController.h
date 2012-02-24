//
//  tulpaViewController.h
//  serializationScratch
//
//  Created by Colin Sullivan on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

#import "Model.h"
#import "View.h"

@interface tulpaViewController : UIViewController

@property (strong, nonatomic) Model* m;

@end

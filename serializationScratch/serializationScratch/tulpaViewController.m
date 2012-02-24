//
//  tulpaViewController.m
//  serializationScratch
//
//  Created by Colin Sullivan on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "tulpaViewController.h"

@implementation tulpaViewController

@synthesize m;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
//    // serialization
//    Model *m = [[Model alloc] init];
//
//    [m.attributes setValue:[[NSNumber alloc] initWithInt:1] forKey:@"id"];
//    [m.attributes setValue:[[NSString alloc] initWithString:@"Colin"] forKey:@"name"];
//        
//    BOOL isValid = [NSJSONSerialization isValidJSONObject:m.attributes];
//    
//    if (isValid) {
//        NSLog(@"m is a valid JSON object!");
//    }
//    else {
//        NSLog(@"m is an invalid JSON object!");
//    }
//    
//    NSError* error;
//    NSData* serializedModel = [NSJSONSerialization dataWithJSONObject:m.attributes options:NSJSONWritingPrettyPrinted error:&error];
//    
//    if (serializedModel) {
//        NSLog(@"m:\n%@", [[NSString alloc] initWithData:serializedModel encoding:NSUTF8StringEncoding]);
//    }
//    else {
//        NSLog(@"An error occurred while serializing:\n%@", error);
//    }
//    
//    // de-serialization
//    NSLog(@"Attempting to de-serialize into new instance");
//    Model* another = [[Model alloc] init];
//    another.attributes = [NSJSONSerialization JSONObjectWithData:serializedModel options:NSJSONReadingAllowFragments|NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error];
//    if (another.attributes) {
//        NSLog(@"another:\n%@", another.attributes);
//    }
//    else {
//        NSLog(@"An error occurred while de-serializing:\n%@", error);
//    }
//    
//    View* v = [[View alloc] init];
//
//    // this view will watch `another` for changes in name
//    NSLog(@"View.addObserver");
//    [v addObserver:another forKeyPath:@"attributes" options:NSKeyValueObservingOptionNew&NSKeyValueObservingOptionInitial context:NULL];
//    
//    NSLog(@"Changing id");
//    [another setValue:[[NSNumber alloc] initWithInt:2] forKeyPath:@"attributes.id"];
//    
//    NSLog(@"Changing name");
//    [another setValue:[[NSString alloc] initWithString:@"Derek"] forKeyPath:@"attributes.name"];
    
    
    
    // Serialization
    m = [[Model alloc] init];
    m.name = @"Colin";

    NSLog(@"m.id: %@", m.id);    
    NSLog(@"m.name: %@", m.name);
    
//    NSMutableDictionary* mserialized = [m serialize];
//    NSLog(@"mserialized:\n%@", mserialized);
    
    View* v = [[View alloc] init];
    [m addObserver:v forKeyPath:@"name" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:NULL];
    
    m.name = @"Locky";
    
    [m dealloc];
    
    
    
//    RKObjectMappingProvider* mappingProvider = [RKObjectMappingProvider objectMappingProvider];
    
//    RKObjectMapping* modelMapping = [RKObjectMapping mappingForClass:[Model class]];
//    [modelMapping mapAttributes:@"id", @"name", nil];
    
//    [mappingProvider addObjectMapping:modelMapping];
    
//    RKObjectSerializer* modelSerializer = [RKObjectSerializer serializerWithObject:m mapping:modelMapping];
//    NSMutableDictionary* serializedModel = [modelSerializer serializedObject:&error];
    
//    if (serializedModel) {
//        NSLog(@"serializedModel:\n%@", serializedModel);
//    }
//    else {
//        NSLog(@"An error occurred while serializing:\n%@", error);
//    }
    
    // De-serialization, instantiation
//    [m dealloc];
//    m = [[Model alloc] init];
//    
//    NSLog(@"De-serializing");
//    RKObjectMappingOperation* mapperOperation = [RKObjectMappingOperation mappingOperationFromObject:serializedModel toObject:m withMapping:modelMapping];
//    if ([mapperOperation performMapping:&error]) {
//        NSLog(@"m.id: %@", m.id);
//        NSLog(@"m.name: %@", m.name);
//    }
//    else {
//        NSLog(@"An error occurred while de-serializing:\n%@", [error localizedDescription]);
//    }
    
    

    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end

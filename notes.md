https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/KeyValueCoding/Articles/BasicPrinciples.html
- bottom has simple key value - dot syntax example

https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/KeyValueObserving/Articles/KVOCompliance.html#//apple_ref/doc/uid/20002178-BAJEAIEE
- bottom has examples for manually notifying observers

psuedocode for user action synchronization:

    // Time that it may be safe to advance to if no more user actions have
    // happened prior.
    time potentiallySafe = now;

    duration timeSince = now - action.time;


    // `UserAction` instance happened now or in the past
    if(timeSince >= 0) {

        // if no more actions happened before time potentiallySafe
        if(potentiallySafe - action.time > 0) {
            // we can advance time up until previous user actions
            g_safe = potentiallySafe;
        }
        
        // perform `UserAction` instance
        action.perform();

        // potentially allow time to advance to most recently applied user 
        // action
        potentiallySafe = action.time;
    }
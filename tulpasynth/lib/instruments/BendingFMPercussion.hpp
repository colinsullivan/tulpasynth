//
//  BendingFMPercussion.h
//  tulpasynth
//
//  Created by Colin Sullivan on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef tulpasynth_BendingFMPercussion_h
#define tulpasynth_BendingFMPercussion_h

#include "FMPercussion.hpp"

namespace instruments {
    /**
     *  @class subclass of FMPercussion that bends notes.
     **/
    class BendingFMPercussion : protected FMPercussion {
    public:
        
        BendingFMPercussion();
        ~BendingFMPercussion();
        
        virtual stk::StkFrames& next_buf(stk::StkFrames& frames);
        
        virtual void velocity(stk::StkFloat aVelocity);
        virtual void freq(stk::StkFloat aFreq);
        
        virtual void play();
        virtual void stop();
        
        /**
         *  Set the duration of the next note in seconds.
         **/
        void duration(stk::StkFloat aDuration);
        
        /**
         *  Set the direction of the next bend (should be -1.0 or 1.0)
         **/
        void bendDirection(stk::StkFloat aDirection);

    protected:
        /**
         *  Duration of next note in seconds.
         **/
        stk::StkFloat _duration;
        
        /**
         *  Direction of next bend
         **/
        stk::StkFloat _bendDirection;
        
    };
}

#endif

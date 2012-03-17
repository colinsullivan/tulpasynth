Envelope masterEnv => dac;

LPF masterFilt => masterEnv;
Envelope filtAutomatorEnv => blackhole;
masterFilt.gain(0.4);


SinOsc carrier => masterFilt;
carrier.sync(2);
SinOsc modulator => carrier;
modulator.gain(220);
modulator.freq(880);
carrier.gain(0.5);

SinOsc carrierTwo => masterFilt;
carrierTwo.sync(2);
modulator => carrierTwo;
// SinOsc modulatorTwo => carrierTwo;
// modulatorTwo.gain(110);
// modulatorTwo.freq(220);
carrierTwo.gain(0.5);

// Noise n => masterFilt;
// n.gain(0.5);
// noiseShaper.Q(0.9);
// noiseShaper.freq(1000);
// noiseShaper.gain(1.75);

masterFilt.Q(10);

masterEnv.duration(10::ms);

fun void filtAutomator() {
    880*5 => float maxFreq;
    880/2 => float minFreq;

    440 => float oscMaxFreq;
    oscMaxFreq/2.0 => float oscMinFreq;

    float oscFreq;

    while(true) {
        masterFilt.freq(maxFreq - (maxFreq-minFreq)*filtAutomatorEnv.value());
        oscMaxFreq - (oscMaxFreq-oscMinFreq)*(filtAutomatorEnv.value()) => oscFreq;
        carrier.freq(oscFreq);
        carrierTwo.freq(oscFreq+2.0);
        10::ms => now;
    }
}
spork ~ filtAutomator();

fun void fire() {
    0.25::second => dur fireDuration;
    filtAutomatorEnv.duration(fireDuration);
    filtAutomatorEnv.keyOn();
    masterEnv.keyOn();
    fireDuration => now;
    masterEnv.keyOff();
}

1::second => now;
fire();
1::second => now;


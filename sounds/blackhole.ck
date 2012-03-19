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

float _freq;
fun float freq(float aFreq) {
    aFreq => _freq;
    modulator.freq(_freq*2.0);
    carrier.freq(_freq);
    modulator.gain(_freq/2.0);
    return _freq;
}

fun void filtAutomator() {
    float maxFreq;
    float minFreq;

    float oscMaxFreq;
    float oscMinFreq;

    float oscFreq;

    while(true) {
        _freq*10.0 => maxFreq;
        _freq => minFreq;

        _freq => oscMaxFreq;
        _freq/2.0 => oscMinFreq;

        masterFilt.freq(maxFreq - (maxFreq-minFreq)*filtAutomatorEnv.value());
        oscMaxFreq - (oscMaxFreq-oscMinFreq)*(filtAutomatorEnv.value()) => oscFreq;
        carrier.freq(oscFreq);
        carrierTwo.freq(oscFreq+2.0);
        10::ms => now;
    }
}
// Shred @ filtAutomatorShred;
spork ~ filtAutomator();



fun void fire() {
    0.25::second => dur fireDuration;
    // spork ~ filtAutomator() @=> filtAutomatorShred;
    filtAutomatorEnv.duration(fireDuration);
    filtAutomatorEnv.keyOn();
    masterEnv.keyOn();
    fireDuration => now;
    masterEnv.keyOff();
    filtAutomatorEnv.keyOff();
    // filtAutomatorShred.exit();
}

1::second => now;
[0, 4, 5, 7, 10, 12, 14, 17] @=> int pitches[];
60 => int basePitch;

for(0 => int i; i < pitches.size(); i++) {
    freq(Std.mtof(basePitch + pitches[i]));
    fire();
    0.5::second => now;
}

1::second => now;


Envelope masterEnv => dac;

LPF masterFilt => masterEnv;
Envelope filtAutomatorEnv => blackhole;
masterFilt.gain(0.6);


SinOsc carrier => masterFilt;
carrier.sync(2);
SqrOsc modulator => carrier;
modulator.gain(0.8);
modulator.freq(2);
carrier.gain(0.7);

Noise n => masterFilt;
n.gain(0.5);
// noiseShaper.Q(0.9);
// noiseShaper.freq(1000);
// noiseShaper.gain(1.75);

masterFilt.Q(8);

masterEnv.duration(10::ms);

fun void filtAutomator() {
    880 => float maxFreq;
    55 => float minFreq;

    440 => float oscMaxFreq;
    55 => float oscMinFreq;


    while(true) {
        masterFilt.freq(maxFreq - (maxFreq-minFreq)*filtAutomatorEnv.value());
        carrier.freq(oscMaxFreq - (oscMaxFreq-oscMinFreq)*(filtAutomatorEnv.value()));
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
2::second => now;


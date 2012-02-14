
Step unity => Envelope env => CurveTable attackCurve => Gain vca;
1 => unity.next;
3 => vca.op;

SinOsc carrier => vca => Gain out => dac;

carrier.sync(2);

unity => Envelope modulatorEnv => CurveTable modulatorEnvCurve => Gain modulatorVca;
3 => modulatorVca.op;
SinOsc modulator => modulatorVca => carrier;

// p4
1.0 => float carrierGain;
// p5
0 => float carrierFreq;
// p6
2000 => float modulatorFreq;

0 => float modulatorGain;

fun void freq(float aFreq) {
    aFreq => carrierFreq;
    25 * carrierFreq => modulatorGain;
    // Math.pow(carrierFreq*400/modulatorFreq, 3) => modulatorGain;

    carrier.freq(carrierFreq);
    modulator.freq(modulatorFreq);
}
freq(440);


carrier.gain(carrierGain);
modulator.gain(modulatorGain);


// [0., 0.5, 1., 0.5, 0.] => curve.coefs;
[
    // initial attack
    0.0, 0.0, 2.5,
    0.01, 0.75, 2.5,
    // peak
    0.12, 0.9, -2.5,
    0.2, 1.0, 2.5,
    0.28, 0.9, -5,
    // exponential decay
    1.0, 0.0
] => attackCurve.coefs;

[
    // initial decay
    0.0, 1.0, -2.5,
    0.25, 0.0, 0,
    1.0, 0.0
] => modulatorEnvCurve.coefs;

out.gain(0.5);


env.duration(0.25::second);
env.target(0.999);

modulatorEnv.duration(0.05::second);
modulatorEnv.target(0.999);

fun void noteOn() {
    modulator.phase(0);
    modulatorEnv.value(0);
    env.value(0);
    env.keyOn();
    modulatorEnv.keyOn();
    0.15::second => now;
}

69 => int base;
base => int note;

1 => int direction;

// while(true) {
//     freq(Std.mtof(note));
//     noteOn();
//     direction*3 +=> note;

//     if(note > base+(3 * 8)) {
//         -1 => direction;
//     }
//     else if(note < base) {
//         1 => direction;
//     }
// }

// 1::second => now;


for(0 => float i; i < 1.0; 0.0001 +=> i) {
    <<< "", attackCurve.lookup(i) >>>;
}
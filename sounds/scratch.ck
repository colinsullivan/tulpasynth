
Step unity => Envelope env => CurveTable attackCurve => Gain vca;
1 => unity.next;
3 => vca.op;

SinOsc carrier => vca => Gain out => dac;


// [0., 0.5, 1., 0.5, 0.] => curve.coefs;
[
    // initial attack
    0.0, 0.75, 2.5,
    // peak
    0.12, 0.9, -2.5,
    0.2, 1.0, 2.5,
    0.28, 0.9, -5,
    // exponential decay
    1.0, 0.0
] => attackCurve.coefs;


out.gain(0.5);

carrier.freq(440);

env.duration(0.4::second);
env.target(0.999);
env.keyOn();

2::second => now;

3::second => now;


// for(0 => float i; i < 1.0; 0.01 +=> i) {
//     <<< i, ",", curve.lookup(i) >>>;
// }
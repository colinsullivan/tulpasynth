

// // Descending minor thirds starting on an A
// 69 => int current;
// 3 => int decrement;


// Descending major thirds starting on a high C
96 => int current;
4 => int decrement;

<<< "[", "" >>>;
for(0 => int i; i < 32; i++) {
    <<< "this->pitches["+i+"] = "+Std.mtof(current)+";", "" >>>;
    decrement -=> current;
}
<<< "]", "" >>>;

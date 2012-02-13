

// // Descending minor thirds starting on an A
// 69+12+12 => int current;
// 3 => int decrement;
// 0 => int startingIndex;

// // Descending minor thirds starting on a higher A
// 69+12+12+12 => int current;
// 3 => int decrement;
// 0 => int startingIndex;



// Descending major thirds starting on a high C
96 => int current;
4 => int decrement;
0 => int startingIndex;

for(startingIndex => int i; i < 32; i++) {
    <<< "this->pitches["+i+"] = "+Std.mtof(current)+";", "" >>>;
    decrement -=> current;
}


// Descending major thirds starting on a high C
// 96 => int current;
// <<< "[", "" >>>;
// for(0 => int i; i < 32; i++) {
//     if(i < 31) {
//         <<< Std.mtof(current), "," >>>;
//     }
//     else {
//         <<< Std.mtof(current), "" >>>;
//     }

//     4 -=> current;
// }
// <<< "]", "" >>>;

// Descending minor thirds starting on an A
69 => int current;
<<< "[", "" >>>;
for(0 => int i; i < 32; i++) {
    if(i < 31) {
        <<< Std.mtof(current), "," >>>;
    }
    else {
        <<< Std.mtof(current), "" >>>;
    }

    3 -=> current;
}
<<< "]", "" >>>;

;   7654 3210
;   |||| ||++- Color bits 3-2 for top left quadrant of this byte
;   |||| ++--- Color bits 3-2 for top right quadrant of this byte
;   ||++------ Color bits 3-2 for bottom left quadrant of this byte
;   ++-------- Color bits 3-2 for bottom right quadrant of this byte

attribs0:
    .db %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101
    .db %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101 ; TREES
    .db %01000101, %00010101, %00010101, %01000101, %00010101, %00010101, %01000101, %00010101

    .db %10101010, %10101010, %10101010, %01100110, %10011001, %10101010, %10101010, %10101010
    .db %10101010, %00101010, %10001010, %01100110, %10011001, %10101010, %10101010, %10101010
    .db %10101010, %10100010, %10101000, %01100110, %10011001, %10101010, %10101010, %10101010 ; GROUND ETC.
    .db %10101010, %00000000, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    
attribs1:
    .db %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101
    .db %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101 ; TREES
    .db %01000101, %00010101, %00010101, %01000101, %00010101, %00010101, %01000101, %00010101

    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    
attribs2:
    .db %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101
    .db %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101 ; TREES
    .db %01000101, %00010101, %00010101, %01000101, %00010101, %00010101, %01000101, %00010101

    .db %10101010, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %10101010
    .db %10101010, %10100000, %10100000, %10100000, %10100000, %10100000, %10100000, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    
attribs3:
    .db %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101
    .db %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101 ; TREES
    .db %01000101, %00010101, %00010101, %01000101, %00010101, %00010101, %01000101, %00010101

    .db %10101010, %00000000, %10101010, %10101010, %10101010, %10101010, %00000000, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %00000000, %10101010, %10101010, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    
attribs4:
    .db %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101
    .db %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101 ; TREES
    .db %01000101, %00010101, %00010101, %01000101, %00010101, %00010101, %01000101, %00010101

    .db %10101010, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %10101010
    .db %10101010, %10100000, %10100000, %10100000, %10100000, %10100000, %10100000, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    
attribs5:
    .db %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101
    .db %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101 ; TREES
    .db %01000101, %00010101, %00010101, %01000101, %00010101, %00010101, %01000101, %00010101

    .db %10101010, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %00000000, %10101010, %10101010, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    
attribs6:
    .db %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101
    .db %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101 ; TREES
    .db %01000101, %00010101, %00010101, %01000101, %00010101, %00010101, %01000101, %00010101

    .db %10101010, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    .db %10101010, %10101010, %00000000, %10101010, %10101010, %10101010, %10101010, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %00000000, %10101010, %10101010, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    
attribs7:
    .db %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101
    .db %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101 ; TREES
    .db %01000101, %00010101, %00010101, %01000101, %00010101, %00010101, %01000101, %00010101

    .db %10101010, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %00001010, %10101010, %10101010, %10101010
    .db %10101010, %00000000, %10101010, %10101010, %10100000, %10101010, %10101010, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    
attribs8:
    .db %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101
    .db %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101 ; TREES
    .db %01000101, %00010101, %00010101, %01000101, %00010101, %00010101, %01000101, %00010101

    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010

attribs9:
    .db %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101
    .db %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101 ; TREES
    .db %01000101, %00010101, %00010101, %01000101, %00010101, %00010101, %01000101, %00010101

    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    
attribsA:
    .db %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101
    .db %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101 ; TREES
    .db %01000101, %00010101, %00010101, %01000101, %00010101, %00010101, %01000101, %00010101

    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
    .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
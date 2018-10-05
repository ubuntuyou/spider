checkCollision:
left:
    lda leftIsPressed
    beq right

    ldx spriteV
    inx
    stx spriteY
    lda spriteH
    clc
    adc #$08
    sta spriteX
    jsr compareToBkg

    lda spriteV
    clc
    adc #$0F
    sta spriteY
    lda spriteH
;    clc
    adc #$07
    sta spriteX
    jmp compareToBkg

right:
    lda rightIsPressed
    beq up

    ldx spriteV
    inx
    stx spriteY
    lda spriteH
    clc
    adc #$18
    sta spriteX
    jsr compareToBkg

    lda spriteV
    clc
    adc #$0F
    sta spriteY
    lda spriteH
;    clc
    adc #$18
    sta spriteX
    jmp compareToBkg

up:
    lda upIsPressed
    beq down

    ldx spriteV
    inx
    stx spriteY
    lda spriteH
    clc
    adc #$08
    sta spriteX
    jsr compareToBkg

    ldx spriteV
    inx
    stx spriteY
    lda spriteH
    clc
    adc #$10
    sta spriteX
    jsr compareToBkg

    ldx spriteV
    inx
    stx spriteY
    lda spriteH
    clc
    adc #$18
    sta spriteX
    jsr compareToBkg

down:
    lda downIsPressed
    beq checkCollisionDone

    lda spriteV
    clc
    adc #$0F
    sta spriteY
    lda spriteH
;    clc
    adc #$07
    sta spriteX
    jsr compareToBkg

    lda spriteV
    clc
    adc #$0F
    sta spriteY
    lda spriteH
;    clc
    adc #$10
    sta spriteX
    jsr compareToBkg

    lda spriteV
    clc
    adc #$0F
    sta spriteY
    lda spriteH
;    clc
    adc #$18
    sta spriteX
    jmp compareToBkg
checkCollisionDone:
    rts

compareToBkg:
    jsr getBGtype
    bne cpLeft
    rts
cpLeft:
    lda leftIsPressed
    beq cpRight

    lda scroll
    and #$0F
    sta temp
    lda spriteH
    sec
    sbc #$0A
    clc
    adc temp
    and #$0F
    eor #$0F
;    clc
    adc spriteH
    sta spriteH
    
    lda #$00
    sta animationEnable

    rts
cpRight:
    lda rightIsPressed
    beq cpUp

    lda scroll
    and #$0F
    sta temp
    lda spriteH
    clc
    adc #$18
;    clc
    adc temp
    and #$0F
    eor #$FF
;    clc
    adc spriteH
    sta spriteH
    
    lda #$00
    sta animationEnable

    rts
cpUp:
    lda upIsPressed
    beq cpDown

    lda spriteV
    and #$0F
    eor #$0F
    clc
    adc spriteV
    sta spriteV

    lda #$00
    sta upIsPressed
    lda #$01
    sta downIsPressed
cpDown:
    ldx jumping
    dex
    beq abortJump
    lda downIsPressed
    beq compareToBkgDone

    lda spriteV
    clc
    adc #$0F
    and #$0F
    eor #$FF
;    clc
    adc spriteV
    sta spriteV
abortJump:
    lda #$00
    sta velocity
    sta jumping
    sta jumpVelocity
compareToBkgDone:
    rts

getBGtype:
    ldx scroll+1
    lda spriteX

    clc
    adc scroll
    bcs +
    dex
+   lsr A
    lsr A
    lsr A
    lsr A
    sta spriteXpos

    lda spriteY
    and #$F0
    clc
    adc spriteXpos
    tay

    lda backgroundsLo,x
    sta colPtr
    lda backgroundsHi,x
    sta colPtr+1

    lda (colPtr),y
    tax
    lda colAtb,x
getBGtypeDone:
    rts

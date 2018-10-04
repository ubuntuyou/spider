checkCollision:
left:
    lda leftIsPressed
    beq right

    lda spriteV
    clc
    adc #$01
    sta spriteY
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
    clc
    adc #$07
    sta spriteX
    jmp compareToBkg

right:
    lda rightIsPressed
    beq up

    lda spriteV
    clc
    adc #$01
    sta spriteY
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
    clc
    adc #$18
    sta spriteX
    jmp compareToBkg

up:
    lda upIsPressed
    beq down

    lda spriteV
    clc
    adc #$01
    sta spriteY
    lda spriteH
    clc
    adc #$08
    sta spriteX
    jsr compareToBkg

    lda spriteV
    clc
    adc #$01
    sta spriteY
    lda spriteH
    clc
    adc #$10
    sta spriteX
    jsr compareToBkg

    lda spriteV
    clc
    adc #$01
    sta spriteY
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
    clc
    adc #$07
    sta spriteX
    jsr compareToBkg

    lda spriteV
    clc
    adc #$0F
    sta spriteY
    lda spriteH
    clc
    adc #$10
    sta spriteX
    jsr compareToBkg

    lda spriteV
    clc
    adc #$0F
    sta spriteY
    lda spriteH
    clc
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
    tax
    sec
    sbc #$0A
    clc
    adc temp
    and #$0F
    eor #$0F
    sta temp
    txa
    clc
    adc temp
    sta spriteH
    
    lda #$00
    sta animationEnable

    rts
cpRight:
    lda rightIsPressed
    beq cpUp

    lda scroll
    and #$0F
    clc
    sta temp
    lda spriteH
    tax
    clc
    adc #$19
    clc
    adc temp
    and #$0F
    sta temp
    txa
    sec
    sbc temp
    sta spriteH
    
    lda #$00
    sta animationEnable

    rts
cpUp:
    lda upIsPressed
    beq cpDown

    lda spriteV
    tay
    and #$0F
    eor #$0F
    sta temp
    tya
    clc
    adc temp
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
    tay
    clc
    adc #$10
    and #$0F
    sta temp
    tya
    sec
    sbc temp
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
    stx bkgColPtr

    lda spriteY
    and #$F0
    clc
    adc spriteXpos
    sta spriteYpos

    ldx bkgColPtr
    lda backgroundsLo,x
    sta colPtr
    lda backgroundsHi,x
    sta colPtr+1

    ldy spriteYpos
    lda (colPtr),y
    tax
    lda colAtb,x
getBGtypeDone:
    rts

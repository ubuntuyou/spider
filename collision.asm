;updateColTbl:
;   lda scroll+1
;   cmp #$0B
;   beq updateColTblDone

;   lda scroll            ; Load scroll value and divide by 16
;   tay
;   eor oldScroll
;   and #%00010000
;   beq @cont     ; updateColTblDone  ; If carry is set then scroll is not divisible by 16 so skip update
;   lda #$00
;   sta needCol
;   rts
;@cont
;   tya
;   lsr A
;   lsr A
;   lsr A
;   lsr A
;   tay                   ; Else, carry is clear and scroll is divisible by 16 so update column

;    lda needCol
;    beq updateColTblDone

;   ldx scroll+1
;   lda backgroundsLo,x
;   sta bkgPtr
;   lda backgroundsHi,x
;   sta bkgPtr+1

;   lda #$00
;   sta colPtr
;   lda #$06
;   sta colPtr+1

;   ldx #$00              ; Initialize X
;@loop
;   lda (bkgPtr),y        ; Load a byte from the scroll+1 (Y contains column offset)
;   cmp #$C0
;   bcc @one              ; If greater than #$CB then branch to .one
;   lda #$00              ; Else, load #$00 (free movement tile)
;   beq @next             ; and branch to next
;@one
;   lda #$01              ; Load A with #$01 (solid tile)
;@next
;   sta (colPtr),y        ; and store in the corresponding spot in collision table
;   lda bkgPtr            ; Add 10 to bkgPtr to point to next byte in column
;   clc
;   adc #$10
;   sta bkgPtr
;   lda colPtr
;   clc
;   adc #$10
;   sta colPtr            ; Also update colPtr
;   inx
;   cpx #$10              ; Check if 16 columns have been updated
;   bne @loop             ; If not then repeat until it does
;   dec needCol
;updateColTblDone:
;   rts

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
    cmp #$C0
    bcc cpLeft
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
    sta BGtype
getBGtypeDone:
    rts

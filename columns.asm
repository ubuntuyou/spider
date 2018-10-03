columnBuff:
    lda scroll          ; Load scroll
    tay
    eor oldScroll
    and #%00010000
    beq @next           ; If carry is set then not divisible by 8
    lda #$00
    sta needUpdate      ; So clear needUpdate flag
    rts                 ; End
@next
    tya
    lsr A
    lsr A
    lsr A
    lsr A
    tay

    lda needUpdate      ; Check if needUpdate flag is set
    bne columnBuffDone  ; If not then skip

    ldx scroll+1
    lda backgroundsLo,x
    sta bkgPtr
    lda backgroundsHi,x
    sta bkgPtr+1

    ldx #$00            ; Initialize X
leftMetaColumn:
    lda (bkgPtr),y      ; Load first metatile, Y holds column offset
    sta columnBuffer,x  ; Store in buffer
    clc
    adc #$10            ; Add #$10 to A to get bottom left tile
    inx
    sta columnBuffer,x  ; and store in next buffer spot
    lda bkgPtr          ; Load bkgPtr
    clc
    adc #$10            ; Add #$10 for next scroll+1 metatile
    sta bkgPtr          ; Update bkgPtr
    inx
    cpx #$1E            ; Increment X and check if 30 tiles have been copied to buffer
    bne leftMetaColumn  ; If not then repeat until true

    ldx scroll+1
    lda backgroundsLo,x
    sta bkgPtr          ; Reset bkgPtr to process second half of meta column

    ldx #$20            ; Select third row of buffer
rightMetaColumn:
    lda (bkgPtr),y      ; Load first metatile, Y holds column offset
    clc
    adc #$01            ; Add 1 for top right tile in metatile
    sta columnBuffer,x  ; Store in buffer
    clc
    adc #$10            ; Add #$10 to get bottom right tile of metatile
    inx
    sta columnBuffer,x  ; and store in next buffer spot
    lda bkgPtr          ; Load bkfPtr
    clc
    adc #$10            ; Add #$10 for next scroll+1 metatile
    sta bkgPtr          ; Update bkgPtr
    inx
    cpx #$3E            ; Increment X and check if next 30 tiles have been copied to buffer
    bne rightMetaColumn ; If not then repeat until true

    lda nametable       ; Load nametable
    eor #$01            ; Flip the first bit
    asl A
    asl A
    clc                 ; Multiply by 4 to get either 0 or 4
    adc #$20            ; Add #$20 for either 20 or 24
    sta addrHi          ; and store in addrHi

    lda scroll          ; Load Scroll
    lsr A
    lsr A
    lsr A               ; Divide by 8 for nametable column offset
    sta addrLo          ; Store in addrLo

    lda #$1E
    sta columnCount     ; Store 30 in columnCount

    lda #$01
    sta needUpdate      ; Set needAtbBuff and need update flags
    sta needDraw        ; Increment needDraw flag
columnBuffDone:
    rts

updateColumn:
    lda needDraw          ; Check if needDraw flag set
    beq updateColumnDone  ; If not then skip
    
    lda softPPU_Control
    eor #%00000100
    sta PPU_Control     ; Set bit 2 of PPU_Control to increment PPU address by 32

    ldy #$02
    ldx #$00            ; Initialise X for first row of buffer
@outerLoop

    lda PPU_Status
    lda addrHi
    sta PPU_Address
    lda addrLo
    sta PPU_Address

@loop
    lda columnBuffer,x  ; Load first byte of column buffer
    sta PPU_Data        ; Store in $2007
    inx
    cpx columnCount     ; Increment X and check if equal to columnCount
    bne @loop           ; If not equal then repeat until true
    inc columnCount
    asl columnCount     ; Multiply columnCount by 2 for value of 60
    inc addrLo          ; Increment addrLo for next nametable column
    ldx #$20
    dey
    bne @outerLoop

    lda softPPU_Control
    sta PPU_Control     ; Clear bit 2 of PPU_Control to increment address by 1

    dec needDraw          ; Clear needDraw flag
updateColumnDone:
    rts
    
updateAttribs:
    lda scroll            ; Load scroll
    cmp #$04
    bne updateAttribsDone

    lda nametable       ; Load nametable
    eor #$01            ; Flip the first bit
    asl A
    asl A
    clc                 ; Multiply by 4 to get either 0 or 4
    adc #$23            ; Add #$20 for either 23 or 27
    sta colHi

    lda PPU_Status
    lda colHi
    sta PPU_Address
    lda #$C0
    sta PPU_Address

    ldx scroll+1
    lda attribsLo,x
    sta atbPtr
    lda attribsHi,x
    sta atbPtr+1

    ldy #$00
@loop
    lda (atbPtr),y      ; Load attribute byte
    sta PPU_Data
    iny
    cpy #$40
    bne @loop           ; If not #$00 then repeat until true
updateAttribsDone:
    rts

;updateAttribs:
;   lda needAtbBuff       ; Check if needAtbBuff flag is set, skip if not
;   beq setupAttribsDone


;    lda scroll            ; Load scroll
;    cmp #$04
;    tay
;    eor oldScroll
;    and #%00010000
;    bne setupAttribsDone  ; If carry set then not divisible by 32
;    tya                   ; Else transfer to Y
;    lsr A
;    lsr A
;    lsr A
;    lsr A
;    lsr A
;    tay

;    lda nametable       ; Load nametable
;   eor #$01            ; Flip the first bit
;   asl A
;    asl A
;    clc                 ; Multiply by 4 to get either 0 or 4
;   adc #$23            ; Add #$20 for either 23 or 27
;   sta colHi

;    lda PPU_Status
;   lda colHi
;   sta PPU_Address
;   lda #$C0
;   sta PPU_Address

;   ldx scroll+1
;   lda attribsLo,x
;   sta atbPtr
;   lda attribsHi,x
;   sta atbPtr+1

;    ldy #$00
;   ldx #$40            ; Load X with #$08 for loop counter
;@loop
;   lda (atbPtr),y      ; Load attribute byte
;   sta attribBuffer,y  ; Store in buffer
;   sta PPU_Data
;   tya                 ; Transfer Y to A
;   clc
;   adc #$08            ; Add #$08
;   tay
;    iny
;    cpy #$40                 ; Transfer back to Y
;   dex                 ; Decrement X
;   bne @loop           ; If not #$00 then repeat until true

;   dec needAtbBuff     ; Decrement needAtbBuff

;   lda #$01
;   sta needAttribs     ; Set needAttribs pointer to #$02
;updateAttribsDone:
;   rts

;updateAttribs:
;   lda needAttribs     ; Load needAttribs pointer
;   bmi updateAttribsDone
;   bne @skip           ; If not then branch to .skip

;   lda PPU_Status
;   lda colHi
;   sta PPU_Address
;   lda #$C0
;   sta PPU_Address

;   ldx #$00            ; Initialize X
;@loop
;   lda attribBuffer,x  ; Load byte from buffer
;   sta PPU_Data        ; Store in $2007
;   inx                 ; Increment X
;   cpx #$40            ; Compare to #$40
;   bne @loop           ; If not equal then loop until true
;@skip
;   dec needAttribs     ; Decrement needAttribs flag
;updateAttribsDone:
;   rts

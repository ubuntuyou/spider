; Use scroll+1 to index into a table of enemy header pointers.
; If no enemies are present then do nothing, otherwise spawn enemies.
; Each frame check if enemies are dead or alive. If dead check next enemy.
; If alive check enemy type and jump to subroutine for that type of enemy.
; Also check for collision with enemies in same fashion as we did for chests
;	in the dungeon crawler type game. If collision detected jump to damage/death subroutines.
; Need to know player direction, enemy type, collision status, maybe direction of collision, and camera location.
;
; Similar loading routines can be used for items/power-ups.

loadEnemies:
	ldx scroll+1
	lda levelEnemyTableLo,x
	sta levelEnemyPtr
	lda levelEnemyTableHi,x
	sta levelEnemyPtr+1
loadEnemiesDone:
	rts

levelEnemyTableLo:

levelEnemyTableHi:


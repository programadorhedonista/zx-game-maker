SUB FASTCALL BeepFX_Play(sound as ubyte)
  #ifdef ENABLED_128k
    ASM
      push af
    END ASM
    PaginarMemoria(3)
    ASM
      pop af
    END ASM
  #endif
  ASM
    push ix ; Guardamos ix
    ld [49153],a ; Cargamos el sonido a reproducir
    call 49152 ; Reproducimos el sonido
    pop ix ; Recuperamos ix
  END ASM
  #ifdef ENABLED_128k
    PaginarMemoria(0)
  #endif
END SUB

#ifdef NEW_BEEPER_PLAYER
  SUB FASTCALL BeepFX_NextNote()
    #ifdef ENABLED_128k
      PaginarMemoria(3)
    #endif
    ASM
      call 49169 ; Siguiente nota
    END ASM
    #ifdef ENABLED_128k
      PaginarMemoria(0)
    #endif
  END SUB
#endif
format PE console

entry Start

include 'Win32a.inc'

section '.data' data readable writable

        strA db 'Enter first number: ', 0
        strB db 'Enter second number: ', 0
        strOp db 'Enter Operation: ', 0
        resStr db 'Result %d', 0
        resMod db '/%d', 0
        spaceStr db ' %d', 0
        emptyStr db '%d', 0
        infinity db 'infinity', 0
        point db ',', 0
        strMistake db 'Wrong input of the operation!', 0

        A dd ?
        B dd ?
        C dd ?
        NULL = 0

section '.code' readable executable

        Start:
                push strA
                call [printf]

                push A
                push spaceStr
                call [scanf]

                push strB
                call [printf]

                push B
                push spaceStr
                call [scanf]

                push strOp
                call [printf]

                call [getch]

                cmp eax, 43         ; Sum
                jne notAdd ;проверка флага предыдущей строки: если флаг равен 0, т.е. не равны, то сразу прыгаем к notAdd
                    mov ecx, [A]
                    add ecx, [B]
                    push ecx
                    push resStr
                    call [printf]

                    jmp finish

                notAdd:
                cmp eax, 45      ;substration
                jne notSub
                    mov ecx, [A]
                    sub ecx, [B]

                    push ecx
                    push resStr
                    call [printf]
                    jmp finish

                notSub:
                cmp eax, 42      ;multiplication
                jne notMul
                    mov ecx, [A]
                    imul ecx, [B]

                    push ecx
                    push resStr
                    call [printf]
                    jmp finish

                notMul:
                cmp eax, 37      ;division
                jne notMod
                    mov eax, [A]
                    mov ecx, [B]
                    mov edx, 0
                    cmp [B], 0
                    jne notNullDiv       ;Если делим на 0
                        push infinity
                        call [printf]
                        jmp finish

                    notNullDiv:
                    div ecx
                    mov [C], edx

                    push eax
                    push resStr
                    call [printf]

                    push [C]
                    push spaceStr
                    call [printf]

                    push [B]
                    push resMod
                    call [printf]

                    jmp finish

                notMod:
                cmp eax, 47
                jne notDiv          ;Fractional Division
                    mov eax, [A]
                    mov ecx, [B]
                    mov edx, 0
                    cmp [B], 0
                    jne notNullDiv2
                        push infinity
                        call [printf]
                        jmp finish

                    notNullDiv2:
                    div ecx
                    mov [C], edx

                    push eax
                    push resStr
                    call [printf]

                    push point
                    call [printf]

                    mov ebx, 0
                    lp:
                        mov eax, [C]
                        mov ecx, [B]
                        imul eax, 10

                        mov edx, 0
                        div ecx
                        mov [C], edx

                        push eax
                        push emptyStr
                        call [printf]

                        add ebx, 1
                        cmp ebx, 5
                    jne lp

                    jmp finish

                notDiv:
                    push strMistake
                    call [printf]
                    jmp finish

                finish:
                call [getch]
                push NULL
                call [ExitProcess]


section 'idata' import data readable

        library kernel, 'kernel32.dll',\
               msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess'

        import msvcrt,\
               printf, 'printf',\
               scanf, 'scanf',\
               getch, '_getch'

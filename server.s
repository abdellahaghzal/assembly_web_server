.intel_syntax noprefix
.global _start

_start:
    open_socket:
        mov rdi, 0x2
        mov rsi, 0x1
        mov rdx, 0x0
        mov rax, 0x29
        syscall

    store_sock_fd:
        mov r15, rax

    bind_socket:
        mov rdi, r15
        set_sockaddr_in:
            mov rbp, rsp
            sub rsp, 16
            mov WORD PTR [rsp], 0x2
            mov WORD PTR [rsp + 2], 0x5000
            mov DWORD PTR [rsp + 4], 0x0
            mov QWORD PTR [rsp + 8], 0
        mov rsi, rsp
        mov rdx, 0x10
        mov rax, 0x31
        syscall

    listen:
        mov rdi, r15
        mov rsi, 0x0
        mov rax, 0x32
        syscall

    accept:
        mov rdi, r15
        mov rsi, 0x0
        mov rdx, 0x0
        mov rax, 0x2B
        syscall

    store_new_connection:
        mov r14, rax

    fork:
        mov rax, 0x39
        syscall
        cmp rax, 0
        je close_listiner
        cleenup:
            mov rdi, r14
            mov rax, 0x3
            syscall
        jmp accept

    close_listiner:
        mov rdi, r15
        mov rax, 0x3
        syscall

    read_req:
        mov rbp, rsp
        mov rdi, r14
        sub rsp, 2560
        mov rsi, rsp
        mov rdx, 2560
        mov rax, 0x0
        syscall

    store_req_size:
        mov r15, rax

    null_terminate_the_req:
        mov BYTE PTR [rsp + rax], 0x0

    identify_req:
        cmp BYTE PTR [rsp], 0x47
        je get_req
        cmp BYTE PTR [rsp], 0x50
        je post_req
        jmp exit

    get_req:
        get_open_file:
            lea rcx, [rsp + 3]
            get_loop:
                inc rcx
                cmp BYTE PTR [rcx], 0x20
                jne get_loop
            mov BYTE PTR [rcx], 0x0
            lea rdi, [rsp + 4]
            mov rsi, 0x0
            mov rax, 0x2
            syscall

        get_store_opened_file:
            mov r13, rax

        get_read_file_content:
            mov rdi, r13
            sub rsp, 256
            mov rsi, rsp
            mov rdx, 256
            mov rax, 0x0
            syscall

        get_store_read_ret:
            mov r12, rax

        get_close_file:
            mov rdi, r13
            mov rax, 0x3
            syscall

        get_respond:
            get_write_header:
                mov rdi, r14
                get_prep_response:
                    sub rsp, 19
                    mov DWORD PTR [rsp], 0x50545448
                    mov DWORD PTR [rsp + 4], 0x302E312F
                    mov DWORD PTR [rsp + 8], 0x30303220
                    mov DWORD PTR [rsp + 12], 0x0D4B4F20
                    mov WORD PTR [rsp + 16], 0x0D0A
                    mov BYTE PTR [rsp + 18], 0x0A
                mov rsi, rsp
                mov rdx, 0x13
                mov rax, 0x1
                syscall
            get_write_content:
                mov rdi, r14
                lea rsi, [rsp + 0x13]
                mov rdx, r12
                mov rax, 0x1
                syscall
        jmp exit

    post_req:
        post_open_file:
            lea rcx, [rsp + 4]
            post_loop:
                inc rcx
                cmp BYTE PTR [rcx], 0x20
                jne post_loop
            mov BYTE PTR [rcx], 0x0
            lea rdi, [rsp + 5]
            mov rsi, 0x41
            mov rdx, 0x1FF
            mov rax, 0x2
            syscall

        post_store_opened_file:
            mov r13, rax

        post_write_file_content:
            mov rdi, r13
            mov rcx, 0
            find_headers_end:
                inc rcx
                cmp DWORD PTR [rsp + rcx], 0x0A0D0A0D
                jne find_headers_end
            add rcx, 4
            lea rsi, [rsp + rcx]
            mov rdx, r15
            sub rdx, rcx
            mov rax, 0x1
            syscall

        post_close_file:
            mov rdi, r13
            mov rax, 0x3
            syscall

        post_respond:
            mov rdi, r14
            post_prep_response:
                sub rsp, 19
                mov DWORD PTR [rsp], 0x50545448
                mov DWORD PTR [rsp + 4], 0x302E312F
                mov DWORD PTR [rsp + 8], 0x30303220
                mov DWORD PTR [rsp + 12], 0x0D4B4F20
                mov WORD PTR [rsp + 16], 0x0D0A
                mov BYTE PTR [rsp + 18], 0x0A
            mov rsi, rsp
            mov rdx, 0x13
            mov rax, 0x1
            syscall

    exit:
        mov rdi, 0
        mov rax, 0x3C
        syscall

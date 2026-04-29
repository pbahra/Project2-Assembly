# double.s
# Pavan Bahra, CMSC313
# Reads a number from stdin, doubles it, prints "The double is: <result>"
# 32-bit GAS assembly for Linux x86
# Compile: gcc -nostdlib -no-pie double.s -o double
# Run: ./double then type a number

.section .data
    prompt:     .asciz "The double is: "   # output 
    prompt_len = . - prompt
    newline:    .byte 10                   
.section .bss
    .skip 32                               
input_buf:  .skip 32                       
out_buf:    .skip 32                       

.section .text
.globl _start

_start:
    #------------------------------------------
    # Step 1: Read number from stdin
    #------------------------------------------
    movl    $3, %eax            
    movl    $0, %ebx            
    leal    input_buf, %ecx     
    movl    $32, %edx           
    int     $0x80               

    #------------------------------------------
    # Step 2: Convert ASCII string -> integer
    #------------------------------------------
    leal    input_buf, %esi     
    xorl    %eax, %eax          
    xorl    %ebx, %ebx          

parse_loop:
    movzbl  (%esi), %ebx        
    cmpl    $'0', %ebx          
    jl      parse_done          
    cmpl    $'9', %ebx          
    jg      parse_done          
    subl    $'0', %ebx          # convertss ASCII digit -> integer
    imull   $10, %eax           
    addl    %ebx, %eax          
    incl    %esi                
    jmp     parse_loop

parse_done:

    #------------------------------------------
    # Step 3: Double the number
    #------------------------------------------
    sall    $1, %eax            

    #------------------------------------------
    # Step 4: Convert integer -> ASCII string
    #------------------------------------------
    leal    out_buf, %edi       
    movl    %edi, %esi          
    movl    $10, %ecx           
    xorl    %ebp, %ebp          

    # If result is 0
    testl   %eax, %eax
    jnz     int_to_str_loop
    movb    $'0', (%edi)        
    incl    %edi
    incl    %ebp
    jmp     reverse_done

int_to_str_loop:
    testl   %eax, %eax
    jz      reverse_str         
    xorl    %edx, %edx          
    divl    %ecx                
    addl    $'0', %edx          
    movb    %dl, (%edi)         
    incl    %edi
    incl    %ebp                
    jmp     int_to_str_loop

reverse_str:
    leal    -1(%edi), %edi      

reverse_loop:
    cmpl    %esi, %edi
    jle     reverse_done        # Stop when pointer meet
    movb    (%esi), %al         
    movb    (%edi), %bl
    movb    %bl, (%esi)
    movb    %al, (%edi)
    incl    %esi
    decl    %edi
    jmp     reverse_loop

reverse_done:

    #------------------------------------------
    # Step 5: Print "The double is: "
    #------------------------------------------
    movl    $4, %eax            
    movl    $1, %ebx            
    leal    prompt, %ecx        
    movl    $prompt_len, %edx   # length of prompt
    int     $0x80               

    #------------------------------------------
    # Step 6: Print the doubled number
    #------------------------------------------
    movl    $4, %eax            
    movl    $1, %ebx            
    leal    out_buf, %ecx       
    movl    %ebp, %edx          # number of digits
    int     $0x80               

    #------------------------------------------
    # Step 7: Print newline
    #------------------------------------------
    movl    $4, %eax
    movl    $1, %ebx
    leal    newline, %ecx
    movl    $1, %edx
    int     $0x80

    #------------------------------------------
    # Step 8: Exit cleanly
    #------------------------------------------
    movl    $1, %eax            
    xorl    %ebx, %ebx          
    int     $0x80               

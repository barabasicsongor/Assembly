# Bubble sort with elements stored on heap

        .data
        .align 2

input:  .asciiz "\nEnter array size>"
input2: .asciiz "\nEnter a number>"
cr:     .asciiz "\n"

        .text
        .globl main

main:
        li $v0, 4;              # Syscall code 4 to print string
        la $a0, input;          # Argument string as input
        syscall;
        li $v0, 5;              # Syscall code 5 to read int
        syscall;
        bltz $v0, EXIT;
        move $s1, $v0;          # Put N in s1
        mul $a0, $s1, 4;        # Amount of space in 4N bytes for heap (or N words)
        li $v0, 9;              # Syscall code 9 is sbrk allocate heap
        syscall;
        move $s0, $v0;          # Copy base address of heap region to s0
        li $s2, 0;              # i = 0 in s2

# Reading loop
LOOP:   sub $t0, $s2, $s1;      # i-N in t0
        bgez $t0, ELOOP         # exit loop
        li $v0, 4;              # Syscall code 4 to print string
        la $a0, input2;         # Argument string as input
        syscall;
        li $v0, 5;              # Syscall code 5 to read int
        syscall;
        li $t1, 4;              # Constant 4
        mul $t1, $s2, $t1;      # Compute array offset in t1
        add $t2, $s0, $t1;      # Add to base address
        sw $v0, ($t2);          # Store in heap
        addi $s2, $s2, 1;       # i++
        j LOOP

ELOOP: nop;

# Bubblesort
        addi $a0, $s1, 0;       # Put N in argument a0
        move $a1, $s0;          # Copy base address from s0 to argument a1
        jal bubblesort;         # Call bubblesort function
        move $s0, $v0;          # Copy base address of heap region to s0 from function return v0

# Print the array contents

        li $s2, 0;              # i=0 in s2

LOOP2:  sub $t0, $s2, $s1;      # i-N in t0
        bgez $t0, ELOOP2;       # exit loop
        li $t1, 4;              # Constant 4
        mul $t1, $s2, $t1;      # Compute array offset in t1
        add $t2, $s0, $t1;      # Add to base address
        lw $a0, ($t2);          # Load data into a0 for printing
        li $v0, 1;              # Syscall code 1 to print int
        syscall;
        li $v0, 4;              # Syscall code 4 to print string
        la $a0, cr;             # Argument string as input
        syscall;
        addi $s2, $s2, 1;       # i++
        j LOOP2;

ELOOP2: nop;

EXIT:   li $v0, 10;
        syscall;

bubblesort:
        move $v0, $a1;          # Copy base address of heap to return argument v0
        addi $a0, $a0, 1;      # N-- for the limit

LOOP3:  li $t0, 0;              # swapped = 0
        li $t1, 1;              # i=1
        addi $a0, $a0, -1;      # N-- for the limit

LOOP4:  sub $t2, $t1, $a0;      # i-N in t2
        bgez $t2, ELOOP4;
        addi $t2, $t1, -1;      # i-1 in t2
        li $t3, 4;              # Constant 4
        mul $t4, $t1, $t3;      # Compute array offset of i in t4
        mul $t5, $t2, $t3;      # Compute array offset of i-1 in t5
        add $t6, $a1, $t4;      # Add to base address for i
        add $t7, $a1, $t5;      # Add to base address for i-1
        lw $t4, ($t6);          # Load value from i in t4
        lw $t5, ($t7);          # Load value from i-1 in t5
        sub $t3, $t5, $t4;      # pos i-1 - pos i value
        bgtz $t3, SWAP;         # values need to be swapped
        j CONTINUE;             # No swap needed, continue
SWAP:   sw $t4, ($t7);          # Store val i in pos i-1
        sw $t5, ($t6);          # Store val i-1 in pos i
        li $t0, 1;              # swapped = 1

CONTINUE:
        addi $t1, $t1, 1;       # i++
        j LOOP4;

ELOOP4: bgtz $t0, LOOP3;        # swapped > 0, do it again

ELOOP3: move $v0, $a1;          # Copy base address into return param
        jr $ra;                 # Jump back to main program
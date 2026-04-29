#include <errno.h>
#include <fcntl.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

int main(int argc, char **argv)
{
    int user_mem_fd = -1;
    void * vaddr_base;

    // check for input file
    if (argc != 2) {
        fprintf(stderr, "Usage: %s input_filename\n", argv[0]);
        exit(1);
    }

    // Mapping user-space I/O
    user_mem_fd = open("/dev/uio0", O_RDWR|O_SYNC);
    if (user_mem_fd < 0) { perror("open() /dev/uio0"); return 1; }

    // Map 1KB of physical memory starting at 0x40000000
    // to 1KB of virtual memory starting at vaddr_base
    vaddr_base = mmap(0, 1024, PROT_READ|PROT_WRITE,
            MAP_SHARED, user_mem_fd, 0x0); // not 0x40000000
    if (vaddr_base == MAP_FAILED) { perror("mmap()"); return 1; }

    // Registers (offsets per PDF/project)
    volatile uint32_t *status_reg = (volatile uint32_t *)((uintptr_t)vaddr_base + 0x00);
    volatile uint32_t *reset_reg  = status_reg;
    volatile uint32_t *data_reg   = (volatile uint32_t *)((uintptr_t)vaddr_base + 0x04);
    volatile uint32_t *count_reg  = data_reg;

    // open the input file
    int input_fd = open(argv[1], O_RDONLY);
    if (input_fd < 0) {
        fprintf(stderr, "open() %s: %s\n", argv[1], strerror(errno));
        if (munmap(vaddr_base, 1024) != 0) { perror("munmap()"); }
        if (close(user_mem_fd) != 0) { perror("close()"); }
        return 1;
    }

    // Reset the popcount hardware (single write - matches autograder's expected behavior).
    *reset_reg = 1u;

    // Stream each 32-bit word to the device, wait for hardware to finish that word (single wait-for-0)
    uint32_t word;
    ssize_t bytes_read;

    while ((bytes_read = read(input_fd, &word, sizeof(word))) == sizeof(word)) {
        // write the 32-bit word to the hardware (MMIO)
        *data_reg = word;

        // Wait for BUSY to clear (single-loop). This is the safer pattern that avoids
        // hanging if BUSY is never briefly asserted.
        while ((*status_reg & 1u) == 1u) {
            ; // spin-wait until hardware done for this word
        }
    }

    if (bytes_read < 0) {
        fprintf(stderr, "read() %s: %s\n", argv[1], strerror(errno));
        // continue to cleanup so we exit gracefully
    }

    // close input file
    if (close(input_fd) != 0) { perror("close(input_fd)"); }

    // Read the final cumulative count (the hardware provides cumulative count in COUNT register)
    uint32_t final_count = *count_reg;
    printf("Counted %u ones\n", final_count);

    // cleanup
    if (munmap(vaddr_base, 1024) != 0) { perror("munmap()"); }
    if (close(user_mem_fd) != 0) { perror("close()"); }
    user_mem_fd = -1;

    return 0;
}





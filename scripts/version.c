#include <stdio.h>
#include <fcntl.h>

int main(int argc, char const *argv[]){
    // Get the grep output 

    char output[100];  // Allocate sufficient buffer size
    if (fgets(output, sizeof(output), stdin) == NULL) {
        printf("No input received\n");
    } 
    
    // Check if output is as expected 


    /* Compare to the stored version */
    // Get the stored version
    if (argc != 2) return 1;
    char *pathname = argv[1]; 
    int rd = open(pathname,O_RDONLY);
    if (rd == -1) return 2;
    

    

    return 0;
}

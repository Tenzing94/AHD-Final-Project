#include <stdio.h>
#include <string.h>

// function to convert decimal to binary 
int decToBinary(unsigned int n, char inp ) 
{ 
    // array to store binary number 
    unsigned int binaryNum[1000] = {0}; 
  
    // counter for binary array 
    int i = 0; 
    while (i<32) { 
  
        // storing remainder in binary array 
        binaryNum[i] = n % 2; 
        n = n / 2; 
        i++; 
    } 
  
  	if(inp == 'b')
  	{
	    // printing binary array in reverse order 
	    for (int j = 17; j >= 2; j--) 
	        printf("%d",binaryNum[j]); 
	        
	    printf("\n\n");
	}
	else if(inp =='j')
	{
		// printing binary array in reverse order 
	    for (int j = 27; j >= 2; j--) 
	        printf("%d",binaryNum[j]); 
	        
	    printf("\n\n");
	}
    
    return 0;
} 

int main()
{
	unsigned int pc,address,imm,currentLine, targetLine;
	
	char inp;

	do
	{
		printf("Input branch(b), jump(j) or quit(q) : ");
		scanf("%c",&inp);
		
		if(inp == 'b')
		{
			printf("\nInput current line : ");
			scanf("%d",&currentLine);
			pc = (currentLine - 1) * 4;
			printf("\nInput target line : ");
			scanf("%d",&targetLine);
			address = (targetLine - 1)*4;
							
			imm = address - pc - 4;
			printf("Current pc = %d\t Target pc = %d",pc,address);
		}
		else if(inp == 'j')
		{
			printf("\nInput target line : ");
			scanf("%d",&targetLine);
			imm = (targetLine - 1)*4;
		}
		
		printf("\n%d\n",imm);
		printf("VALUE TO USE : ");
		decToBinary(imm,inp);
		
	}while(inp != 'q');
	
	return 0;
}

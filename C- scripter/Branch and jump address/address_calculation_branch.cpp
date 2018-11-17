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
	unsigned int pc,address,imm;
	
	char inp;

	do
	{
		printf("Input branch(b), jump(j) or quit(q) : ");
		scanf("%c",&inp);
		
		if(inp == 'b')
		{
			printf("\nInput current pc : ");
			scanf("%d",&pc);
			printf("\nInput target pc : ");
			scanf("%d",&address);
							
			imm = address - pc - 4;
			printf("\n%d\n",imm);
//			printf("Displays only 28 bits append 4 MSB by sign extend");
		}
		else if(inp == 'j')
		{
			printf("\nInput target pc : ");
			scanf("%d",&imm);
		}
		
		printf("VALUE TO USE : ");
		decToBinary(imm,inp);
		
	}while(inp != 'q');
	
	return 0;
}

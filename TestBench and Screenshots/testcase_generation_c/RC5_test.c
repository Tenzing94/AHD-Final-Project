#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "RC5.h"

// function to convert decimal to binary 
int decToBinary(unsigned int n, unsigned int binaryNumOut[1000] ) 
{ 
    // array to store binary number 
    unsigned int binaryNum[1000] = {0}; 
  
    // counter for binary array 
    int i = 0; 
    while (i<32) { 
  
        // storing remainder in binary array 
        binaryNum[i] = n % 2; 
        binaryNumOut[i] = binaryNum[i];
        n = n / 2; 
        i++; 
    }     
    return 0;
} 


int main(){
 	unsigned char key[16];
  	unsigned char val1[100];
  	unsigned char val2[100];
  	unsigned int ct_ret[2] = {0,0};
 	int i,j;
 	
 	unsigned int msb_bin[1000], lsb_bin[1000], msb, lsb;
 	
 	unsigned int msb_enc_bin[1000], lsb_enc_bin[1000], msb_enc, lsb_enc;
 	
  	FILE *fp_out_enc, *fp_input_enc, *fp_input_key, *output_enc_hex ;
  	fp_out_enc = fopen("enc_output.txt", "w");
	fp_input_enc = fopen("enc_input.txt", "w");
	fp_input_key = fopen("key_input.txt", "w");
	output_enc_hex = fopen("output.txt", "w");
	
	char *key1 = "00000000000000000000000000";
	char *key_in = "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
   	strcpy(val1, "00000000");
    strcpy(val2, "00000000");
	
	for(i=0;i<160;i++)
	{
		RC5(key1, val1, val2, ct_ret);
	
		printf("%s%s\n ",val1,val2);
	
		// Loop to convert to binary
		
		msb = (int)strtoul(val1, NULL, 16);
		lsb = (int)strtoul(val2, NULL, 16);
		
		decToBinary(msb,msb_bin);
		decToBinary(lsb,lsb_bin);

	    for (j = 31; j >= 0; j--) 
			fprintf(fp_input_enc,"%d",msb_bin[j]); 
	    
		for (j = 31; j >= 0; j--) 
			fprintf(fp_input_enc,"%d",lsb_bin[j]); 
			   
		fprintf(fp_input_enc,"\n"); 
		
		
		// Print skey input in file
		fprintf(fp_input_key,"%s\n",key_in); 
		
		// Print for encrypt output
		
		msb_enc = ct_ret[0];
		lsb_enc = ct_ret[1];
		
		decToBinary(msb_enc,msb_enc_bin);
		decToBinary(lsb_enc,lsb_enc_bin);

	    for (j = 31; j >= 0; j--) 
			fprintf(fp_out_enc,"%d",msb_enc_bin[j]); 
	    
		for (j = 31; j >= 0; j--) 
			fprintf(fp_out_enc,"%d",lsb_enc_bin[j]); 
			   
		fprintf(fp_out_enc,"\n"); 
		
		
		//Print in output enc in hex
		fprintf(output_enc_hex,"%.8lX%.8lX\n",ct_ret[0],ct_ret[1]);
		
		if(i < 72)
		{
			val1[i%8] += 1;
		}
		else if(i < 144)
		{
			val2[i%8] += 1;
		}
		else if(i<150)
		{
			val1[i%8] = 'f';
		}
		else if(i < 158)
		{
			val2[i%8] = 'f';
		}
		else
		{
			strcpy(val1, "ffffffff");
    		strcpy(val2, "ffffffff");
		}

	}

	fclose(output_enc_hex);
	fclose(fp_input_key);
	fclose(fp_input_enc);
	fclose(fp_out_enc);
	return 0;
}

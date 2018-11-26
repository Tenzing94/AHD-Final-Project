#include <stdio.h>
#include <string.h>

int getOpcode( char command[5], char* opcode )
{
	char rtype[6] = "000000";
	char addi[6] = "000001";
	char subi[6] = "000010";
	char andi[6] = "000011";
	char ori[6] = "000100";
	char shl[6] = "000101";
	char lw[6] = "000111";
	char sw[6] = "001000";
	char blt[6] = "001001";
	char beq[6] = "001010";
	char bne[6] = "001011";
	char jmp[6] = "001100";
	char hal[6] = "111111";
	
	if (strcmp(command,"add") == 0)
	{
		strcpy(opcode, rtype);
	}
	else if (strcmp(command,"sub") == 0)
	{
		strcpy(opcode, rtype);
	}
	else if (strcmp(command,"and") == 0)
	{
		strcpy(opcode, rtype);
	}
	else if (strcmp(command,"or") == 0)
	{
		strcpy(opcode, rtype);
	}
	else if (strcmp(command,"nor") == 0)
	{
		strcpy(opcode, rtype);
	}
	else if (strcmp(command,"addi") == 0)
	{
		strcpy(opcode, addi);
	}
	else if (strcmp(command,"subi") == 0)
	{
		strcpy(opcode, subi);
	}
	else if (strcmp(command,"andi") == 0)
	{
		strcpy(opcode, andi);
	}
	else if (strcmp(command,"ori") == 0)
	{
		strcpy(opcode, ori);
	}
	else if (strcmp(command,"shl") == 0)
	{
		strcpy(opcode, shl);
	}
	else if (strcmp(command,"lw") == 0)
	{
		strcpy(opcode, lw);
	}
	else if (strcmp(command,"sw") == 0)
	{
		strcpy(opcode, sw);
	}
	else if (strcmp(command,"blt") == 0)
	{
		strcpy(opcode, blt);
	}
	else if (strcmp(command,"beq") == 0)
	{
		strcpy(opcode, beq);
	}
	else if (strcmp(command,"bne") == 0)
	{
		strcpy(opcode, bne);
	}
	else if (strcmp(command,"jmp") == 0)
	{
		strcpy(opcode, jmp);
	}
	else if (strcmp(command,"hal") == 0)
	{
		strcpy(opcode, hal);
	}

	return 0;
}

int getFunct( char command[4], char* opcode )
{
	char add[6] = "000001";
	char sub[6] = "000011";
	char and1[6] = "000101";
	char or1[6] = "000111";
	char nor[6] = "001001";
	
	if (strcmp(command,"add") == 0)
	{
		strcpy(opcode, add);
		
	}
	else if (strcmp(command,"sub") == 0)
	{
		strcpy(opcode, sub);
		
	}
	else if (strcmp(command,"and") == 0)
	{
		strcpy(opcode, and1);
		
	}
	else if (strcmp(command,"or") == 0)
	{
		strcpy(opcode, or1);
		
	}
	else if (strcmp(command,"nor") == 0)
	{
		strcpy(opcode, nor);
		
	}
	
	
	return 0;
}

int getRegister(char reg[6], char* opcode)
{
	char r0[6] = "00000\0";
	char r1[6] = "00001\0";
	char r2[6] = "00010\0";
	char r3[6] = "00011\0";
	char r4[6] = "00100\0";
	char r5[6] = "00101\0";
	char r6[6] = "00110\0";
	char r7[6] = "00111\0";
	char r8[6] = "01000\0";
	char r9[6] = "01001\0";
	char r10[6] = "01010\0";
	char r11[6] = "01011\0";
	char r12[6] = "01100\0";
	char r13[6] = "01101\0";
	char r14[6] = "01110\0";
	char r15[6] = "01111\0";
	char r16[6] = "10000\0";
	char r17[6] = "10001\0";
	char r18[6] = "10010\0";
	char r19[6] = "10011\0";
	char r20[6] = "10100\0";
	char r21[6] = "10101\0";
	char r22[6] = "10110\0";
	char r23[6] = "10111\0";
	char r24[6] = "11000\0";
	char r25[6] = "11001\0";
	char r26[6] = "11010\0";
	char r27[6] = "11011\0";
	char r28[6] = "11100\0";
	char r29[6] = "11101\0";
	char r30[6] = "11110\0";
	char r31[6] = "11111\0";
	
	if (strcmp(reg,"r0") == 0)
	{
		
		strcpy(opcode, r0);		
	}
	else if (strcmp(reg,"r1") == 0)
	{
		
		strcpy(opcode, r1);		
		
	}
	else if(strcmp(reg,"r2") == 0)
	{
		strcpy(opcode, r2);	
	}
	else if(strcmp(reg,"r3") == 0)
	{
		strcpy(opcode, r3);	
	}
	else if(strcmp(reg,"r4") == 0)
	{
		strcpy(opcode, r4);	
	}
	else if(strcmp(reg,"r5") == 0)
	{
		strcpy(opcode, r5);	
	}
	else if(strcmp(reg,"r6") == 0)
	{
		strcpy(opcode, r6);	
	}
	else if(strcmp(reg,"r7") == 0)
	{
		strcpy(opcode, r7);	
	}
	else if(strcmp(reg,"r8") == 0)
	{
		strcpy(opcode, r8);	
	}
	else if(strcmp(reg,"r9") == 0)
	{
		strcpy(opcode, r9);	
	}
	else if(strcmp(reg,"r10") == 0)
	{
		strcpy(opcode, r10);	
	}
	else if(strcmp(reg,"r11") == 0)
	{
		strcpy(opcode, r11);	
	}
	else if(strcmp(reg,"r12") == 0)
	{
		strcpy(opcode, r12);	
	}
	else if(strcmp(reg,"r13") == 0)
	{
		strcpy(opcode, r13);	
	}
	else if(strcmp(reg,"r14") == 0)
	{
		strcpy(opcode, r14);	
	}
	else if(strcmp(reg,"r15") == 0)
	{
		strcpy(opcode, r15);	
	}
	else if(strcmp(reg,"r16") == 0)
	{
		strcpy(opcode, r16);	
	}
	else if(strcmp(reg,"r17") == 0)
	{
		strcpy(opcode, r17);	
	}
	else if(strcmp(reg,"r18") == 0)
	{
		strcpy(opcode, r18);	
	}
	else if(strcmp(reg,"r19") == 0)
	{
		strcpy(opcode, r19);	
	}
	else if(strcmp(reg,"r20") == 0)
	{
		strcpy(opcode, r20);	
	}
	else if(strcmp(reg,"r21") == 0)
	{
		strcpy(opcode, r21);	
	}
	else if(strcmp(reg,"r22") == 0)
	{
		strcpy(opcode, r22);	
	}
	else if(strcmp(reg,"r23") == 0)
	{
		strcpy(opcode, r23);	
	}
	else if(strcmp(reg,"r24") == 0)
	{
		strcpy(opcode, r24);	
	}
	else if(strcmp(reg,"r25") == 0)
	{
		strcpy(opcode, r25);	
	}
	else if(strcmp(reg,"r26") == 0)
	{
		strcpy(opcode, r26);	
	}
	else if(strcmp(reg,"r27") == 0)
	{
		strcpy(opcode, r27);	
	}
	else if(strcmp(reg,"r28") == 0)
	{
		strcpy(opcode, r28);	
	}
	else if(strcmp(reg,"r29") == 0)
	{
		strcpy(opcode, r29);	
	}
	else if(strcmp(reg,"r30") == 0)
	{
		strcpy(opcode, r30);	
	}
	else if(strcmp(reg,"r31") == 0)
	{
		strcpy(opcode, r31);	
	}

	
	return 0;
}

int main()
{
	FILE* fp, *fp1;
	int i;
	char buff[255];
	fp = fopen("assemb.txt", "r");
	fp1 = fopen("opcode.txt", "w");
	
	
	while ( ( fgets(buff, 255, (FILE*)fp)) != '\0' )
	{
		
		char command[5], reg1[6], reg2[6], reg3[6],immediate[17];
		
		i = 0;
		int regStart = 0;
		
		while(buff[i] != ' ' && buff[i] != '\n')
		{
			command[i] = buff[i];
			i++;
		}
		
		command[i] = '\0';
		regStart = i+1;
		i=0;
		
		printf("Command - %s\n", command);
		
		char opcode[6];
		char functOp[6];
		char reg1Op[5];
		char reg2Op[5];
		char reg3Op[5];
		char shamt1[3]="000";	
		char shamt2[2]="00";
		
		char first8[9],second8[9],thirsd8[9],fourth8[9];
//		int regStart = 4,regStart1 = 7,regStart2 = 10;
		
		//Get OpCode first 6 bits
		getOpcode(command, opcode);
		
		printf("\nOpcode : %s\n", opcode);
		
		//R-Type
		if(strcmp(opcode,"000000") == 0)
		{	
			while(buff[regStart] != ',')
			{
				reg1[i] = buff[regStart];
				regStart++;
				i++;
			}
			reg1[i] = '\0';
			regStart += 1;
			i=0;
	
			while(buff[regStart] != ',')
			{
				reg2[i] = buff[regStart];
				regStart++;
				i++;
			}
			reg2[i] = '\0';
			regStart += 1;
			i=0;
			
			while(buff[regStart] != '\n')
			{
				reg3[i] = buff[regStart];
				regStart++;
				i++;
			}
			reg3[i] = '\0';
			regStart += 1;
			i=0;
	
			getFunct(command, functOp);
			printf("funct - %s\n", functOp);
			
			getRegister(reg1, reg1Op);
			printf("reg 1 - %s\n", reg1Op);
			
			getRegister(reg2, reg2Op);
			printf("reg 2- %s\n", reg2Op);
			
			getRegister(reg3, reg3Op);
			printf("reg 3 - %s\n", reg3Op);
			
			printf("%s - %s %s %s %s\n",buff,command,reg1,reg2,reg3);
			
			for(i=0;i<6;i++)
			{
				first8[i] = opcode[i];
			}
			first8[6] = reg1Op[0];
			first8[7] = reg1Op[1];
			first8[8] = '\0';
					
			second8[0] = reg1Op[2];
			second8[1] = reg1Op[3];
			second8[2] = reg1Op[4];
			
			for(i=3;i<8;i++)
			{
				second8[i] = reg2Op[i-3];
			}
			
			second8[8] = '\0';
			
			for(i=0;i<5;i++)
			{
				thirsd8[i] = reg3Op[i];
			}
			
			for(i=5;i<8;i++)
			{
				thirsd8[i] = shamt1[i-5];
			}
			
			thirsd8[8] = '\0';
			
			
			fourth8[0] = '0';
			fourth8[1] = '0';
			
			for(i=2;i<8;i++)
			{
				fourth8[i] = functOp[i-2];
			}
			
			fourth8[8] = '\0';
			
			fprintf(fp1,"\"%s\",\"%s\",\"%s\",\"%s\",\n",first8,second8,thirsd8,fourth8);		
		}
		else if( !(strcmp(opcode,"001100") == 0) && !(strcmp(opcode,"111111") == 0))		//J-Type
		{
			while(buff[regStart] != ',')
			{
				reg1[i] = buff[regStart];
				regStart++;
				i++;
			}
			reg1[i] = '\0';
			regStart += 1;
			i=0;
	
			while(buff[regStart] != ',')
			{
				reg2[i] = buff[regStart];
				regStart++;
				i++;
			}
			reg2[i] = '\0';
			regStart += 1;
			i=0;
			
			while(buff[regStart] != '\n')
			{
				immediate[i] = buff[regStart];	
				regStart++;
				i++;
			}
			
			immediate[16] = '\0';
			
			
			getRegister(reg1, reg1Op);
			printf("reg 1 - %s\n", reg1Op);
			
			getRegister(reg2, reg2Op);
			printf("reg 2- %s\n", reg2Op);
			
			printf("immediate - %s\n", immediate);
			
			printf("%s - %s %s %s %s\n",buff,command,reg1,reg2,immediate);
			
			for(i=0;i<6;i++)
			{
				first8[i] = opcode[i];
			}
			first8[6] = reg1Op[0];
			first8[7] = reg1Op[1];
			first8[8] = '\0';
					
			second8[0] = reg1Op[2];
			second8[1] = reg1Op[3];
			second8[2] = reg1Op[4];
			
			for(i=3;i<8;i++)
			{
				second8[i] = reg2Op[i-3];
			}
			
			second8[8] = '\0';
			
			for(i=0;i<8;i++)
			{
				thirsd8[i] = immediate[i];
			}	
			
			thirsd8[8] = '\0';
			
			for(i=0;i<8;i++)
			{
				fourth8[i] = immediate[i+8];
			}	
			
			fourth8[8] = '\0';
			
			fprintf(fp1,"\"%s\",\"%s\",\"%s\",\"%s\",\n",first8,second8,thirsd8,fourth8);		
			
		}
		else if( (strcmp(opcode,"001100") == 0) || (strcmp(opcode,"111111") == 0))
		{
			char targetAdd[27];
			
			if((strcmp(opcode,"001100") == 0))			//Jump
			{
				for(i=0;i<26;i++)
				{
					targetAdd[i] = buff[i+4];
				}	
				
				targetAdd[26] = '\0';
				
				for(i=0;i<6;i++)
				{
					first8[i] = opcode[i];
				}
				first8[6] = targetAdd[0];
				first8[7] = targetAdd[1];
				first8[8] = '\0';
				
				for(i=0;i<8;i++)
				{
					second8[i] = targetAdd[i+2];
				}
				
				second8[8] = '\0';
				
				for(i=0;i<8;i++)
				{
					thirsd8[i] = targetAdd[i+10];
				}	
				
				thirsd8[8] = '\0';
				
				for(i=0;i<8;i++)
				{
					fourth8[i] = targetAdd[i+18];
				}	
				
				fourth8[8] = '\0';
				
				
			}
			else										//halt
			{
				for(i=0;i<26;i++)
				{
					targetAdd[i] = '0';
				}	
				
				targetAdd[26] = '\0';	
				
				//
				
				for(i=0;i<6;i++)
				{
					first8[i] = opcode[i];
				}
				first8[6] = '0';
				first8[7] = '0';
				first8[8] = '\0';
				
				for(i=0;i<8;i++)
				{
					second8[i] = '0';
				}
				
				second8[8] = '\0';
				
				for(i=0;i<8;i++)
				{
					thirsd8[i] = '0';
				}	
				
				thirsd8[8] = '\0';
				
				for(i=0;i<8;i++)
				{
					fourth8[i] = '0';
				}	
				
				fourth8[8] = '\0';
			}
			
			printf("target - %s\n", targetAdd);
			
			fprintf(fp1,"\"%s\",\"%s\",\"%s\",\"%s\",\n",first8,second8,thirsd8,fourth8);	
			
		}
		
		printf("----------------------------------\n");
			
	}
		
	fclose(fp);
	fclose(fp1);
	return 0;
}

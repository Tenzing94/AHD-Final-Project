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
	
	
	printf("Command - %s\n", command);
	
	if (strcmp(command,"add ") == 0)
	{
		strcpy(opcode, rtype);
	}
	else if (strcmp(command,"sub ") == 0)
	{
		strcpy(opcode, rtype);
	}
	else if (strcmp(command,"and ") == 0)
	{
		strcpy(opcode, rtype);
	}
	else if (strcmp(command,"or1 ") == 0)
	{
		strcpy(opcode, rtype);
	}
	else if (strcmp(command,"nor ") == 0)
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
	else if (strcmp(command,"ori ") == 0)
	{
		strcpy(opcode, ori);
	}
	else if (strcmp(command,"shl ") == 0)
	{
		strcpy(opcode, shl);
	}
	else if (strcmp(command,"lw1 ") == 0)
	{
		strcpy(opcode, lw);
	}
	else if (strcmp(command,"sw1 ") == 0)
	{
		strcpy(opcode, sw);
	}
	else if (strcmp(command,"blt ") == 0)
	{
		strcpy(opcode, blt);
	}
	else if (strcmp(command,"beq ") == 0)
	{
		strcpy(opcode, beq);
	}
	else if (strcmp(command,"bne ") == 0)
	{
		strcpy(opcode, bne);
	}
	else if (strcmp(command,"jmp ") == 0)
	{
		strcpy(opcode, jmp);
	}
	else if (strcmp(command,"hal ") == 0)
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
	
	if (strcmp(command,"add ") == 0)
	{
		strcpy(opcode, add);
		
	}
	else if (strcmp(command,"sub ") == 0)
	{
		strcpy(opcode, sub);
		
	}
	else if (strcmp(command,"and ") == 0)
	{
		strcpy(opcode, and1);
		
	}
	else if (strcmp(command,"or1 ") == 0)
	{
		strcpy(opcode, or1);
		
	}
	else if (strcmp(command,"nor ") == 0)
	{
		strcpy(opcode, nor);
		
	}
	
	
	return 0;
}

int getRegister(char reg[3], char* opcode)
{
	char r0[5] = "00000";
	char r1[6] = "00001\0";
	char r2[5] = "00010";
	char r3[5] = "00011";
	char r4[5] = "00100";
	char r5[5] = "00101";
	char r6[5] = "00110";
	char r7[5] = "00111";
	char r8[5] = "01000";
	char r9[5] = "01001";
	char r10[5] = "01010";
	char r11[5] = "01011";
	char r12[5] = "01100";
	char r13[5] = "01101";
	char r14[5] = "01110";
	char r15[5] = "01111";
	char r16[5] = "10000";
	char r17[5] = "10001";
	char r18[5] = "10010";
	char r19[5] = "10011";
	char r20[5] = "10100";
	char r21[5] = "10101";
	char r22[5] = "10110";
	char r23[5] = "10111";
	char r24[5] = "11000";
	char r25[5] = "11001";
	char r26[5] = "11010";
	char r27[5] = "11011";
	char r28[5] = "11100";
	char r29[5] = "11101";
	char r30[5] = "11110";
	char r31[5] = "11111";
	
	
	
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
	char command[5], reg1[3], reg2[3], reg3[3],immediate[17];
	fp = fopen("assemb.txt", "r");
	fp1 = fopen("opcode.txt", "w");
	
	
	while ( ( fgets(buff, 255, (FILE*)fp)) != '\0' )
	{
		for(i=0;i<4;i++)
		{
			command[i] = buff[i];		
		}
		command[4] = '\0';
		
		char opcode[6];
		char functOp[6];
		char reg1Op[5];
		char reg2Op[5];
		char reg3Op[5];
		char shamt1[3]="000";	
		char shamt2[2]="00";
		
		char first8[9],second8[9],thirsd8[9],fourth8[9];
		
		//Get OpCode first 6 bits
		getOpcode(command, opcode);
		
		printf("\n opcode %s\n", opcode);
		
		//R-Type
		if(strcmp(opcode,"000000") == 0)
		{	
			reg1[0] = buff[4];
			reg1[1] = buff[5];
			reg1[2] = '\0';
			
			reg2[0] = buff[7];
			reg2[1] = buff[8];
			reg2[2] = '\0';
			
			reg3[0] = buff[10];
			reg3[1] = buff[11];
			reg3[2] = '\0';
			
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
			if( (strcmp(opcode,"000001") == 0) || (strcmp(opcode,"000010") == 0) || (strcmp(opcode,"000011") == 0) )
			{
				reg1[0] = buff[5];
				reg1[1] = buff[6];
				reg1[2] = '\0';
				
				reg2[0] = buff[8];
				reg2[1] = buff[9];
				reg2[2] = '\0';
				
				for(i=11;i<27;i++)
				{
					immediate[i-11] = buff[i];		
				}
				immediate[16] = '\0';
			}
			else
			{
				reg1[0] = buff[4];
				reg1[1] = buff[5];
				reg1[2] = '\0';
				
				reg2[0] = buff[7];
				reg2[1] = buff[8];
				reg2[2] = '\0';
				
				for(i=10;i<26;i++)
				{
					immediate[i-10] = buff[i];		
				}
				immediate[16] = '\0';
			}
			
			
			
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
			
	}
		
	fclose(fp);
	fclose(fp1);
	return 0;
}

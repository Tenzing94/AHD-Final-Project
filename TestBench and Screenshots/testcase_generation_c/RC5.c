/* RC5REF.C -- Reference implementation of RC5-32/12/16 in C.        */
/* Copyright (C) 1995 RSA Data Security, Inc.                        */
#include "stdio.h"
#include "time.h"
#include "string.h"
#include "stdlib.h"
typedef unsigned int WORD; /* Should be 32-bit = 4 bytes        */
#define w        32             /* word size in bits                 */
#define r        12             /* number of rounds                  */  
#define b        16             /* number of bytes in key            */
#define c         4             /* number  words in key = ceil(8*b/w)*/
#define t        26             /* size of table S = 2*(r+1) words   */


// For key 00000000000000000000000000000000
    WORD S[t] = {0X9BBBD8C8, 0X1A37F7FB, 0X46F8E8C5,
      0X460C6085, 0X70F83B8A, 0X284B8303, 0X513E1454, 0XF621ED22,
      0X3125065D, 0X11A83A5D, 0XD427686B, 0X713AD82D, 0X4B792F99,
      0X2799A4DD, 0XA7901C49, 0XDEDE871A, 0X36C03196, 0XA7EFC249,
      0X61A78BB8, 0X3B0A1D2B, 0X4DBFCA76, 0XAE162167, 0X30D76B0A,
      0X43192304, 0XF6CC1431, 0X65046380};                      

//// For key 00000000000000000000000000000001
//    WORD S[t] = {0X36221aed, 0Xd2c60b81, 0X68a65609,
//      0X7fe643de, 0X96841077, 0X4ad0a670, 0X1a08eedb, 0X65fc4bbe,
//      0X1e60e594, 0X476fd29c, 0Xc5709c96, 0Xd8c195eb, 0X6bcf7623,
//      0X9094584f, 0X77fb82c8, 0Xe82dfc07, 0Xf47bb0ea, 0X95b079f6,
//      0X53c67e66, 0X47753374, 0X1386c75b, 0X8b5266ce, 0X1a349fa0,
//      0X8b0d06e9, 0Xe518b107, 0Xa2af9b17};  

WORD P = 0xb7e15163, Q = 0x9e3779b9;  /* magic constants             */
/* Rotation operators. x must be unsigned, to get logical right shift*/
#define ROTL(x,y) (((x)<<(y&(w-1))) | ((x)>>(w-(y&(w-1)))))
#define ROTR(x,y) (((x)>>(y&(w-1))) | ((x)<<(w-(y&(w-1)))))

void RC5_ENCRYPT(WORD *pt, WORD *ct) /* 2 WORD input pt/output ct    */
{ WORD i, A=pt[0]+S[0], B=pt[1]+S[1];
  for (i=1; i<=r; i++) 
    { A = ROTL(A^B,B)+S[2*i]; 
      B = ROTL(B^A,A)+S[2*i+1]; 
    }
  ct[0] = A; ct[1] = B;  
} 

void RC5_DECRYPT(WORD *ct, WORD *pt) /* 2 WORD input ct/output pt    */
{ WORD i, B=ct[1], A=ct[0];
  for (i=r; i>0; i--) 
    { B = ROTR(B-S[2*i+1],A)^A; 
      A = ROTR(A-S[2*i],B)^B; 
    }
  pt[1] = B-S[1]; pt[0] = A-S[0];  
} 

void RC5_SETUP(unsigned char *K) /* secret input key K[0...b-1]      */
{  WORD i, j, k, u=w/8, A, B, L[c]; 
   /* Initialize L, then S, then mix key into S */
   for (i=b-1,L[c-1]=0; i!=-1; i--) L[i/u] = (L[i/u]<<8)+K[i];
   for (S[0]=P,i=1; i<t; i++) S[i] = S[i-1]+Q;
   for (A=B=i=j=k=0; k<3*t; k++,i=(i+1)%t,j=(j+1)%c)   
     { A = S[i] = ROTL(S[i]+(A+B),3);  
       B = L[j] = ROTL(L[j]+(A+B),(A+B)); 
     }  
} 

void RC5(char* key2, char* v1, char* v2, WORD *ct0_ret)
{ WORD i, j, pt1[2], pt2[2], ct[2] = {0,0};
  unsigned char key[b];
  unsigned char val1[100];
  unsigned char val2[100];
  time_t t0, t1;
  if (sizeof(WORD)!=4) 

  printf("RC5-32/12/16\n");




      pt1[0]=ct[0]; pt1[1]=ct[1]; 

      for (j=0;j<b;j++) key[j] = 1;
	  char *key1 = key2;
	  strcpy(val1, v1);
	  strcpy(val2 , v2);




	  pt1[0] = (int)strtoul(val1, NULL, 16);
	  pt1[1] = (int)strtoul(val2, NULL, 16);

	  unsigned int bytearray[12];
	  int str_len = strlen(key1);

	  for (i = 0; i < (str_len / 2); i++) {
		  sscanf(key1 + 2 * i, "%02x", &key[i]);

	  }


      /* Setup, encrypt, and decrypt */
//      RC5_SETUP(key);  
      RC5_ENCRYPT(pt1,ct);  
      RC5_DECRYPT(ct,pt2);
      /* Print out results, checking for decryption failure */


//	  for (j = 0; j<str_len/2; j++) printf("%.2X ", key[j]);
      printf("\n   plaintext %.8lX %.8lX  --->  ciphertext %.8lX %.8lX  \n",
             pt1[0], pt1[1], ct[0], ct[1]);
      ct0_ret[0] = ct[0];
      ct0_ret[1] = ct[1];

      if (pt1[0]!=pt2[0] || pt1[1]!=pt2[1]) 
        printf("Decryption Error!");

}


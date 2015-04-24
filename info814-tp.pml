#define CHALEUR_CRITIQUE 500
#define NB_CAPTEUR 4
#define NB_CONNECTEUR 3


/*
int chaleurCourante = 400;
chan niveau_chaleur = [O] of {int};
*/

mtype = {fork};


#define left forks[my_id]

chan forks[NB_CAPTEUR] = [1] of {bit};


int chaleurCourante = 400;
chan niveau_chaleur = [0] of {int};

/*	Channel capteur */
chan in_capteur = [0] of {int};
chan out_capteur = [0] of {int};

/*	Channel connecteur */
chan in_connecteur1 = [4] of {int};
chan in_connecteur2 = [4] of {int};
chan in_connecteur3 = [4] of {int};
chan out_connecteur = [0] of {int};

/*	Channel hothot */
chan in_hothot = [0] of {int};
chan out_hothot1 = [0] of {int};
chan out_hothot2 = [0] of {int};
chan out_hothot3 = [0] of {int};
chan out_hothot4 = [0] of {int};


/* Channel Horloge */
chan wait = [0] of {int};
chan reply = [0] of {int};


/* Channel controleur */
chan send_msg_controleur = [3] of {int}

/* Horloge */
active proctype horloge(){
	int val;
	int i=0;
	do
		:: 
		wait ?val ->
			do
				:: i == val -> reply !0; i=0; break;
				:: i < val -> i = i+1;
			od;
	od
}


active proctype hothot(){
	do
	::
		wait !1000; reply ?_;
		if
			:: skip -> chaleurCourante = chaleurCourante + 50;
			:: skip -> chaleurCourante = chaleurCourante - 50;
			:: skip -> chaleurCourante = chaleurCourante + 100;
			:: skip -> chaleurCourante = chaleurCourante - 100;
		fi;
		::out_hothot1 !chaleurCourante;
		::out_hothot2 !chaleurCourante;
		::out_hothot3 !chaleurCourante;
		::out_hothot4 !chaleurCourante;
	od
}


proctype Capteur(){
	
	/*printf("Capteur\t");*/

	int tmp1,tmp2,tmp3,tmp4;

	do

		:: 	

		wait !40000; reply ?_;

		out_hothot1 ?tmp1 ; out_hothot2 ?tmp2; out_hothot3 ?tmp3; out_hothot4 ?tmp4	->
		
				/*out_capteur !tmp ;*/
				/*chaleurCourante = tmp;*/

/*
				if
					:: ( (( tmp1 == tmp2 ) && ( tmp2 == tmp3 ))  || (( tmp1 == tmp3 ) && ( tmp3 == tmp4 )) || (( tmp2 == tmp3 ) && ( tmp3 == tmp4 )) || (( tmp1 == tmp2 ) && ( tmp2 == tmp4))) ->
					printf("\n******\n");
					:: else -> skip;
				fi

				printf("Capteur 1: %d\n",tmp1);
				printf("Capteur 2: %d\n",tmp2);
				printf("Capteur 3: %d\n",tmp3);
				printf("Capteur 4: %d\n\n\n",tmp4);*/

				in_connecteur1 !tmp1;
				in_connecteur1 !tmp2;
				in_connecteur1 !tmp3;
				in_connecteur1 !tmp4;

				in_connecteur2 !tmp1;
				in_connecteur2 !tmp2;
				in_connecteur2 !tmp3;
				in_connecteur2 !tmp4;


				in_connecteur3 !tmp1;
				in_connecteur3 !tmp2;
				in_connecteur3 !tmp3;
				in_connecteur3 !tmp4;




/*
				in_connecteur2 !chaleurCourante;
				in_connecteur3 !chaleurCourante;

*/
	od

}

proctype Collecteur(){
	int i,j,k,l;
	int a,b,c;
	
	do
		::
		wait !3000; reply ?_;
		printf("\n========================================\n");
		in_connecteur1 ?i;in_connecteur1 ?j;in_connecteur1 ?k;in_connecteur1 ?l -> 
				printf("Collecteur1 : %d,%d,%d,%d\n",i,j,k,l);
				if
					:: ( (( i == j ) && ( j == k )) || (( j == k ) && ( k == l )) || (( i == k ) && ( k == l )) ||  (( k == i ) && ( i == l ))  ) -> 
						if
							:: (i<CHALEUR_CRITIQUE) -> a=0;
							:: (i>=CHALEUR_CRITIQUE) -> a=1;
						fi;
					:: else -> a=2;
				fi;


		in_connecteur2 ?i;in_connecteur2 ?j;in_connecteur2 ?k;in_connecteur2 ?l -> 
				printf("Collecteur2 : %d,%d,%d,%d\n",i,j,k,l);
				if
					:: ( (( i == j ) && ( j == k )) || (( j == k ) && ( k == l )) || (( i == k ) && ( k == l )) ||  (( k == i ) && ( i == l ))  ) -> 
						if
							:: (i<CHALEUR_CRITIQUE) -> b=0;
							:: (i>=CHALEUR_CRITIQUE) -> b=1;
						fi;
					:: else -> b=2;
				fi;


		in_connecteur3 ?i;in_connecteur3 ?j;in_connecteur3 ?k;in_connecteur3 ?l -> 
				printf("Collecteur3 : %d,%d,%d,%d\n\n\n",i,j,k,l);
				if
					:: ( (( i == j ) && ( j == k )) || (( j == k ) && ( k == l )) || (( i == k ) && ( k == l )) ||  (( k == i ) && ( i == l ))  ) -> 
						if
							:: (i<CHALEUR_CRITIQUE) -> c=0;
							:: (i>=CHALEUR_CRITIQUE) -> c=1;
						fi;
					:: else -> c=2;
				fi;



/*
		printf("==>a=%d",a);
		printf("==>b=%d",b);
		printf("==>c=%d",a);
*/
		send_msg_controleur !a;
		send_msg_controleur !b;
		send_msg_controleur !c;
		run Controlleur();
		/*in_connecteur2 ?i -> printf("Collecteur2 : %d\n",i);
		in_connecteur3 ?i -> printf("Collecteur3 : %d\n",i);*/
	od
	
}

proctype Controlleur(){
	/*printf("Controlleur -> %d\n",chaleurCourante);*/
	int i,j,k;
	
	send_msg_controleur ?i ->
	send_msg_controleur ?j ->
	send_msg_controleur ?k ->

	if
		:: ( (i==0) || (j==0) || (k==0) ) -> 
			printf("Temperature Normal :) \n");
			printf("\n========================================\n");
		:: ( (i==1) || (j==1) || (k==1) ) -> 
			printf("Alarme Temperature !!\n");
			printf("\n=######################################=\n");
			printf("\n=######################################=\n");
			printf("\n=######################################=\n");
			printf("\n========================================\n");
		:: else -> 
			printf("Défaillance Capteur x_x\n");
			printf("\n========================================\n");
	fi;
}

active proctype main(){

	run Capteur();
	run Collecteur();

/*
	run Controlleur();
	printf("main\t");
	byte capteur = NB_CAPTEUR;
	atomic{
		do
			:: capteur = 4 ->
				run capteur(1);
				run capteur(2);
		od
	} 
*/


}
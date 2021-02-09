u27 = ffgen(('x^3-'x+1)*Mod(1,3),'u);
codf27(s) = [if(x==32,0,u27^(x-97))|x<-Vec(Vecsmall(s)),x==32||x>=97&&x<=122];


\\fonction pour décoder un message dans F27
\\ comme x est codé par u27^(k=x-97), u27^k est décodé par x=k+97
decodf27(v)={
	c= vector(#v);
	for(i=1,#v,
		for(k=0,25,if(v[i]==u27^k,c[i]=k+97,if(v[i]==0,c[i]=32)););
	);
  Strchr(c);
}

\\fonction d'exponentiation de matrice récursive
expoMat(m,n) = {
	if(n==0,return( matid(40)));
	if(n== 1,return (m));
	if(n%2==0,return (expoMat(m^2,n/2)), return (m*expoMat(m^2,(n-1)/2)));
}


\\boucle de calcul pour chaque facteur de n
dechiffre(m,f)={
	for(i=1,matsize(f)[1],m=expoMat(m,f[i,1]^f[i,2]));
	m;
}



\\on récupère le chiffré et le nombre d'itérations
test=readvec("input.txt")[1];
n=test[3];
\\on factorise n qui déclenche une erreur stack overflow à l'appel de l'exponentiation
\\fac est une matrice de deux colonnes, la première contient les facteurs,
\\la seconde contient les exposants.
fac=factor(n);
\\on chiffre et on met sous forme de vecteur colonne
test=codf27(test[2]);
test=test~;
\\définition de la matrice de transition comme expliquée dans le document donné en lien plus bas
m=matrix(40,40,i,j,if(j==i+1,1,0));
m[40,1]=-u27;
m[40,2]=-1;
\\Comme on veut déchiffrer, on suit les consignes d'Adèle, et on inverse la matrice
m=m^(-1);
\\on applique les n itérations à l'aide de la décomposition en facteurs
m=dechiffre(m,fac);
test=m*test;
test=test~;
test=decodf27(test);
print(test);
 

\\NB : le document suivant a été utile pour résoudre le challenge
\\http://iml.univ-mrs.fr/~rodier/Cours/LFSR.pdf

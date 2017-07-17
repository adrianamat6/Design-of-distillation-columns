
*Option for the display statement to print 8 decimals
option decimals=8;


$ontext
Example 9.1 page 168 from Smith, R. (2005). Chemical process design and
 integration. Chichester, West Sussex, England, Wiley.

A distillation column operating at 14 bar with a saturated liquid feed of
1000 kmol·h-1 with composition given in Table 9.1 is to be separated into an
overhead product that recovers 99% of the n-butane overhead and 95% of the
 i-pentane in the bottoms. Relative volatilities are also given in Table 9.1.

Component      fi (kmol·h.1)   Relative volatility (alpha_{i,j})
   Propane           30.3                     16.5
  i-Butane           90.7                     10.5
  n-Butane(LK)      151.2                     9.04
 i-Pentane(HK)      120.9                     5.74
 n-Pentane          211.7                     5.10
  n-Hexane          119.3                     2.92
 n-Heptane          156.3                     1.70
 n-Octane           119.6                     1.00

$offtext
SETS
 I i is a component /P,iB,nB_LK,iP_HK,nP,nH,nHep,nO/
 R r is Underwood root /r1*r7/
 C c is a column (separation task) /nB_iP/

 active_root(c,r) active Underwood root

 alias (i,j)
;


* Set the active root
 active_root('nB_iP','r3') = YES;


PARAMETERS
 RECOVERY(c,i)  mole flowrate ratio between distillate to feed stream for component i in column c
 RECOVERY_LK(c) mole flowrate ratio distillate to feed stream for light key component in column c
* RECOVERY_BOTTOMS(c,i)  mole flowrate ratio bottoms to feed stream for component i in column c
 RECOVERY_BOTTOMS_HK(c) mole flowrate ratio bottoms to feed stream for heavy key component in column c

 LK(c) position for the light key component in column c
 HK(c) position for the heavy key component in column c
;

 LK('nB_iP') = 3;
 HK('nB_iP') = 4;


TABLE  alpha(c,i) relative volatility for component i in column c

           P    iB nB_LK iP_HK    nP   nH  nHep    nO
nB_iP   16.5  10.5  9.04  5.74  5.10 2.92  1.70  1.00

;








$ontext
The ratio of equilibrium K-values for two components, i and j, measures their
 relative volatility:
                       \alpha_{i,j} = K_{i} / K_{j}

Definition of the K-value, Ki , that relates the vapor (y_{i}) and
liquid (x_{i}) mole fractions of component i:
       K_{i} = y_{i} / x_{i}  = \phi_{i}^{L} / \phi_{i}^{V}
where  phi_{i}^{L} is liquid-phase fugacity coefficient and \phi_{i}^{V} is
is vapor-phase fugacity coefficient
$offtext

* Column for the separation task B,T / EB,S
* alpha('B')  = 9.03150011825442e-002/9.79326204634734e-003;
* alpha('T')  = 4.15247587741316e-002/9.79326204634734e-003;
* alpha('EB') = 1.52598348764147e-002/9.79326204634734e-003;
* alpha('S')  = 9.79326204634734e-003/9.79326204634734e-003;

* Column for the separation task B / T
* 81 kPa, 82 ºC
* alpha('B_TES','B')  = 1.38809443225675 /0.121889172158170;
* alpha('B_TES','T')  = 0.514930627891890/0.121889172158170;
* alpha('B_TES','EB') = 0.247237618195237/0.121889172158170;
* alpha('B_TES','S')  = 0.121889172158170/0.121889172158170;
* LK('B_TES') = 1;
* HK('B_TES') = 2;

*For Example 9.1 Smith [2005]
 RECOVERY_LK(c) = 0.99  ;
 RECOVERY_BOTTOMS_HK(c) = 0.95 ;



loop(c$(ord(c)=1),
    RECOVERY(c,i)$(ord(i) < LK(c) ) = 1;
    RECOVERY(c,i)$(ord(i) = LK(c) ) = RECOVERY_LK(c);
    RECOVERY(c,i)$(ord(i) = HK(c) ) = 1 - RECOVERY_BOTTOMS_HK(c);
    RECOVERY(c,i)$(ord(i) > HK(c) ) = 0;
);

 display recovery;





POSITIVE VARIABLES
 V1(c)    vapor mole flowrate in the enriching section
 V2(c)    vapor mole flowrate in the exhausting section
 L1(c)    liquid mole flowrate in the enriching section
 L2(c)    liquid mole flowrate in the exhausting section
 F(c)     total mole flowrate in the feed stream
 D(c)     total mole flowrate in the distillate stream
 B(c)     total mole flowrate in the bottom stream
 Fi(c,i) mole flowrate for component i in the feed stream [kmol·h^{-1}]
 Di(c,i) mole flowrate for component i in the distillate stream
 Bi(c,i) mole flowrate for component i in the bottom stream
 root_UW(c,r) Underwood root for a given separation task
;

VARIABLES
 objfunValue
;

EQUATIONS
COMPONENT_MOLE_BALANCE
TOTAL_MOLE_BALANCE
TOP_TOTAL_MOLE_BALANCE
BOTTOM_TOTAL_MOLE_BALANCE
FEED_TOTAL_MOLE_BALANCE
THERMAL_CONDITION_OF_THE_FEED
TOTAL_COMPONENT_RELATION_FEED
TOTAL_COMPONENT_RELATION_DISTILLATE
TOTAL_COMPONENT_RELATION_BOTTOM
UNDERWOOD_1
UNDERWOOD_2
UNDERWOOD_3
COMPONENT_RECOVERY_IN_DISTILLATE
OBJECTIVE_FUNCTION
;

COMPONENT_MOLE_BALANCE(c,i)..
    Fi(c,i) =E= Di(c,i) + Bi(c,i)
;

TOTAL_MOLE_BALANCE(c)..
    F(c) =E= D(c) + B(c)
;

TOP_TOTAL_MOLE_BALANCE(c)..
    V1(c) =E= D(c) + L1(c)
;

BOTTOM_TOTAL_MOLE_BALANCE(c)..
    L2(c) =E= V2(c) + B(c)
;

FEED_TOTAL_MOLE_BALANCE(c)..
    F(c) + L1(c) + V2(c) =E= V1(c) + L2(c)
;

THERMAL_CONDITION_OF_THE_FEED(c)..
    V1(c) =E= V2(c)
;

TOTAL_COMPONENT_RELATION_FEED(c)..
    F(c) =E= sum(i, Fi(c,i))
;

TOTAL_COMPONENT_RELATION_DISTILLATE(c)..
    D(c) =E= sum(i, Di(c,i))
;

TOTAL_COMPONENT_RELATION_BOTTOM(c)..
    B(c) =E= sum(i, Bi(c,i))
;

UNDERWOOD_1(active_root(c,r))..
    sum(i, alpha(c,i) * Fi(c,i) / (alpha(c,i) - root_UW(c,r)) ) =E= V1(c) - V2(c)
;

UNDERWOOD_2(active_root(c,r))..
    sum(i, alpha(c,i) * Di(c,i) /(alpha(c,i) - root_UW(c,r)) ) =L= V1(c)
;

UNDERWOOD_3(active_root(c,r))..
    sum(i, alpha(c,i) * Bi(c,i) / (alpha(c,i) - root_UW(c,r))) =G= -V2(c)
;



* Force component mole flowrate at the at bottoma and distillate according to the given recovery

COMPONENT_RECOVERY_IN_DISTILLATE(c,i)$(ord(i) <= LK(c) OR ord(i) >= HK(c) )..
    Di(c,i) =E= RECOVERY(c,i)*Fi(c,i)
;


OBJECTIVE_FUNCTION..
         objfunValue =E= 1
;


model oneColum /
COMPONENT_MOLE_BALANCE
TOTAL_MOLE_BALANCE
TOP_TOTAL_MOLE_BALANCE
BOTTOM_TOTAL_MOLE_BALANCE
FEED_TOTAL_MOLE_BALANCE
THERMAL_CONDITION_OF_THE_FEED
TOTAL_COMPONENT_RELATION_FEED
TOTAL_COMPONENT_RELATION_DISTILLATE
TOTAL_COMPONENT_RELATION_BOTTOM
UNDERWOOD_1
UNDERWOOD_2
UNDERWOOD_3
COMPONENT_RECOVERY_IN_DISTILLATE
OBJECTIVE_FUNCTION
/
;

loop( (c,r,i)$(ord(i) = ord(r)),
             root_UW.up(c,r) = alpha(c,i)  - 0.01;

    );

loop( (c,r,i)$(ord(i) = ord(r)+1 ),
             root_UW.lo(c,r) = alpha(c,i)  + 0.01;
    );


display root_UW.up,root_UW.lo;


root_UW.l(c,r) = (root_UW.lo(c,r) + root_UW.up(c,r))/2;



*Fi.fx('B')  =  1.611 ;
*Fi.fx('T')  =  1.133 ;
*Fi.fx('EB') =  8.228 ;
*Fi.fx('S')  = 12.090 ;

* Mole flowrate [kmol/h] in the feed stream to Column for the separation task B / T
* Fi.fx(c,'B')  =  1.01058769874740 ;
* Fi.fx(c,'T')  =  0.840672260860312 ;
* Fi.fx(c,'EB') =  9.32775594686684e-003 ;
* Fi.fx(c,'S')  =  1.93294958922850e-004 ;


loop(c$(ord(c)=1),
    Fi.fx(c,'P')     =     30.3   ;
    Fi.fx(c,'iB')    =     90.7   ;
    Fi.fx(c,'nB_LK') =    151.2   ;
    Fi.fx(c,'iP_HK') =    120.9   ;
    Fi.fx(c,'nP')    =    211.7   ;
    Fi.fx(c,'nH')    =    119.3   ;
    Fi.fx(c,'nHep')  =    156.3   ;
    Fi.fx(c,'nO')    =    119.6   ;
    );

solve oneColum using NLP min objfunValue
;


display Fi.l, Di.l, Bi.l;


*===============================================================================
* Calculate minimum number of stages
*===============================================================================

$ontext

         Numero minimo de pisos y pisos reales:

           Si se trabaja con recuperaciones, el numero minimo de pisos  se puede obtener a priori de las recuperaciones
           De acuerdo con la ecuacion de FENSKE (que supone reflujo total):

                          | ziD   zjB|
                        Ln| ---  --- |
                          | zjD   ziB|
                 Nmin = ------------------           i = LK,  j = HK
                             Ln(aplha(ij))

         En funcion de las recuperaciones se queda:
                           |  rec(i)     rec(j)    |
                        Ln |--------- · ---------- |
                           | 1-rec(i)    1-rec(j)  |
                 Nmin = ----------------------------
                                   Ln(alpha(ij))


         El numero real de pisos se puede calcular a partir de la correlacion de Gilliland
         (o bien con la heurística N ~= 2Nmin )


                                                         |
                            |       _           _ 0.5688 |
          NP - Nmin         |      |  R  - Rmin  |       |
         ----------- = 0.75 | 1  - | ----------- |       |
           NP + 1           |      |_   r  + 1  _|       |
                            |                            |


         En lugar de usar Gilliland usamos la correlacion de Molokanov que da mejores resultados

         N - Nmin             |  1 + 54.4*X           X - 1   |
        ----------  =  1 - exp| ---------------- * ---------- |
          N + 1               |_  11 + 117.2*X        X^0.5  _|

      where:           R - Rmin
                 X = ----------
                        R + 1

         Si se fija de antemano la relación de reflujo (numero de veces la minima) p.e. a 1.2Rmin
         entonces el numero de pisos se puede calcular a priori



         La altura de la columna la podemos calcular suponiendo una separación entre
         platos. Un valor típico es 0.6 m

         H(c) = SepPlatos*(NP-1) + 3  m (se añaden 3 metros )

         La posicion del piso de alimentacion la podemos obtener de la correlación de  Kirkbride

                        _                            _ 0.206
                NR      |   z(HK)    xB(LK)^2     B   |
             -------  = | ------- * ---------- * ---- |
                NS      |_  z(LK)    xD(HK)^2     D  _|

         Si las recuperaciones son todas iguales nos queda
                   _                0.206
            NR     |  FLK     D    |
         ------- = | -----  ------ |
            NS     |_ FHK     B    |


*----------------------------------------------------------------------------------------------------


$offtext
SET
 s secciones de columna /s1, s2/;

PARAMETERS
 Nmin(c)  Numero minimo de pisos
 SepPisos Separacion entre pisos
;


 Nmin(c) = sum((i,j)$(ord(i) = LK(c) and ord(j) = HK(c)),
          log(  RECOVERY_LK(c)         / ( 1-RECOVERY_LK(c) )
              * RECOVERY_BOTTOMS_HK(c) / ( 1-RECOVERY_BOTTOMS_HK(c) ) )
              / log( alpha(c,i) / alpha(c,j) )
               );

 SepPisos = 0.6;

;

display Nmin;



POSITIVE VARIABLES

         a       Numero de veces por encima del reflujo minimo (ej 1.2 veces el minimo)
         Rmin    Reflujo minimo
         NP(c)   Numero de pisos reales
         X(c)    variable auxiliar ver comentarios previos
         H(c,s)    altura de la seccion de columna

         NS(c,s)  Pisos en cada seccion
         ;


         a.lo = 1.01;
         NP.lo(c) = Nmin(c) + 0.0001;
         X.lo(c) = 0.00000001;


EQUATIONS
         pisos01, Pisos02, pisos03, pisos04, pisos05, pisos06, pisos07;

pisos01(c)..  (NP(c) - Nmin(c))/(NP(c) + 1) =E=
               1 - exp(
                        ( 1+ 54.4*X(c))/(11+117.2*X(c)) * (X(c)-1)/sqrt(X(c))
                        ) ;

pisos02(c).. X(c) =E= Rmin(c)*(a-1)/(a*Rmin(c)+1);

pisos03(c)..  Rmin(c)*D(c) =E= L1(c);

pisos04(c)..     NS(c,'s1') =E= NS(c,'s2')*(sum(i$(ord(i) = LK(c)), Fi(c,i))/(sum(i$(ord(i) = HK(c)), Fi(c,i))  ) * D(c)/(B(c)+ 1e-6))**0.206;
pisos05(c)..     NP(c) =E= NS(c,'s1') + NS(c,'s2');


pisos06(c)..  H(c,'s1') =E= SepPisos*(NS(c,'s1') - 1) + 1.5;
pisos07(c)..  H(c,'s2') =E= SepPisos*(NS(c,'s2')) + 1.5;


*----------------------------------------------------------------------------------------------------
$ontext

         En esta seccion calculamos el diametro de las columnas
         ( METODO DE FAIR)

                 F = u sqrt(rov)  ;  u = velocidad del vapor; rov = densidad del vapor

                 u = V*M/rov/A  ; V = flujo molar de vapor; M = Peso molecular; A = sección transversal

                 así A = M*V/(F*sqrt(rov))  donde 2000 <= F <= 9000 m/h (kg/m3)^1/2


                 Fair define un factor de capacidad como c = uf(sig0/sig)^0.2(rov/(rol-rov))^1/2

                         uf = velocidad de inundación
                         sig = tensión superficial
                         rol = densidad del líquido

                 Fair también define un parámetro de flujo

                         f = L/V (rov/rol)^1/2 (Mv/ML)^1.5

                 En la correlación, la velocidad del vapor está basada en el área neta, en lugar del área transversal, para
                 corregir el efecto de los downcomers velocidades y areas están relacionadas por

                         An·un = A·u,  ---> An/A ~ [0.8-0.9]

                 La tensión superficial se puede estimar si no se conoce. Sin embargo, en muchos casos los resutlados son insensibles
                 al valor de sig (la ecuación esta normalizada para sig0 = 20 mN/m. Afortunadamente, en muchos casos el resultado
                 es insensible a la tensión superficial y además se tiene margen porque se decide el porcentaje de inundación

                 Para el calculo de f Fair propone la siguiente correlación

                         c = co/(1 + c1*f^c2)

                Columnas de pisos con espaciado de 24 in = 0.61 m

                      Co = 439; c1 = 2.25;  c2 = 1.2


    El diseño se hace para valores de la velocidad de inundación [60-80%]

    La ecuación que aparece al final es entonces válida con las siguientes suposiciones razonables:

    1. La densidad de los líquidos es mucho mayor que la de los gases     rol-rov ~ rol
    2. L/V(Mv/ML)^1.5 << sqrt(rol/rov)  ---->  c ~= c0
    3. sig/sig0 ~ 1


                 entonces Fflood = sqrt(rol)(An/A)*Co

                         4. An/A ~ 0.8
                         5. % inumndación = 0.7

                 Area ~= Mv/(rol*rov)^0.5 * 1/0.7 * 1/Co * (A/An)*V

                 Si se conocen todos los datos la ecuación anterior es lineal en V

                 NOTA: se puede usar una densidad media del líquido y una densidad media del vapor a una Temp media
                       los errores están amortiguados or el porcentaje de inundación que se elige de forma arbitraria


                NOTA 2:  El flujo de vapor calculado con Underwood es el valor mínimo. El valor real es el flujo que
                         circula cuando RR = aRmin.

                         Así pues Vreal(c) = V(c) + L1(c)*(a-1)

$offtext



SCALAR
         rol "densidad media del liquido kg/m3" /480/
         rov " densidad media del vapor" /38/
*         NOTA: el producto rol*rov varia en las peores condiciones un 8% como máximo (comprobado con HYSYS).
*               se pueden utilizar estos valores medios sin demasiado error para un diseño preliminar
*                Presion de operacion 1 atm.

         Mv Peso molecular medio se calcula en las condiciones de alimento /70 /
*                Se puede afinar y calcular el diámetro en las condiciones de alimentacion a cada columna por ejemplo.

POSITIVE VARIABLE

         Area(c,s);



EQUATIONS
         ec01, ec02;

*ec01(c)..       Area(c,'s1') =E= Mv/(rol*rov)**0.5* 1/0.7 * 1/439 * 1/0.8 * (V1(c) + L1('c2')*(a-1));
*ec02(c)..       Area(c,'s2') =E= Mv/(rol*rov)**0.5* 1/0.7 * 1/439 * 1/0.8 * (V2(c) + L1('c2')*(a-1));

ec01(c)..       Area(c,'s1') =E= Mv/(rol*rov)**0.5* 1/0.7 * 1/439 * 1/0.8 * (V1(c) + L1('nB_iP')*(a-1));
ec02(c)..       Area(c,'s2') =E= Mv/(rol*rov)**0.5* 1/0.7 * 1/439 * 1/0.8 * (V2(c) + L1('nB_iP')*(a-1));



*-----------------------------------------------------------------------------------------------
$ontext

        Consumo de energía en condensador y caldera

         si se conoce el DHvap de cada componente se puede aproximar como

                 Qcond = V1(c)*inHVap = D(i,c)*DHVap(c)/D(c)*V1(c)
                 Qreb =  V2(c)*inHVap = B(i,c)*DHVap(c)/B(c)*V2(c)

         En este caso tenemos casi Benceno puro y p-Xyleno puro
                 No se comete demasido error si se supone producto puro

$offtext

PARAMETERS
*!!!!!!VALORES INVENTADOS
 DHvap(i)  "kJ/kmol"
 /P     30520
  iB    33220
  nB_LK 30000
  iP_HK 30000
  nH    30000
  nHep  30000
  nO    30000
 /;
*!!!!!!VALORES INVENTADOS


POSITIVE VARIABLES
         Qreb     kW
         Qcond    kW ;

EQUATIONS
         heat01, heat02;

heat01..
    Qcond =E= sum(i, Di('nB_iP',i)*DHvap(i))/D('nB_iP')*(V1('nB_iP')+ L1('nB_iP')*(a-1))/3600 ;
;
heat02..
    Qreb  =E= sum(i, Bi('nB_iP',i)*DHvap(i))/B('nB_iP')*(V2('nB_iP')+ L1('nB_iP')*(a-1))/3600 ;


*-----------------------------------------------------------------------------------------------

$ontext

        Calculo de los cambidores de calor Caldera y reboiler

         Utilizamos un coeficiente global medio U = 800 W/(m2 ºC)

         La temperatura del condensador es de  80 ºC (producto puro)
         La temperatura de la caldera es de 138.5 ºC  (producto puro)

         Como refrigerante usaremos agua que entra a 30 y sale a 45 ºC
         Como calefacción usamos un vapor a baja presion a 160 ºC

         DTMLcon = ( (80-45) - (80-30) )/ Ln( (80-45)/(80-30)   ) = 42.055;
         DTMLReb = 160-138.5  = 21.5 ºC



$offtext

SCALAR

         DTMLCond  ºC   /42.055/
         DTMLReb   ºC   /21.5/
         Ureb     "kW/m2/K"  /0.8/
         Ucond    "kW/m2/K"  /0.8/

;
POSITIVE VARIABLES
      AreaCond
      AreaReb;

EQUATIONS
         Cambcal01, Cambcal02;



Cambcal01..    Qreb  =E= Ureb*AreaReb*DTMLReb;
Cambcal02..    QCond =E= Ucond*AreaCond*DTMLCond;




*-----------------------------------------------------------------------------------------------

$ontext

        Costes de inversion y operacion

         CEPCIref =   382;
         CEPCI    =   570.6 (Feb 2015 )
         fscale = factor de escala para los costes. Vendran dados en miles de dolares = 1e-3;

         Coste de la carcasa:    (411.5*AreaCarcasa*H(t,zc) )*(2.25+1.82)*CEPCI/CEPCIref*fscale;

         Coste de los pisos:    (368.68*Area(c,s) + 508.77)*NS(c,s)*CEPCI/CEPCIref*fscale;

         Coste de los cambiadores:  (124.87*AreaCond + 11257)*(1.63+1.66)*CEPCI/CEPCIref*fscale;

         Coste de operación:
                 Servicios calientes:  14.05 $/GJ
                 Servicios frios:      0.354$/GJ


         factor anualizacion = 0.25;   (fa)

$offtext

SCALAR
         CEPCIref        / 382/
         CEPCI           / 570.6/
         fscale          /1e-3/
         CostWater       /0.354/
         CostSteam       /14.05/
         fa              /0.25/
;

POSITIVE VARIABLES
         CostColumnSection(c,s)
         CostPisos(c,s)
         CostReb
         CostCond
         CostServicioCaliente
         CostServicioFrio  ;

VARIABLE CTA
;

EQUATIONS
         cost01, cost02, cost03, cost04, cost05, cost06, cost07;

cost01(c,s)..      CostColumnSection(c,s) =E=   (603.27*Area(c,s)*H(c,s) + 5492.3)*(2.25+1.82)*CEPCI/CEPCIref*fscale;
cost02(c,s)..      CostPisos(c,s)         =E=   (368.68*Area(c,s) + 508.77)*NS(c,s)*CEPCI/CEPCIref*fscale;

cost03..           CostReb                =E=    (124.87*AreaReb  + 11257)*(1.63+1.66)*CEPCI/CEPCIref*fscale;
cost04..           CostCond               =E=    (124.87*AreaCond + 11257)*(1.63+1.66)*CEPCI/CEPCIref*fscale;

cost05..           CostServicioCaliente  =E= Qreb*CostSteam*3600*8000/1e6*fscale;
cost06..           CostServicioFrio      =E= QCond*CostWater*3600*8000/1e6*fscale;


cost07..           CTA   =E=  fa*(sum((c,s), CostColumnSection(c,s) + CostPisos(c,s)) + CostReb + CostCond ) +
                               CostServicioCaliente + CostServicioFrio;


model petlyuk2 /
COMPONENT_MOLE_BALANCE
TOTAL_MOLE_BALANCE
TOP_TOTAL_MOLE_BALANCE
BOTTOM_TOTAL_MOLE_BALANCE
FEED_TOTAL_MOLE_BALANCE
THERMAL_CONDITION_OF_THE_FEED
TOTAL_COMPONENT_RELATION_FEED
TOTAL_COMPONENT_RELATION_DISTILLATE
TOTAL_COMPONENT_RELATION_BOTTOM
UNDERWOOD_1
UNDERWOOD_2
UNDERWOOD_3
COMPONENT_RECOVERY_IN_DISTILLATE
*                 petlyuk
                 ec01, ec02,
                 pisos01, pisos02, pisos03, pisos04, pisos05, pisos06, pisos07,
                 heat01, heat02,
                 Cambcal01, Cambcal02
                 cost01, cost02, cost03, cost04, cost05, cost06, cost07/;

solve  petlyuk2 using NLP minimizing CTA;





scalars
prueba
;
prueba = Mv/(rol*rov)**0.5* 1/0.7 * 1/439 * 1/0.8 * (V1.l('nB_iP') +  L1.l('nB_iP')*(a.l-1) );
display prueba;


PARAMETER
         Diametro(c,s);

         Diametro(c,s) = (4*Area.l(c,s)/pi)**0.5;

display Diametro;


*============================================================================END
* Calculate minimum number of stages
*============================================================================END



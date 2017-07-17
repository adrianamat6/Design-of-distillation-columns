# Design-of-distillation-columns

Distillation column model consists on a set of mole balances along distillation 
columns as well as Underwood Equations. Furthermore, the minimum number of stages 
using the Fenske Equation, the total number of stages using Molokanov Equation, 
the feed stage using Kirkbride Equation, the column diameter calculated from 
minimum vapor internal flowrate, heat flow and condenser in the column are 
needed to design a distillation column. Therefore, these calculations are carried
out according to literature correlations [7].


[7] Smith, R. (s.f). Chemical Process Design and Integration. Centre for Process
Integration School of Chemical Engineerging and Analytical Science, University of
Manchester.

 ____________________________________________________________________________________
· R. Smith : 

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
 
 ____________________________________________________________________________________
 
 · Columna1_Columna2_v3 :
 
 System of two serial distillation columns.
                     1st Column                         2nd Column
 Components     
 Benzene 
 Toluene       LK (<= 0.005 in bottoms)
 E-Benzene     HK (<= 0.005 in distillate)                 LK (<= 0.003 in bottoms)
 Styrene                                                   HK (<= 0.003 in distillate) -------> desired component 
 
 The feed which goes to the first column distillation is an organic one composed of
 Benzene, Toluene, E-Benzene and Styrene. In the first column, the light key component
 (Toluene) must have a molar fraction lower or equal than 0.005 in bottoms, and the 
 heavy key component (Ebenzene) a molar fraction lower or equal to 0.005 in distillate.
 For column 2 the heavy key component is Styrene monomer and the light key component is
 E-Benzene. The separation required is a molar fraction of light key component in bottoms 
 of 0.003 and a molar fraction of heavy key component of 0.003 in distillate.
 
 
 
 
 


$title LPL optimization
*---------------------------Start of Formulations-------------------------------
Sets
i /NY, AZ, CA, FL, OH, IL, TX, VA, WA, NV, MI/
j /Region1, Region2, Region3, Region4, Region5/
s /Small, Medium, Large/
k /N/
m /IR/;

Parameters D(i, j), P_df(i, k), C(j, s), Ir_df(m, j), P(i), Ir(j)
           N(s) /Small 2 ,Medium 3 ,Large 4/;

$call GDXXRW Phase2_Data_OR2.xlsx par=P_df rng=N!b3:c14 rdim=1 cdim=1
$GDXIN Phase2_Data_OR2.gdx
$load P_df

$call GDXXRW Phase2_Data_OR2.xlsx par=D rng=D!b4:g15 rdim=1 cdim=1
$GDXIN Phase2_Data_OR2.gdx
$load D

$call GDXXRW Phase2_Data_OR2.xlsx par=C rng=BC!b5:e10 rdim=1 cdim=1
$GDXIN Phase2_Data_OR2.gdx
$load C

$call GDXXRW Phase2_Data_OR2.xlsx par=Ir_df rng=IR!c4:h5 rdim=1 cdim=1
$GDXIN Phase2_Data_OR2.gdx
$load Ir_df

P(i) = P_df(i, "N");
Ir(j) = Ir_df("IR", j);



* ------------------------------------------------------------------------------

Binary variables
x(i, j)
y(j, s);


Free variable Z;


Equations
Obj_F, equ2, equ3, equ4;

Obj_F        .. Z =e= Sum((j, s), C(j, s)*y(j, s))
                    + Sum((i, j), Ir(j)*P(i)*D(i, j)*x(i, j));

equ2(j)      .. Sum(i, x(i, j)) =l= Sum(s, N(s)*y(j, s));
equ3(i)      .. Sum(j, x(i, j)) =e= 1;
equ4(j)      .. Sum(s, y(j, s)) =l= 1;

Model LPL /all/;

Option Optcr = 0;

Option MIP = CPLEX;

Solve LPL using MIP Min Z;

Display x.l, y.l;

* ------------------------------------------------------------------------------

$call gdxxrw Output.xlsx

execute_unload 'Output.gdx', Z;
execute 'gdxxrw.exe Output.gdx var=Z rng=sheet1!a1';

execute_unload 'Output.gdx', x;
execute 'gdxxrw.exe Output.gdx var=x rng=sheet1!a3';

execute_unload 'Output.gdx', y;
execute 'gdxxrw.exe Output.gdx var=y rng=sheet1!a16';



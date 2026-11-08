% Carga la librería para hacer cálculo simbólico exacto
pkg load symbolic

% Define x1 y x2 como variables simbólicas (representan las dos variables aleatorias)
syms x1 x2

% 1. Cálculo del valor esperado de la función trigonométrica bajo independencia.
% Al integrar, la simetría de las exponenciales y la trigonometría hacen que el resultado sea 0.
int(int(exp(-x1-x2)*(cos(x1-x2)-sin(x1+x2)),x1,0,inf),x2,0,inf)

% Define 'r' como variable simbólica (representa el parámetro de correlación en la cópula FGM)
syms r

% 2. Cálculo de la distribución marginal de x2.
% Al integrar respecto a x1, el término que acompaña a 'r' se anula, demostrando que la marginal
% sigue siendo exponencial pura: da como resultado exp(-x2). La correlación no altera las marginales.
int(exp(-x1-x2)*(1+r*(cos(x1)-sin(x1))*(cos(x2)-sin(x2))),x1,0,inf)

% 3. Cálculo de la Esperanza (Media) de una variable exponencial estándar.
% El resultado de esta integral es 1.
int(x1*exp(-x1),x1,0,inf)

% 4. Cálculo de la Varianza de la variable exponencial.
% Al integrar el cuadrado de la diferencia respecto a la media (1), el resultado es 1.
int((x1-1)^2*exp(-x1),x1,0,inf)

% 5. Cálculo de la Covarianza utilizando la densidad conjunta modificada (FGM).
% Al centrar las variables con (x1-1) y (x2-1), la primera parte se anula (por independencia),
% y la segunda parte (con la 'r') da como resultado exactamente 'r'.
% Esto demuestra que el coeficiente de correlación de Pearson en este modelo es 'r'.
int(int((x1-1)*(x2-1)*exp(-x1-x2)*(1+4*r*(cos(x1)-sin(x1))*(cos(x2)-sin(x2))),x1,0,inf),x2,0,inf)

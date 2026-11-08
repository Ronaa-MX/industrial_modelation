% Carga el paquete de estadística
%pkg load statistics

n=1000;
% Genera 1000 números aleatorios con distribución normal estándar N(0,1)
x=randn(n, 1);

% TRANSFORMACIÓN MATEMÁTICA:
% 1. erf(x/sqrt(2)) aplica la función error, que mapea la normal a un rango (-1, 1)
% 2. abs(...) toma el valor absoluto (dobla la distribución como un espejo)
% 3. 1-2*abs(...) refleja y escala para volver a tener un rango (-1, 1)
% 4. erfinv(...) es la función INVVERSA de la función error (mapea de vuelta)
% 5. sqrt(2)*... escala el resultado final.
y=sqrt(2)*erfinv(1-2*abs(erf(x/sqrt(2))));

% Gráfica de la Función de Distribución Acumulada (CDF) empírica de x
plot(sort(x),[1:n]/(n+1),'b.')
hold on

% Gráfica de la CDF empírica de y.
% ¡Notarás que se superpone perfectamente con la de x!
plot(sort(y),[1:n]/(n+1),'k.')

% CORRECCIÓN DEL ERROR:
% El código original tenía [-3:6/n:3/sqrt(2))] lo cual rompía la sintaxis.
% Se corrigió cerrando el corchete y dividiendo el vector completo entre sqrt(2).
% Esto grafica la CDF teórica de la Normal Estándar en rojo.
plot([-3:6/n:3],(1+erf([-3:6/n:3]/sqrt(2)))/2,'r-')

figure
% Gráfica de dispersión (Scatter plot) entre x e y.
% Muestra la relación geométrica entre ambas variables.
plot(x,y,'bo')

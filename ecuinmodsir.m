clear; clc; close all;
pkg load symbolic % Asegúrate de tener cargado el paquete en Octave

% 1. Definir variables simbólicas
syms x(r) a n

% 2. Definir la EDO
edo = diff(x(r)) == a * ((1 - (x(r)+r)/n) - 1);

% 3. Resolver la EDO CON UNA CONDICIÓN INICIAL (¡Esto quita el error de fplot!)
% Supongamos que en r=0, la población inicial es x=1000
condicion_inicial = x(0) == 1000;
sol_simbolica = dsolve(edo, condicion_inicial);

% 4. Asignar valores numéricos usando 'sym' para evitar el warning
% Usamos sym(1)/sym(2) o sym(0.5) para decirle a Octave que es intencional
sol_numerica = subs(sol_simbolica, [a, n], [sym(1)/sym(2), sym(1000)]);

% 5. Convertir a función numérica (manejador de funciones)
% Esto evita problemas de compatibilidad entre el motor simbólico y fplot
funcion_plot = matlabFunction(sol_numerica);

% 6. Graficar usando fplot
figure;
fplot(funcion_plot, [0, 10000], 'r-', 'LineWidth', 2);
grid on;
xlabel('r (tiempo)');
ylabel('x(r) (población)');
title('Solución de la EDO con condición inicial x(0)=1000');

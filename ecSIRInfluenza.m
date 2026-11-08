% =========================================================
% Resolver la EDO:
%   dX/dR = a*(1 - (X + R)/N) - 1
% usando lsode en Octave
% =========================================================

clear; clc; close all;

% -------------------------
% Parámetros de la ecuación
% -------------------------
a = 2;      % Ajusta este valor
N = 10;     % Ajusta este valor

% -------------------------
% Condición inicial y dominio de R
% -------------------------
R0 = 0;     % Valor inicial de R
X0 = 5;     % Condición inicial: X(R0) = X0
Rf = 10;    % Valor final de R
n  = 200;   % Número de puntos para la solución

% -------------------------
% Definir la función f(X,R)
% lsode espera f(X,R), no f(R,X)
% -------------------------
f = @(X, R) a * (1 - (X + R) / N) - 1;

% Vector de valores de R donde se calculará la solución
R_span = linspace(R0, Rf, n);

% -------------------------
% Resolver la EDO con lsode
% -------------------------
[X_sol, istate, msg] = lsode(f, X0, R_span);

% Mostrar estado de la integración
printf('istate = %d\n', istate);
if istate ~= 1
  printf('Mensaje de lsode: %s\n', msg);
end

% -------------------------
% Graficar la solución
% -------------------------
figure;
plot(R_span, X_sol, 'b-', 'LineWidth', 2);
xlabel('R');
ylabel('X(R)');
title('Solución de dX/dR = a(1 - (X+R)/N) - 1');
grid on;

% -------------------------
% Mostrar algunos valores numéricos
% -------------------------
disp('     R          X(R)');
disp([R_span(:), X_sol(:)]);

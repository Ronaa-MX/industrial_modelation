clear all; clc; close all;

% 1. Cargar datos
try
    M = dlmread('DATOS_INFLUENZA_2009.csv', ',');
catch
    error('No se encontró el archivo. Verifica el nombre y la ruta.');
end
t = M(:,1);
x = M(:,2);

% 2. Definir la ecuación implícita para 'a'
ecuacion_a = @(a) ( (x.*t)' * exp(a*t) ) / ( t' * exp(2*a*t) ) - ...
                  ( x' * exp(a*t) ) / sum( exp(2*a*t) );

% 3. Resolver para 'a' usando fsolve (semilla inicial 0.25)
opciones = optimset('Display', 'iter');
a_opt = fsolve(ecuacion_a, 0.25, opciones);

% 4. Calcular x0 óptimo dado a_opt
x0_opt = ( x' * exp(a_opt*t) ) / sum( exp(2*a_opt*t) );

fprintf('\n--- Parámetros (Variable Projection) ---\n');
fprintf('Tasa de crecimiento (a) = %.4f\n', a_opt);
fprintf('Población inicial (x0)  = %.4e\n', x0_opt);

% 5. Graficar
figure;
plot(t, x, 'bo', 'MarkerFaceColor', 'b'); hold on;
t_fino = linspace(min(t), max(t), 200)';
plot(t_fino, x0_opt * exp(a_opt * t_fino), 'r-', 'LineWidth', 2);
grid on;
xlabel('Días'); ylabel('Casos');
title('Ajuste No Lineal (Variable Projection)');
legend('Datos', 'Modelo Ajustado');

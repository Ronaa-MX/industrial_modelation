clear all; clc; close all;

% 1. Cargar datos
try
    M = dlmread('DATOS_INFLUENZA_2009.csv', ',');
catch
    error('No se encontró el archivo. Verifica el nombre y la ruta.');
end

t_full = M(:,1);
x_full = M(:,2);

% 1. Graficar datos originales
figure;
plot(t_full, x_full, 'bo', 'MarkerFaceColor', 'b'); hold on;

% Curva empírica inicial (la del pizarrón, usando todo el vector)
% Nota: Usamos x_full y t_full para no mezclar con el subconjunto
plot(t_full, exp(t_full * log(x_full(end)) / (length(t_full)-1)), 'r-');

% 2. Seleccionar subconjunto (con protección de índices)
idx_fin = min(49, length(t_full));
idx_ini = min(38, idx_fin - 1);
t = t_full(idx_ini:idx_fin);
x = x_full(idx_ini:idx_fin);

% 3. Método 1: Variable Projection (Ecuación implícita)
ecuacion_a = @(a) ( (x.*t)' * exp(a*t) ) / ( t' * exp(2*a*t) ) - ...
                  ( x' * exp(a*t) ) / sum( exp(2*a*t) );

% Resolver para 'a' usando fsolve
opciones = optimset('Display', 'off');
a_vp = fsolve(ecuacion_a, 0.25, opciones);

% Calcular x0 óptimo dado a_vp
x0_vp = ( x' * exp(a_vp*t) ) / sum( exp(2*a_vp*t) );

fprintf('\n--- Parámetros (Variable Projection) ---\n');
fprintf('Tasa de crecimiento (a) = %.4f\n', a_vp);
fprintf('Población inicial (x0)  = %.4e\n', x0_vp);

% 4. Método 2: Linealización (Mínimos Cuadrados)
p_lin = polyfit(t, log(x), 1);
a_lin = p_lin(1);       % Pendiente = tasa de crecimiento
x0_lin = exp(p_lin(2)); % Intercepto = ln(x0)

fprintf('\n--- Parámetros (Linealización) ---\n');
fprintf('Tasa de crecimiento (a) = %.4f\n', a_lin);
fprintf('Población inicial (x0)  = %.4e\n', x0_lin);

% 5. Graficar ambos modelos
t_fino = linspace(min(t), max(t), 100)';

% Modelo Variable Projection
plot(t_fino, x0_vp * exp(a_vp * t_fino), 'r-', 'LineWidth', 2);

% Modelo Linealizado
plot(t_fino, x0_lin * exp(a_lin * t_fino), 'k--', 'LineWidth', 2);

grid on;
xlabel('Días'); ylabel('Casos');
title('Comparación de Métodos de Ajuste Exponencial');
legend('Datos', 'Modelo Empírico Inicial', 'Variable Projection (No Lineal)',
'Linealización (Mínimos Cuadrados)', 'Location', 'northwest');

clear all; clc; close all;

% 1. Cargar datos de forma segura
try
    M = dlmread('DATOS_INFLUENZA_2009.csv', ',');
catch
    error('No se encontró el archivo. Verifica el nombre y la ruta.');
end

t_full = M(:,1);
x_full = M(:,2);
n_full = length(t_full);

% 2. Graficar datos originales
figure;
plot(t_full, x_full, 'bo', 'MarkerFaceColor', 'b'); hold on;

% 3. Curva Empírica Inicial (usando datos completos)
% Se calcula la tasa bruta asumiendo t0=0 y x0=1
r_empirico = log(x_full(end)) / (n_full - 1);
plot(t_full, exp(t_full * r_empirico), 'r-', 'LineWidth', 1.5);

% 4. Seleccionar subconjunto (con protección de índices)
idx_fin = min(49, n_full);
idx_ini = min(38, idx_fin - 1);
t_fit = t_full(idx_ini:idx_fin);
x_fit = x_full(idx_ini:idx_fin);

% 5. Método 1: Linealización (Mínimos Cuadrados)
% Corrección matemática: se aplica log(x) para linealizar
P = polyfit(t_fit, log(x_fit), 1);
r_lineal = P(1);
x0_lineal = exp(P(2));

% 6. Método 2: Variable Projection (No Lineal)
ecuacion_a = @(a) ( (x_fit.*t_fit)' * exp(a*t_fit) ) / ( t_fit' * exp(2*a*t_fit) ) - ...
                  ( x_fit' * exp(a*t_fit) ) / sum( exp(2*a*t_fit) );
opciones = optimset('Display', 'off');
a_vp = fsolve(ecuacion_a, 0.25, opciones);
x0_vp = ( x_fit' * exp(a_vp*t_fit) ) / sum( exp(2*a_vp*t_fit) );

% 7. Mostrar comparación de tasas
fprintf('\n--- Comparación de Tasas de Crecimiento ---\n');
fprintf('1. Empírica (bruta)      = %.4f\n', r_empirico);
fprintf('2. Linealizada (polyfit) = %.4f\n', r_lineal);
fprintf('3. Variable Projection   = %.4f\n', a_vp);

% 8. Graficar modelos sobre el subconjunto
t_fino = linspace(min(t_fit), max(t_fit), 100)';

% Modelo Linealizado (negro)
plot(t_fino, x0_lineal * exp(r_lineal * t_fino), 'k-', 'LineWidth', 2);

% Modelo Variable Projection (magenta)
plot(t_fino, x0_vp * exp(a_vp * t_fino), 'm-', 'LineWidth', 2);

% 9. Configuración final de la gráfica
grid on;
xlabel('Días'); ylabel('Casos');
title('Comparación de Métodos de Ajuste Exponencial');
legend('Datos Originales', 'Curva Empírica Bruta', ...
       'Linealización (log)', 'Variable Projection', ...
       'Location', 'northwest');

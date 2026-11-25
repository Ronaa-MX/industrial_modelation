% =========================================================================
% SCRIPT GNU OCTAVE / MATLAB: MODELO DE DILL CON PARÁMETROS REALES
% Fuentes: Dill et al. (1975) / Mack (1985) / Kudrya (2025)
% =========================================================================
clear all; clc; close all;

% SELECCIÓN DE RESINA (1 = Kodak 820 [Mack 1985], 2 = Shipley AZ1350J [Dill 1975])
tipo_resina = 2;

if tipo_resina == 1
    % Kodak 820 (lambda = 405.5 nm) - Mack (1985)
    nombre_resina = 'Kodak 820 (\lambda = 405.5 nm)';
    A  = 1.04;       % [1/um]
    B  = 0.0719;     % [1/um]
    C  = 0.020;      % [cm^2/mJ]
    d  = 1.08;       % Espesor [um]
    I_inc = 2.81;    % Intensidad incidente [mW/cm^2]
    tau12 = 0.933;   % Transmisión de interfaz
    I0 = I_inc * tau12; % Intensidad en la superficie superior [mW/cm^2]
else
    % Shipley AZ1350J (lambda = 404.7 nm) - Dill (1975)
    nombre_resina = 'Shipley AZ1350J (\lambda = 404.7 nm)';
    A  = 0.86;       % [1/um]
    B  = 0.07;       % [1/um]
    C  = 0.018;      % [cm^2/mJ]
    d  = 1.10;       % Espesor [um]
    I0 = 2.50;       % Intensidad corregida [mW/cm^2]
end

fprintf('=== MODELO DE DILL: %s ===\n', nombre_resina);
fprintf('Parámetros extraídos: A = %.2f um^-1, B = %.4f um^-1, C = %.3f cm^2/mJ\n', A, B, C);

% =========================================================================
% 1. ESPACIO DE FASES DE KIRKWOOD (dM/dz vs M)
% =========================================================================
M_vec = linspace(0.001, 0.999, 200); % Concentración relativa M
dM_dz = M_vec .* (-B .* log(M_vec) + A .* (1 - M_vec));

figure('Name', 'Espacio de Fases de Kirkwood');
plot(M_vec, dM_dz, 'b-', 'LineWidth', 2);
grid on;
xlabel('Concentración Relativa de Inhibidor M');
ylabel('Ritmo de Cambio Espacial dM/dz [\mu m^{-1}]');
title(sprintf('Espacio de Fases de Kirkwood (dM/dz vs M)\nResina: %s', nombre_resina));
ylim([0, max(dM_dz)*1.1]);

% =========================================================================
% 2. RESOLUCIÓN DE LA EDO DE KIRKWOOD EN EL ESPESOR d
% =========================================================================
tiempos = [6, 12]; % Tiempos de exposición [s]
z_grid  = linspace(0, d, 100);
kirkwood_ode = @(z, M) M * (-B * log(max(M, 1e-10)) + A * (1 - M));

figure('Name', 'Perfiles M(z) por Kirkwood');
hold on;
colors = lines(length(tiempos));

for k = 1:length(tiempos)
    t_exp = tiempos(k);
    E0 = I0 * t_exp;               % Dosis acumulada en superficie [mJ/cm^2]
    M_sup = exp(-C * E0);          % Condición inicial en x = 0
    [z_out, M_out] = ode45(kirkwood_ode, z_grid, M_sup);
    plot(z_out, M_out, 'Color', colors(k,:), 'LineWidth', 2, ...
         'DisplayName', sprintf('t = %d s (E_0 = %.1f mJ/cm^2)', t_exp, E0));
end
grid on;
xlabel('Profundidad x [\mu m]');
ylabel('Inhibidor Residual M(z)');
title(sprintf('Evolución de M(z) en la Capa (%s)', nombre_resina));
legend('Location', 'southeast');
hold off;

% =========================================================================
% 3. SIMULACIÓN DIRECTA DEL SISTEMA DE EDPs ACOPLADAS DE DILL
% =========================================================================
Nz = 100;                 % Puntos espaciales
Nt = 1200;                % Pasos temporales
t_max = 120;              % Tiempo máximo [s]

z  = linspace(0, d, Nz);
dz = z(2) - z(1);
t  = linspace(0, t_max, Nt);
dt = t(2) - t(1);

M_edp = ones(Nz, Nt);     % M(z,0) = 1 (Resina no expuesta)
I_edp = zeros(Nz, Nt);

for k = 1:Nt-1
    % EDP Espacial: dI/dz = -(A*M + B)*I
    I_local = zeros(1, Nz);
    I_local(1) = I0;
    for i = 1:Nz-1
        alpha_local = A * M_edp(i, k) + B;
        I_local(i+1) = I_local(i) * exp(-alpha_local * dz);
    end
    I_edp(:, k) = I_local';

    % EDP Temporal: dM/dt = -C * I * M
    M_edp(:, k+1) = M_edp(:, k) - C * I_local' .* M_edp(:, k) * dt;
    M_edp(:, k+1) = max(min(M_edp(:, k+1), 1), 0);
end

% Comparación entre la solución de EDP acoplada y la EDO de Kirkwood a t = 60 s
figure('Name', 'Comparación EDP vs Kirkwood');
idz_t60 = round(60 / dt);
plot(z, M_edp(:, idz_t60), 'r--', 'LineWidth', 2.5, 'DisplayName', 'EDP Acoplada de Dill');
hold on;
E0_60 = I0 * 60;
M_sup_60 = exp(-C * E0_60);
[z_k, M_k] = ode45(kirkwood_ode, z_grid, M_sup_60);
plot(z_k, M_k, 'k-', 'LineWidth', 1.5, 'DisplayName', 'Reducción EDO Kirkwood');
grid on;
xlabel('Profundidad z [\mu m]');
ylabel('Inhibidor Residual M(z)');
title(sprintf('Verificación a t = 60 s (%s)', nombre_resina));
legend('Location', 'southeast');

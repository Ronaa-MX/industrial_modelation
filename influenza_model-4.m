clear; clc; close all;

% 1. Cargar datos
try
    M = dlmread('DATOS_INFLUENZA_2009.csv', ',');
catch
    error('No se encontró el archivo.');
end
t = M(:,1);
x = M(:,2);

% 2. Gráfica inicial
plot(t,x,'bo'); hold on;
n = length(t);
plot(t,exp(t*log(x(n))/(n-1)),'r-');

% 3. Recorte de datos: 14 valores (del índice 35 al 48)
% 48 - 35 + 1 = 14
t = t(35:48);
x = x(35:48);

% 4. Ajuste Linealizado
P = polyfit(t,log(x),1);
plot(t,exp(P(1)*t+P(2)),'k-')

% 5. Ajuste Variable Projection
aa = fsolve(@(a)(x.*t)'*exp(a*t)/(t'*exp(2*a*t))-x'*exp(a*t)/sum(exp(2*a*t)),0.25);
x0 = x'*exp(aa*t)/sum(exp(2*aa*t));
plot(t,x0*exp(aa*t),'m-')

% 6. Mostrar tasas
disp([log(x(length(x)))/(n-1), P(1), aa])

% 7. Residuos
n = length(x); % Ahora n = 14
res1 = x' - exp(P(1)*t+P(2))';
res2 = x' - x0*exp(aa*t)';

% 8. Prueba de Lilliefors
z1 = (sort(res1) - mean(res1)) / std(res1);
F1 = (erf(z1/sqrt(2)) + 1) / 2;
lill1 = max(max([1:n]/n - F1, F1 - [0:n-1]/n)) * sqrt(n);

z2 = (sort(res2) - mean(res2)) / std(res2);
F2 = (erf(z2/sqrt(2)) + 1) / 2;
lill2 = max(max([1:n]/n - F2, F2 - [0:n-1]/n)) * sqrt(n);

fprintf('\n--- Estadísticos de Lilliefors (n=14) ---\n');
fprintf('Lilliefors Modelo 1 (Lineal): %.4f\n', lill1);
fprintf('Lilliefors Modelo 2 (No Lineal): %.4f\n', lill2);

% 9. Prueba de Rachas de Wald-Wolfowitz
% Modelo 1
med1 = median(res1);
signos1 = res1 > med1;
R1 = 1 + sum(abs(diff(signos1)));
n1_pos = sum(signos1); n1_neg = n - n1_pos;
mu_R1 = (2 * n1_pos * n1_neg) / n + 1;
var_R1 = (2 * n1_pos * n1_neg * (2 * n1_pos * n1_neg - n)) / ((n^2) * (n - 1));
if var_R1 > 0, Z1 = (R1 - mu_R1) / sqrt(var_R1); else, Z1 = 0; end

% Modelo 2
med2 = median(res2);
signos2 = res2 > med2;
R2 = 1 + sum(abs(diff(signos2)));
n2_pos = sum(signos2); n2_neg = n - n2_pos;
mu_R2 = (2 * n2_pos * n2_neg) / n + 1;
var_R2 = (2 * n2_pos * n2_neg * (2 * n2_pos * n2_neg - n)) / ((n^2) * (n - 1));
if var_R2 > 0, Z2 = (R2 - mu_R2) / sqrt(var_R2); else, Z2 = 0; end

fprintf('\n--- Prueba de Rachas (n=14) ---\n');
fprintf('Modelo 1 (Lineal):    Rachas = %d, Z = %.4f\n', R1, Z1);
fprintf('Modelo 2 (No Lineal): Rachas = %d, Z = %.4f\n', R2, Z2);
fprintf('Nota: Si |Z| < 1.96, los residuos son independientes.\n');

% =========================================================
% PARTE 1: GENERACIÓN DE NÚMEROS PSEUDOALEATORIOS (MAPA LOGÍSTICO)
% =========================================================
n=1000;
x=zeros(n,1);
x(1)=rand(1,1); % Semilla inicial aleatoria entre 0 y 1
for k=2:n
  % Ecuación del Mapa Logístico (x_{k+1} = 4*x_k*(1-x_k))
  % Es un sistema dinámico caótico determinista.
  x(k)=4*x(k-1)*(1-x(k-1));
end

% Gráfica de Retardo (Phase Space Plot)
% Dibuja x(k) contra x(k+2). No se ve una nube uniforme, sino una parábola
% porque el sistema es determinista (el siguiente valor depende del anterior).
plot(x(1:n-2),x(3:n),'bo')

% =========================================================
% PARTE 2: DISTRIBUCIÓN DE LOS DATOS (FUNCIÓN DE DISTRIBUCIÓN ACUMULADA)
% =========================================================
figure
% Grafica la CDF empírica de los datos x
plot(sort(x),[1:n]/(n+1),'b.')
hold on
% Superpone la CDF teórica del Mapa Logístico (Distribución de Arcoseno)
% F(x) = 0.5 + asin(2x - 1)/pi
plot([1:n]/(n+1),0.5+asin(2*[1:n]/(n+1)-1)/pi,'r')

% =========================================================
% PARTE 3: TRANSFORMACIÓN A DISTRIBUCIÓN UNIFORME
% =========================================================
% Aplicamos la inversa de la CDF teórica a los datos (Transformada Integral de Probabilidad)
% y = F(x). Por teoría, esto convierte cualquier variable con CDF F en una uniforme [0,1]
y=0.5+asin(2*x-1)/pi;
figure
plot(sort(y),[1:n]/(n+1),'b.')
hold on
% Línea de referencia para una distribución perfectamente uniforme
plot([0,1],[0,1],'r-')

% =========================================================
% PARTE 4: OTRO GENERADOR: MAPA TIENDA DE CAMPAÑA (TENT MAP)
% =========================================================
U=zeros(n,1);
U(1)=rand(1,1);
for k=2:n
  % Ecuación del Mapa Tienda (U_{k+1} = 1 - |1 - 2*U_k|)
  % Es otro sistema caótico, pero su distribución natural SÍ es uniforme.
  U(k)=1-abs(1-2*U(k-1));
end
figure
plot(sort(U),[1:n]/(n+1),'b.')
hold on
% Línea de referencia para una distribución uniforme
plot([0,1],[0,1],'r-')

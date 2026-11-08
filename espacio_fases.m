a=2;                          % Parámetro de tasa (tasa de infección o transición)
n=1000;                       % Capacidad de carga o tamaño total de la población
X=zeros(n,1);                 % Preasignación de memoria: vector columna de ceros para variable X
R=X;                          % Preasignación de memoria: vector columna de ceros para variable R
X(1)=10;                      % Condición inicial: X empieza con 10 individuos
k=1;                          % Contador de iteraciones (índice)

while X(k)>0                  % El bucle continúa mientras X sea mayor que 0 (mientras haya individuos)

  % Regla de transición estocástica:
  % Se genera un número aleatorio uniforme, se multiplica por un factor exponencial
  % que depende del estado actual (X(k) y R(k)), y se compara con otro número aleatorio.
  if rand(1,1)*exp(-a*(1-(X(k)+R(k))/n)+1)>rand(1,1)
    X(k+1)=X(k)-1;            % Si la condición se cumple: X disminuye en 1
    R(k+1)=R(k)+1;            % Simultáneamente, R aumenta en 1 (transición de X a R)
  else
    X(k+1)=X(k)+1;            % Si no se cumple: X aumenta en 1 (nacimiento/recrecimiento)
    R(k+1)=R(k);              % R se mantiene constante (no hay transición)
  endif

  k++;                        % Incrementa el contador para la siguiente iteración
end

hold on                       % Mantiene la gráfica actual para superponer nuevos trazos

% Dibuja la curva determinista (la solución analítica de la EDO) en rojo.
% Esta es la función: X(R) = 1000 - R - 999 * exp(-2R/1000)
plot([1:1000],1000-[1:1000]-999*exp(-2*[1:1000]/1000),'r-')

% Dibuja la trayectoria estocástica simulada en azul.
% Eje X: R (los pasos o recuperados), Eje Y: X (los individuos restantes)
plot(R(1:k),X(1:k),'bo')

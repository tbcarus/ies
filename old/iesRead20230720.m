% Считывание КСС из файла.
% Вывод графиков КСС реализован пока только для осесимметричнлшл (один
% азимутальный угол) и асимметричного (азимутальные углы заданы в диапазоне 0-360) распределений.

close all
clear all
clc


files = dir; %все файлы дирректории
filename = 'Elliptical.ies';
Ireaded = struct(); % все значащие данные входного файла будут храниться в структуе данных. Несохранённые данные считаются стандартными (для нас) или несущественными.
file = textread(deblank(filename), '%s', 'delimiter', '\n');

[m, n] = size(file); %берём количество строк в файле
i = 1; %номер строки
str = cell2mat(strread(file{i,1}, '%s','whitespace', '')); %считывание строки
i = i+1;
while (~strncmp(str, 'TILT', 4)) %пропускаем все строки и доходим до начала данных после этой строки
    str = cell2mat(strread(file{i,1}, '%s','whitespace', ''));
    i = i+1;
end
str = strread(file{i,1}); %считываем строку с параметрами светильника и ксс
i = i+1; %следующая строка
Fies = str(2); % световой поток, указанный в файле
M = str(3); %множитель
P = str(4); %количество полярных углов
A = str(5); %количество азимутальных углов
Ireaded.F = str(2); Ireaded.m = str(3); Ireaded.P = str(4); Ireaded.A = str(5); 
str = strread(file{i,1}); %считываем строку с мощностью светильника
power = str(3); %мощность светильника
Ireaded.power = str(3);
i = i+1; %следующая строка


%% цикл для считывания полярных углов
angleP = 0;
cause = 1; %флаг для циклов while
while (cause) %цикл для считывания полярных углов
    str = str2num(file{i,1}); %считываем первую строку полярных углов
    if (angleP == 0)
        angleP = str; %запись первой строки углов
    else
        angleP(length(angleP)+1:length(angleP)+length(str)) = str(1:end); % запись последующих строк углов, если они в ies файле не уместились на одной строке
    end
    i = i+1;
    if (length(angleP) == P) %если количество считанных значений равно числу полярных углов, то завершаем цикл
        cause = 0;
    end
end
anglePorig = angleP;
Ireaded.angleP = angleP;

%% цикл считывания азимутальных углов. Аналогично полярным углам
angleA = 0;
cause = 1;
while (cause)
    str = str2num(file{i,1}); %считываем азимутальные углы
    if (angleA == 0)
        angleA = str;
    else
        angleA(length(angleA)+1:length(angleA)+length(str)) = str(1:end); % запись последующих строк углов, если они в ies файле не уместились на одной строке
    end
    i = i+1;
    if (length(angleA) == A)
        cause = 0;
    end
end
angleAorig = angleA;
Ireaded.angleA = angleA;

%% цикл считывания значений сил света. Аналогично считыванию углов
stroka = 1; %номер считываемой строки
j = 1; %счётчик азимутальных углов при считывании сил света
I(1:A, 1:P) = 0;
for i=i:m
    str = str2num(file{i,1}); %считываем силы света
    if (stroka == 1)
        I(j,1:length(str)) = M*str;
        Imark = str; %макрер для правильного счёта углов
    else
        I(j,length(Imark)+1:length(Imark)+length(str)) = M*str(1:end);
        Imark(length(Imark)+1:length(Imark)+length(str)) = str(1:end);
    end
    stroka = stroka+1;
    if (length(Imark) == P)
        j = j+1;
        stroka = 1;
    end
    if (j == A+1)
        break;
    end;
end
Ireaded.I = I;

%% дополнение недостающих азимутальных углов, если КСС осесимметричная с одним азимутальным углом 0 градусов
if (A == 1) %если источник осесимметричный (один полярный угол), копируем его в пределах углов 0-90 градусов
    for i=1:90+1
        angleA(i) = 0 + (i-1);
        I(i,:) = I(1,:);
    end
    A = length(angleA);
end;

%% Интерполирование КСС
% Если КСС задана всего 4 азимутальными углами, то интерполяция сплайном
% очень корявая. Поэтому применяется последовательная интерполяция. Шаги
% нужно подобрать экспериметально.
% Оказалось, что в точках разрыва, торые бывают в кривых, КСС ведёт себя
% плохо (выплески) при интерполяции кубической и сплайном
if (length(angleA) == 5)
    if(sum(angleA == 0:90:360) == 5)
        disp('!!ВНИМАНИЕ!!! Исходная КСС представлена только в двух плоскостях. Для неосесимметричных кривых результат интерполяции будет некорректным!');
    end;
end;
step = (A-1)/ceil((A-1)/20);
[X, Y] = meshgrid(0:(angleP(end))/(P-1):angleP(end), angleA(1):(angleA(end)-angleA(1))/(A-1):angleA(end)); % Первоначальная сетка в ies файле
[Xi, Yi] = meshgrid(0:1:angleP(end), angleA(1):step:angleA(end));
angleP = 0:1:angleP(end);
Ii1 = interp2(X, Y, I, Xi, Yi, 'linear');
maxIi = max(max(Ii1));
for i=1:length(Ii1(:,1))
    for j=1:length(Ii1(1,:))
        if (Ii1(i,j) < 0.005*maxIi)
            Ii1(i,j) = 0;
        end;
    end
end;

X = Xi; Y = Yi;
step2 = (A-1)/ceil((A-1)/10);
[Xi, Yi] = meshgrid(0:1:angleP(end), angleA(1):step2:angleA(end));
angleP = 0:1:angleP(end);
Ii2 = interp2(X, Y, Ii1, Xi, Yi, 'cubic');
maxIi2 = max(max(Ii2));
for i=1:length(Ii2(:,1))
    for j=1:length(Ii2(1,:))
        if (Ii2(i,j) < 0.005*maxIi2)
            Ii2(i,j) = 0;
        end;
    end
end;

X = Xi; Y = Yi;
step3 = 1;
[Xi, Yi] = meshgrid(0:1:angleP(end), angleA(1):step3:angleA(end));
angleP = 0:1:angleP(end);
Ii3 = interp2(X, Y, Ii2, Xi, Yi, 'linear');
maxIi3 = max(max(Ii3));
for i=1:length(Ii3(:,1))
    for j=1:length(Ii3(1,:))
        if (Ii3(i,j) < 0.005*maxIi3)
            Ii3(i,j) = 0;
        end;
    end
end;
Ii = Ii3;

%% дополнение полярных углов до 180 градусов
if (angleP(end) < 180) % если информация отсутствет, то силы света в этих направлениях равны 0
    while (angleP(end) ~= 180)
        angleP(end+1) = angleP(end) + 1;
        Ii(:, end+1) = 0;
    end
    [A, P] = size(Ii);
    angleA = angleA(1):1:angleA(end);
end

%% Дополнение азимутальных углов до 360 градусов
if ((angleA(1) == 0) && (angleA(end) == 90)) %если заданы азимутальные углы 0-90 градусов, достраиваем до 0-360
    Ii(end:end+length(Ii(:,1))-1,:) = flipud(Ii);
    angleA(end+1:end+90) = [91:180];
    Ii(end:end+length(Ii(:,1))-1,:) = Ii;
    angleA(end+1:end+180) = [181:360];
end
if ((angleA(1) == 90) && (angleA(end) == 270)) %если заданы азимутальные углы 90-270 градусов, достраиваем до 0-360
    Ii(91:91+length(Ii(:,1))-1,:) = Ii;
    angleA(91:91+length(angleA)-1) = angleA;
    Ii(1:90,:) = flipud(Ii(92:92+90-1,:));
    angleA(1:91) = [0:90];
    Ii(end:end+length(Ii(181:181+90,1))-1,:) = flipud(Ii(181:181+90,:));
    angleA(272:361) = [271:360];
end
if ((angleA(1) == 0) && (angleA(end) == 180)) %если заданы азимутальные углы 0-180 градусов, достраиваем до 0-360
    Ii(end:361,:) = Ii;
    angleA(end+1:end+180) = [181:360];
end
if ((angleA(1) == 0) && (angleA(end) == 360)) %если заданы азимутальные углы 0-360 градусов
    %только добавляем все азимутальные углы 0-360 градусов
    angleA = [0:360];
end
Iinterpolated = struct();
Iinterpolated.A = length(angleA);
Iinterpolated.P = length(angleP);
Iinterpolated.angleA = angleA;
Iinterpolated.angleP = angleP;
Iinterpolated.I = Ii;
%% Вывод графиков
if (length(angleAorig) == 1) % подгоовка данных исходной КСС, заданной одним азимутальным углом
    I0 = I(1,2:end); I180 = fliplr(I(1,1:end)); I90 = I0; I270 = I180;
else
    if(angleAorig(1) == 0 && angleAorig(end) == 360) % подготовка данных исходной КСС, заданной азимутальными углами 0-360
        I0 = I(1,2:end);
        I180 = fliplr(I((A-1)/2+1, :));
        I90 = I((A-1)/4*3+1,2:end);
        I270 = fliplr(I((A-1)/4+1, :));
    end;
end;

Ii = iesRotor(Ii, 45);

% h1=polar(pi/2:pi/(length(I(1,:))-1):2*pi+pi/2, cat(2, fliplr(I((A-1)/2+1, :)) ,I(1,2:end)), '--red'); % Вывод исходной КСС 0-180
h1=polar(pi/2:pi/(length(I(1,:))-1):2*pi+pi/2, cat(2, I180 ,I0), '--red');
set(h1,'LineWidth',3);
hold on
% h2=polar(pi/2:pi/(length(I(1,:))-1):2*pi+pi/2, cat(2, fliplr(I((A-1)/4+1, :)) ,I((A-1)/4*3+1,2:end)), '--blue'); % Вывод исходной КСС 90-270
h2=polar(pi/2:pi/(length(I(1,:))-1):2*pi+pi/2, cat(2, I270, I90), '--blue');
set(h2,'LineWidth',3);
% polar(transpose(Yi(:, 1)*pi/180 + pi/2), cat(2, fliplr(Ii(181, :)) ,Ii(1,2:end)), 'magenta'); % Вывод интерполированной КСС 0-180
% polar(transpose(Yi(:, 1)*pi/180 + pi/2), cat(2, fliplr(Ii(271, :)) ,Ii(91,2:end)), 'cyan'); % Вывод интерполированной КСС 90-270
polar([0:1:360]*pi/180 + pi/2, cat(2, fliplr(Ii(181, :)) ,Ii(1,2:end)), 'magenta'); % Вывод интерполированной КСС 0-180
polar([0:1:360]*pi/180 + pi/2, cat(2, fliplr(Ii(271, :)) ,Ii(91,2:end)), 'cyan'); % Вывод интерполированной КСС 90-270
title('КСС');
legend('Исходная КСС 0-180', 'Исходная КСС 90-270', 'Интерп КСС 0-180', 'Интерп КСС 90-270');

figure
Pang = round(0.11*length(Ii(1,:))); % Угол полярных координат на котором сечётся фотометрическое тело
polar([0:360/(A-1):360]*pi/180, I(:, (length(I(1,:))-1)/180*angleP(Pang)+1)', 'green'); % Вывод проекции исходной КСС по полярному углу Pang
hold on
polar(angleA(1:step3:end)*pi/180, Ii(:, Pang)', '--black'); % Вывод проекции интерполированной КСС по полярному углу Pang
% title(strcat('Сечение КСС с полярным углом ', num2str(Pang-1), 'градусов'));
title(['Сечение КСС с полярным углом ', num2str(Pang-1), ' градусов']);
legend('Исходная', 'Интерполированная');

%% Инетрполированная кривая
% figure
% polar(transpose(Yi(:, 1)*pi/180 + pi/2), cat(2, fliplr(Ii(181, :)) ,Ii(1,2:end)), 'red');
% hold on
% polar(transpose(Yi(:, 1)*pi/180 + pi/2), cat(2, fliplr(Ii(271, :)) ,Ii(91,2:end)), 'blue');
% title('Интерполированная КСС');
% for i=1:length(Ii(:,1))
%     Itemp(i) = max(Ii(i, :).*sin(angleP*pi/180));
% end;
% figure
% polar(angleA*pi/180, transpose(Ii(:,1)));
% title('Интерполированная КСС');
% figure
% hold on
% for i=1:91
%     polar((i-1)*pi/180, Itemp(i));
% end;

%% Вывод КСС шагов интерполяции
% figure
% Pang = round(0.25*length(Ii(1,:)));
% polar([0:90:360]*pi/180, I(:, (length(I(1,:))-1)/180*angleP(Pang)+1)', '--black');
% hold on
% polar(angleA(1:step:end)*pi/180, Ii1(:, Pang)', 'red');
% polar(angleA(1:step2:end)*pi/180, Ii2(:, Pang)', 'blue');
% polar(angleA(1:step3:end)*pi/180, Ii3(:, Pang)', 'green');
% title(strcat('Сечение КСС с полярным углом ', num2str(Pang-1)));
% legend('Исходная', ...
%         strcat('Интерполяция ',num2str(step),' градусов'), ...
%         strcat('Интерполяция ',num2str(step2),' градусов'),...
%         strcat('Интерполяция ',num2str(step3),' градусов'));

%% Вычисление светового потока по силам света в ies

% A = length(Ii(:, 1));
% P = length(Ii(1, :));
% Fsum = 0; %световой поток по КСС
% for i=1:P-1 %подсчёт светового потока по КСС
%     Is = 0; %сила света в шаровом слое
%     for j=1:A-1
%         Is = Is + (Ii(j, i) + Ii(j, i+1))/2;
%     end
%     % disp(i);
%     % (Is/(j))*2*pi*(cos(angleP(i)*pi/180)-cos(angleP(i+1)*pi/180))
%     Fsum = Fsum + (Is/(j))*2*pi*(cos(angleP(i)*pi/180)-cos(angleP(i+1)*pi/180));
% end
disp(num2str(iesFlux(Ii)));
Inormalized = iesNormalize(Ii, 5000);
disp(num2str(iesFlux(Inormalized)));
Inormalized1000 = iesNormalize(Ii, 1000);
disp(num2str(iesFlux(Inormalized1000)));







function f = iesInterpolate(I, stepA, stepP)
%% дополнение недостающих азимутальных углов, если КСС осесимметричная с одним азимутальным углом 0 градусов
if (I.A == 1) %если источник осесимметричный (один полярный угол), копируем его в пределах углов 0-90 градусов
    for i=1:90+1
        angleA(i) = 0 + (i-1);
        I(i,:) = I(1,:);
    end
    A = length(angleA);
else
    angleA = I.angleA; % просто вытаскиваю переменные из структуры, чтобы не менять их далее в ранее написанном коде
    A = I.A;
    angleP = I.angleP;
    P = I.P;
end;

%% Интерполирование КСС
% Если КСС задана всего 4 азимутальными углами, то интерполяция сплайном
% очень корявая. Поэтому применяется последовательная интерполяция. Шаги
% нужно подобрать экспериметально.
% Оказалось, что в точках разрыва, торые бывают в кривых, КСС ведёт себя
% плохо (выплески) при интерполяции кубической и сплайном
if (length(I.angleA) == 5)
    if(sum(I.angleA == 0:90:360) == 5)
        disp('!!ВНИМАНИЕ!!! Исходная КСС представлена только в двух плоскостях. Для неосесимметричных кривых результат интерполяции будет некорректным!');
    end;
end;
if(A~= 361 && P~=181) % условие для исключени дублирования интерполяции при повороте
    step = 20;
    [X, Y] = meshgrid(0:(angleP(end))/(P-1):angleP(end), angleA(1):(angleA(end)-angleA(1))/(A-1):angleA(end)); % Первоначальная сетка в ies файле
    [Xi, Yi] = meshgrid(0:1:angleP(end), angleA(1):step:angleA(end));
    angleP = 0:1:angleP(end);
    Ii1 = interp2(X, Y, I.I, Xi, Yi, 'linear');
    maxIi = max(max(Ii1));
    for i=1:length(Ii1(:,1))
        for j=1:length(Ii1(1,:))
            if (Ii1(i,j) < 0.005*maxIi)
                Ii1(i,j) = 0;
            end;
        end
    end;
    
    X = Xi; Y = Yi;
    step2 = 10;
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
else % Если вход в интерполяцию уже после поворота (до поворота интерполяция по двум углам с шагом 1 градус),
    % то переход сразу на финальную итерацию с заданными
    % шагами интерполяции
    [X, Y] = meshgrid(0:(angleP(end))/(P-1):angleP(end), angleA(1):(angleA(end)-angleA(1))/(A-1):angleA(end)); % Первоначальная сетка в ies файле
    Ii2 = I.I;
end

step3 = stepA;
[Xi, Yi] = meshgrid(0:stepP:angleP(end), angleA(1):step3:angleA(end));
angleP = 0:stepP:angleP(end);
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
    angleA = [0:stepA:360];
end
Iinterpolated = struct();
Iinterpolated.A = length(angleA);
Iinterpolated.P = length(angleP);
Iinterpolated.angleA = angleA;
Iinterpolated.angleP = angleP;
Iinterpolated.I = Ii;
f = Iinterpolated;
end
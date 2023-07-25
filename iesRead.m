% —читывание  —— из файла.
% ¬ывод графиков  —— реализован пока только дл€ осесимметричнлшл (один
% азимутальный угол) и асимметричного (азимутальные углы заданы в диапазоне 0-360) распределений.

function f = iesRead(filename)
if(~exist(filename))
    f = 0;
    disp(['‘айл ' filename ' не найден. ѕропуск записи.']);
    return;
end;

Ireaded = struct(); % все значащие данные входного файла будут хранитьс€ в структуе данных. ЌесохранЄнные данные считаютс€ стандартными (дл€ нас) или несущественными.
file = textread(deblank(filename), '%s', 'delimiter', '\n');
[m, n] = size(file); %берЄм количество строк в файле
i = 1; %номер строки
str = cell2mat(strread(file{i,1}, '%s','whitespace', '')); %считывание строки
i = i+1;
while (~strncmp(str, 'TILT', 4)) %пропускаем все строки и доходим до начала данных после этой строки
    str = cell2mat(strread(file{i,1}, '%s','whitespace', ''));
    i = i+1;
end
str = strread(file{i,1}); %считываем строку с параметрами светильника и ксс
i = i+1; %следующа€ строка
Fies = str(2); % световой поток, указанный в файле
M = str(3); %множитель
P = str(4); %количество пол€рных углов
A = str(5); %количество азимутальных углов
Ireaded.F = str(2); Ireaded.m = str(3); Ireaded.P = str(4); Ireaded.A = str(5);
str = strread(file{i,1}); %считываем строку с мощностью светильника
power = str(3); %мощность светильника
Ireaded.power = str(3);
i = i+1; %следующа€ строка
%% цикл дл€ считывани€ пол€рных углов
angleP = 0;
cause = 1; %флаг дл€ циклов while
while (cause) %цикл дл€ считывани€ пол€рных углов
    str = str2num(file{i,1}); %считываем первую строку пол€рных углов
    if (angleP == 0)
        angleP = str; %запись первой строки углов
    else
        angleP(length(angleP)+1:length(angleP)+length(str)) = str(1:end); % запись последующих строк углов, если они в ies файле не уместились на одной строке
    end
    i = i+1;
    if (length(angleP) == P) %если количество считанных значений равно числу пол€рных углов, то завершаем цикл
        cause = 0;
    end
end
anglePorig = angleP;
Ireaded.angleP = angleP;

%% цикл считывани€ азимутальных углов. јналогично пол€рным углам
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

%% цикл считывани€ значений сил света. јналогично считыванию углов
stroka = 1; %номер считываемой строки
j = 1; %счЄтчик азимутальных углов при считывании сил света
I(1:A, 1:P) = 0;
for i=i:m
    str = str2num(file{i,1}); %считываем силы света
    if (stroka == 1)
        I(j,1:length(str)) = M*str;
        Imark = str; %макрер дл€ правильного счЄта углов
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
f = Ireaded;
end

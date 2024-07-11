% Создание однотипных IES файлов, различающихся по мощности, по образцам.
%Вводятся поток светодиода, мощность, их количество и размер светильника
%Перебираются все образцы в папке с m-фалом и сохраняются в папках по
%названиям. 
%Формат названия фалов "MD C40 A19 P1 83.ies", CUBE M C30 A10 P2 83.ies"/
%Всего в имени 5 групп, если при разделении (поиск пробела) получается
%больше, то первые группы объединяются - это название серии. группа 1 -
%название серии, группа 2 - цветовая температура, группа 3 - угол
%излучения, группа 4 - мощность (не исползуется), группа 5 - кпд оптики в
%%.
%Изначально задаётся количество СИД в создаваемых файлах, габариты
%светильников.
%Поток светодиода берётся из образцовых файлов и умножается на коэффициент
%KLED или может быть задан вручную
%Мощность одного светодиода в основном задаётся, но может браться 
%из образцового файла - перемнная power_LED.
%Мощность образцовых светильников считывается из файла
%Мощность создаваймых ies округляется математически кратно 1 Вт
%Учитывается зависимость КПД ИП от мощности. КПД расчитывается по формуле, 
%если КПД меньше 0,9, то берётся 0,9 со случайным шумом 0,001 - здесь не
%используется
%Перемнная Power- одиночная или двойная мощность. Используется при
%формировании имён выходных файлов
%Последнее число (здесь 83  КПД линзы в %)

clear all
clc

files = dir; %все файлы дирректории
N_files = length(files); %количество файлов в дирректории
NN = 0; %счётчик ies файлов при поиске
N_file = 0; %Используется для записи номеров найденных в папке ies файлов
for i=1:N_files
%поиск в дирректории файлов с расширением ies и запоминание их номеров    
    if findstr('.ies', lower(files(i).name))&(~files(i).isdir)
        NN = NN + 1;
        N_file(NN) = i;
    end
end
N_LED =     [16]; %Количество светодиодов в создаваемом файле
dlina =     [0.15]; %длина светильника в создаваемом файле
L_NEW =     ['L06';  'L09';    'L12';  'L15']; %сокращение длин для наименования файла
%N_LED =     [9      12       15      21      27      33      39      45      51];
%dlina =     [0.3    0.35     0.4     0.5     0.6     0.7     0.8     0.9     1]; %длина светильника в создаваемом файле
%N_LED =     [9.49      12      15      21];
shirina =   [0.15]; %ширина светилньика в создаваемом файле
visota =    [0.06]; %высота светильника в создаваемом файле
file_all = length(N_LED)*length(N_file); %количество создаваемых файлов
file_count = 0; %счётчик созданных файлов

for N_faila = 1:length(N_file)
    name_groups = regexp(cell2mat(regexp(files(N_file(N_faila)).name, '.ies', 'split')), ' ', 'split');
    if (length(name_groups) > 5)
        for i = 2:(length(name_groups)-5+1)
            name_groups(1) = strcat(name_groups(1), {' '}, name_groups(i));
        end
        name_groups(2) = name_groups(length(name_groups)-3);
        name_groups(3) = name_groups(length(name_groups)-2);
        name_groups(4) = name_groups(length(name_groups)-1);
        name_groups(5) = name_groups(length(name_groups)-0);
    end
    
%    name_pos = findstr(' ',files(N_file(N_faila)).name); %поиск позиций групп в названии файла
%    dot_pos = findstr('.',files(N_file(N_faila)).name); %поиск позиций точки в названии (вторая позиция - расширение файла)
    %file_N_LED = str2num(files(N_file(N_faila)).name(name_pos(1)+1:name_pos(2)-1)); %количество СИД в IES
    %mkdir(strcat(files(N_file(N_faila)).name(1:name_pos(1)-1),'-',files(N_file(N_faila)).name(name_pos(3)+1:name_pos(4)-1)));
    %New_dir = [files(N_file(N_faila)).name(1:name_pos(1)-1),' ',files(N_file(N_faila)).name(name_pos(4)+1:dot_pos(2)-1)];
    New_dir = cell2mat(name_groups(1));
    mkdir(New_dir);
    lens_eff = str2num(cell2mat(name_groups(5)))/100; %КПД линзы
    
%данные для ввода
power_LED = 1.375; %мощность одного СИД в рабочем режиме(без учёта ИП)
KLED = 1; %коэффициент для изменения потока 1 диода
stepA = 5; %шаг вывода азимутальных углов
stepP = 2; %шаг вывода полярных углов
FvLED = 230*0.85*lens_eff; %световой поток одного светодиода, умноженный на светопропускание защитного стекла. КПД оптики берётся из переменной lens_eff
Power = 2; %Мощность двойная или одинарная

flat_glass = 0; %не равно нулю если учитываем влияние плоского защитного стекла
N = [1 0 0]; %количество соотвествующих линз в светильнике
ROTOO = [0 0 0]; %матрица поворота КСС вокруг оптической оси. Поворот только в плюс - против часовой стрелки
n_glass = 1.5; %показатель преломления плоского защитного стекла
Rpcb = 0.6; %коэффициент отражения печатной платы. Для упрощения распределение отражённого света ламбертовское
%обрабатываемые кривые. Последний файл всегда 'GAUSS.IES' (файл с ламбертовским распределением для упрощения)
%filename = char(files(N_file(N_faila)).name, 'GAUSS.IES');
filename = files(N_file(N_faila)).name;
%filename_NEW = 'created.ies'; %название создаваемого файла


warning off;
%D{1,1} = 'Имя файла'; D{1,2} = 'Поляр. углы /шаг'; D{1,3} = 'Азим. углы /шаг'; D{1,4} = 'Поток в файле'; D{1,5} = 'Поток по КСС'; D{1,6} = 'КПД'; D{1,7} = 'Множитель';
%disp('          Файл                          Полярные углы /шаг                  Азимутальные углы /шаг')
CUT = 1; %переменная для запоминания номера позиции в массиве углов и сил света при выводе файла.
k = 1; %номер файла в списке
F1 = 0; %световой поток до защитного стекла
F2 = 0; %световой поток после защитного стекла
Fresult = 0; %результирующий световой поток светильника

%цикл считывания данных из файлов
%for k=1:length(filename(:,1))

    file = textread(deblank(filename), '%s', 'delimiter', '\n'); %считывание файла
    stroka = 1; %номер считываемой строки
    j = 1; %счётчик азимутальных углов при считывании сил света
    P = 0;  %количество полярных углов в файле
    A = 0;  %количество азимутальных углов в файле
    X = 0;Y = 0;Xi = 0;Yi = 0;I = 0;Ii = 0;Imark = 0;Is = 0;
    cause = 1; %флаг для циклов while
    angleP = 0;
    angleA = 0;
    [m n] = size(file); %берём количество строк в файле
    i = 1; %номер строки
    str = cell2mat(strread(file{i,1}, '%s')); %считывание строки
    i = i+1;
    while (~strncmp(str, 'TILT', 4)) %пропускаем все строки и доходим до начала данных после этой строки
        str = cell2mat(strread(file{i,1}, '%s','whitespace', ''));
        i = i+1;
    end
    str = strread(file{i,1}); %считываем строку с параметрами светильника и ксс
    Fies = str(2); % световой поток, указанный в файле
    M = str(3); %множитель
    P = str(4); %количество полярных углов
    A = str(5); %количество азимутальных углов
    i = i+1; %следующая строка
    str = strread(file{i,1}); %считываем строку с мощностью светильника
    power = str(3); %мощность светильника
    %power_LED = power/str2num(files(N_file(N_faila)).name(name_pos(1)+1:name_pos(2)-1));
    i = i+1; %следующая строка
    while (cause) %цикл для считывания полярных углов
        str = str2num(file{i,1}); %считываем первую строку полярных углов
        if (angleP == 0)
            angleP = str; %запись первой строки углов
        else
            angleP(length(angleP)+1:length(angleP)+length(str)) = str(1:end); %запись последующих строк углов, если они в ies файле не уместились на одной строке
        end
        i = i+1;
        if (length(angleP) == P) %если количество считанных значений равно числу полярных углов, то завершаем цикл
            cause = 0;
        end
    end
    cause = 1; 
    while (cause) %цикл считывания азимутальных углов. Аналогично полярным углам
        str = str2num(file{i,1}); %считываем азимутальные углы
        if (angleA == 0)
            angleA = str;
        else
            angleA(length(angleA)+1:length(angleA)+length(str)) = str(1:end);
        end
        i = i+1;
        if (length(angleA) == A)
            cause = 0;
        end
    end
    for i=i:m %цикл считывания значений сил света. Аналогично считыванию углов
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
    end
%    if (length(filename(k,:)) >= 19)%запись имени файла
%        D{k+1,1} = deblank(filename(k,1:19)); 
%   else
%        D{k+1,1} = deblank(filename(k,:));
%    end
%    D{k+1,2} = strcat(num2str(angleP(1)), '-', num2str(angleP(end)), ' /', num2str(angleP(2)-angleP(1))); %запись полярных углов, указанных в файле и шага
%    if (A == 1) %запись азмутальных углов, указанных в файле и шага
%        D{k+1,3} = strcat('0 /0');
%    else
%        D{k+1,3} = strcat(num2str(angleA(1)), '-', num2str(angleA(end)), ' /', num2str(angleA(2)-angleA(1)));
%    end
%    D{k+1,4} = num2str(Fies); %световой поток источника, указанный в фотометрическом файле
%    D{k+1,7} = num2str(M); %множитель, указанный в фотометрическом файле
    %дополнение недостающих азимутальных и полярных углов.
    if (A == 1) %если источник осесимметричный (один полярный угол), копируем его в пределах углов 0-90 градусов
        for i=1:90+1
            angleA(i) = 0 + (i-1);
            I(i,:) = I(1,:);
        end
        A = length(angleA);
    end
    %создание сетки для интерполирования с шагом 1 градус
    [X, Y] = meshgrid(0:(angleP(end))/(P-1):angleP(end), angleA(1):(angleA(end)-angleA(1))/(A-1):angleA(end));
    [Xi, Yi] = meshgrid(0:1:angleP(end), angleA(1):1:angleA(end));
    angleP = 0:1:angleP(end);
    Ii = interp2(X, Y, I, Xi, Yi, 'spline'); %интерполирование бикубическим сплайном
    if (angleP(end) < 180) %дополнение полярных углов до 180 градусов, если информация отсуствет, то силы света в этих направлениях равны 0
        while (angleP(end) ~= 180)
           angleP(end+1) = angleP(end) + 1;
           Ii(:, end+1) = 0;
        end
        [A, P] = size(Ii);
        angleA = angleA(1):1:angleA(end);
    end
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
    A = length(angleA);
    P = length(angleP);
    Fsum = 0; %световой поток по КСС
     for i=1:P-1 %подсчёт светового потока по КСС
        Is = 0; %сила света в шаровом слое
        for j=1:A-1
            Is = Is + (Ii(j, i) + Ii(j, i+1))/2;
        end
       % disp(i);
       % (Is/(j))*2*pi*(cos(angleP(i)*pi/180)-cos(angleP(i+1)*pi/180))
        Fsum = Fsum + (Is/(j))*2*pi*(cos(angleP(i)*pi/180)-cos(angleP(i+1)*pi/180));
    end
    Fsum = Fsum;
    Iall(:,:,1) = Ii; %сохраняем силы света всех считанных КСС
    Fall = Fsum; %сохраняем световые потоки всех считанных КСС
%    D{k+1,5} = Fsum; %расчитанный световой поток по КСС
%    D{k+1,6} = Fsum/Fies; %соотношение расчитанного и заднного в файле световых потоков
%end   
%конец цикла считывания из файлов  



    %FvLED = KLED*Fall/file_N_LED; %световой поток 1 СИД в создаваемых IES
    
    
    Eff = 105.745; %целевая эффективность светильника
    cd(New_dir); %переход в каталог

    
%цикл создания файлов с одинаковыми КСС    
    for N_faila_new = 1:length(N_LED) 
        N = [N_LED(N_faila_new) 0 0];

        P_LEDS = N_LED(N_faila_new)*power_LED; %мощность светодиодов в сетильнике
        Power_suply_eff = 0.9327*exp(-((N_LED(N_faila_new)-70.27)/82.05).^2) + ...
            0.03006*exp(-((N_LED(N_faila_new)-11.13)/7.781).^2) + ...
                  0.2627*exp(-((N_LED(N_faila_new)-11.52)/31.2).^2); %функция расчёта эффективности ИП от мощности диодов
        if (Power_suply_eff < 0.88)
            %жулим, если КПД ИП оказывается меньше 0,9
            Power_suply_eff = 0.88;% + 0.002*(rand-0.5); %дополнительно вносится случайный шум в КПД макс +-0,005
        end
        Power_suply_eff = 0.85;
    
    %FvLED = ((round(power_LED*N_LED(N_faila_new)/5)*5)/N_LED(N_faila_new))*Eff; %вычисление потока СИД на основе целевой эффективности светильника
    
    %имя нового файла
    %filename_NEW = strcat(files(N_file(N_faila)).name(1:name_pos(1)-1),'-', num2str(N_LED(N_faila_new)),'-',...
    %    files(N_file(N_faila)).name(name_pos(2)+1:name_pos(3)-1),'-',num2str(round(power_LED*N_LED(N_faila_new)/5)*5),...
    %    '-', files(N_file(N_faila)).name(name_pos(4)+1:dot_pos(2)-1), '.ies');
%    filename_NEW = [files(N_file(N_faila)).name(1:name_pos(1)-1),' ', L_NEW(N_faila_new,:),' ',...
%        files(N_file(N_faila)).name(name_pos(1)+1:name_pos(2)-1),' ',files(N_file(N_faila)).name(name_pos(2)+1:name_pos(3)-1),...
%        ' P', num2str(Power), '', '.ies'];
    filename_NEW = cell2mat(strcat(name_groups(1), {' '}, name_groups(2), {' '}, name_groups(3), ' P', num2str(Power), {'.ies'}));
    
    Iresult = Iall(:,:)*(N(1)*FvLED/Fall); %суммарная кривая с учётом количества светильников и потока светодиодов

    Fresult = 0;
    for i=1:P-1 %подсчёт результирующего светового потока светильника
            Is = 0; %сила света в шаровом слое
            for j=1:A-1
                Is = Is + (Iresult(j, i) + Iresult(j, i+1))/2; %сила света в шаровом слое
            end
            Fresult = Fresult + (Is/(j))*2*pi*(cos(angleP(i)*pi/180)-cos(angleP(i+1)*pi/180));
        
    end



%polar(angleP*pi/180, Iresult(1,:))
%polar((-angleP)*pi/180, Iresult(181,:))
%polar((angleP)*pi/180, Iresult(91,:), 'r')
%polar((-angleP)*pi/180, Iresult(271,:), 'r')

%вывод файла

fid = fopen(filename_NEW, 'w'); 
fprintf(fid, 'IESNA:LM-63-1995\r\n');
fprintf(fid, '[TEST]\r\n');
fprintf(fid, '[DATA]\r\n');
%fprintf(fid, '[TESTLAB] MATLAB\r\n');
%fprintf(fid, '[TESTDATE]\r\n');
fprintf(fid, '[MANUFAC] L1 LED\r\n');
fprintf(fid, '[LUMCAT]\r\n');
%fprintf(fid, strcat('[LUMINAIRE] ', ([' ', files(N_file(N_faila)).name(1:name_pos(1)-1),' ', L_NEW(N_faila_new,:),' ',...
%        files(N_file(N_faila)).name(name_pos(1)+1:name_pos(2)-1),' ',files(N_file(N_faila)).name(name_pos(2)+1:name_pos(3)-1),...
%        ' P', num2str(Power), '', '\r\n'])));
fprintf(fid, cell2mat(strcat('[LUMINAIRE]', {' '}, strcat(name_groups(1), {' '}, name_groups(2), {' '}, name_groups(3),...
    ' P', num2str(Power), '\r\n'))));
fprintf(fid, '[ISSUEDATE]\r\n');
fprintf(fid, '[MORE] В файле указан поток светильника\r\n');
%if (length(filename(:,1)) > 2)
%for i=2:length(filename(:,1))-1 
%    fprintf(fid, strcat('+', num2str(N(i)), 'x', filename(i,1:7)));
%end;
%end;
%fprintf(fid, '\r\n');
%fprintf(fid, '[LAMPCAT]\r\n');
%fprintf(fid, '[LAMP]');
%for i=1:length(filename(:,1))-1
%    fprintf(fid, strcat(' +', num2str(N(i)), 'x', filename(i,1:7)));
%end
%fprintf(fid, '\r\n');
%fprintf(fid, '[OTHER] Моделирование КСС из разных ies\r\n');
fprintf(fid, 'TILT=NONE\r\n');
Iresult = Iresult/(Fresult/1000);
temp = mat2str([1 round(Fresult*1000)/1000 round(Fresult)/1000 angleP(end-90)/stepP+1 angleA(end)/stepA+1 ...
    1 2 shirina(N_faila_new) dlina(N_faila_new) visota(N_faila_new)]);
fprintf(fid, strcat(temp(2:end-1), '\r\n'));
%fprintf(fid, '1 1 1\r\n');
fprintf(fid, strcat(['1 1 ' num2str(round((P_LEDS/Power_suply_eff)/1)*1)],'\r\n'));

Iresult = round(Iresult*1000)/1000;
Iresult(:,1) = Iresult(1,1);
CUT = 1;
for i = 1:stepP:length(angleP)-90 %вывод полярных углов
    temp = mat2str(angleP(CUT:stepP:i));
    if ((length(temp) >= 120) || (i == length(angleP)-90))
        fprintf(fid, strcat(temp(2:end-1), '\r\n')); %запись со второго элемента, потому что в первом элементе сивол '['. Аналогично до end-1
        temp = 0;
        CUT = i+stepP;
    end
end
CUT = 1;
for i = 1:stepA:length(angleA) %вывод азимутальных углов
    temp = mat2str(angleA(CUT:stepA:i));
    if ((length(temp) >= 120) || (i == length(angleA)))
        fprintf(fid, strcat(temp(2:end-1), '\r\n'));
        temp = 0;
        CUT = i+stepA;
    end
end
for i=1:stepA:length(angleA) %вывод значений сил света
    CUT = 1;
    for j=1:stepP:length(angleP)-90
        temp = mat2str(Iresult(i, CUT:stepP:j));
        if ((length(temp) >= 120) || (j == length(Iresult(i,:))-90))
            if (temp(1) == '[')
                fprintf(fid, strcat(temp(2:end-1), '\r\n'));
            else
                fprintf(fid, strcat(temp(1:end), '\r\n'));
            end
            temp = 0;
            CUT = j+stepP;
        end
    end
end
fclose(fid);
%D_new{1, 1} = 'Созданный файл';
%D_new{1,2} = 'Поляр. углы /шаг'; D_new{1,3} = 'Азим. углы /шаг'; D_new{1,4} = 'Поток в файле'; D_new{1,5} = 'Поток по КСС'; D_new{1,6} = 'КПД'; D_new{1,7} = 'Множитель';
%D_new{2, 1} = filename_NEW; 
%D_new{2, 2} = strcat(num2str(angleP(1)), '-', num2str(angleP(end)-90), ' /', num2str(stepP));
%D_new{2, 3} = strcat(num2str(angleA(1)), '-', num2str(angleA(end)), ' /', num2str(stepA));
%D_new{2, 4} = num2str(round(Fresult*1000)/1000);
%D_new{2, 5} = num2str(Fresult);
%D_new{2, 6} = num2str(Fresult/(round(Fresult*1000)/1000));
%D_new{2, 7} = num2str(round(Fresult)/1000);
%disp(D_new)

file_count = file_count+1;
%disp(strcat(num2str(file_count), '/', num2str(file_all)));
disp([filename_NEW, ' ', num2str(round(10*P_LEDS/Power_suply_eff)/10) ' - '...
    num2str(round((P_LEDS/Power_suply_eff)/5)*5) '   ' num2str(FvLED*N(1)) '  ' num2str(FvLED*N(1)/(round((P_LEDS/Power_suply_eff)/5)*5))])

end
cd('..');%выход из каталога
end
if length(N_file)==0
    disp('ies-файлы в дирректории отсутсвуют');
end

clc
close all
clear all
% Общая логика работы программы:
% 1. Считывание данных, которые должны быть в выходном файле
% 2. Сортировка считанных данных по стобце КСС
% 3. Считывание КСС
% 4. Интерполирование КСС с шагом 1 градус
% 5. Поворот КСС
% 6. Интерполирование КСС с заданным шагом
% 6. Нормирование КСС по требуемому потоку
% 7. Создание/переход в нужную папку для сохранения файла
% 8. Сохранение файла
% Данные между модулями передаются в формате структур
% Есть регулярный источник ошибок из-за произвольного присваивания типов
% данным из ячеек. Ячейки могут считываться с типом cell или numeric, char
% в зависимости от конфигурации входного xlsx файла, но борьба с этим
% продолжается.

inputFileName = 'input.xlsx'; % имя входного файла с данными
iesResult = struct('standart','IESNA:LM-63-1995\r\n',...
    'test',' www.martinirus.ru\r\n',...
    'data',[datestr(datetime('now'),'mm.dd.yyyy'), '\r\n'],...
    'manufac',' MARTINI RUS\r\n',...
    'lumcat',' Артикул\r\n','luminaire',' Светильник\r\n',...
    'lampcat','\r\n','lamp',' СИД\r\n',...
    'balastcat','\r\n','other',' Light color\r\n',...
    'more','\r\n','tilt','TILT=NONE\r\n'); % предварительное заполнение шапки параметров ies файла

fouts = xlsRead(inputFileName); % список всех считанных данных из входного файла
len = length(fouts);
% цикл перебора всех входных данных, формирование структуры данных для
% заполнения выходного файла и запись файла в каждой итерации цикла
for i = 1:len 
    fout = fouts(i); % для удобства
    iesResult.code = cell2mat(fout.art); % артикул
    iesResult.name = cell2mat(fout.name); % название
    if (isempty(iesResult.name)) % проверка, чтобы не генерировать ошибочные КСС
        disp(['Наименование в строке ' num2str(i) ' не указанo. Пропуск записи.']);
        continue;
    end;
    iesResult.version = cell2mat(fout.version); % версия - дополнительный параметр используется для наименования
    if(isnumeric(iesResult.version)) iesResult.version = int2str(iesResult.version); end;
    iesResult.optics = cell2mat(fout.optics); % тип оптики
    iesResult.cct = cell2mat(fout.cct); % ТЦ/цвет
    
    if(isnan(fout.P)) % проверка, чтобы не генерировать ошибочные КСС
        disp(['Мощность не указана или не числовая, пропуск записи ' num2str(i+1)]);
        continue;
    end;
    iesResult.power = fout.P;
    
    if(isnan(fout.F)) % проверка, чтобы не генерировать ошибочные КСС
        disp(['Поток не задан или не числовой, пропуск записи ' num2str(i+1)]);
        continue;
    end;
    iesResult.F = fout.F;
    
    iesResult.more1 = cell2mat(fout.more1); % дополнительное свойство, вычленное из входного наименования
    iesResult.more2 = cell2mat(fout.more2); % дополнительное свойство, вычленное из входного наименования
    iesResult.more3 = cell2mat(fout.more3); % дополнительное свойство, вычленное из входного наименования
    iesResult.more4 = cell2mat(fout.more4); % дополнительное свойство, вычленное из входного наименования
    if (strcmp(iesResult.more1, 'DALI')) % добавление к артикулу
        iesResult.code = [iesResult.code 'DD'];
    end;
    if (strcmp(iesResult.more3, 'RGBW')) % добавление к артикулу
        iesResult.code = [iesResult.code 'RGBW'];
    end;
    if((strcmp(iesResult.more1, 'DMX')||strcmp(iesResult.more1, 'DMX-RDM')) && ~strcmp(iesResult.more3, 'RGBW'))  % добавление к артикулу
        iesResult.code = [iesResult.code 'DMX'];
    end;
    if (strcmp(iesResult.more2, '5 DEG'))  % добавление к артикулу
        iesResult.code = [iesResult.code 'U'];
    end;
    if (strcmp(iesResult.more4, 'сквоз. провод'))  % добавление к артикулу
        iesResult.code = [iesResult.code 'M'];
    end;
      
    if (isnan(fout.H)) % проверка, чтобы не генерировать ошибочные КСС
        disp(['Высота не задана или не числовая, пропуск записи ' num2str(i+1)]);
        continue;
    end;
        iesResult.height = fout.H;
    
    if (isnan(fout.L)) % проверка, чтобы не генерировать ошибочные КСС
        disp(['Длина не задана или не числовая, пропуск записи ' num2str(i+1)]);
        continue;
    end;
        iesResult.lenght = fout.L;
    
    if (isnan(fout.W)) % проверка, чтобы не генерировать ошибочные КСС
        disp(['Ширина не задана или не числовая, пропуск записи ' num2str(i+1)]);
        continue;
    end;
        iesResult.width = fout.W;
    
    if (isnan(fout.dP))
        disp(['Шаг интерполяции полярных углов не задан, значение по умолчанию 2']);
        iesResult.dP = 2;
    else
        iesResult.dP = fout.dP;
    end;
    if (isnan(fout.dA) || ~isnumeric(fout.dA))
        disp(['Шаг интерполяции азимутальных углов не задан, значение по умолчанию 2']);
        iesResult.dA = 2;
    else
        iesResult.dA = fout.dA;
    end;
    
    if(isnan(fout.rot))
        disp(['Угол поворота не задан, значение по умолчанию 0']);
        rot = 0;
    else
        rot = fout.rot; % Угол поворота КСС
    end;
    
    ies = iesRead(cell2mat(fout.ies)); % Чтение файла
    % читать можно и заранее все файлы в папке, но это улучшение на
    % будущее. Чтение занимает всего несколько десятков мс.
    if (~isstruct(ies))
        continue;
    end;
    
    if (rot)
        ies2 = iesInterpolate(ies, 1, 1); % сначала интерполяция с малым шагом
        ies2 = iesRotor(ies2, rot); % поворот
        ies2 = iesInterpolate(ies2, iesResult.dA, iesResult.dP); % интерполяция с заданным шагом, 
        % если интерполироваться сразу с заданным шагом, а он довольно грубый, а поворот на
        % произвольный угол, то получится некорректный результат
    else
        ies2 = iesInterpolate(ies, iesResult.dA, iesResult.dP);
    end;
    
    % iesView(ies, ies2); % отображение КСС
    ies3 = iesNormalize(ies2, 1000); % приведение сил света к 1000 лм
    
%     disp(['Поток в исходном файле: ' num2str(iesFlux(ies.I)) ' лм']);
%     disp(['Поток в интерполированном файле: ' num2str(iesFlux(ies2.I)) ' лм']);
%     disp(['Поток в файле после нормирования: ' num2str(iesFlux(ies3.I)) ' лм']);
    
    % заполнение остальных полей структуры данных
    iesResult.Nlamp = 1;
    iesResult.M = iesResult.F/1000;
    iesResult.P = ies3.P;
    iesResult.A = ies3.A;
    iesResult.type = 1;
    iesResult.system = 2;
    iesResult.kb = 1;
    iesResult.vers = 1;
    iesResult.angleP = ies3.angleP;
    iesResult.angleA = ies3.angleA;
    iesResult.I = ies3.I;
    
    iesSave(iesResult); % сохранение файла
    disp([num2str(floor(100*i/len)) '%']);
end;
disp('Программа завершена');













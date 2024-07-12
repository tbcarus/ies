% функци€ простого сохранени€ ies файла дл€ простого переворота ies

function f = iesSaveSimple(ies)
lumName = [ies.name]; % формирование названи€ светильника
lumName = strtrim(lumName); % убрать пробелы по кра€м
lumName = regexprep(lumName, '\s+', ' '); % убрать лишние пробелы между словами
filename = [strtrim([ies.name '-flipped']) '.ies']; % формирование имени файла
Iresult = ies.I; % дл€ удобства
Iresult = round(Iresult*1000)/1000; % убрать лишие цифры в дес€тичной дроби

%вывод файла
fid = fopen(filename, 'w'); 
fprintf(fid, ies.standart);
fprintf(fid, ['[TEST]' ies.test]);
fprintf(fid, ['[DATA] ' ies.data]);
fprintf(fid, ['[MANUFAC]' ies.manufac]);
fprintf(fid, ['[LUMCAT] ' '\r\n']);
fprintf(fid, ['[LUMINAIRE] ' lumName '\r\n']);
fprintf(fid, ['[LAMPCAT]' ies.lampcat]);
fprintf(fid, ['[LAMP]' ies.lamp]);
fprintf(fid, ['[OTHER] ' '\r\n']);
fprintf(fid, ['[MORE]' ies.more]);
fprintf(fid, ies.tilt);

fprintf(fid, [mat2str(ies.Nlamp) ' ' mat2str(ies.F) ' ' mat2str(ies.M) ...
     ' ' mat2str(ies.P) ' ' mat2str(ies.A) ' ' mat2str(ies.type) ...
     ' ' mat2str(ies.system) ' ' mat2str(ies.width) ...
     ' ' mat2str(ies.length) ' ' mat2str(ies.height) '\r\n']);
fprintf(fid, [mat2str(ies.kb) ' ' mat2str(ies.vers) ' ' mat2str(ies.power) '\r\n']);

%вывод пол€рных углов
CUT = 1;
stepP = ies.angleP(end)/(ies.P-1);
for i = 1:1:length(ies.angleP)
    temp = mat2str(ies.angleP(CUT:1:i));
    if ((length(temp) >= 120) || (i == length(ies.angleP)))
        if (temp(1) == '[') % если в переменной temp более одного значени€, то будут []
            fprintf(fid, strcat(temp(2:end-1), '\r\n')); %запись со второго элемента, потому что в первом элементе сивол '['. јналогично до end-1
        else
            fprintf(fid, strcat(temp(1:end), '\r\n')); % если элемент всего 1, то [] не будет
        end
        temp = 0;
        CUT = i+1;
    end
end

%вывод азимутальных углов
CUT = 1;
stepA = ies.angleA(end)/(ies.A-1);
for i = 1:1:length(ies.angleA)
    temp = mat2str(ies.angleA(CUT:1:i));
    if ((length(temp) >= 120) || (i == length(ies.angleA)))
        if (temp(1) == '[') % если в переменной temp более одного значени€, то будут []
            fprintf(fid, strcat(temp(2:end-1), '\r\n')); %запись со второго элемента, потому что в первом элементе сивол '['. јналогично до end-1
        else
            fprintf(fid, strcat(temp(1:end), '\r\n')); % если элемент всего 1, то [] не будет
        end
        temp = 0;
        CUT = i+1;
    end
end

%вывод значений сил света
for i=1:1:length(ies.angleA)
    CUT = 1;
    for j=1:1:length(ies.angleP)
        temp = mat2str(Iresult(i, CUT:1:j));
        if ((length(temp) >= 120) || (j == length(Iresult(i,:))))
            if (temp(1) == '[')
                fprintf(fid, strcat(temp(2:end-1), '\r\n'));
            else
                fprintf(fid, strcat(temp(1:end), '\r\n'));
            end
            temp = 0;
            CUT = j+1;
        end
    end
end

fclose(fid);
    disp(['‘айл ' ies.name ' .......записан']);
end

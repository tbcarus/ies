% функция считывания данных из эксель файла

function f = xlsRead(filename)

fin = readtable(filename,'ReadRowNames',true); % считанный файл
iesData = struct(); % структура выходных данных
for i = 1:height(fin)
    if (iscell(fin.Art(i))) iesData(i).art = fin.Art(i); else iesData(i).art = {fin.Art(i)}; end; % артикул
    if (isnan(cell2mat(iesData(i).art))) iesData(i).art = {''}; end;
    iesData(i).name = fin.Name(i); % название
    
    % все поля, кроме гарантированно цифровых переводятся в формат cell для удобства,
    % так как, если в столбце присутсвуют не только цифры, то стичан будет
    % cell, если только цифры, то будет numeric.
    if (iscell(fin.Version(i))) iesData(i).version = fin.Version(i); else iesData(i).version = {fin.Version(i)}; end;
    if (isnan(cell2mat(iesData(i).version))) iesData(i).version = {''}; end;
    
    iesData(i).optics = fin.Optics(i);
    iesData(i).ies = fin.IES(i);
    iesData(i).cct = fin.CCT(i);
    iesData(i).P = str2double(fin.P(i));
    if (isnumeric(fin.F(i))) iesData(i).F = fin.F(i); else iesData(i).F = str2double(fin.F(i)); end;
    if (iscell(fin.More1(i))) iesData(i).more1 = fin.More1(i); else iesData(i).more1 = {fin.More1(i)}; end;
    if (isnan(cell2mat(iesData(i).more1))) iesData(i).more1 = {''}; end;
    if (iscell(fin.More2(i))) iesData(i).more2 = fin.More2(i); else iesData(i).more2 = {fin.More2(i)}; end;
    if (isnan(cell2mat(iesData(i).more2))) iesData(i).more2 = {''}; end;
    if (iscell(fin.More3(i))) iesData(i).more3 = fin.More3(i); else iesData(i).more3 = {fin.More3(i)}; end;
    if (isnan(cell2mat(iesData(i).more3))) iesData(i).more3 = {''}; end;
    if (iscell(fin.More4(i))) iesData(i).more4 = fin.More4(i); else iesData(i).more4 = {fin.More4(i)}; end;
    if (isnan(cell2mat(iesData(i).more4))) iesData(i).more4 = {''}; end;
    if (isnumeric(fin.Height(i))) iesData(i).H = fin.Height(i); else iesData(i).H = str2double(fin.Height(i)); end;
    if (isnumeric(fin.Length(i))) iesData(i).L = fin.Length(i); else iesData(i).L = str2double(fin.Length(i)); end;
    if (isnumeric(fin.Width(i))) iesData(i).W = fin.Width(i); else iesData(i).W = str2double(fin.Width(i)); end;
    if (isnumeric(fin.dP(i))) iesData(i).dP = fin.dP(i); else iesData(i).dP = str2double(fin.dP(i)); end;
    if (isnumeric(fin.dA(i))) iesData(i).dA = fin.dA(i); else iesData(i).dA = str2double(fin.dA(i)); end;
    if (isnumeric(fin.ROT(i))) iesData(i).rot = fin.ROT(i); else iesData(i).rot = str2double(fin.ROT(i)); end;
end

f = iesData;
end
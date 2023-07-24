function f = xlsRead()

fin = readtable('input-f.xlsx','ReadRowNames',true);
iesData = struct();
for i = 1:height(fin)
    iesData(i).art = fin.Art(i);
    iesData(i).name = fin.Name(i);
    iesData(i).version = fin.Version(i);
    iesData(i).optics = fin.Optics(i);
    iesData(i).ies = fin.IES(i);
    iesData(i).cct = fin.CCT(i);
    iesData(i).P = fin.P(i);
    iesData(i).F = fin.F(i);
    iesData(i).more1 = fin.More1(i);
    iesData(i).more2 = fin.More2(i);
    if (isnan(iesData(i).more2))
        iesData(i).more2 = '';
    end;
    iesData(i).more3 = fin.More3(i);
    if (isnan(iesData(i).more3))
        iesData(i).more3 = '';
    end;
    iesData(i).H = fin.Height(i);
    iesData(i).L = fin.Length(i);
    iesData(i).W = fin.Width(i);
    iesData(i).dP = fin.dP(i);
    iesData(i).dA = fin.dA(i);
    iesData(i).rot = fin.ROT(i);
end

f = iesData;
end
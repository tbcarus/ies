% Отражение КСС относительно горизонтальной плоскости
% Проверок входных данных пока нет

function f = iesMirror(ies, plane)
I = ies.I;
aMirrored = 0;
if(strcmp(plane, Planes.C0180))
    aMirrored = (360 - ies.angleA);
end
if(strcmp(plane, Planes.C90270))
    aMirrored = mod((180 - ies.angleA), 360);
end
assert(aMirrored(1)~=0, 'Не указана плоскость отражения');

[~, aMirroredIdx] = ismember(aMirrored, ies.angleA);
Imirrored = I(aMirroredIdx, :);
iesResult = ies;
iesResult.I = Imirrored;
disp(['КСС отражена относительно плоскости ', plane]);
f = iesResult;
end



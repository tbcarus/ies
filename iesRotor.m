% Поворот КСС вокруг оптической оси (ось пересечения плоскостей 0-180 и
% 90-270. Положительное направление против часовой стрелки

function f = iesRotor(ies, rot)
I = ies.I;
stepA = 360/(length(I(:,1))-1);
Ii(1:length(I(:,1)), 1:length(I(1,:))) = 0;
Ii(1:floor(rot/stepA),:) = I(end-(floor(rot/stepA)-1):end,:);
Ii(floor(rot/stepA)+1:end,:) = I(1:end-floor(rot/stepA),:);
iesResult = ies;
iesResult.I = Ii;
disp(['КСС повернута на ' num2str(rot) ' градусов']);
f = iesResult;
end
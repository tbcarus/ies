% Отражение КСС относительно горизонтальной плоскости

function f = iesFlip(ies)
I = ies.I;
Iflipped = fliplr(I);
iesResult = ies;
iesResult.I = Iflipped;
disp('КСС отражена относительно гризонтальной оси');
f = iesResult;
end
function [Iplanes, thetaPlotDeg, hFig, hAx] = plotIesAzimutPlanes(iesResult, planesDeg, normalize)
% Строит полные сечения фотометрического тела в полярной системе координат
% для заданных азимутальных плоскостей.
%
% Вход:
%   iesResult  - структура с полями:
%                angleP : вектор полярных углов, градусы (0...180)
%                angleA : вектор азимутальных углов, градусы (0...360)
%                I      : матрица сил света
%                         размер: [numel(angleA) x numel(angleP)]
%                F      : световой поток, лм
%
%   planesDeg  - вектор азимутальных плоскостей в градусах,
%                например [0 10 45 90]
%
% Выход:
%   Iplanes      - матрица полных сечений в кд/клм
%   thetaPlotDeg - вектор углов (0...360)
%   hFig         - handle figure
%   hAx          - handle polaraxes
%
% Пример вызова:
%   plotIesAzimutPlanes(iesResult, [0 10 45 90], true); кд/клм
%   plotIesAzimutPlanes(iesResult, [0 10 45 90], falde); кд

    %% Проверка входов
    if nargin < 2
        error('Нужно передать минимум два аргумента: iesResult и planesDeg, [normalize].');
    end

    if nargin < 3
        normalize = false;
    end

    requiredFields = {'angleP', 'angleA', 'I', 'F'};
    for k = 1:numel(requiredFields)
        if ~isfield(iesResult, requiredFields{k})
            error('В структуре iesResult отсутствует поле "%s".', requiredFields{k});
        end
    end

    angleP = iesResult.angleP(:).';
    angleA = iesResult.angleA(:);
    I = iesResult.I;
    F = iesResult.F;

    planesDeg = planesDeg(:);

    %% Нормировка к кд/клм
    if normalize
        Inorm = I / (F / 1000);
        unitLabel = 'кд/клм';
    else
        Inorm = I;
        unitLabel = 'кд';
    end

    %% Нормализация углов
    planesDeg = mod(planesDeg, 360);

    %% Проверка наличия плоскостей
    tol = 1e-9;
    for k = 1:numel(planesDeg)
        if ~any(abs(angleA - planesDeg(k)) < tol)
            error('Плоскость %.6g° отсутствует в iesResult.angleA.', planesDeg(k));
        end
        if ~any(abs(angleA - mod(planesDeg(k)+180,360)) < tol)
            error('Противоположная плоскость отсутствует.');
        end
    end

    %% Формирование полной угловой оси
    thetaPlotDeg = [angleP, 180 + angleP(2:end)];
    Iplanes = zeros(numel(planesDeg), numel(thetaPlotDeg));

    %% Формирование сечений
    for k = 1:numel(planesDeg)
        c1 = planesDeg(k);
        c2 = mod(c1 + 180, 360);

        idx1 = find(abs(angleA - c1) < tol, 1);
        idx2 = find(abs(angleA - c2) < tol, 1);

        I1 = Inorm(idx1, :);
        I2 = Inorm(idx2, :);

        Iplanes(k, :) = [I1, fliplr(I2(1:end-1))];
    end

    %% Построение
    hFig = figure('Color','w');
    hAx = polaraxes(hFig);
    hold(hAx,'on');

    thetaRad = deg2rad(thetaPlotDeg);

    for k = 1:numel(planesDeg)
        polarplot(hAx, thetaRad, Iplanes(k,:), ...
            'LineWidth',1.5, ...
            'DisplayName',sprintf('C%g',planesDeg(k)));
    end

    %% Оформление
    hAx.ThetaZeroLocation = 'bottom';
    hAx.ThetaDir = 'clockwise';
    hAx.ThetaLim = [0 360];

    hAx.ThetaTick = [0 30 60 90 120 150 180 210 240 270 300 330];
    hAx.ThetaTickLabel = {'0','30','60','90','120','150','±180', ...
                          '-150','-120','-90','-60','-30'};

    grid(hAx,'on');
    hAx.GridLineStyle = '--';
    hAx.MinorGridLineStyle = '--';

    title(hAx,['Сечение фотометрического тела, ', unitLabel]);
    legend(hAx,'show','Location','best');
end
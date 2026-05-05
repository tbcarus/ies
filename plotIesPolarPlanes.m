function [Icuts, thetaPlotDeg, hFig, hAx] = plotIesPolarPlanes(iesResult, gammaDeg, normalize)
% plotIesPolarGammaCutsNorm
% Строит сечения фотометрического тела для заданных полярных углов gamma.
%
% Вход:
%   iesResult  - структура с полями:
%                angleP : вектор полярных углов, градусы (0...180)
%                angleA : вектор азимутальных углов, градусы (0...360)
%                I      : матрица сил света
%                         размер: [numel(angleA) x numel(angleP)]
%                F      : световой поток, лм
%
%   gammaDeg   - вектор полярных углов, градусы,
%                например [30 60 90]
%
% Выход:
%   Icuts       - матрица сечений в кд/клм
%   thetaPlotDeg - вектор азимутальных углов для построения
%   hFig        - handle figure
%   hAx         - handle polaraxes
%
% Пример вызова:
%   plotIesPolarPlanes(iesResult, [30 60 90], true); кд/клм
%   plotIesPolarPlanes(iesResult, [30 60 90], false); кд

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
    angleA = iesResult.angleA(:).';
    I = iesResult.I;
    F = iesResult.F;

    gammaDeg = gammaDeg(:).';

    %% Проверка размеров
    [nA, nP] = size(I);

    if nA ~= numel(angleA)
        error('Число строк в iesResult.I должно совпадать с длиной iesResult.angleA.');
    end

    if nP ~= numel(angleP)
        error('Число столбцов в iesResult.I должно совпадать с длиной iesResult.angleP.');
    end

    if ~isscalar(F) || ~isnumeric(F) || ~isfinite(F) || F <= 0
        error('iesResult.F должен быть положительным конечным скаляром в люменах.');
    end

    if isempty(gammaDeg)
        error('Список полярных углов gammaDeg пуст.');
    end

    %% Нормировка к кд/клм
    if normalize
        Inorm = I / (F / 1000);
        unitLabel = 'кд/клм';
    else
        Inorm = I;
        unitLabel = 'кд';
    end

    %% Проверка наличия заданных полярных углов
    tol = 1e-9;

    for k = 1:numel(gammaDeg)
        if ~any(abs(angleP - gammaDeg(k)) < tol)
            error('Полярный угол %.6g° отсутствует в iesResult.angleP.', gammaDeg(k));
        end
    end

    %% Подготовка азимутальной оси
    % Если 360° отсутствует, но есть 0°, добавляем 360° как копию 0°,
    % чтобы кривая была замкнутой.
    thetaPlotDeg = angleA;
    Iplot = Inorm;

    has0 = any(abs(angleA - 0) < tol);
    has360 = any(abs(angleA - 360) < tol);

    if has0 && ~has360
        idx0 = find(abs(angleA - 0) < tol, 1, 'first');
        thetaPlotDeg = [thetaPlotDeg, 360];
        Iplot = [Iplot; Inorm(idx0, :)];
    end

    %% Формирование сечений
    Icuts = zeros(numel(gammaDeg), numel(thetaPlotDeg));

    for k = 1:numel(gammaDeg)
        idxP = find(abs(angleP - gammaDeg(k)) < tol, 1, 'first');

        % Для фиксированного gamma берём все значения по азимуту C
        Icuts(k, :) = Iplot(:, idxP).';
    end

    %% Построение
    hFig = figure('Color', 'w');
    hAx = polaraxes(hFig);
    hold(hAx, 'on');

    thetaRad = deg2rad(thetaPlotDeg);

    for k = 1:numel(gammaDeg)
        polarplot(hAx, thetaRad, Icuts(k, :), ...
            'LineWidth', 1.5, ...
            'DisplayName', sprintf('\\gamma%g', gammaDeg(k)));
    end

    %% Оформление
    hAx.ThetaZeroLocation = 'top';
    hAx.ThetaDir = 'clockwise';
    hAx.ThetaLim = [0 360];

    hAx.ThetaTick = 0:30:330;
    hAx.ThetaTickLabel = {'0','30','60','90','120','150','180', ...
                          '210','240','270','300','330'};

    grid(hAx, 'on');
    hAx.GridLineStyle = '--';
    hAx.MinorGridLineStyle = '--';

    title(hAx, ['Сечение фотометрического тела по полярным углам, ', unitLabel]);
    legend(hAx, 'show', 'Location', 'best');
end
fig = uifigure('Name', 'PID制御 応答比較シミュレーター', 'Position', [80 80 980 600]);
panel = uipanel(fig, 'Title', 'ゲイン設定', 'Position', [20 20 230 560], 'FontSize', 11);
uilabel(panel, 'Text', '比例ゲイン  Kp', 'Position', [10 500 200 22], 'FontSize', 11, 'FontWeight', 'bold');
sld_p = uislider(panel, 'Limits', [0 20], 'Value', 2, 'Position', [12 480 200 3], 'MajorTicks', [0 5 10 15 20]);
lbl_p = uilabel(panel, 'Text', 'Kp = 2.0', 'Position', [10 455 200 22], 'FontSize', 10, 'HorizontalAlignment', 'center');
uilabel(panel, 'Text', '積分ゲイン  Ki', 'Position', [10 410 200 22], 'FontSize', 11, 'FontWeight', 'bold');
sld_i = uislider(panel, 'Limits', [0 10], 'Value', 1, 'Position', [12 390 200 3], 'MajorTicks', [0 2.5 5 7.5 10]);
lbl_i = uilabel(panel, 'Text', 'Ki = 1.0', 'Position', [10 365 200 22], 'FontSize', 10, 'HorizontalAlignment', 'center');
uilabel(panel, 'Text', '微分ゲイン  Kd', 'Position', [10 320 200 22], 'FontSize', 11, 'FontWeight', 'bold');
sld_d = uislider(panel, 'Limits', [0 10], 'Value', 1, 'Position', [12 300 200 3], 'MajorTicks', [0 2.5 5 7.5 10]);
lbl_d = uilabel(panel, 'Text', 'Kd = 1.0', 'Position', [10 275 200 22], 'FontSize', 10, 'HorizontalAlignment', 'center');
uilabel(panel, 'Text', '─── 定常偏差 ───', 'Position', [10 230 200 22], 'FontSize', 10, 'HorizontalAlignment', 'center');
lbl_ess = uilabel(panel, 'Text', 'P=0.33  PI=0.00  PID=0.00', 'Position', [10 205 200 22], 'FontSize', 10, 'HorizontalAlignment', 'center', 'FontColor', [0 0 0.8]);
ax = uiaxes(fig, 'Position', [265 40 695 530]);
xlabel(ax, '時間 t [s]', 'FontSize', 11); ylabel(ax, '出力 y', 'FontSize', 11);
title(ax, 'PID応答比較', 'FontSize', 13); grid(ax, 'on');
cb = @(src,evt) pid_update(sld_p, sld_i, sld_d, lbl_p, lbl_i, lbl_d, lbl_ess, ax);
sld_p.ValueChangedFcn = cb; sld_i.ValueChangedFcn = cb; sld_d.ValueChangedFcn = cb;
pid_update(sld_p, sld_i, sld_d, lbl_p, lbl_i, lbl_d, lbl_ess, ax);

function pid_update(sld_p, sld_i, sld_d, lbl_p, lbl_i, lbl_d, lbl_ess, ax)
    Kp = sld_p.Value; Ki = sld_i.Value; Kd = sld_d.Value;
    lbl_p.Text = sprintf('Kp = %.1f', Kp);
    lbl_i.Text = sprintf('Ki = %.1f', Ki);
    lbl_d.Text = sprintf('Kd = %.1f', Kd);

    r = 1; tspan = [0 20]; s0 = [0; 0; 0];
    % プラント: ÿ + ẏ + y = u（微分は測定値微分でキック回避）
    odef = @(t, s, kp, ki, kd) [ s(2); ...
        -s(2) - s(1) + ( kp*(r - s(1)) + ki*s(3) - kd*s(2) ); ...
        r - s(1) ];
    [tP, yP] = ode45(@(t,s) odef(t,s, Kp, 0,  0 ), tspan, s0);
    [tI, yI] = ode45(@(t,s) odef(t,s, Kp, Ki, 0 ), tspan, s0);
    [tD, yD] = ode45(@(t,s) odef(t,s, Kp, Ki, Kd), tspan, s0);

    lbl_ess.Text = sprintf('P=%.2f  PI=%.2f  PID=%.2f', ...
        r - yP(end,1), r - yI(end,1), r - yD(end,1));

    cla(ax);
    plot(ax, tP, yP(:,1), '-', 'LineWidth', 2); hold(ax, 'on');
    plot(ax, tI, yI(:,1), '-', 'LineWidth', 2);
    plot(ax, tD, yD(:,1), '-', 'LineWidth', 2);
    yline(ax, r, 'k--', 'LineWidth', 1);
    hold(ax, 'off'); grid(ax, 'on'); ylim(ax, [0 1.8]);
    legend(ax, {'P', 'PI', 'PID', '目標 r'}, 'Location', 'southeast');
    xlabel(ax, '時間 t [s]', 'FontSize', 11); ylabel(ax, '出力 y', 'FontSize', 11);
    title(ax, sprintf('PID応答比較   K_p=%.1f,  K_i=%.1f,  K_d=%.1f', Kp, Ki, Kd), 'FontSize', 12);
end

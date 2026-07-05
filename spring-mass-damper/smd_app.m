fig = uifigure('Name', 'ばね-マス-ダンパ シミュレーター', 'Position', [100 100 900 580]);
panel = uipanel(fig, 'Title', 'パラメータ', 'Position', [20 20 220 530], 'FontSize', 11);
uilabel(panel, 'Text', '質量 m [kg]', 'Position', [10 470 180 22], 'FontSize', 10);
sld_m = uislider(panel, 'Limits', [0.1 5], 'Value', 1.0, 'Position', [10 450 190 3]);
lbl_m = uilabel(panel, 'Text', 'm = 1.00 kg', 'Position', [10 425 190 22], 'FontSize', 10, 'HorizontalAlignment', 'center');
uilabel(panel, 'Text', 'ばね定数 k [N/m]', 'Position', [10 380 180 22], 'FontSize', 10);
sld_k = uislider(panel, 'Limits', [1 50], 'Value', 10, 'Position', [10 360 190 3]);
lbl_k = uilabel(panel, 'Text', 'k = 10.0 N/m', 'Position', [10 335 190 22], 'FontSize', 10, 'HorizontalAlignment', 'center');
uilabel(panel, 'Text', '減衰比 ζ', 'Position', [10 290 180 22], 'FontSize', 10);
sld_z = uislider(panel, 'Limits', [0.01 2.5], 'Value', 0.3, 'Position', [10 270 190 3]);
lbl_z = uilabel(panel, 'Text', 'ζ = 0.30', 'Position', [10 245 190 22], 'FontSize', 10, 'HorizontalAlignment', 'center');
lbl_info = uilabel(panel, 'Text', 'ωn = 3.16 rad/s', 'Position', [10 190 190 22], 'FontSize', 10, 'HorizontalAlignment', 'center', 'FontColor', [0 0.5 0]);
lbl_damp = uilabel(panel, 'Text', '→ 不足減衰', 'Position', [10 165 190 22], 'FontSize', 11, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'FontColor', [0 0 0.8]);
ax = uiaxes(fig, 'Position', [260 60 620 490]);
xlabel(ax, '時間 t [s]', 'FontSize', 11); ylabel(ax, '変位 x [m]', 'FontSize', 11);
title(ax, 'ばね-マス-ダンパ系の応答', 'FontSize', 13); grid(ax, 'on');
cb = @(src,evt) smd_update(sld_m, sld_k, sld_z, lbl_m, lbl_k, lbl_z, lbl_info, lbl_damp, ax);
sld_m.ValueChangedFcn = cb; sld_k.ValueChangedFcn = cb; sld_z.ValueChangedFcn = cb;
smd_update(sld_m, sld_k, sld_z, lbl_m, lbl_k, lbl_z, lbl_info, lbl_damp, ax);

function smd_update(sld_m, sld_k, sld_z, lbl_m, lbl_k, lbl_z, lbl_info, lbl_damp, ax)
    m = sld_m.Value; k = sld_k.Value; zeta = sld_z.Value;
    c = 2 * zeta * sqrt(m * k); omega_n = sqrt(k / m);
    lbl_m.Text = sprintf('m = %.2f kg', m);
    lbl_k.Text = sprintf('k = %.1f N/m', k);
    lbl_z.Text = sprintf('ζ = %.2f', zeta);
    lbl_info.Text = sprintf('ωn = %.2f rad/s', omega_n);
    if zeta < 1; lbl_damp.Text = '→ 不足減衰（振動）'; lbl_damp.FontColor = [0 0 0.8];
    elseif abs(zeta-1)<0.01; lbl_damp.Text = '→ 臨界減衰'; lbl_damp.FontColor = [0 0.6 0];
    else; lbl_damp.Text = '→ 過減衰'; lbl_damp.FontColor = [0.8 0 0]; end
    tspan = [0, max(6, 4*pi/omega_n)];
    odefun = @(t,y) [y(2); -(c/m)*y(2)-(k/m)*y(1)];
    [t, y] = ode45(odefun, tspan, [1.0; 0.0]);
    cla(ax); plot(ax, t, y(:,1), 'b-', 'LineWidth', 2); yline(ax, 0, 'k:');
    xlabel(ax, '時間 t [s]', 'FontSize', 11); ylabel(ax, '変位 x [m]', 'FontSize', 11);
    title(ax, sprintf('m=%.1fkg  k=%.1fN/m  ζ=%.2f  ωn=%.2frad/s', m, k, zeta, omega_n), 'FontSize', 12);
    grid(ax, 'on');
end

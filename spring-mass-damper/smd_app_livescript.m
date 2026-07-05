%% ばね-マス-ダンパ系 振動シミュレーション（インタラクティブ版）
% 運動方程式:
%
% $$m\ddot{x} + c\dot{x} + kx = 0$$
%
% ここで $m$：質量 [kg]、$c$：減衰係数 [N·s/m]、$k$：ばね定数 [N/m] です。
%
% このスクリプトを実行するとスライダー付きのシミュレーターが起動します。
% スライダーを動かすたびにグラフが自動更新されます。

%% シミュレーターの起動
% 以下のセルを実行してください（Ctrl+Enter または「セクションを実行」ボタン）。

% ---- ウィンドウ作成 ----
fig = uifigure('Name', 'ばね-マス-ダンパ シミュレーター（Live Script版）', ...
               'Position', [80 80 960 600]);

% ---- 左パネル（スライダー群） ----
panel = uipanel(fig, 'Title', 'パラメータ設定', ...
    'Position', [15 15 240 560], 'FontSize', 11);

% 質量 m
uilabel(panel, 'Text', '質量  m  [kg]', ...
    'Position', [10 500 210 22], 'FontSize', 11, 'FontWeight', 'bold');
sld_m = uislider(panel, 'Limits', [0.1 5.0], 'Value', 1.0, ...
    'Position', [10 478 210 3], 'MajorTicks', [0.1 1 2 3 4 5]);
lbl_m = uilabel(panel, 'Text', 'm = 1.00 kg', ...
    'Position', [10 452 210 22], 'FontSize', 10, 'HorizontalAlignment', 'center');

% ばね定数 k
uilabel(panel, 'Text', 'ばね定数  k  [N/m]', ...
    'Position', [10 405 210 22], 'FontSize', 11, 'FontWeight', 'bold');
sld_k = uislider(panel, 'Limits', [1.0 50.0], 'Value', 10.0, ...
    'Position', [10 383 210 3], 'MajorTicks', [1 10 20 30 40 50]);
lbl_k = uilabel(panel, 'Text', 'k = 10.0 N/m', ...
    'Position', [10 357 210 22], 'FontSize', 10, 'HorizontalAlignment', 'center');

% 減衰比 ζ
uilabel(panel, 'Text', '減衰比  ζ  [-]', ...
    'Position', [10 310 210 22], 'FontSize', 11, 'FontWeight', 'bold');
sld_z = uislider(panel, 'Limits', [0.01 2.50], 'Value', 0.30, ...
    'Position', [10 288 210 3], 'MajorTicks', [0 0.5 1.0 1.5 2.0 2.5]);
lbl_z = uilabel(panel, 'Text', 'ζ = 0.30', ...
    'Position', [10 262 210 22], 'FontSize', 10, 'HorizontalAlignment', 'center');

% 計算結果ラベル
uilabel(panel, 'Text', '─── 計算結果 ───', ...
    'Position', [10 220 210 22], 'FontSize', 10, 'HorizontalAlignment', 'center');
lbl_wn   = uilabel(panel, 'Text', 'ωn = 3.16 rad/s', ...
    'Position', [10 195 210 22], 'FontSize', 10, 'HorizontalAlignment', 'center');
lbl_fn   = uilabel(panel, 'Text', 'fn = 0.50 Hz', ...
    'Position', [10 172 210 22], 'FontSize', 10, 'HorizontalAlignment', 'center');
lbl_type = uilabel(panel, 'Text', '▶ 不足減衰', ...
    'Position', [10 140 210 28], 'FontSize', 12, 'FontWeight', 'bold', ...
    'HorizontalAlignment', 'center', 'FontColor', [0 0 0.8]);

% ---- 右エリア（グラフ） ----
ax = uiaxes(fig, 'Position', [275 50 660 520]);
xlabel(ax, '時間  t  [s]', 'FontSize', 11);
ylabel(ax, '変位  x  [m]', 'FontSize', 11);
grid(ax, 'on');

% ---- コールバック関数（スライダー変更時に呼ばれる） ----
function update(sld_m, sld_k, sld_z, lbl_m, lbl_k, lbl_z, lbl_wn, lbl_fn, lbl_type, ax)
    m    = sld_m.Value;
    k    = sld_k.Value;
    zeta = sld_z.Value;
    c    = 2 * zeta * sqrt(m * k);
    wn   = sqrt(k / m);
    fn   = wn / (2 * pi);

    % ラベル更新
    lbl_m.Text  = sprintf('m = %.2f kg', m);
    lbl_k.Text  = sprintf('k = %.1f N/m', k);
    lbl_z.Text  = sprintf('ζ = %.2f', zeta);
    lbl_wn.Text = sprintf('ωn = %.3f rad/s', wn);
    lbl_fn.Text = sprintf('fn = %.3f Hz', fn);

    if zeta < 0.999
        lbl_type.Text      = '▶ 不足減衰（振動）';
        lbl_type.FontColor = [0 0 0.8];
    elseif zeta <= 1.001
        lbl_type.Text      = '▶ 臨界減衰';
        lbl_type.FontColor = [0.1 0.6 0.1];
    else
        lbl_type.Text      = '▶ 過減衰';
        lbl_type.FontColor = [0.8 0.1 0.1];
    end

    % 数値シミュレーション
    tspan  = [0, max(8, 5 * 2 * pi / max(wn, 0.1))];
    odefun = @(t, y) [y(2); -(c/m)*y(2) - (k/m)*y(1)];
    [t, y] = ode45(odefun, tspan, [1.0; 0.0]);

    % グラフ更新
    cla(ax);
    plot(ax, t, y(:,1), 'b-', 'LineWidth', 2);
    yline(ax, 0, 'k:', 'LineWidth', 1);
    xlabel(ax, '時間  t  [s]', 'FontSize', 11);
    ylabel(ax, '変位  x  [m]', 'FontSize', 11);
    title(ax, sprintf('m = %.2f kg  |  k = %.1f N/m  |  ζ = %.2f  |  ωn = %.3f rad/s', ...
        m, k, zeta, wn), 'FontSize', 11);
    grid(ax, 'on');
end

% ---- コールバック登録 ----
cb = @(~,~) update(sld_m, sld_k, sld_z, lbl_m, lbl_k, lbl_z, lbl_wn, lbl_fn, lbl_type, ax);
sld_m.ValueChangedFcn = cb;
sld_k.ValueChangedFcn = cb;
sld_z.ValueChangedFcn = cb;

% ---- 初期描画 ----
update(sld_m, sld_k, sld_z, lbl_m, lbl_k, lbl_z, lbl_wn, lbl_fn, lbl_type, ax);

%% 理論解説
% *減衰比 ζ による挙動の違い*
%
% * $\zeta < 1$（不足減衰）：振動しながら減衰。工学的に最もよく見られる。
% * $\zeta = 1$（臨界減衰）：振動せず最速で平衡点へ収束。
% * $\zeta > 1$（過減衰）：振動せずゆっくり収束。臨界減衰より遅い。
%
% *固有角周波数 と 固有振動数*
%
% $$\omega_n = \sqrt{\frac{k}{m}}, \qquad f_n = \frac{\omega_n}{2\pi}$$
%
% *減衰係数 c と 減衰比 ζ の関係*
%
% $$c = 2\zeta\sqrt{mk}, \qquad \zeta = \frac{c}{2\sqrt{mk}}$$

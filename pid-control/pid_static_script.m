%% PID制御の応答比較（P / PI / PID）
% 2次遅れプラント $\ddot y + \dot y + y = u$ を制御し、単位ステップ応答を比較します。
% コントローラ: $u = K_p e + K_i \int e\,dt + K_d \dot e$（$e = r - y$）
%
% このスクリプトでは、下の Kp / Ki / Kd を書き換えて実行すると、
% 同じゲインを使った P・PI・PID の3応答を重ねて表示します。

%% ゲイン設定
% ここの値を変更して実行してください。
Kp = 2.0;   % 比例ゲイン
Ki = 1.0;   % 積分ゲイン
Kd = 1.0;   % 微分ゲイン

%% プラントとコントローラの定義
r     = 1;              % 目標値（ステップ入力）
tspan = [0, 20];
s0    = [0; 0; 0];      % 状態: [y; ydot; ∫e dt]

% プラント: ÿ + ẏ + y = u（微分は測定値微分でキック回避: ė = -ẏ）
odef = @(t, s, kp, ki, kd) [ ...
    s(2); ...
    -s(2) - s(1) + ( kp*(r - s(1)) + ki*s(3) - kd*s(2) ); ...
    r - s(1) ];

%% 3パターンの数値積分
[tP, yP] = ode45(@(t,s) odef(t,s, Kp, 0,  0 ), tspan, s0);   % P
[tI, yI] = ode45(@(t,s) odef(t,s, Kp, Ki, 0 ), tspan, s0);   % PI
[tD, yD] = ode45(@(t,s) odef(t,s, Kp, Ki, Kd), tspan, s0);   % PID

fprintf('Kp=%.1f Ki=%.1f Kd=%.1f | 定常偏差  P=%.3f  PI=%.3f  PID=%.3f\n', ...
    Kp, Ki, Kd, r - yP(end,1), r - yI(end,1), r - yD(end,1));

%% グラフ表示
figure;
plot(tP, yP(:,1), '-', 'LineWidth', 2); hold on;
plot(tI, yI(:,1), '-', 'LineWidth', 2);
plot(tD, yD(:,1), '-', 'LineWidth', 2);
yline(r, 'k--', 'LineWidth', 1);
hold off; grid on; ylim([0, 1.8]);
legend('P', 'PI', 'PID', '目標 r', 'Location', 'southeast');
xlabel('時間  t  [s]', 'FontSize', 12);
ylabel('出力  y', 'FontSize', 12);
title(sprintf('PID応答比較   K_p=%.1f,  K_i=%.1f,  K_d=%.1f', Kp, Ki, Kd), 'FontSize', 12);

%% 理論解説
% * P（比例）  ：速いが定常偏差（オフセット）が残る
% * I（積分）  ：定常偏差をゼロにするが、振動・行き過ぎを招きやすい
% * D（微分）  ：オーバーシュートを抑え安定化する
%
% Ki=0 にすると P 制御となり、最終値が r=1 に届かずオフセットが残ります。
% Ki を上げると偏差は消えますが振動が増え、Kd を足すと収まります。

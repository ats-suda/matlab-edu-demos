%[text] # PID制御の応答比較（P / PI / PID）
%[text] 2次遅れプラント $\\ddot y + \\dot y + y = u$ を制御し、単位ステップ応答を比較します。
%[text] コントローラ: $u = K\_p\\, e + K\_i \\int e\\,dt + K\_d\\, \\dot e \\quad (e = r - y)$
%[text] スライダーを動かすと、同じ $K\_p, K\_i, K\_d$ を使った **P**・**PI**・**PID** の3応答が自動更新されます。
Kp = 2; %[control:slider:kp01]{"position":[6,7]}
Ki = 1; %[control:slider:ki01]{"position":[6,7]}
Kd = 1; %[control:slider:kd01]{"position":[6,7]}

r     = 1;              % 目標値（ステップ入力）
tspan = [0, 20];
s0    = [0; 0; 0];      % 状態: [y; ydot; ∫e dt]

% プラント: ÿ + ẏ + y = u（微分は測定値微分でキック回避: ė = -ẏ）
odef = @(t, s, kp, ki, kd) [ ...
    s(2); ...
    -s(2) - s(1) + ( kp*(r - s(1)) + ki*s(3) - kd*s(2) ); ...
    r - s(1) ];

[tP,  yP ] = ode45(@(t,s) odef(t,s, Kp, 0,  0 ), tspan, s0);   % P
[tI,  yI ] = ode45(@(t,s) odef(t,s, Kp, Ki, 0 ), tspan, s0);   % PI
[tD,  yD ] = ode45(@(t,s) odef(t,s, Kp, Ki, Kd), tspan, s0);   % PID

% 定常偏差（最終値と目標の差）
essP  = r - yP(end,1);
essI  = r - yI(end,1);
essD  = r - yD(end,1);
fprintf('Kp=%.1f Ki=%.1f Kd=%.1f | 定常偏差  P=%.3f  PI=%.3f  PID=%.3f\n', ...
    Kp, Ki, Kd, essP, essI, essD);

figure(1); clf;
plot(tP, yP(:,1), '-',  'LineWidth', 2); hold on;
plot(tI, yI(:,1), '-',  'LineWidth', 2);
plot(tD, yD(:,1), '-',  'LineWidth', 2);
yline(r, 'k--', 'LineWidth', 1);
hold off; grid on; ylim([0, 1.8]);
legend('P', 'PI', 'PID', '目標 r', 'Location', 'southeast');
xlabel('時間  t  [s]', 'FontSize', 12);
ylabel('出力  y', 'FontSize', 12);
title(sprintf('PID応答比較   K_p=%.1f,  K_i=%.1f,  K_d=%.1f', Kp, Ki, Kd), 'FontSize', 12);

%[text] ## 理論解説
%[text] **各項の役割**
%[text] - **P（比例）**：偏差に比例して操作。速いが**定常偏差（オフセット）が残る**
%[text] - **I（積分）**：偏差の累積を打ち消し、**定常偏差をゼロ**にする（ただし振動・行き過ぎを招きやすい）
%[text] - **D（微分）**：偏差の変化を抑え、**オーバーシュートを減らし安定化**する
%[text] **観察のヒント**
%[text] - $K\_i$ を 0 にすると P 制御。最終値が $r=1$ に届かず**オフセット**が残るのが分かります
%[text] - $K\_i$ を上げると偏差は消えるが**振動**が増える → $K\_d$ を足すと収まる
%[text] - $K\_p$ を上げると速くなるが**行き過ぎ**が増える

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright","rightPanelPercent":40}
%---
%[control:slider:kp01]
%   data: {"defaultValue":2,"label":"比例ゲイン Kp","max":20,"min":0,"run":"SectionToEnd","runOn":"ValueChanging","step":0.5}
%---
%[control:slider:ki01]
%   data: {"defaultValue":1,"label":"積分ゲイン Ki","max":10,"min":0,"run":"SectionToEnd","runOn":"ValueChanging","step":0.5}
%---
%[control:slider:kd01]
%   data: {"defaultValue":1,"label":"微分ゲイン Kd","max":10,"min":0,"run":"SectionToEnd","runOn":"ValueChanging","step":0.5}
%---

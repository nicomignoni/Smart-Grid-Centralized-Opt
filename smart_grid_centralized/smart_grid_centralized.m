%% Settings from the "Access Economy for Storage in Energy Communities" Python implementation
%  https://bitbucket.org/nivesp/marketdesign_energycommunities/src/master/func/PVScenarios.py,
%  https://bitbucket.org/nivesp/marketdesign_energycommunities/src/master/run_me_NumberScenarios.py

clear

% Number of prosumers and hours 
N = 10; 
T = 24; % hours

% Expected PV power generation 
S_mean = [0.0 0.0 0.0 0.0 0.01 0.1 0.2 0.3 0.5 ...
		  0.6 0.8 0.85 0.8 0.8 0.7 0.6 0.5 0.3 ...
		  0.2 0.1 0.01 0.0 0.0 0.0];

D_mean = [0.2 0.1 0.2 0.3 0.4 0.6 0.9 1.3 1.8 ...
          0.3 0.8 0.7 0.6 0.5 0.5 0.6 0.9 1.3 ...
          1.7 2.0 1.6 1.2 0.8 0.3];

% Multiplicative factors for S and D
mS = 6;
mD = 3;
          
% Max power exchange and storage capacity
P_max  = 4.5;
E_max  = 10;
E_init = 1.5;

% Sampling scenarios
var = 0.025;

% Buying and selling price (€/KW)
epsilon  = 0.3;
C = [0.10 0.10 0.10 0.10 0.10 0.10 0.20 0.50 0.50 ...
     0.50 0.40 0.30 0.30 0.30 0.20 0.20 0.20 ...
     0.20 0.50 0.50 0.50 0.20 0.10 0.10];
R = arrayfun(@(x) (1-epsilon)*x, C);

% Efficiencies 
Eff_ch  = 0.95;
Eff_dis = 1.05;
%% Model
S = mS * gen_PVScenarios(S_mean, N, var)';
D = mD * kron(ones(N, 1), D_mean)';
Phi = 8;

% Build vector f
f = zeros(1, Phi*T);
for i=1:T
   f(Phi*(i-1)+1:Phi*i) = [C(i) C(i) 0 0 -R(i) 0 -R(i) 0];
end
f = kron(ones(1, N), f);

% Build matrix A
U = [0 0 1 1 1 0 0 0;
     1 0 1 0 0 1 0 0;
     0 Eff_ch 0 Eff_ch 0 -Eff_dis -Eff_dis -1;
     0 0 0 0 0 0 0 0];
 
V = zeros(4*T, Phi * T);
V(end, end) = 1;

W = zeros(4, Phi);
W(end-1, end) = 1;

Z = diag(ones(N*T - 1, 1), -1);

A = kron(eye(N*T), U) + kron(eye(N), V) + kron(Z, W);

% Build vector a
a1 = zeros(1, 4*N*T);
for i=1:N*T
    a1(4*i-3:4*i) = [S(i) D(i) 0 0];
end
a2      = zeros(1, 4*T);
a2(3)   = E_init;
a2(end) = E_init;

a = a1 + kron(ones(1, N), a2);

% Build matrix B
J = [0 0 0 0 0 0 0 1;
     0 1 0 1 0 0 0 0;
     0 0 0 0 0 1 1 0];
B = kron(eye(N*T), J);

% Build matrix b
b = kron(ones(1, N*T), [E_max P_max P_max]); 

% Build vector lb
lb = zeros(1, Phi*N*T);

[x, total_community_cost] = linprog(f, B, b, A, a, lb, []);

%% Gathering results

community_cost = reshape(f'.*x, Phi, T, N);
tensor_Phi     = reshape(x, Phi, T, N);           

% Community cost (hourly)
r2d_cost_t    = sum(community_cost(1, :, :), 3);
r2e_cost_t    = sum(community_cost(2, :, :), 3);
s2r_revenue_t = sum(community_cost(5, :, :), 3);
e2r_revenue_t = sum(community_cost(7, :, :), 3);

% Community cost (prosumers and retailer)
r2d_cost_n    = sum(community_cost(1, :, :), 2);
r2e_cost_n    = sum(community_cost(2, :, :), 2);
s2r_revenue_n = sum(community_cost(5, :, :), 2);
e2r_revenue_n = sum(community_cost(7, :, :), 2);

% Individual price (lambda)
lambda = sum(community_cost, [3 1])./sum(tensor_Phi, [3 1]);

% Model variables
r2d = reshape(tensor_Phi(1,:,:), T, []); % Retailer to Demand
r2e = reshape(tensor_Phi(2,:,:), T, []); % Retailer to Storage
s2d = reshape(tensor_Phi(3,:,:), T, []); % PV Generation to Demand
s2e = reshape(tensor_Phi(4,:,:), T, []); % PV Generation to Storage
s2r = reshape(tensor_Phi(5,:,:), T, []); % PV Generation to Retailer
e2d = reshape(tensor_Phi(6,:,:), T, []); % Storage to Demand
e2r = reshape(tensor_Phi(7,:,:), T, []); % Storage to Retailer
e   = reshape(tensor_Phi(8,:,:), T, []); % Storage

% Average (and Std) Generation
avg_S = mean(S, 2);
std_S = std(S, 0, 2);

%% Plotting 

% Lambda 
figure
hold on
plot(lambda, "-o"); plot(mean(lambda)*ones(1,T), "--c");
xlabel("Ora giornaliera [h]")
ylabel("€")
hold off

% Prices
figure;
hold on
plot(C, "-or"); plot(R, "-og");
xlabel("Ora giornaliera [h]");
ylabel("€/kW")
title("Costo dell'energia (Acquisto e vendita)")
legend("Costo di Acquisto", "Prezzo di Vendita")
hold off

% PV Generation vs Demand
figure
hold on 
p(1) = plot(avg_S, "-bo"); 
plot(avg_S + std_S, "--c"); plot(avg_S - std_S, "--c"); 
p(2) = plot(mD * D_mean, "-ro");
ylabel("kW");
xlabel("Ora giornaliera [h]");
title("Generazione PV & Domanda")
legend(p([1 2]), "Generazione PV", "Domanda")
hold off

% Community costs (prosumers and retailer)
figure

yyaxis left
cost_per_prosumer = r2d_cost_n + r2e_cost_n + s2r_revenue_n + e2r_revenue_n;
cost_per_prosumer = reshape(cost_per_prosumer, 1, []);
bar(cost_per_prosumer)
ylabel("Costo giornaliero [€]")

yyaxis right
plot(sum(S,1), "-o", "LineWidth", 4)
ylabel("PV [kW]")
xlabel("Prosumer")

% Community costs (hourly)
figure
tiledlayout(2, 1)

nexttile
hold on 
b = bar([r2d_cost_t + r2e_cost_t; s2r_revenue_t + e2r_revenue_t]', 'stacked');
b(1).FaceColor = '#A2142F'; b(2).FaceColor = '#77AC30';
ylabel("€")
title("Costi & Ricavi")
legend("Costi", "Ricavi")
hold off

nexttile
hold on 
b = bar([r2d_cost_t; r2e_cost_t; s2r_revenue_t; e2r_revenue_t]', 'stacked');
b(1).FaceColor = '#A03D13'; b(2).FaceColor = '#D95319';
b(3).FaceColor = '#77AC30'; b(4).FaceColor = '#547722';
ylabel("€")
xlabel("Ora giornaliera [h]");
title("Composizione dei costi")
set(gca, 'XTick', 1:T)
legend('R -> D', "R -> E", "S -> R", "E -> R");
hold off

% Demand satisfaction
figure
tiledlayout(3, 1)

nexttile
hold on 
plot(mD * D_mean, "-o"), plot(mean(r2d, 2), "-o")
ylabel("kW")
set(gca, 'XTick', 1:T)
title("Dal Retailer alla Domanda")
legend("Domanda media", "R -> D Media")
hold off

nexttile
hold on 
plot(mD * D_mean, "-o"), plot(mean(s2d, 2), "-o")
ylabel("kW")
set(gca, 'XTick', 1:T)
title("Dalla Generazione PV alla Domanda")
legend("Domanda media", "S -> D Media")
hold off

nexttile
hold on 
plot(mD * D_mean, "-o"), plot(mean(e2d, 2), "-o")
xlabel("Ora giornaliera [h]");
set(gca, 'XTick', 1:T)
ylabel("kW")
title("Dallo Storage alla Domanda")
legend("Domanda media", "E -> D Media")
hold off

% Storage state
figure
tiledlayout(2, 1)

nexttile
hold on 
plot(avg_S, "-o"), plot(mean(s2e, 2), "-o")
ylabel("kW")
title("Dalla Generazione PV allo Storage")
legend("Avg. PV Generation", "S -> E Media")
hold off

nexttile
hold on 
plot(mean(e, 2), "-o"), plot(mean(r2e, 2), "-o")
xlabel("Ora giornaliera [h]");
ylabel("kW")
title("Dal Retailer allo Storage")
legend("Storage Medio", "R -> E Media")
hold off

% Energy sold
figure
tiledlayout(2, 1)

nexttile
hold on 
plot(avg_S, "-o"), plot(mean(s2r, 2), "-o")
ylabel("kW")
title("Dalla Generazione PV al Retailer")
legend("PV Gen. Media", "S -> R Media")
hold off

nexttile
hold on 
plot(mean(e, 2), "-o"), plot(mean(e2r, 2), "-o")
xlabel("Ora giornaliera [h]");
ylabel("kW")
title("Dallo Storage al Retailer")
legend("Storage Medio", "E -> R Media")
hold off



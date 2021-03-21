function PV_Scenarios = gen_PVScenarios(PV,NS,b0)
    
    NTime = size(PV, 2);
    mi    = zeros(1, NTime);
    
    % Generate sigma covariance matrix
    ni   = 7; % strength of correlation
    Sigma = zeros(NTime);
    for i=1:NTime
        for j=1:NTime
            Sigma(i,j) = exp(-abs(i - j)/ni);
        end
    end
    
    mean = PV;
    
    % Variance that accounts for increasing forecast error
    b1 = 0;
    var = zeros(1, NTime);
    for i=1:NTime
        var(i) = b0 + b1*sqrt(i);
    end
    
    % Initial random vector Xks
    Xks = mvnrnd(mi, Sigma, NS);
    
    Yks = zeros(size(Xks));
    for i=1:size(Xks, 1)
        for j=1:size(Xks, 2)
            Yks(i,j) = 0.5*(1 + erf(Xks(i,j))/sqrt(2));
        end
    end
    
    % PV power generation scenarios following a beta distribution with alpha 
	% and beta based on mean and variance
    alpha = zeros(1, NTime);
    beta  = zeros(1, NTime);
    for i=1:NTime
        alpha(i) = mean(i) * (mean(i)*(1 - mean(i))/var(i) - 1);
        beta(i)  = (1 - mean(i)) * (mean(i)*(1 - mean(i))/var(i) - 1);
    end
    
    PV_Scenarios = zeros(NS, NTime);
    for i=1:NS
        for j=1:NTime
            PV_Scenarios(i,j) = betainv(Yks(i,j), alpha(j), beta(j));
        end
    end
    
    % Replace NaNs with 0s
    PV_Scenarios(isnan(PV_Scenarios)) = 0;
end 
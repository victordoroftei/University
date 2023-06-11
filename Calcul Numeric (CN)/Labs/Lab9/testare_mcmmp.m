clf;
hold on;

x = 10 * rand(1, 100);
f = 1 + 20 * (x .^ 2 + 20 * rand(1, 100));
plot(x, f, 'or', 'markerfacecolor', 'r', 'markersize', 3) # Plotam norul de puncte

[coefs, eroare] = mcmmp(x, f, 2)
p = @(X) polyval(coefs, X);
fplot(p, [0, 10], '-b', 'linewidth', 3)  # Plotam dreapta

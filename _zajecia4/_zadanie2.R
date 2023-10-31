# dane
GPA =	c(2.8, 3.4, 3, 3.5, 3.6, 3, 2.7, 3.7)
ACT =	c(21,	24,	26,	27,	29,	25,	25,	30)

## oszacowanie współczynników
beta_1 = cov(GPA, ACT) / var(ACT)
beta_0 = mean(GPA) + beta_1 * mean(ACT)

## suma reszt jest równa zero
# reszty
reszty = GPA - (0.5681319 + 0.1021978 * ACT)

# suma reszt
sum(reszty)


## szacowanie modelu macierzowo
X=cbind(rep(1,8), ACT)

(beta = solve(t(X)%*%X) %*% t(X) %*% GPA)
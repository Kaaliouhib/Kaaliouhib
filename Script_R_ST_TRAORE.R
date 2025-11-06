# Modélisation VAR et VEC

# Importation de la base de donnée
library(readxl)
base2025 <- read_excel("C:/Users/HP/Desktop/TP_Série_Temporelle_Mr_TRAORE/base2025.xlsx")
View(base2025)

# Afficher les premières ligne de la base
head(base2025)

# Vérification de la structure des données

str(base2025)

# 1. MODELISATION VAR

# Etape 1: Stationnarité des variables
annee <- ts(base2025$Annee)
annee

# PIB
pib <- ts(base2025$PIB, start = min(annee), end = 2022)
plot(pib)

acf(pib,lag.max =30,plot = T )
pacf(pib,lag.max =30,plot = T )

library(tseries)

adf.test(pib)
pp.test(pib)
kpss.test(pib)


# Différentier la variable

dpib <- diff(pib, lag = 1)
plot(dpib)


adf.test(dpib)
pp.test(dpib)
kpss.test(dpib)
# pib est I(1)

# Exportation
exportation <-  ts(base2025$Exportation, start = min(annee), end = 2022)
plot(exportation)

adf.test(exportation)
pp.test(exportation)
kpss.test(exportation)

dexportation <- diff(exportation, lag = 1)
plot(dexportation)


adf.test(dexportation)
pp.test(dexportation)
kpss.test(dexportation)
# exportation est I(1)

# Crédit
credit <- ts(base2025$credit, start = min(annee), end= 2022)
plot(credit)

adf.test(credit)
pp.test(credit)
kpss.test(credit)

dcredit <- diff(credit, lag = 1)
plot(dcredit)

# FBCF
FBCF <- ts(base2025$FBCF, start = min(annee), end =2022)
plot(FBCF)

adf.test(FBCF)
pp.test(FBCF)
kpss.test(FBCF)

dFBCF <- diff(FBCF, lag = 1)
plot(dFBCF)

adf.test(dFBCF)
pp.test(dFBCF)
kpss.test(dFBCF)
# FBCF est I(1)

# IDE

IDE <- ts(base2025$IDE, start = min(annee), end= 2022)
plot(IDE)

adf.test(IDE)
pp.test(IDE)
kpss.test(IDE)

dIDE <- diff(IDE, lag = 1)
plot(dIDE)


adf.test(dIDE)
pp.test(dIDE)
kpss.test(dIDE)

# IDE est de I(1)

# Population
population <- ts(base2025$Population, start = min(annee), end = 2022)
plot(population)

adf.test(population)
pp.test(population)
kpss.test(population)

dpopulation <- diff(population, lag = 1)
plot(dpopulation)


adf.test(dpopulation)
pp.test(dpopulation)
kpss.test(dpopulation)

# population est I(1)

# Dette

dette<- ts(base2025$Dette, start = min(annee), end = 2022)
plot(dette)

adf.test(dette)
pp.test(dette)
kpss.test(dette)

ddette <- diff(dette, lag = 1)
plot(ddette)


adf.test(ddette)
pp.test(ddette)
kpss.test(ddette)

# dette est I(1)

# Modélisation VAR

baseVAR <- cbind(dpib, dexportation, dcredit, dFBCF, dIDE, dpopulation, ddette)

library(vars)

est_VAR <- VARselect(baseVAR, lag.max = 6, type = "none")
est_VAR$selection

y = est_VAR$criteria[1,]
ts.plot(y)
z = est_VAR$criteria[2,]
ts.plot(z)

Estimation <-  VAR(baseVAR, p=6, type = "const")
summary(Estimation)

# Décomposition de la variance

Decomp <- fevd(Estimation)
plot(Decomp)
Decomp

# Fonction de réponses impulsionnelles

irf <- irf(Estimation, n.ahead = 6)
plot(irf)
irf

# Prévision 
Prev <- predict(Estimation, n.ahead = 5, ci = 0.95)
Prev

# Stabilité

stab <- stability(Estimation, type = "Rec-CUSUM")
plot(stab)

# Analyse des causalité
causality(Estimation, cause = "dpib")

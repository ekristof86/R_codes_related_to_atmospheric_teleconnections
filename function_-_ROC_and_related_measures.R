################################################################################
### RECEIVER OPERATING CHARACTERISTIC (ROC) CURVE ANALYSIS: SUMMARY MEASURES ###
################################################################################

# Counting numbers of true positive (TP), true negative (TN), false positive (FP) and false negative (FN) elements
# in two tables (two dimensional matrices) with the same dimensions, where the first table is used as reference.
# Summary measures such as the Matthews correlation coefficient (Chicco & Jurman, 2020)
# and the Youden index (Youden, 1950) are computed.

# Creating objects of the followings:
# TP, TN, FP, FN
# TPR, FPR, TNR, FNR

ROC <- function(ref,mod) {
  if(dim(ref)[1]!=dim(mod)[1] | dim(ref)[2]!=dim(mod)[2]) stop("The two tables should have the same dimensions.")
  
  ### Computing TP, FP, FN, TN values:
  # True positive:
  TP <- sum(ref*mod)
  
  # False positive:
  FP <- length(which(ref-mod == -1) == TRUE)
  
  # False negative:
  FN <- length(which(ref-mod == 1) == TRUE)
  
  # True negative:
  TN <- length(ref) - (TP+FP+FN)
  
  if(sum(TP+TN+FP+FN) != dim(ref)[1] * dim(ref)[2]) stop("Error: sum of TP, TN, FP and FN is not equal to the number of cells in ref.")
  
  # print(paste0("Classification of ", sum(TP+TN+FP+FN), " cells."))
  # print(paste0("Distribution: TP=", TP, ", TN=", TN, ", FP=", FP, ", FN=", FN))
  
  ### Summary measures:
  TPR <- TP / (TP+FN)
  TNR <- TN / (TN+FP)
  FNR <- FN / (FN+TP)
  FPR <- FP / (FP+TN)
  
  # Accuracy:
  ACC <- (TP+TN) / (TP+TN+FP+FN)
  
  # Youden-index:
  Youden <- TPR - FPR
  # or: ((TP*TN) - (FN*FP)) / ((TP+FN) * (FP+TN))
  
  # F1 score:
  F1 <- (2*TP) / ((2*TP) + FP + FN)
  
  # G score:
  G <- sqrt((TP / (TP + FP)) * (TP / (TP + FN)))
  
  # BACC:
  BACC <- ((TP / (TP + FN)) + TN / (TN + FP)) / 2
  
  # Matthews correlation coefficients:
  MCC <- ((TP * TN) - (FP * FN)) / 
    ( sqrt((TP + FP) * (TP + FN) * (TN + FP) * (TN + FN)) )
  
  # print(paste0("ACC: ", ACC, ", F1 score: ", F1, ", G score: ",
  #              G, ", BACC: ", BACC, ", MCC: ", MCC))
  
  results <<- data.frame(
    TPR=TPR,
    TNR=TNR,
    FNR=FNR,
    FPR=FPR,
    ACC=ACC,
    Youden=Youden,
    F1=F1,
    G=G,
    BACC=BACC,
    MCC=MCC
  )
}

### Examples:

## 1st:
# a <- c(1,0,1,1,1,0,1,1,1,1,0,0,0,0,1,1,0,1,0,0)
# b <- c(0,1,1,1,1,0,1,0,0,1,1,1,1,0,0,1,0,1,1,1)

## 2nd:
# a <- c(rep(0,10), rep(1,10))
# b <- c(1, rep(0,19))

# A <- array(data=a, dim=c(4,5))
# B <- array(data=b, dim=c(4,5))

## 3rd:
# a <- c(rep(1,63), rep(0,72), rep(0,28), rep(1,37))
# b <- c(rep(1,63), rep(0,72), rep(1,28), rep(0,37))

# A <- array(data=a, dim=c(4,50))
# B <- array(data=b, dim=c(4,50))

# ROC(ref=A, mod=B)
# ROC(ref=B, mod=A)


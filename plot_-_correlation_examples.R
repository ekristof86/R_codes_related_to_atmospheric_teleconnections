################################
### Examples of correlations ###
################################

# Creating two samples:
x <- seq(0,1,0.2)
y <- x**2
# The relationship between the samples x and y is not linear.


######### Computing correlations #########

### Computing Pearson correlations:
cor1_p <- cor(x=x, y=y, method="pearson")     # positive correlation
cor1_n <- cor(x=x, y=-1*y, method="pearson")  # negative correlation

### Computing Spearman correlations: # perfect correlations
cor2_p <- cor(x=x, y=y, method="spearman")    # positive correlation
cor2_n <- cor(x=x, y=-1*y, method="spearman") # negative correlation

cor1_0 <- cor(x=c(-1*rev(x),x), y=c(rev(y),y), method="pearson")  # no correlation
cor2_0 <- cor(x=c(-1*rev(x),x), y=c(rev(y),y), method="spearman") # no correlation

######### Visualizing the samples #########
png("Examples_of_correlations.png", width=16, height=5.5, 
    units="in", res=300, pointsize=22)
par(mfrow=c(1,3)) # creating three plots in a row
plot(x=x, y=y, type="b", lwd=2, col="blue", pch=16, ylim=c(0,1),
     xaxt="n", yaxt="n", ann=FALSE)
title(xlab="sample 1", ylab="sample 2", cex.lab=1.2)
axis(side=1, at=x, labels=x)
axis(side=2, at=y, labels=y, las=2)
axis(side=2, at=0.06, labels=0.04, tick=FALSE, las=2) # Add the label 0.04 separately due to lack of space.
abline(h=y, v=x, lty=2, col="blue")
legend("topleft", legend=c( paste0("Pearson: ",  round(cor1_p, digits=2)), 
                            paste0("Spearman: ", round(cor2_p, digits=2)) ),
       cex=1.1)

plot(x=x, y=-1*y, type="b", lwd=2, col="blue", pch=16,  ylim=c(-1,0.02),
     xaxt="n", yaxt="n", ann=FALSE)
title(xlab="sample 1", ylab="sample 2", cex.lab=1.2)
axis(side=1, at=x, labels=x)
axis(side=2, at=-1*y, labels=-1*y, las=2)
axis(side=2, at=0.02, labels=0, tick=FALSE, las=2)
abline(h=-1*y, v=x, lty=2, col="blue")
legend("topright", legend=c( paste0("Pearson: ",  round(cor1_n, digits=2)), 
                             paste0("Spearman: ", round(cor2_n, digits=2)) ),
       cex=1.1)

plot(x=c(-1*rev(x),x), y=c(rev(y),y), type="b", pch=16, lwd=2, col="blue", ylim=c(0,1),
     xaxt="n", yaxt="n", ann=FALSE)
title(xlab="sample 1", ylab="sample 2", cex.lab=1.2)
axis(side=1, at=c(-1*rev(x),x), labels=c(-1*rev(x),x), las=2)
axis(side=2, at=y, labels=y, las=2)
axis(side=2, at=0.06, labels=0.04, tick=FALSE, las=2)
abline(h=c(rev(y),y), v=c(-1*rev(x),x), lty=2, col="blue")
legend("top", legend=c( paste0("Pearson: ",  round(cor1_0, digits=2)), 
                        paste0("Spearman: ", round(cor2_0, digits=2)) ),
       cex=1.1)

graphics.off()

######### Reproducing Spearman-correlation "manually" #########

# Two samples:
x <- 1:5
y <- c(5,70,2,4,6)

print(x)
print(y)

# Calculating of correlations automatically:
cor(x=x, y=y, method="pearson")
cor(x=x, y=y, method="spearman")

# "Manual" calculation:
x_ranked <- x # because its elements are in increasing order
y_ranked <- order(y)
cor(x=x_ranked, y=y_ranked, method="pearson") # same as cor(x=x, y=y, method="spearman")
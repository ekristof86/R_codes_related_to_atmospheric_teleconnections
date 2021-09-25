#############################################################################
### Creating map of Mediterranean Oscillation indices based on literature ###
#############################################################################

# Sources of the station-based indices:
# Mediterranean Oscillation:
# Brunetti, M., Maugeri, M., Nanni, T., 2002: Atmospheric circulation and precipitation
# in Italy for the last 50 years. International Journal of Climatology 2002, 22, 1455‒1471.

# Mediterranean Oscillation:
# Conte, M., Giuffrida, A., Tedesco, S, 1989: The Mediterranean Oscillation,
# Impact on Precipitation and Hydrology in Italy. In: Conference on Climate Water, pp. 121‒137,
# Publications of the Academy of Finland, Helsinki.

# Mediterranean Oscillation:
# Palutikof, J.P., 2003: Analysis of Mediterranean climate data: measured and modelled.
# In: Bolle, H.J. (ed.) (125–132). Mediterranean Climate: Variability and Trends.
# Springer, Berlin, Germany, 371 p.

# Western Mediterranean Oscillation:
# Martín-Vide, J., López-Bustins, J. A., 2006: The Western Mediterranean Oscillation and rainfall
# in the Iberian Peninsula. International Journal of Climatology, 26, 1455–1475.

# Required R package:
library(maps)

# Parameters of the map:
xlim1 <- -10
xlim2 <- 40
ylim1 <- 28
ylim2 <- 50
pm <- 2 # to start subtitles of latitudes with N30
brk <- 5
color <- "grey50" # country borders
color2 <- c("red", "darkgreen", "purple", "blue") # symbols of cities
symbol <- 16 # cities are denoted with coloured full circles

# Coordinates of stations which are the basis of the oscillation indices:
coords_x0 <- c(3.06,   5.37, -5.35, 11.87)
coords_x1 <- c(31.37, 35.22, 34.78, -6.20)
coords_y0 <- c(36.75, 43.30, 36.14, 45.42)
coords_y1 <- c(30.05, 31.78, 32.07, 36.47)

# Labels of cities:
labels   <- c("Algír", "Kairó", "Marseille", "Jeruzsálem", "Gibraltár", "Tel Aviv", "Padova", "San\nFernando") # In Hungarian
#labels  <- c("Algiers", "Cairo", "Marseille", "Jerusalem", "Gibraltar", "Tel Aviv", "Padua", "San\nFernando") # In English

# Coordinates of city labels:
text_x <- c(3,  30, 3.1,  36,    -5,  35,    11.9, -6.7)
text_y <- c(38, 29, 44.5, 31,  34.5, 33.5,   46.5,   39)

legend <- c("Conte et al. (1989)", "Brunetti et al. (2002)", 
            "Palutikof (2003)", "Martín-Vide &\nLópez-Bustins (2006)")

# Creating the map:
png("MO_indices.png", width=11, height=6.7, units="in", res=300, pointsize=18)
plot(x=0, y=0, col="white", xlim=c(xlim1,xlim2), ylim=c(ylim1,ylim2),
     ann=FALSE, xaxt="n", yaxt="n", xaxs="i", yaxs="i") # Creating an empty plot.
map(database="world", xlim=c(xlim1,xlim2), ylim=c(ylim1,ylim2), 
    col=color, interior=FALSE, add=TRUE)
map(database="world", regions="Hungary", xaxs="i", yaxs="i",
    xlim=c(xlim1,xlim2), ylim=c(ylim1,ylim2), 
    col=color, interior=FALSE, add=TRUE)
abline(h=seq(ylim1+pm,ylim2+pm,brk), v=seq(xlim1,xlim2,brk), lty=2, col=color)
axis(side=1, at=seq(xlim1,xlim2,brk), labels=paste0(seq(xlim1,xlim2,brk), "°"))
axis(side=2, at=seq(ylim1+pm,ylim2+pm,brk), labels=paste0(seq(ylim1+pm,ylim2+pm,brk), "°"), las=2)
points(x=c(coords_x0,coords_x1), y=c(coords_y0,coords_y1), pch=symbol, col=color2)
arrows(x0=coords_x0, y0=coords_y0, x1=coords_x1, y1=coords_y1, code=0, lwd=2, col=color2)
legend(x="topright", legend=legend, ncol=1, pch=symbol, col=color2, cex=0.8)
text(x=text_x, y=text_y, col=rep(color2, each=2), labels=labels)
graphics.off()

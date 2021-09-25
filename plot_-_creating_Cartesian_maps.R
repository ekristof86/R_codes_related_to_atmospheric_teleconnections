######################################
### PLOTTING DATA ON CARTESIAN MAP ###
######################################

# plottingDataOnMap() creates a map with Atlantic view in png format
# which contains uniformly distributed data on the Northern Hemisphere.

# Required packages:
library(fields) # image.plot
library(RColorBrewer) # brewer.pal, colorRampPalette
library(maps) # map

# Parameters:
# x: values of the first dimension (lon)
# y: values of the second dimension (lat)
# z: plotted data (order of dimensions: lon, lat)
# file: path and title of the file
# width: width of the plot in inch
# height: height of the plot in inch
# res: resolution of the plot in dpi
# ptsize: pointsize of the characters on the plot
# col_nr: number of colors which is used by creating colorscale with function brewer.pal
# col_scale: title of the colorscale which is available via the RColorBrewer package
# brks: breaks of the colorscale
# lab.brks: legend of the colorscale
# lat_lines: lines of latitudes
# lon_lines: lines of longitudes
# lon_primary: x axis ticks where labels are fitted
# lat_primary: y axis ticks where labels are fitted
# lon_secondary: x axis ticks where ticks are fitted
# lat_secondary: y axis ticks where ticks are fitted
# size_axis_x: size of the x axis labels
# size_axis_y: size of the x axis labels
# col_geo_lines: color of the lines which represent geographical longitudes and latitudes
# col_border: color of map borders
# point_x: longitude of the points which are plotted on the map if point==TRUE
# point_y: latitude of the points which are plotted on the map if point==TRUE
# point_pch: type of the symbol which represents the points if point==TRUE
# point_size: size of the symbol which represents the points if point==TRUE
# point_col: color of the symbol which represents the points if point==TRUE

plottingDataOnMap <- function(file="Plot_title.png", width=19.5, height=6.8, res=300, ptsize=18,
                              x=seq(-180,177.5,2.5), y=seq(0,90,2.5),
                              z=matrix(runif(5328, min=-1, max=-0.2), nrow=length(seq(-180,177.5,2.5)), ncol=length(seq(0,90,2.5))),
                              x_lab=c("-160°","-120°","-80°","-40°","0°","40°","80°","120°","160°"),
                              y_lab=c("0°","20°","40°","60°","80°"),
                              col_nr=9, col_scale="Blues",
                              lab.brks=c("-0.7","-0.65","-0.6","-0.55","-0.5","-0.45","-0.4","-0.35","-0.3"),
                              brks=c(-0.7,-0.65,-0.6,-0.55,-0.5,-0.45,-0.4,-0.35,-0.3),
                              lat_lines=seq(0,80,20), lon_lines=seq(-160,160,20),
                              lon_primary=seq(-160,160,40), lat_primary=seq(0,80,20),
                              lon_secondary=seq(-160,160,20), lat_secondary=seq(0,80,20),
                              size_axis_x=1, size_axis_y=1, col_geo_lines="black", col_borders="grey60",
                              point=TRUE, point_x=19.5, point_y=48, point_pch=16, point_size=1.5, point_col="red"){
  
  # Create the colorscale:
  colorscale <- rev(colorRampPalette(brewer.pal(col_nr,col_scale))(length(brks)-1))
  
  # Create the map:
  png(file, units="in", width=width, height=height, res=res, pointsize=ptsize)
  image.plot(x=x, y=y, z=z, col=colorscale,
             breaks=brks, lab.breaks=lab.brks, ann=FALSE, xaxt="n", yaxt="n")
  abline(h=lat_lines, v=lon_lines, col=col_geo_lines, lty=2)
  map("world", interior=FALSE, add=TRUE, col=col_borders)
  if(point==TRUE) points(x=point_x, y=point_y, pch=point_pch, cex=point_size, col=point_col)
  axis(1, at=lon_primary, labels=x_lab, cex.axis=size_axis_x)
  axis(1, at=lon_secondary, labels=FALSE, tck=-0.02)
  axis(2, at=lat_primary, labels=y_lab, cex.axis=size_axis_y, las=2)
  graphics.off()
}
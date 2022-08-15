######################################
### PLOTTING DATA ON CARTESIAN MAP ###
######################################

# Note that plottingDataOnMap() creates a map with Atlantic view in png format
# as an example. It contains randomly generated uniformly distributed data
# between the values -1 and -0.2 in the Northern Hemisphere.

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

# col_scale_type: if the colorscale is "continuous" or "discrete", the former is the default
# col_scale_type2: if the colorscale is discrete, then the colorscale can be "built-in" or
#                 "custom", the former is the default
# col_scale: title of the colorscale which is available via the RColorBrewer package in case of continuous colorscale:
             # (e.g., sequential colorscales are "Blues", "Reds", or divergent colorscales are "RdBu", "RdYlBu") or
             # vector of colors (e.g., c(orange", lightpink", "lightsteelblue1","grey60"), c("#FFFFFF", "#AAAAAA")
             # in case of discrete colorscale)
# col_nr: the number of colors which is used to construct the colorscale
# reverse: if TRUE, then the sequence of colors in the colorscale will be reversed
# brks: breaks of the colorscale
# lab_brks: legend of the colorscale
# lat_lines: lines of latitudes
# lon_lines: lines of longitudes
# lon_primary: x axis ticks where labels are fitted
# lat_primary: y axis ticks where labels are fitted
# lon_secondary: x axis ticks where ticks are fitted
# lat_secondary: y axis ticks where ticks are fitted
# size_axis_x: size of the x axis labels
# size_axis_y: size of the x axis labels
# col_axis_x: color of the x axis
# col_axis_y: color of the y axis
# col_geo_lines: color of the lines which represent geographical longitudes and latitudes
# col_border: color of map borders
# point_x: longitude of the points which are plotted on the map if point==TRUE
# point_y: latitude of the points which are plotted on the map if point==TRUE
# point_pch: type of the symbol which represents the points if point==TRUE
# point_size: size of the symbol which represents the points if point==TRUE
# point_col: color of the symbol which represents the points if point==TRUE
# line_coord_lon1: longitude of the point from which the line is drawn if connect_points==TRUE
# line_coord_lon2: longitude of the point to which the line is drawn if connect_points==TRUE
# line_coord_lat1: latitude of the point from which the line is drawn if connect_points==TRUE
# line_coord_lat2: latitude of the point to which the line is drawn if connect_points==TRUE
# line_width: width of the line if connect_points==TRUE
# line_col: color of the line if connect_points==TRUE
# contour_col: color of contour lines if contour==TRUE
# contour_lwd: width of contour lines if contour==TRUE
# contour_labcex: size of values associated with contour labels if contour==TRUE

plottingDataOnMap <- function(file=file, width=width, height=height, res=res, ptsize=ptsize,
                              x=x, y=y, z=z, x_lab=x_lab, y_lab=y_lab,
                              reverse=reverse, col_scale_type=col_scale_type, col_scale_type2=col_scale_type2, 
                              col_nr=col_nr, col_scale=col_scale, lab_brks=lab_brks, brks=brks,
                              lat_lines=lat_lines, lon_lines=lon_lines,
                              lon_primary=lon_primary, lat_primary=lat_primary,
                              lon_secondary=lon_secondary, lat_secondary=lat_secondary,
                              size_axis_x=size_axis_x, size_axis_y=size_axis_y, col_axis_x=col_axis_x, col_axis_y=col_axis_y,
                              col_geo_lines=col_geo_lines, col_borders=col_borders,
                              point=point, point_x=point_x, point_y=point_y, point_pch=point_pch, point_size=point_size, point_col=point_col,
                              connect_points=connect_points, line_coord_lon1=line_coord_lon1, line_coord_lon2=line_coord_lon2,
                              line_coord_lat1=line_coord_lat1, line_coord_lat2=line_coord_lat2, line_width=line_width, line_col=line_col,
                              contour=contour, contour_col=contour_col, contour_lwd=contour_lwd, contour_labcex=contour_labcex){
  
  # Checking:
  if (col_scale_type=="continuous" & col_scale_type2=="custom") {
    stop("Error: please use one of the colorscale available in the RColorBrewer package.")
  }
  
  # Creating the colorscale if col_scale_type=="continuous":
  if(col_scale_type=="continuous") {
    if (reverse==TRUE) {
      colorscale <- rev(colorRampPalette(brewer.pal(col_nr,col_scale))(length(brks)-1))
    }
    
    if (reverse==FALSE) {
      colorscale <- colorRampPalette(brewer.pal(col_nr,col_scale))(length(brks)-1)
    }
  }
  
  # Creating the colorscale if col_scale_type=="discrete"and col_scale_type2=="built-in":
  if(col_scale_type=="discrete" & col_scale_type2=="built-in") {
    if (reverse==TRUE) {
      colorscale <- rev(colorRampPalette(brewer.pal(col_nr,col_scale))(col_nr))
    }
    
    if (reverse==FALSE) {
      colorscale <- colorRampPalette(brewer.pal(col_nr,col_scale))(col_nr)
    }
  }
    
  if(col_scale_type=="discrete" & col_scale_type2=="custom") {
    if (reverse==TRUE) {
      colorscale <- rev(col_scale)
    }
    
    if (reverse==FALSE) {
      colorscale <- col_scale
    }
  }
  
  # Creating the map:
    png(file=file, units="in", width=width, height=height, res=res, pointsize=ptsize)
    if(col_scale_type=="continuous") {
        image.plot(x=x, y=y, z=z, col=colorscale,
                   breaks=brks, lab.breaks=lab_brks, ann=FALSE, xaxt="n", yaxt="n")
    }
    if(col_scale_type=="discrete") {
      image.plot(x=x, y=y, z=z, col=colorscale,
                 nlevel=col_nr, axis.args=list(at=brks, labels=lab_brks),
                 ann=FALSE, xaxt="n", yaxt="n")
    }
        abline(h=lat_lines, v=lon_lines, col=col_geo_lines, lty=2)
        map("world", interior=FALSE, add=TRUE, col=col_borders)
        axis(1, at=lon_primary, labels=x_lab, col=col_axis_x, cex.axis=size_axis_x)
        axis(1, at=lon_secondary, col=col_axis_x, labels=FALSE, tck=-0.02)
        axis(2, at=lat_primary, labels=y_lab, col=col_axis_y, cex.axis=size_axis_y, las=2)
        axis(2, at=lat_secondary, col=col_axis_y, labels=FALSE, tck=-0.02)
        axis(3, at=lon_secondary, col=col_axis_x, labels=FALSE, tck=0)
        axis(4, at=lat_secondary, col=col_axis_y, labels=FALSE, tck=0)
        if(point==TRUE) {
          points(x=point_x, y=point_y, pch=point_pch, cex=point_size, col=point_col)
        }
        if(connect_points==TRUE) {
          arrows(x0=line_coord_lon1, x1=line_coord_lon2,
                 y0=line_coord_lat1, y1=line_coord_lat2, lwd=line_width, col=line_col, code=0)
        }
        if(contour==TRUE) { 
          contour(x=x, y=y, z=z, col=contour_col, lwd=contour_lwd, labcex=contour_labcex,
                  levels=pretty(c(brks[1],tail(brks,1)), col=col_nr), add=TRUE)
        }
    graphics.off()
  }
  
### Examples:
# x=seq(-180,177.5,2.5)
# y=seq(0,90,2.5)
# z_cont=matrix(runif(5328, min=-0.7, max=-0.3), nrow=length(seq(-180,177.5,2.5)), ncol=length(seq(0,90,2.5)))
# z_disc=matrix(sample(x=0:4, size=5328, replace=TRUE), nrow=length(seq(-180,177.5,2.5)), ncol=length(seq(0,90,2.5)))
# x_lab=c("-160°","-120°","-80°","-40°","0°","40°","80°","120°","160°")
# y_lab=c("0°","20°","40°","60°","80°")

# plottingDataOnMap(file="Map_continuous.png", width=19.5, height=6.8, res=300, ptsize=18,
#                   x=x, y=y, z=z_cont, x_lab=x_lab, y_lab=y_lab,
#                   lab_brks=c("-0.7","-0.65","-0.6","-0.55","-0.5","-0.45","-0.4","-0.35","-0.3"),
#                   brks=c(-0.7,-0.65,-0.6,-0.55,-0.5,-0.45,-0.4,-0.35,-0.3),
#                   reverse=FALSE, col_scale_type="continuous", col_scale_type2="built-in",
#                   col_nr=9, col_scale="Blues",
#                   lat_lines=seq(0,80,20), lon_lines=seq(-160,160,20),
#                   lon_primary=seq(-160,160,40), lat_primary=seq(0,80,20),
#                   lon_secondary=seq(-160,160,20), lat_secondary=seq(0,80,20),
#                   size_axis_x=1, size_axis_y=1, col_axis_x="grey60", col_axis_y="grey60",
#                   col_geo_lines="black", col_borders="grey60",
#                   point=TRUE, point_x=c(-150,20,-140,30), point_y=c(52.5,60,30,42.5),
#                   point_pch=16, point_size=1.5, point_col="red",
#                   connect_points=TRUE, line_coord_lon1=c(-150,20), line_coord_lon2=c(-140,30),
#                   line_coord_lat1=c(52.5,60), line_coord_lat2=c(30,42.5), line_width=3, line_col="red",
#                   contour=FALSE, contour_col="red2", contour_lwd=2, contour_labcex=0.7)
# 
# plottingDataOnMap(file="Map_discrete_with_custom_colorscale.png", width=19.5, height=6.8, res=300, ptsize=18,
#                   x=x, y=y, z=z_disc, x_lab=x_lab, y_lab=y_lab, lab_brks=0:4, brks=0:4,
#                   reverse=FALSE, col_scale_type="discrete", col_scale_type2="custom",
#                   col_nr=5, col_scale=c("white", "#c896ff", "#ff9664", "#64ffc8", "#6496ff"),
#                   lat_lines=seq(0,80,20), lon_lines=seq(-160,160,20),
#                   lon_primary=seq(-160,160,40), lat_primary=seq(0,80,20),
#                   lon_secondary=seq(-160,160,20), lat_secondary=seq(0,80,20),
#                   size_axis_x=1, size_axis_y=1, col_axis_x="grey60", col_axis_y="grey60",
#                   col_geo_lines="black", col_borders="grey60",
#                   point=TRUE, point_x=c(-150,20,-140,30), point_y=c(52.5,60,30,42.5),
#                   point_pch=16, point_size=1.5, point_col="red",
#                   connect_points=TRUE, line_coord_lon1=c(-150,20), line_coord_lon2=c(-140,30),
#                   line_coord_lat1=c(52.5,60), line_coord_lat2=c(30,42.5), line_width=3, line_col="red",
#                   contour=FALSE, contour_col="red2", contour_lwd=2, contour_labcex=0.7)
# 
# plottingDataOnMap(file="Map_discrete_with_built-in_colorscale.png", width=19.5, height=6.8, res=300, ptsize=18,
#                   x=x, y=y, z=z_disc, x_lab=x_lab, y_lab=y_lab, lab_brks=0:4, brks=0:4,
#                   reverse=FALSE, col_scale_type="discrete", col_scale_type2="built-in",
#                   col_nr=4, col_scale="Blues",
#                   lat_lines=seq(0,80,20), lon_lines=seq(-160,160,20),
#                   lon_primary=seq(-160,160,40), lat_primary=seq(0,80,20),
#                   lon_secondary=seq(-160,160,20), lat_secondary=seq(0,80,20),
#                   size_axis_x=1, size_axis_y=1, col_axis_x="grey60", col_axis_y="grey60",
#                   col_geo_lines="black", col_borders="grey60",
#                   point=TRUE, point_x=c(-150,20,-140,30), point_y=c(52.5,60,30,42.5),
#                   point_pch=16, point_size=1.5, point_col="red",
#                   connect_points=TRUE, line_coord_lon1=c(-150,20), line_coord_lon2=c(-140,30),
#                   line_coord_lat1=c(52.5,60), line_coord_lat2=c(30,42.5), line_width=3, line_col="red",
#                   contour=FALSE, contour_col="red2", contour_lwd=2, contour_labcex=0.7)

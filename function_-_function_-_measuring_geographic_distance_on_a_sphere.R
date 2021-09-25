#########################################################################
### COMPUTING DISTANCES BETWEEN TWO POINTS ON THE SURFACE OF A SPHERE ###
#########################################################################

# alpha1: longitude of the first point (between 0 and 360)
# alpha2: longitude of the second point (between 0 and 360)
# fi1: latitude of the first point (between 0 and 180)
# fi2: latitude of the second point (between 0 and 180)
# radius: radius of the sphere, 6371 km (average radius of the Earth) is taken by default

### Function to compute geographical distance:
geo_distance <- function(alfa1,alfa2,fi1,fi2,radius=6371) {
  # Convert grades to radian:  
  alfa1rad <- (alfa1*pi)/180
  alfa2rad <- (alfa2*pi)/180
  fi1rad <- (fi1*pi)/180
  fi2rad <- (fi2*pi)/180
  
  # Cosine of the angle between the vectors drawn from the center of the Earth to the two points on the sphere:
  costeta  <- cos(fi1rad)*cos(fi2rad)*cos(alfa1rad-alfa2rad)+sin(fi1rad)*sin(fi2rad)
  
  # Computing arcus cosine of the costeta and multiply with the radius of the Earth to get the distance:
  d <- acos(costeta)*radius
  
  return(d)
}
library("animation")
myfun <- function ( ) {
  n = ani.options("nmax")
  x = sample(1:n)
  y = sample(1:n)
  for (i in 1:n) {  
    plot(x[i], y[i], cex = 3, col = 3, pch = 3, , lwd = 2,
         ylim = c(0, 50),
         xlim = c(0, 50))
    ani.pause()   
    }
  }
saveHTML()
par(mar = c(3, 3, 1, 0.5), mgp = c(1.5, 0.5, 0), tcl = -0.3) 
myfun() 
#ani.stop()
library(rbokeh)

p <- figure(logo=NULL, tools = c("pan","wheel_zoom","box_zoom","resize", "reset", "save")) %>%
  ly_points(Sepal.Length, Sepal.Width, data = iris,
                        color = Species, glyph = Species,
            hover = "orpa ma @Species ")

rbokeh2html(p,file="test.html")
p
            
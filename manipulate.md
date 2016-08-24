---
title: "manipulate"
output: html_document
---


```

## Including Plots

You can also embed plots, for example:


```{r, echo = FALSE}
shinyAppDir(
  system.file("examples/06_tabsets", package="shiny"),
  options=list(
    width="100%", height=700
  )
)

```

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.

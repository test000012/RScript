
source("shaded_errorbar.R")
require("R.matlab")
library(ggsci)
library(ggsignif)
library(ggplot2)

## example) number of predictor = 2   --------
## It needs to make the dataset by matlab as follow:
## PLRData( predictor(e.g.NR or R), time, 1) = time data(e.g. -0.2s ~ 1.5s)
## PLRData( predictor(NR or R), time, 2) = Standard error of the mean(lower)
## PLRData( predictor(NR or R), time, 3) = Standard error of the mean(upper)
## PLRData( predictor(NR or R), time, 4) = averaged PLR

PLRdata <- readMat('data1.mat')
g <- c("PNN","PNR")
d <- makeDataSet(PLRdata,g)
config <- list(lim_x = c(-0.2,1.5),
               lim_y = c(-0.5, 4),
               alpha = 0.3,
               label_x = "Condition",
               label_y = "Pupil Changes [%]",
               gr = c("#F8766D","#ECB01F"),
               grCol = c("#F8766D","#ECB01F")
)

p <- disp(d,config,1)
print(p)


## example) number of predictor = 3   --------

PLRdata <- readMat('data2.mat')
g <- c("NR->R","NR->NR",'R->R')
d <- makeDataSet(PLRdata,g)

config <- list(lim_x = c(-0.2, 1.5),
               lim_y = c(-0.5, 4),
               alpha = 0.3,
               label_x = "Time [s]",
               label_y = "Pupil Changes [%]",
               gr = c("#ECB01F","#F8766D","#619CFF"),
               grCol = c("#F8766D","#ECB01F","#619CFF")
)
p <- disp(d,config,1)
print(p)
##------------------------------------------
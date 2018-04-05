
source("/Users/Yuta-PC/Documents/Rscript/shaded_error/shaded_errorbar.R")
require("R.matlab")

## example) number of predictor = 2   --------
## It needs to make the dataset by matlab as follow:
## PLRData( predictor(e.g.NR or R), time, 1) = time data(e.g. -0.2s ~ 1.5s)
## PLRData( predictor(NR or R), time, 2) = Standard error of the mean(lower)
## PLRData( predictor(NR or R), time, 3) = Standard error of the mean(upper)
## PLRData( predictor(NR or R), time, 4) = averaged PLR

PLRdata <- readMat('/Users/Yuta-PC/Documents/matlab/Insight/hiddenPictureAnalysis6.3.0/datashow/data5.mat')
g <- c("PNN","PNR","PRR")
d <- makeDataSet(PLRdata,g)
config <- list(xlim = c(-0.2, 4.0),
               ylim = c(-0.5, 0.2),
               alpha = 0.3,
               label_x = "Condition",
               label_y = "Pupil Changes [%]",
               gr = c("#FFFFFF","#808080","#1A1A1A"),
               gr_point = c("#F8766D","#ECB01F","#619CFF")
)

p <- disp(d,config,1)
print(p)



## example) number of predictor = 3   --------
# source( "/Users/Yuta-PC/Documents/Rscript/clearFunc.R" )
# clearAll()
# 
# source("/Users/Yuta-PC/Documents/Rscript/shaded_error/shaded_errorbar.R")
# require("R.matlab")
# library(ggsci)
# 
# PLRdata <- readMat('/Users/Yuta-PC/Documents/matlab/Insight/hiddenPictureAnalysis6.3.0/datashow/data5.mat')
# g <- c("NR->R","NR->NR",'R->R')
# d <- makeDataSet(PLRdata,g)
# 
# config <- list(lim_x = c(-0.2, 3),
#                lim_y = c(-0.5, 8),
#                alpha = 0.3,
#                label_x = "Time [s]",
#                label_y = "Pupil Changes [%]",
#                gr = c("#ECB01F","#F8766D","#619CFF"),
#                gr_point = c("#F8766D","#ECB01F","#619CFF")
# )
# p <- disp(d,config,1)
# print(p)
##------------------------------------------
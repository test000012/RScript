
source("/Users/Yuta-PC/Documents/Rscript/Insight/initialization.R")

##----- show the results in the glare condition --------
## It needs to make the dataset by matlab as follow:
## PLRData( predictor(e.g.NR or R), time, 1) = time data(e.g. -0.2s ~ 1.5s)
## PLRData( predictor(NR or R), time, 2) = Standard error of the mean(lower)
## PLRData( predictor(NR or R), time, 3) = Standard error of the mean(upper)
## PLRData( predictor(NR or R), time, 4) = averaged PLR

PLRdata <- readMat('/Users/Yuta-PC/Documents/matlab/Glare2/colorGlareExp/analysis/dataShow/data1.mat')
PLRdata$dataForR <- PLRdata$dataForR[1:7,,]
g <- c("Black","Blue","Cyan","Green","Yellow","Red","Magenta")

d <- makeDataSet(PLRdata,g)
config <- list(lim_x = c(-0.2, 4.0),
               lim_y= c(-0.45, 0.2),
               label_x = "Time [s]",
               label_y = "Pupil Changes [%]",
               grCol=g,
               title = "Glare")
p <- disp(d,config,0)
print(p)
ggsave(file = "/Users/Yuta-PC/Desktop/results_glare.pdf", plot = p, dpi = 100, width = 6.4, height = 4.8)

##----- show the results in the control condition --------
PLRdata <- readMat('/Users/Yuta-PC/Documents/matlab/Glare2/colorGlareExp/analysis/dataShow/data1.mat')

PLRdata$dataForR <- PLRdata$dataForR[8:14,,]
d <- makeDataSet(PLRdata,g)
config$title <- "Control"
p <- disp(d,config,0)
print(p)
ggsave(file = "/Users/Yuta-PC/Desktop/results_control.pdf", plot = p, dpi = 300, width = 6.4, height = 4.8)

##----- show color spectrum data ---------
source("/Users/Yuta-PC/Documents/Rscript/shaded_error/shaded_errorbar.R")
PLRdata <- readMat('/Users/Yuta-PC/Documents/matlab/Glare2/SRDespp/data1.mat')
g <- c("Black","Blue","Cyan","Green","Yellow","Red","Magenta")

config <- list(lim_x = c(380, 780),
               lim_y = c(0, 0.005),
               alpha_val = 0.2,
               label_x = "Wavelength [nm]",
               label_y = expression(paste("Radiance [W*sr"^{"-1"},"*m"^{"-2"} ,"]" )),
               grCol=g)
d <- makeDataSet(PLRdata,g)
p <- disp(d,config,1)
print(p)
ggsave(file = "/Users/Yuta-PC/Desktop/colorDest.pdf", plot = p, dpi = 300, width = 6.4, height = 4.8)

##----- show the correlation between PLR and adjusted luminane-----

source("/Users/Yuta-PC/Documents/Rscript/shaded_error/shaded_errorbar.R")
PLRdata <- readMat('/Users/Yuta-PC/Documents/matlab/Glare2/colorGlareExp/analysis/dataShow/data2.mat')
g <- c("Black","Blue","Cyan","Green","Yellow","Red","Magenta")

d <- PLRdata$dataScatterForR
x <- NULL
y <- NULL
for (i in 1 : dim(d)[1] ) {
  x <- c(x, d[i, ,1])
  y <- c(y, d[i, ,2])
}
ribbondata <- data.frame(X=x,Y=y)
  groups <- rep(g, dim(d)[1])

ribbondata  <- cbind(ribbondata,groups)
config <- list(lim_x = c(0.8, 1.4),
               lim_y = c(-0.7, 0.6),
               alpha_val = 0.7,
               label_x = "Adjusted luminance",
               label_y = "Pupil Changes [mm]",
               grCol=g)

res <- lm(Y ~ X, data = ribbondata)

newdata <- data.frame(X=seq(0.5,1.5,0.001))
norns.con <- predict(res,newdata, interval="confidence",level=0.95)
norns.con <- as.data.frame(norns.con)

intercept_val <- summary(res)$coefficients[1,"Estimate"]
slope_val <- summary(res)$coefficients[2,"Estimate"]

data.conf <- data.frame(x = newdata$X,ymin = norns.con$lwr,ymax = norns.con$upr)

g3 <- ggplot() + 
  geom_line(aes(newdata$X,norns.con$lwr), colour="gray",linetype = "dotdash",size=0.5)+
  geom_line(aes(newdata$X,norns.con$upr), colour="gray",linetype = "dotdash",size=0.5)+
  geom_ribbon(data = data.conf, alpha = 0.3,
              aes(x = x, ymin = ymin, ymax = ymax)) +
  
  geom_point(data = ribbondata, alpha = config$alpha_val,
             aes(x = X, y = Y, colour = groups, fill = groups), size = 3) +
  scale_color_manual(values = config$gr) +
  # scale_size_area()+
  xlab(config$label_x) + ylab(config$label_y) + 
  coord_cartesian(xlim=config$lim_x, ylim=config$lim_y) +
  # scale_x_continuous(expand = c(0, 0))+
  geom_abline(intercept = intercept_val, slope = slope_val)

g3 <- g3+theme(
  axis.title.x = element_text(size=16),
  axis.title.y = element_text(size=16),
  axis.text.x = element_text(colour="black"),
  axis.text.y = element_text(colour="black"),
  panel.background = element_rect(fill = "transparent",color = 'black'),
  panel.grid.major = element_line(colour = "gray", size = 0.05),
  panel.grid.minor = element_line(colour = NA),
  text=element_text(size=16,family="Times")
)
print(g3)
ggsave(file = "/Users/Yuta-PC/Desktop/correlation.pdf", plot = g3, dpi = 300, width = 6.4, height = 4.8)



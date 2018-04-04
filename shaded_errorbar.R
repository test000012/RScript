
makeDataSet <- function(PLRdata,gr) {
  d <- PLRdata$dataForR
  data_x <- NULL
  data_y <- NULL
  ymin <- NULL
  ymax <- NULL
  for (i in 1 : dim(d)[1] ) {
    data_x <- c(data_x, d[i, ,1])
    ymin <- c(ymin, d[i, ,2])
    ymax <- c(ymax, d[i, ,3])
    data_y <- c(data_y, d[i, ,4])
  }
  
  # order_line <- c(6,1,2,3,7,5,4,13,8,9,10,14,12,11)
  # order_line <- c(1,2,3,4,5,6,7,8,9,10,11,12,13,14)
  
  order_line <- c(1,2,3,4,5,6,7)
  
  ribbondata <- data.frame(data_x,data_y,ymin,ymax)
  datalen = length(ymin)
  
  groups <- NULL
  order <- NULL
  for (i in 1 : dim(d)[1] ) {
    groups <- c(groups,rep(gr[i], dim(d)[2]))
    order <- c(order,rep(order_line[i], dim(d)[2]))
  }
  ribbondata  <- cbind(ribbondata,groups,order)
  return(ribbondata)
}

disp <- function(ribbondata,config,shadeFl){
  
  if (shadeFl == 1) {
    
    ribbondata$groups <- factor(ribbondata$groups, levels = ribbondata$groups[order(ribbondata$order)])
    
    g2 <- ggplot() + 
      geom_ribbon(data = ribbondata, alpha = config$alpha,
                  aes(x = data_x, ymin = ymin, ymax = ymax, 
                      group = groups, fill = groups)) + 
      geom_line(data = ribbondata, 
                aes(x = data_x, y = data_y, colour = groups, group = groups)) + 
      # , linetype = "solid"
      # ggtitle(config$title) +
      scale_color_manual(values = config$grCol)  + 
      scale_fill_manual(values = config$grCol) +
      xlab(config$label_x) + ylab(config$label_y) + 
      coord_cartesian(xlim = config$lim_x, ylim=config$lim_y) +
      scale_x_continuous(expand = c(0, 0))
    
  }else{ 
    ribbondata$groups <- factor(ribbondata$groups, levels = ribbondata$groups[order(ribbondata$order)])
    
    g2 <- ggplot() + 
      geom_line(data = ribbondata, 
                aes(x = data_x, y = data_y, colour = groups, group = groups)) + 
      # , linetype = "solid"
      ggtitle(config$title) +
      scale_color_manual(values = config$grCol)  + 
      xlab(config$label_x) + ylab(config$label_y) + 
      coord_cartesian(xlim=config$lim_x, ylim=config$lim_y)+
      scale_x_continuous(expand = c(0, 0))
  }
  
  g2 <- g2+theme(
    axis.text.x = element_text(colour="black"),
    axis.text.y = element_text(colour="black"),
    panel.background = element_rect(fill = "transparent",color = 'black'),
    panel.grid.major = element_line(colour = "gray", size = 0.1),
    panel.grid.minor = element_line(colour = NA),
    text=element_text(size=16,family="Times")
  )
  
  return(g2)
}

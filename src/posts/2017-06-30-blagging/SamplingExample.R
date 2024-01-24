pacman::p_load(dplyr, ggplot2, latex2exp)


theme_set(theme_gray(base_size = 16))
m <- 100              # size of dataset
sd <- 0.17           # noise
theta <- 0.2
Neg <- "#F8766D"
Pos <- "#00BFC4"

#Input til resolution
dpi=300
w=40 *0.5
h=18 *0.5


# simulate label -1
neg.x <- -theta + rnorm(m,sd=sd)
neg.df <- data.frame(label = -1, x = neg.x)

# simulate label 1
pos.x <- theta + rnorm(m,sd=sd)
pos.df <- data.frame(label = 1, x = pos.x)

# bind the two, add a constant for threshold and sample the data to prepare for train/test split
df <- rbind(neg.df, pos.df)
df <- df[sample(1:nrow(df),nrow(df)),]

ggplot(data=data.frame(y=0,x=df$x,col=ifelse(df$label==-1,Pos,Neg))) +
  coord_cartesian(xlim = c(-0.5,0.5),ylim= c(0,3)) + 
  geom_point(aes(x=x,y=y,colour=col)) + 
  stat_function(fun=dnorm,
                color=Neg,
                args=list(mean=-theta, 
                          sd=sd),
                xlim=c(-0.6,0.4)) + 
  stat_function(fun=dnorm,
                color=Pos,
                args=list(mean=theta, 
                          sd=sd),
                xlim=c(-0.4,0.6)) + 
  geom_vline(xintercept=0) + 
  theme(legend.position="none") +
  ylab(NULL) +
  xlab(NULL)
ggsave("samplingOpt.png", width=w, height=h, units = "cm",dpi=dpi)



thresholds <- seq(-0.4,0.4,by = 0.001)



# Minority class of negative observations --------------------------------------


# simulate label -1
neg.x <- -theta + rnorm(m,sd=sd)
neg.df <- data.frame(label = -1, x = neg.x)

# simulate label 1
pos.x <- theta + rnorm(m*10,sd=sd)
pos.df <- data.frame(label = 1, x = pos.x)

# bind the two, add a constant for threshold and sample the data to prepare for train/test split
df <- rbind(neg.df, pos.df)
df <- df[sample(1:nrow(df),nrow(df)),]

ggplot(data=data.frame(y=0,x=df$x,col=ifelse(df$label==-1,Pos,Neg))) +
  coord_cartesian(xlim = c(-0.5,0.5),ylim= c(0,3)) + 
  geom_point(aes(x=x,y=y,colour=col)) + 
  stat_function(fun=dnorm,
                color=Neg,
                args=list(mean=-theta, 
                          sd=sd),
                xlim=c(-0.6,0.4)) + 
  stat_function(fun=dnorm,
                color=Pos,
                args=list(mean=theta, 
                          sd=sd),
                xlim=c(-0.4,0.6)) + 
  geom_vline(xintercept=thresholds[which.min(sapply(thresholds,function(thresh) mean(ifelse(df$x<thresh,-1,1)!=df$label)))]
  ) + 
  theme(legend.position="none")+
  ylab(NULL) +
  xlab(NULL)
ggsave("samplingUndersampled.png", width=w, height=h, units = "cm",dpi=dpi)



# Undersampling -----------------------------------------------------------

pos.df <- df[sample(which(df$label==1),sum(df==-1),replace = T),]

# bind the two, add a constant for threshold and sample the data to prepare for train/test split
tmp.df <- rbind(neg.df, pos.df)
tmp.df <- tmp.df[sample(1:nrow(tmp.df),nrow(tmp.df)),]
  
ggplot(data=data.frame(y=0,x=tmp.df$x,col=ifelse(tmp.df$label==-1,Pos,Neg))) +
  coord_cartesian(xlim = c(-0.5,0.5),ylim= c(0,3)) + 
  geom_point(aes(x=x,y=y,colour=col)) + 
  stat_function(fun=dnorm,
                color=Neg,
                args=list(mean=-theta, 
                          sd=sd),
                xlim=c(-0.6,0.4)) + 
  stat_function(fun=dnorm,
                color=Pos,
                args=list(mean=theta, 
                          sd=sd),
                xlim=c(-0.4,0.6)) + 
  geom_vline(xintercept=thresholds[which.min(sapply(thresholds,function(thresh) mean(ifelse(tmp.df$x<thresh,-1,1)!=tmp.df$label)))]
  )+ 
  theme(legend.position="none")+
  ylab(NULL) +
  xlab(NULL)
ggsave("samplingUnder1.png", width=w, height=h, units = "cm",dpi=dpi)





thresh.list <- c()
for(i in 1:10){
  
  pos.df <- df[sample(which(df$label==1),sum(df==-1),replace = T),]
  
  
  # bind the two, add a constant for threshold and sample the data to prepare for train/test split
  tmp.df <- rbind(neg.df, pos.df)
  tmp.df <- tmp.df[sample(1:nrow(tmp.df),nrow(tmp.df)),]
  
  thresh.list <- c(thresh.list,thresholds[which.min(sapply(thresholds,function(thresh) mean(ifelse(tmp.df$x<thresh,-1,1)!=tmp.df$label)))])
}


gg <- ggplot(data=data.frame(y=0,x=df$x,col=ifelse(df$label==-1,Pos,Neg))) +
  coord_cartesian(xlim = c(-0.5,0.5),ylim= c(0,3)) + 
  geom_point(aes(x=x,y=y,colour=col)) + 
  stat_function(fun=dnorm,
                color=Neg,
                args=list(mean=-theta, 
                          sd=sd),
                xlim=c(-0.6,0.4)) + 
  stat_function(fun=dnorm,
                color=Pos,
                args=list(mean=theta, 
                          sd=sd),
                xlim=c(-0.4,0.6)) + 
  theme(legend.position="none")+
  ylab(NULL) +
  xlab(NULL)

# Plotting all the clfs
for(t in thresh.list){
  gg <- gg + geom_vline(xintercept=thresh.list[t]
  )
}
gg
ggsave("samplingUnderMany.png", width=w, height=h, units = "cm",dpi=dpi)


# The bagged clf
ggplot(data=data.frame(y=0,x=df$x,col=ifelse(df$label==-1,Pos,Neg))) +
  coord_cartesian(xlim = c(-0.5,0.5),ylim= c(0,3)) + 
  geom_point(aes(x=x,y=y,colour=col)) + 
  stat_function(fun=dnorm,
                color=Neg,
                args=list(mean=-theta, 
                          sd=sd),
                xlim=c(-0.6,0.4)) + 
  stat_function(fun=dnorm,
                color=Pos,
                args=list(mean=theta, 
                          sd=sd),
                xlim=c(-0.4,0.6)) + 
  geom_vline(xintercept=mean(thresh.list)
                ) + 
  theme(legend.position="none")+
  ylab(NULL) +
  xlab(NULL)
ggsave("samplingUnderBag.png", width=w, height=h, units = "cm",dpi=dpi)

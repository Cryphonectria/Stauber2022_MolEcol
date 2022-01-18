## manhattan plot for positive selection scans

raisd_manhattan <- function(x, sampling) {
  
  mh <- x %>% 
    
    # Compute chromosome size
    group_by(Chr) %>% 
    summarise(chr_len=max(Pos)) %>% 
    
    # Calculate cumulative position of each chromosome
    mutate(tot=cumsum(chr_len)-chr_len) %>%
    select(-chr_len) %>%
    
    # Add this info to the initial dataset
    left_join(x, ., by=c("Chr"="Chr")) %>%
    
    # Add a cumulative position of each SNP
    arrange(Chr, Pos) %>%
    mutate(BPcum=Pos+tot)
  
  axisdf = mh %>% group_by(Chr) %>% summarize(center=( max(BPcum) + min(BPcum) ) / 2 )
  
  if (sampling==1) {
    xlim=38905355
  } else {xlim=500000}
  
  ggplot(filter(mh, p >= 0), aes(x=BPcum, y=p)) +
    geom_point( aes(color=as.factor(Chr)), alpha=0.7, size=1) +
    scale_color_manual(values = rep(c("#BD632F", "#273E47"), 22 )) +
    # custom X axis:
    scale_x_continuous( label = axisdf$Chr, breaks= axisdf$center ) +
    #scale_y_continuous(expand = c(0, 0), breaks = seq(0,200,pval.view/10), limits = c(0,pval.view)) +     # remove space between plot area and x axis
    labs(x = "Scaffolds", y = expression(mu~"-statistic")) +
    # Custom the theme:
    theme_bw() +
    theme( 
      legend.position="none",
      panel.border = element_blank(),
      panel.grid.major.x = element_blank(),
      panel.grid.minor.x = element_blank()) +
    geom_hline(yintercept = 3.383e+01, col="grey40", linetype="longdash") + # neutral
    geom_hline(yintercept = 6.950e+00, col="grey40", linetype="longdash") + # bottleneck
    geom_hline(yintercept = 2.943e+01, col="grey40", linetype="longdash") + # expansion
    annotate("text", x= xlim, y=12, label="bottleneck") +
    annotate("text", x= xlim, y=31, label="expansion") +
    annotate("text", x= xlim, y=35.5, label="neutral") 
  
}



### manhattan plot for betascan
betascan_manhattan <- function(x, sampling) {
  if (sampling==1) {
    pop="Ticino_sampling1"
  } else {pop="Ticino_sampling2"}
  
  df <- filter(betascan, sampling == pop) %>% na.omit()
  ## make manhattan plot
  mh <- df %>% 
    
    # Compute chromosome size
    group_by(Chr) %>% 
    summarise(chr_len=max(Pos)) %>% 
    
    # Calculate cumulative position of each chromosome
    mutate(tot=cumsum(chr_len)-chr_len) %>%
    select(-chr_len) %>%
    
    # Add this info to the initial dataset
    left_join(df, ., by=c("Chr"="Chr")) %>%
    
    # Add a cumulative position of each SNP
    arrange(Chr, Pos) %>%
    mutate(BPcum=Pos+tot)
  
  axisdf = mh %>% group_by(Chr) %>% summarize(center=( max(BPcum) + min(BPcum) ) / 2 )
  
  
  ggplot(filter(mh, p >= 0), aes(x=BPcum, y=p)) +
    geom_point( aes(color=as.factor(Chr)), alpha=0.7, size=1) +
    scale_color_manual(values = rep(c("#000000", "#9381FF"), 22 )) +
    # custom X axis:
    scale_x_continuous( label = axisdf$Chr, breaks= axisdf$center ) +
    labs(x = "Scaffolds", y = expression(beta~"-statistic")) +
    # Custom the theme:
    theme_bw() +
    theme( 
      legend.position="none",
      panel.border = element_blank(),
      panel.grid.major.x = element_blank(),
      panel.grid.minor.x = element_blank())
  
}

### manhattan plot for Tajimas D
tajima_manhattan <- function(x, sampling) {
  if (sampling==1) {
    pop="Ticino_sampling1"
  } else {pop="Ticino_sampling2"}
  
  t <- filter(tajima, sampling ==pop)
  
  mh <- t %>% 
    
    # Compute chromosome size
    group_by(Chr) %>% 
    summarise(chr_len=max(Pos)) %>% 
    
    # Calculate cumulative position of each chromosome
    mutate(tot=cumsum(chr_len)-chr_len) %>%
    select(-chr_len) %>%
    
    # Add this info to the initial dataset
    left_join(t, ., by=c("Chr"="Chr")) %>%
    
    # Add a cumulative position of each SNP
    arrange(Chr, Pos) %>%
    mutate(BPcum=Pos+tot)
  axisdf = mh %>% group_by(Chr) %>% summarize(center=( max(BPcum) + min(BPcum) ) / 2 )
  
  ggplot(mh, aes(x=BPcum, y=TajimaD)) +
    geom_point( aes(color=as.factor(Chr)), alpha=0.7, size=1) +
    scale_color_manual(values = rep(c("#000000", "#508991"), 22 )) +
    # custom X axis:
    scale_x_continuous( label = axisdf$Chr, breaks= axisdf$center ) +
    #scale_y_continuous(expand = c(0, 0), breaks = seq(0,200,pval.view/10), limits = c(0,pval.view)) +     # remove space between plot area and x axis
    labs(x = "Scaffolds", y = "Tajima's D") +
    # Custom the theme:
    theme_bw() +
    theme( 
      legend.position="none",
      panel.border = element_blank(),
      panel.grid.major.x = element_blank(),
      panel.grid.minor.x = element_blank()) +
    geom_hline(yintercept = 0)
  
}


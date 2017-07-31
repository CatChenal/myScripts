library(lattice)
require(graphics)
require(grid)
require(sp)

# Run | Type | Val
# MID | Ex apo | 2
dat<-read.csv('C:/Users/Cat/Documents/Lab Gunner/MCCE/mcce_R/affin_run_type_val.csv')

UMD_f<-factor( dat$Type, levels=unique( grep("X1|1C|XC", dat$Type, perl=TRUE, value=TRUE, invert=TRUE)), ordered = TRUE)
# removed:, "Ex, XC", "XC.x", "XC.c", "Xi" and "1C"

dat2<-dat[ dat$Type %in% levels(UMD_f) , ]

Type_f<-factor( dat2$Type, levels=levels(UMD_f), ordered = TRUE )
#"Ex, apo", "Ex, X0", "X0_E-1", "X0", "X0_E01", "Ex, 0C", "0C_E-1", "0C", "0C_E01"

Run_f<-levels( dat2$Run )

y_label <- "Free energy (kcal/mol)"

tiff( filename= "C:/Users/Cat/Documents/Lab Gunner/MCCE/mcce_R/Figure 2 highres.tiff",
      width= 6.5,  height=4.25, res= 1200, units="in", pointsize= 11,
      bg= "transparent", family= "", restoreConsole= TRUE, 
      type= c("windows", "cairo"), antialias = "cleartype"
    )

col_Ex <- c('#D5FFFFFF')
# col_neu <- c('#F2F2F2FF') #light grey
# col_free <- c('white')
col_ion <- c('#FFE0B2FF')

bgColors<-c(col_Ex, col_Ex, col_ion, col_ion, col_ion, col_Ex, col_ion, col_ion, col_ion)
txtColors <- c("black", "black", "black", "black","black","black", "black", "black","black")

facLabels <- c( expression( paste( E[x], ", apo", sep="") ), 
                expression( paste( E[x], ", X0", sep="") ),
                expression( paste("X",0^-1, sep="") ),
                expression( "X0" ), 
                expression( paste("X",0^0, sep="") ),
                expression( paste( E[x],", 0C", sep="") ),
                expression( paste("0", C^-1, sep="") ),
                expression( "0C" ),
                expression( paste("0", C^0, sep="")) )


#par.strip.text=list(lineheight=.8,lines=3)

# Create a function to be passed to "strip=" argument of plot
myStripStyle <- function( which.panel, factor.levels, 
                          style=1,
                          par.strip.text,
                          par.strip.border=list(col="black"),
                          custBgCol=par.strip.text$custBgCol,
                          custTxtCol=par.strip.text$custTxtCol, ...)
{
  panel.rect( 0, 0, 1, 1,
              col = custBgCol[which.panel],
              border = 1 )
  panel.text( x = 0.5, y = 0.5,
              lines=2, font=2, cex = 1,
              lab = facLabels[which.panel] )
}

exp_sep <- "\ \ \ \ \ \ \ \ \ "
main_ttl <- paste( "a", "b", "c", "d", "e", "f", "g", "h", "i", sep=exp_sep )

myParSettings <- list( layout.heights=list( strip=2 ),
                       par.main.text = list( font.main=1, cex.main=0.5),
                       box.umbrella = list( col = "black", pch=3, lty= "dotted"), 
                       plot.symbol   = list( cex = 0.7, col = 1, pch= 1) #outlier size and color
                       #box.dot = list(col = "black", pch = 3, cex=2)
                       )
# mar =  c(bottom, left, top, right)
bp_X <- bwplot( dat2$Val ~ dat2$Run | Type_f,  
                xlab="", ylab=y_label, pch = 3, col= "#FF005CFF", scales=list(x=list(rot=90)),
                cex=1, cex.lab=0.5,
                yaxp=c(-22, 10), ylog=FALSE,
                par( mar = c(0.7, 0.7, 0.7, 0.7)+0.05 ),  
                main = main_ttl,
                par.settings=myParSettings,
                layout = ( c(length( levels(Type_f) ) , 1 )),
                par.strip.text = list(custBgCol=bgColors, custTxtCol=txtColors),
                strip=myStripStyle, 
                panel = function(x, y, groups, subscripts, ...) {
                          panel.grid( h = -1, v = 0 )
                          panel.bwplot( x, y, ..., jitter.data = FALSE, 
                                        groups = Type_f, 
                                        subscripts = subscripts,
                                        scales=list( x=list(rot=45) )
                                       )
                }
)
plot(bp_X)
dev.off()
bp_X
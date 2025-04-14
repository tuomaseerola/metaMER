library(metafor, warn.conflicts = FALSE)
library(dmetar, warn.conflicts = FALSE)
library(meta, warn.conflicts = FALSE)
library(DescTools, warn.conflicts = FALSE)
library(ggplot2, quietly = TRUE)
library(ggrepel, quietly = TRUE)
library(forestplot)
library(ggpubr)

C_summary <- read.csv("../analysis/C_summary.csv")
tmp <- C_summary

# Max values
m.cor <- metacor(cor = valuesMax,     # values 
                 n = stimulus_n,
                 studlab = studyREF, # unique_id
                 data = C_summary,
                 common = FALSE,
                 random = TRUE,
                 prediction = TRUE,
                 backtransf = TRUE,
                 sm = "ZCOR",
                 method.tau = "REML",# could be PM (Paule-Mandel) as well
                 method.random.ci = "HK", 
                 title = "MER: Classification: Summary")

#### Forest plot using forestplot
data<-tibble::tibble(mean=m.cor$cor,lower=DescTools::FisherZInv(m.cor$lower),upper=DescTools::FisherZInv(m.cor$upper),study=m.cor$studlab,n=m.cor$n,cor=format(round(m.cor$cor, digits=3), nsmall = 3))
data<-dplyr::arrange(data,mean)


#extrafont::loadfonts()
#extrafont::font_import()

fp1 <- grid.grabExpr(
  print(
    data |>
      forestplot(
        labeltext = c(study, n, cor),
        xticks.digits = 2,
        xlab = "Matthews Correlation Coefficient",
        xticks = seq(0,1,by=0.2),
        clip = c(0, 1)
      ) |>
      fp_add_header(
        study = "Study",
        n = "N",
        cor = expression(italic(r))
      ) |>
      fp_append_row(
        mean  = FisherZInv(m.cor$TE.random),
        lower = FisherZInv(m.cor$lower.random),
        upper = FisherZInv(m.cor$upper.random),
        study = "Summary",
        n = sum(m.cor$n),
        cor = round(FisherZInv(m.cor$TE.random), 3),
        is.summary = TRUE
      ) |>
      fp_set_style(
        box = "grey50",
        line = "grey20",
        summary = "black",
        txt_gp = fpTxtGp(
          ticks=gpar(cex=1.20),
          xlab  = gpar(fontfamily = "Linux Biolinum O", cex = 1.3),
          label = list(gpar(cex = 1.20, fontfamily = "Linux Biolinum O")),
        )
      ) |>
      fp_decorate_graph(grid = structure(
        FisherZInv(m.cor$TE.random)
      ))
  )
)


ggsave(
  filename = "figure4.png",
  dpi = 300,
  height = 6,
  width = 10,
  bg = "#FFFFFF",
  units = 'in',
  fp1
)

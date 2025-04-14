library(metafor, warn.conflicts = FALSE)
library(dmetar, warn.conflicts = FALSE)
library(meta, warn.conflicts = FALSE)
library(DescTools, warn.conflicts = FALSE)
library(ggplot2, quietly = TRUE)
library(ggrepel, quietly = TRUE)
library(forestplot)
library(ggpubr)
R_summary <- read.csv("../analysis/R_summary.csv")
tmp <- dplyr::filter(R_summary, dimension == "valence")
tmp$studyREF[tmp$studyREF == "Wang et al 2022"] <- c("Wang et al 2022a", "Wang et al 2022b")

# Max values
m.cor <- metacor(
  cor = valuesMax,
  # values
  n = stimulus_n,
  studlab = studyREF,
  #citekey, # unique_id
  data = tmp,
  common = FALSE,
  random = TRUE,
  prediction = TRUE,
  #                 backtransf = TRUE,
  #                 sm = "ZCOR",
  method.tau = "REML",
  # could be PM (Paule-Mandel) as well
  method.random.ci = "HK",
  title = "MER: Regression: Valence: Summary"
)

#### Forest plot using forestplot
data <- tibble::tibble(
  mean = m.cor$cor,
  lower = DescTools::FisherZInv(m.cor$lower),
  upper = DescTools::FisherZInv(m.cor$upper),
  study = m.cor$studlab,
  n = m.cor$n,
  cor = format(round(m.cor$cor, digits = 3), nsmall = 3)
)
data <- dplyr::arrange(data, mean)

fp1 <- grid.grabExpr(
  print(
    data |>
      forestplot(
        labeltext = c(study, n, cor),
        xticks.digits = 2,
        xlab = "Correlation",
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
        m.cor$TE.common
      ))
  )
)

ggsave(
  filename = "figure2.png",
  dpi = 300,
  height = 6,
  width = 10,
  bg = "#FFFFFF",
  units = 'in',
  fp1
)

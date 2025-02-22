custom_funnel_plot <- function(data, metric = "cor") {
  # Function to plot a funnel plot with 95% and 99% confidence intervals
  # assumes data from dmetar::metacor function
  
  tmpdata <- data.frame(
    SE = FisherZInv(data$seTE),
    Zr = FisherZInv(data$TE),
    studies = data$studlab
  )
  
  estimate = data$TE.common
  se = data$seTE.common
  se.seq = seq(0, max(data$cor), 0.001)
  ll95 = estimate - (1.96 * se.seq)
  ul95 = estimate + (1.96 * se.seq)
  ll99 = estimate - (3.29 * se.seq)
  ul99 = estimate + (3.29 * se.seq)
  meanll95 = estimate - (1.96 * se)
  meanul95 = estimate + (1.96 * se)
  dfCI = data.frame(ll95, ul95, ll99, ul99, se.seq, estimate, meanll95, meanul95)

  if(metric=="cor"){
    metric_label <- "Correlation"
  }
  if(metric=="MCC"){
      metric_label <- "Matthews Correlation Coefficient"
    }
  else {
    metric_label <- 'Not defined!'
  }

  fp = ggplot(NULL) +
    geom_point(aes(x = SE, y = Zr), color = 'grey50', data = tmpdata) +
    geom_text_repel(
      aes(x = SE, y = Zr, label = studies),
      data = tmpdata,
      size = 2.5,
      max.overlaps = 45
    ) +
    xlab('Standard Error') + ylab(metric_label) +
    geom_line(aes(x = se.seq, y = ll95), linetype = 'dotted', data = dfCI) +
    geom_line(aes(x = se.seq, y = ul95), linetype = 'dotted', data = dfCI) +
    geom_hline(
      yintercept = estimate,
      linetype = 'solid',
      color = 'grey50',
      linewidth = 0.2
    ) +
    scale_x_reverse(
      breaks = seq(0, 0.2, 0.05),
      limits = c(max(tmpdata$SE), 0),
      expand = c(0.001, 0.001)
    ) +
    scale_y_continuous(
      breaks = seq(0.0, 1.00, 0.25),
      limits = c(0.0, 1.00),
      expand = c(0.005, 0.005)
    ) +
    coord_flip() +
    theme_bw()
  return <- fp
}

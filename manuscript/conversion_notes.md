# Conversion from qmd to APA compatible pdf

`apaquarto` works pretty well, it has one bug in mac (can be bypassed).

TE 19/3/2025: I haven't managed to produce nice APA compatible tables in Quarto, since flextables library gives difficulties. The current solution is to use basic knitr::kable and one can add the apa horizontal lines directly in typst using "table.hline(start: 0),", which is a hack.



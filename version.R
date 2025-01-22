# show package version (these are controlled by renv)
print(paste("meta:",packageVersion("meta")))
print(paste("metafor:",packageVersion("metafor")))
print(paste("dmetar:",packageVersion("dmetar")))
print(paste("knitr:",packageVersion("knitr")))

print(sessionInfo())

# run me in terminal: R -e 'source("version.R")'
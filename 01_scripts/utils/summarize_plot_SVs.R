# Summarize and plot merged SVs from both SR and LR data

# This script is made to be executed by the 01_scripts/utils/summarize_plot.sh script
library(ggplot2)
library(ggpubr)
library(data.table)
library(scales)

# 1. Access files from command line ---------------------------------------
argv <- commandArgs(T)
MERGED <- argv[1]

# 2. Import and format ---------------------------------------------------
# Import and assign required class to each variable
merged <- read.table(MERGED, header = FALSE, 
                     col.names = c('CHROM', 'POS', 'ID', 'SVTYPE', 'SVLEN',
                                   'END', 'SUPP', 'SUPP_VEC'),
                     colClasses = c('character')
)

merged[, c('POS', 'SVLEN', 'END', 'SUPP')] <- sapply(merged[, c('POS', 'SVLEN', 'END', 'SUPP')],
                                                     as.numeric)

# Convert SV lengths to num and bins
SVLEN_breaks <- c(-Inf, 50, 100, 250, 500, 1000, 2500, 5000, 10000, Inf)
SVLEN_names <- c('[0-50[',
                 '[50-100[',
                 '[100-250[',
                 '[250-500[',
                 '[500-1000[',
                 '[1000-2500[',
                 '[2500-5000[',
                 '[5000-10000[',
                 '[10000+')

merged$SVLEN_bin <-
  cut(abs(merged$SVLEN), breaks = SVLEN_breaks, labels = SVLEN_names, right = FALSE)

# Add explicit platform info
merged$platform <- sapply(X = as.character(merged$SUPP_VEC), 
                        FUN = function(x){
                          switch(x,
                                 '10' = 'LR', 
                                 '01' = 'SR',
                                 '11' = 'LR + SR')
                        }
)


# 3. Plot -----------------------------------------------------------------
# Choose fun color scheme for sv types --------------------------------
## Get SVTYPE values
svtypes <- sort(unique(merged$SVTYPE)) 
#### we sort so that INV falls at the end of vector and 
#### is assigned the most divergent color from DELs, 
#### as INVs are rare and hard to distinguish bar plots

## Get hex code for as many colors as svtypes for a given viridis palette
hex_svtypes <- viridisLite::viridis(n = length(svtypes), option = 'D')
show_col(hex_svtypes)

## Assign a color to each svtype in a named vector
cols_svtypes <- vector(mode = 'character', length = length(svtypes))
for (i in 1:length(svtypes)) {
  names(cols_svtypes)[i] <- svtypes[i]
  cols_svtypes[i] <- hex_svtypes[i]
}

## Reorder platform callers
reordered_platform <- c('SR', 'LR', 'LR + SR')

merged$platform_reordered <- factor(merged$platform, 
                                   levels = reordered_platform)



# Plot by data type and sv type
ggplot(data = merged) +
  geom_bar(aes(x = platform_reordered, fill = SVTYPE)) + 
  theme(
    ## Plot title
    plot.title = element_text(size = 10, face = 'bold', hjust = 0.5),
    ## Axis
    axis.text.x = element_text(angle = 45, size = 6, hjust = 1),
    axis.text.y = element_text(size = 6, hjust = 1),
    axis.title.x = element_text(size = 8),
    axis.title.y = element_text(size = 8),
    ## Legend
    legend.title = element_text(size = 8, hjust = 0.5),
    legend.text = element_text(size = 7),
    legend.key.size = unit(5, 'mm')
  ) +
  labs(
    x = "Data type",
    y = "SV count",
    fill = "SV type",
    title = "Merged SV count by type and platform"
  ) + 
  scale_fill_manual(values = cols_svtypes)

# Plot by data type and size bins
ggplot(data = merged) +
  geom_bar(aes(x = SVLEN_bin, fill = platform_reordered)) + 
  theme(
    ## Plot title
    plot.title = element_text(size = 10, face = 'bold', hjust = 0.5),
    ## Axis
    axis.text.x = element_text(angle = 45, size = 6, hjust = 1),
    axis.text.y = element_text(size = 6, hjust = 1),
    axis.title.x = element_text(size = 8),
    axis.title.y = element_text(size = 8),
    ## Legend
    legend.title = element_text(size = 8, hjust = 0.5),
    legend.text = element_text(size = 7),
    legend.key.size = unit(5, 'mm')
  ) +
  labs(
    x = "Data type",
    y = "SV count",
    fill = "Data type",
    title = "Merged SV count by size bins and platform"
  ) + 
  scale_fill_viridis_d(option = "B")

# Plot by data type and sv type, with size bins
ggplot(data = merged) +
  #facet_wrap(~platform) +
  facet_grid(rows = vars(platform_reordered), scales = 'free_y') +
  geom_bar(aes(x = SVLEN_bin, fill = SVTYPE)) + 
  theme(
    ## Plot title
    plot.title = element_text(size = 10, face = 'bold', hjust = 0.5),
    ## Axis
    axis.text.x = element_text(angle = 45, size = 6, hjust = 1),
    axis.text.y = element_text(size = 6, hjust = 1),
    axis.title.x = element_text(size = 8),
    axis.title.y = element_text(size = 8),
    ## Legend
    legend.title = element_text(size = 8, hjust = 0.5),
    legend.text = element_text(size = 7),
    legend.key.size = unit(5, 'mm')
  ) +
  labs(
    x = "SV size (bp)",
    y = "SV count",
    fill = "SV type",
    title = "Merged SV count by size bins, types and platform"
  ) + 
  scale_fill_manual(values = cols_svtypes)



# 4. Summarize by table ---------------------------------------------------
table(merged$platform, merged$SVTYPE)


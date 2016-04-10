if (!require("pacman")) install.packages("pacman")
if (!require("digest")) install.packages("digest")
if (!require("ggplot2")) install.packages("ggplot2")

pacman::p_load_current_gh("mattflor/chorddiag")
pacman::p_load(dplyr, magrittr, ggplot2, tidyr, curl)

# curl::curl_download(
#   "https://github.com/yoni/r_we_the_people/blob/master/data/petition_analyses.RData?raw=true"
#   , destfile="data/petition_analyses.RData"
# )

load("data/petition_analyses.RData")
p <- petition_analyses

# recover tag names and ids
ids_names <- rbind(    
  p[, c("issues1.id", "issues1.name")] %>% setNames(c("ids", "names"))
  , p[, c("issues2.id", "issues2.name")] %>% setNames(c("ids", "names"))
  , p[, c("issues3.id", "issues3.name")]%>% setNames(c("ids", "names"))
) %>%
  unique() %>% na.omit()


# get only petitions with multi-tags
tag_count <- p %>%              
  select(id, issues1.id, issues2.id, issues3.id) %>%
  tidyr::gather(order, cats, -id) %>%
  filter(!is.na(cats)) %>%
  mutate(order = tidyr::extract_numeric(order)) %>%
  left_join(ids_names, by=c("cats"="ids"))

xtab_tag <- tag_count %>%
  count(names) %>%
  arrange(desc(n))

xtab_tag %>%
  ggplot2::ggplot(aes(x=factor(names,levels=names),y=n)) +
  geom_bar(stat="identity") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 12),
        plot.margin = unit(c(10,10,20,20), "mm"),
        plot.title = element_text(size = 20))  +
  ggtitle("Distribution of All Tags") +
  labs(x = "petition categories",
       y = "category counts")

# list of tags
tags <- sort(unique(ids_names$names))

# matrix to hold counts
mat <- matrix(0,nrow=nrow(tag_count),ncol=length(tags))
colnames(mat) <- tags


# get columns with tags from dataframe
p_id_nam <- p %>%
  select(contains(".name")) %>%
  mutate(issues1.name= ifelse(is.na(issues1.name), issues.name, issues1.name)) %>%
  mutate_each(funs(ifelse(is.na(.), "", .)), starts_with("issues"))

# make matrix
for (i in seq_along(tags)) {
  for (j in c(1,2,3)){ # 1,2,3 are columns I want
    mat[,i] <- as.numeric(tags[i]==p_id_nam[[j]]) +  mat[,i]
    is.na(mat[,i]) <- 0
  }
}

adjmat <- t(mat) %*% mat

# set number of colors needed
colorCount <- length(tags)

# makes function to create palette
getPalette <- grDevices::colorRampPalette(RColorBrewer::brewer.pal(9, "Set1"))

# manage use of diagonal cells in adj_mat
remove_diags <- function(mat, rm.lower = TRUE, ...) {
  diag(mat) <- 0
  if (isTRUE(rm.lower)) mat[lower.tri(mat)] <- 0
  mat
}

# ## order plot layering by smallest to largest so larges are on top
ord <- order(rowSums(remove_diags(adjmat, FALSE)))

# with the diags means there's a return
chorddiag::chorddiag(adjmat[ord, ord], margin = 150, showTicks =FALSE
                     , groupnameFontsize = 8  # have to shrink font for web viewing
                     , groupnamePadding = 5
                     , groupThickness = .05
                     , chordedgeColor = "gray90"
                     , groupColors = getPalette(colorCount)    
)
?chorddiag::chorddiag

# without the diags means there's NOT return
chorddiag::chorddiag(remove_diags(adjmat[ord, ord], FALSE), margin = 150, showTicks =FALSE
                     , groupnameFontsize = 8       
                     , groupnamePadding = 5
                     , groupThickness = .05
                     , chordedgeColor = "gray90"
                     , groupColors =getPalette(colorCount))  


m <- matrix(c(11975,  5871, 8916, 2868,
              1951, 10048, 2060, 6171,
              8010, 16145, 8090, 8045,
              1013,   990,  940, 6907),
            byrow = TRUE,
            nrow = 4, ncol = 4)
groupnames <- c("black", "blonde", "brown", "red")
row.names(m) <- groupnames
colnames(m) <- groupnames
chorddiag(m)

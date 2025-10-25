# Clean environment
rm(list = ls())
# Set working directory
setwd("/Users/qingchen/Desktop/Hackthon")
# ==========================================
# 1. Install and Load Packages
# ==========================================
install.packages("stringdist")
library(stringdist)
library(readxl)
library(metaboliteIDmapping)

# ==========================================
# 2. Read Your Excel File
# ==========================================
metabolite_data <- read_excel("Metabolite.xlsx") # assumes column 'Metabolite'

# ==========================================
# 3. Prepare for Matching
# ==========================================
# Convert all names to lowercase for best matching
input_names <- tolower(metabolite_data$Metabolite)
db_names <- tolower(metabolitesMapping$Name)

# ==========================================
# 4. Fuzzy Match Function (robust to missing matches)
# ==========================================
get_best_match <- function(x, reference) {
  if(length(reference) == 0 || !nzchar(x)) return(list(index=NA, name=NA, distance=NA))
  dists <- stringdist(x, reference, method='jw')
  if (all(is.na(dists)) || length(dists) == 0) {
    return(list(index=NA, name=NA, distance=NA))
  } else {
    min_index <- which.min(dists)
    return(list(index = min_index, name = reference[min_index], distance = dists[min_index]))
  }
}

# Apply function to all your input metabolites
best_matches <- lapply(input_names, get_best_match, reference = db_names)

matched_index <- sapply(best_matches, function(x) x$index)
matched_name  <- sapply(best_matches, function(x) if(!is.na(x$index)) metabolitesMapping$Name[x$index] else NA)
match_dist    <- sapply(best_matches, function(x) x$distance)



colnames(metabolitesMapping)
str(metabolitesMapping)
head(metabolitesMapping)


# ==========================================
# 5. Build Output Table: Add annotations if matched
# ==========================================
annot_cols <- c("Name", "KEGG") # Change/add other database columns as needed
annot_matched <- lapply(seq_along(matched_index), function(i) {
  idx <- matched_index[i]
  if(is.na(idx)) {
    rep(NA, length(annot_cols))
  } else {
    as.list(metabolitesMapping[idx, annot_cols])
  }
})
annot_df <- do.call(rbind, annot_matched)
colnames(annot_df) <- annot_cols

output <- data.frame(
  OriginalName = metabolite_data$Metabolite,
  MatchedName  = matched_name,
  MatchDistance = match_dist,
  annot_df,
  stringsAsFactors = FALSE
)

# ==========================================
# 6. Save to CSV
# ==========================================

# Apply as.character to each column to ensure atomic vectors
output_flat <- data.frame(lapply(output_full, as.character), stringsAsFactors = FALSE)

# Remove row names just in case
rownames(output_flat) <- NULL

# Export as CSV
write.csv(output_flat, file = "Fuzzy_Metabolite_Mapping.csv", row.names = FALSE)

# check how many genes have KEGG ID
sum(!is.na(output_full$KEGG) & output_full$KEGG != "" & toupper(output_full$KEGG) != "NA")

# ==========================================
# Notes
# ==========================================
# - 'OriginalName' preserves your input name.
# - 'MatchedName' is the closest found in the reference database.
# - 'MatchDistance': lower value = closer match, 0 = perfect.
# - If no match, annotation columns will be NA.
# - You can filter by MatchDistance to review low-confidence matches.
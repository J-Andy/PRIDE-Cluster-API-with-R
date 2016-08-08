# Query PRIDE Cluster API to retreive all MS2 spectra (together with peak intensities) for a list of peptides
# install.packages("httr")
require(httr)
####################################################

# read in the list of cluster ids (those are all associated with a peptide id)
peptide_ids <- read.table("data/peptide_list.txt", sep="\t", stringsAsFactors = FALSE, header = TRUE)


# setup a list to put the result into
query.result <- vector("list", nrow(peptide_ids))
names(query.result)<- peptide_ids[,1]


# loop through the list and create a query to the API for each PEPTIDE_ID
for (i in 1:nrow(peptide_ids)) {
  # some messages so we know what is happening  
  print(paste("Querying PEPTIDE_ID", peptide_ids[i,], sep = ": "))
  # build the query
  query <- paste("http://www.ebi.ac.uk:80/pride/ws/cluster/cluster/", peptide_ids[i,], "/consensusSpectrum", sep="")
  # execute it
  out <- GET(url = query)
  
  # check the status of the query
  print(http_status(out)$category)
  # save 
  data.out <- content(out)
  query.result[[i]] <- data.out$peaks
}

# lets peak at the result for cluster '1059632'
(query.result$`1059632`)

# and plot the MS/MS consensus fragmentation pattern
peptide.1066082 <- vapply(query.result$`1066082`, function(x) unlist(data.frame(mz = x$mz, intensit = x$intensity)), numeric(2) )

plot(peptide.1066082[1,], peptide.1066082[2,], type = "h", lwd=2, xlab = "m/z", ylab="intensity", main="Consensus MS/MS for cluster 1066082")




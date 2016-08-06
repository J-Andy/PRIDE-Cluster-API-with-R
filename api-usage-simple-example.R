# get the required packages
install.packages("httr")
require(httr)

# an example simple query 
query <- "http://www.ebi.ac.uk:80/pride/ws/cluster/cluster/1220897/consensusSpectrum"

out <- GET(url = query)

# check the status
http_status(out)


data <- content(out)

# save content of the query #
write.table(data, "data.txt") 

# Script to fill a template MaxQuant xml file with samples data provided in a sample sheet (location on a disk, fractions, parameters group, ptm etc.)  
# Usage: Rscript fill_xml.R sampleSheet.txt mqparam.xml output.xml

require("XML")

# Parse arguments  
args <- commandArgs(TRUE)

sampleSheet <- read.csv(args[1])
template <- xmlParse(args[2])
output <- args[3]

# Modify template xml file
root = xmlRoot(template, skip = T)

filePaths = newXMLNode("filePaths")
experiments = newXMLNode("experiments")
fractions = newXMLNode("fractions")
ptms = newXMLNode("ptms")
paramGroupIndices = newXMLNode("paramGroupIndices")
reference = newXMLNode("referenceChannel")

for (i in 1:nrow(sampleSheet)){
  newFiles = addChildren(filePaths, newXMLNode("string", as.character(sampleSheet$filePaths[i])))
  newExp = addChildren(experiments, newXMLNode("string", as.character(sampleSheet$Experiment[i])))
  newFrac = addChildren(fractions, newXMLNode("short", as.character(sampleSheet$Fraction[i])))
  newPTMS = addChildren(ptms, newXMLNode("boolean", as.character(sampleSheet$PTM[i])))
  newParams = addChildren(paramGroupIndices, newXMLNode("int", as.character(sampleSheet$ParamGroup[i])))

  if (is.na(sampleSheet$Reference[i]))
    newRef = addChildren(reference, newXMLNode("string", ""))
}

root 

root[["filePaths"]] = newFiles
root[["experiments"]] = newExp
root[["fractions"]] = newFrac
root[["ptms"]] = newPTMS
root[["paramGroupIndices"]] = newParams
root[["referenceChannel"]] = newRef

# Write a new XML file
saveXML(root, file = output)

q(save="no")

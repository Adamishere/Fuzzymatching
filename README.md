# Fuzzymatching
Match to strings based on String Distance.

# Problem:
I was tasked to identify institutions from a Do Not Contact (DNC) list (n=2,000) and remove them from our master list (n=1,500,000). Unforunately, there were no unique IDs associated with the smaller DNC list, instead it only contain their institution name. Both lists were developed through manual data entry, leaving large inconsistency in the names an organization found on both lists (e.g., spelling errors, abreviations, white space, transpositions of words, etc.). Volume required for manual review of all DNC institutions was higher than fesibile possible given our resources.

# Solution

Using the "stringdist" package in R, I was able to calculate the "distance" between two strings, essentially how similar they are. This generally took the form of how many transformations (Insertions, Deletions, Transpositions) needed to make one string into another. 

However, the challege with this approach is that we need to compare every string in the DNC list with every string in the master list. Doing so using a vectorized approach would create an extremely large matrix of distances to calculate (1,500,000 X 2,000). So instead, I opted for a iterative approach, looping each record in the master list against the DNC list (creating a smaller 1 x 2,000 matrix), the best match was retained and stored in cumulative dataset (along with the distance value of the match).

The purpose was to speed up manual review rather than automate the entire process (accuracy was important). Final output data was used by reviewers to quickly review match with small and large differences, and focus on ambigous cases best left for human reviewers. 

Finally, I generalized this approach into a function to be used for similar problems.

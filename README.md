Scripts for a university project, a simple centralized/cooperative smart grid energy cost optimization problem.

The smart grid topology is depicted in the following figures

given the tensor of variables
 <div align="center">
  <img src="https://latex.codecogs.com/gif.latex?%5Cboldsymbol%7B%5CPhi%7D_%7Btn%7D%20%3D%20%5B%5Bp_%7Btn%7D%5E%7BR%20%5Cto%20D%7D%2C%20p_%7Btn%7D%5E%7BR%20%5Cto%20E%7D%2C%20p_%7Btn%7D%5E%7BS%20%5Cto%20D%7D%2C%20p_%7Btn%7D%5E%7BS%20%5Cto%20E%7D%2C%20p_%7Btn%7D%5E%7BS%20%5Cto%20R%7D%2C%20p_%7Btn%7D%5E%7BE%20%5Cto%20D%7D%2C%20p_%7Btn%7D%5E%7BE%20%5Cto%20R%7D%2C%20e_%7Btn%7D%5D%5D%20%5Cin%20%5Cmathbb%7BR%7D%5E%7B%5CPhi%20%5Ctimes%20T%20%5Ctimes%20N%7D">
 </div>
 
the optimization problem is 

<div align="center">
  <img src="https://latex.codecogs.com/gif.latex?%5Cbegin%7Bcases%7D%20%5Cmin_%7B%5Cboldsymbol%7B%5CPhi%7D_%7Btn%7D%7D%7B%5Csum_%7Bt%7D%7B%7D%20%5CBig%28C_t%20%5Csum_%7Bn%7D%7B%7D%20%28p_%7Btn%7D%5E%7BR%20%5Cto%20D%7D%20&plus;%20p_%7Btn%7D%5E%7BR%20%5Cto%20E%7D%29%20-%20R_t%20%5Csum_%7Bn%7D%7B%7D%20%28p_%7Btn%7D%5E%7BS%20%5Cto%20R%7D%20&plus;%20p_%7Btn%7D%5E%7BE%20%5Cto%20R%7D%29%5CBig%29%7D%2C%20%5Cforall%20t%20%5C%20%5Cforall%20n%20%5C%5C%20p_%7Btn%7D%5E%7BS%20%5Cto%20D%7D%20&plus;%20p_%7Btn%7D%5E%7BS%20%5Cto%20E%7D%20&plus;%20p_%7Btn%7D%5E%7BS%20%5Cto%20R%7D%20%3D%20S_%7Btn%7D%2C%20%5C%20%5Cforall%20t%20%5C%20%5Cforall%20n%20%5C%5C%20p_%7Btn%7D%5E%7BS%20%5Cto%20D%7D%20&plus;%20p_%7Btn%7D%5E%7BE%20%5Cto%20D%7D%20&plus;%20p_%7Btn%7D%5E%7BR%20%5Cto%20D%7D%20%3D%20D_%7Bt%7D%2C%20%5C%20%5Cforall%20t%20%5C%20%5Cforall%20n%20%5C%5C%20e_%7Btn%7D%20%3D%20e_%7Bn%2Ct-1%7D%20&plus;%20%5Ceta%5E%7B%5Cuparrow%7D%28p_%7Btn%7D%5E%7BR%20%5Cto%20E%7D%20&plus;%20p_%7Btn%7D%5E%7BS%20%5Cto%20E%7D%29%20-%20%5Ceta%5E%7B%5Cdownarrow%7D%28p_%7Btn%7D%5E%7BE%20%5Cto%20D%7D%20&plus;%20p_%7Btn%7D%5E%7BE%20%5Cto%20R%7D%29%2C%20%5C%20%5Cforall%20n%5C%2C%20%5C%20%5Cforall%20t%20%5C%5C%20e_%7Btn%7D%20%3D%20E%5E%7B%5Ctext%7Binit%7D%7D%2C%20%5C%20%5Cforall%20n%5C%5C%20e_%7Btn%7D%20%5Cleq%20E%5E%7B%5Ctext%7Bmax%7D%7D%2C%20%5C%20%5Cforall%20t%20%5C%20%5Cforall%20n%20%5C%5C%20p_%7Btn%7D%5E%7BR%20%5Cto%20E%7D%20&plus;%20p_%7Btn%7D%5E%7BS%20%5Cto%20E%7D%20%5Cleq%20P%5E%7B%5Ctext%7Bmax%7D%7D%2C%20%5C%20%5Cforall%20t%20%5C%20%5Cforall%20n%20%5C%5C%20p_%7Btn%7D%5E%7BE%20%5Cto%20R%7D%20&plus;%20p_%7Btn%7D%5E%7BE%20%5Cto%20D%7D%20%5Cleq%20P%5E%7B%5Ctext%7Bmax%7D%7D%2C%20%5C%20%5Cforall%20t%20%5C%20%5Cforall%20n%20%5C%5C%20%5Cboldsymbol%7B%5CPhi%7D_%7Btn%7D%20%5Cgeq%20%5Cboldsymbol%7B0%7D%2C%20%5C%20%5Cforall%20t%20%5C%20%5Cforall%20n%20%5Cend%7Bcases%7D">
 </div>

# References

N. Vespermann, T. Hamacher and J. Kazempour, "Access Economy for Storage in Energy Communities," in _IEEE Transactions on Power Systems_, https://doi.org/10.1109/TPWRS.2020.3033999.

N. Vespermann, T. Hamacher, and J. Kazempour, "Electronic companion: Access economy for storage in energy communities", Technical
University of Munich, Tech. Rep., 2020. [Online], https://bitbucket.org/nivesp/marketdesign_energycommunities/.

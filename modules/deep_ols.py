'''
This creates all the functions to conduct
OLS with Deep Learning
Andy Wheeler
https://andrewpwheeler.com/
'''

import torch
import numpy as np
import pandas as pd
from scipy.stats import norm

#torch.manual_seed(0)

try:
    device = torch.device("cuda:0")
    text_dev = 'GPU'
except:
    print("Get on my level bro and get a GPU!")
    text_dev = 'CPU'
    device = torch.device("cpu")
    
#########################################
#Now setting up the regression model

#Defining different symbols for p-values
strong = '💪 yeah bro'
weak = '¯\_(ツ)_/¯'

def p_bro(p):
    if p < 0.05:
        return strong
    else:
        return weak
    
#This function takes the output from ols_deep
#And returns a nicer data frame of the results
def deep_table(model, var_cov, coef_names):
    cov_np = var_cov.detach().numpy()
    coef_np = model.coef.weight.detach().numpy()
    coef_np = coef_np.flatten()
    se_np = np.sqrt(np.diagonal(cov_np))
    dat_np = zip( list(coef_np), list(se_np) )
    pd_dat = pd.DataFrame(dat_np, columns=['Coefficients','Std-Error'],
                          index=coef_names)
    #Now making two tailed p-values
    t_vals = np.absolute( coef_np / se_np )
    p_vals = norm.cdf(-t_vals)*2
    pd_dat['p-values'] = p_vals
    pd_dat['Dude'] = pd_dat['p-values'].apply(p_bro)
    print(pd_dat)
    return pd_dat

class ols_torch(torch.nn.Module):
    def __init__(self, coef_n):
        """
        Construct parameters for the coefficients
        Need the intercept
        """
        super(ols_torch, self).__init__()
        self.coef = torch.nn.Linear(1, coef_n, bias=False)
        #setting the default weights for latent to equal prob
        #torch.nn.init.constant_(self.latent_flat, 1/float(groups))

    def forward(self, x):
        """
        In the forward function we accept a Tensor of input data and we must return
        a Tensor of output data. We can use Modules defined in the constructor as
        well as arbitrary operators on Tensors.
        """
        y_pred = torch.mm(x, self.coef.weight)
        #y_pred = self.coef(x)
        return y_pred
        
#Now making a function to take in the data (as pandas)
#And then return OLS coefficients, x should be the design
#matrix

def ols_deep(y,x,iterations=50000):
    #Set up a model object
    df = x.shape[1]
    model = ols_torch(coef_n = df)
    criterion = torch.nn.MSELoss(reduction='sum')
    optimizer = torch.optim.Adam(model.parameters(), lr=1e-4)
    #Now create the data tensors
    coef_names = list(x)
    x_ten = torch.tensor(x.to_numpy(), dtype=torch.float)
    y_ten = torch.tensor(pd.DataFrame(y).to_numpy(), dtype=torch.float)
    #Now iterating over the model
    for t in range(iterations):
        #Forward pass
        y_pred = model(x_ten)
        #Loss
        loss = criterion(y_pred, y_ten)
        if t % 1000 == 99:
            print(f'{text_dev} go brrrr, iteration {t} & loss is {loss.item()}')
        
        #Zero gradients
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()
    #Now estimating the variance/covariance matrix of coefficients
    #Taken from https://www.reddit.com/r/statistics/comments/1vg8k0/standard_errors_in_glmnet/
    #To be fair, still doing in torch tensors
    n = x.shape[0]
    sigma_sq = loss.item() / (n - df)
    xpx = torch.mm(torch.transpose(x_ten, 0, 1),x_ten) 
    inv_xpx = torch.inverse(xpx)
    t1 = torch.mm(inv_xpx,xpx)
    t2 = torch.mm(t1,inv_xpx)
    var_cov = sigma_sq * t2
    print(f"\n Model Predicting {y.name} \n")
    pd_nicetab = deep_table(model, var_cov, coef_names)
    return model, var_cov, pd_nicetab
    

    

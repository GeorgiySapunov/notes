1. [Shapiro--Wilk test](#Shapiro--Wilk_test)
2. [Mann–Whitney--Wilcoxon U test](#Mann–Whitney--Wilcoxon_U_test)
3. [Fligner--Killeen test](#Fligner--Killeen_test)
4. [Student's t-test](#Student's_t-test)
5. [$\chi^2$ test](#$\chi^2$_test)
6. [Pearson correlation coefficient](#Pearson_correlation_coefficient)
7. [A/B testing](#A/B_testing)

The null hypothesis is rejected if a p_value is less then chosen $\alpha$
(the type I error probability)

## Shapiro--Wilk test <a name="Shapiro--Wilk_test"></a>

Perform the Shapiro-Wilk test for normality.

The Shapiro-Wilk test tests the null hypothesis that the data was drawn from a
normal distribution.

<https://en.wikipedia.org/wiki/Shapiro%E2%80%93Wilk_test>

```python
import pandas as pd
from scipy import stats

df = pd.read_csv('link')

res = stats.shapiro(df[])
print('p value:', res[1])
```

Usually is used in case of less then 2000 observation.
In other case Kolmogorov–Smirnov test is preferred for computational reasons.


## Mann--Whitney--Wilcoxon U test <a name="Mann–Whitney--Wilcoxon_U_test"></a>

A nonparametric test of the null hypothesis that, for randomly selected values
X and Y from two populations, the probability of X being greater than Y is
equal to the probability of Y being greater than X.

P(x>y)=P(x<y)

This test is used when central tendency is median
(**non-normal distribution**: data with outliers, asymmetric (try log) or bimodal histogram).

<https://en.wikipedia.org/wiki/Mann%E2%80%93Whitney_U_test>

Preliminarily:
1. To check normality
2. To check equality of dispersions

```python
import pandas as pd
from scipy import stats

df = pd.read_csv('link')

res = stats.mannwhitneyu(df[], df[])
print('p value:', res[1])
```

## Fligner--Killeen test <a name="Fligner--Killeen_test"></a>

Performs a Fligner--Killeen (median) test of the null that the variances in each
of the groups (samples) are the same.

(as alternative: Brown--Forsythe test)

```python
import pandas as pd
from scipy import stats

df = pd.read_csv('link')

res = stats.fligner(df[], df[])
print('p value:', res[1])
```

## Student's t-test <a name="Student's_t-test"></a>

Among the most frequently used t-tests are:
* A **one-sample** location test of whether the mean of a population has a
  value specified in a null hypothesis.
* A **two-sample** location test of the null hypothesis such that the means of
  two populations are equal. All such tests are usually called Student's
  t-tests, though strictly speaking that name should only be used if the
  variances of the two populations are also assumed to be equal; the form of
  the test used when this assumption is dropped is sometimes called Welch's
  t-test. These tests are often referred to as unpaired or independent samples
  t-tests, as they are typically applied when the statistical units underlying
  the two samples being compared are non-overlapping.

<https://en.wikipedia.org/wiki/Student%27s_t-test>

Calculate the T-test for the means of *two independent* samples of scores.

This is a two-sided test for the null hypothesis that 2 **independent** (_ind) samples
have identical average (expected) values. This test assumes that the
populations have identical variances by default.

This test is used when central tendency is mean value and the distribution is
**close to normal**.

```python
import pandas as pd
from scipy import stats

df = pd.read_csv('link')

res = stats.ttest_ind(df[], df[], equal_var=False)
#equal_var=False is for not equal dispersions (see. Fligner--Killeen test)
print('p value:', res[1])
```

Calculate the t-test on **TWO RELATED** (_rel) samples of scores.

This is a two-sided test for the null hypothesis that 2 related or repeated
samples have identical average (expected) values.


```python
import pandas as pd
from scipy import stats

df = pd.read_csv('link')

res = stats.ttest_rel(df[], df[])
print('p value:', res[1])
```

## $\chi^2$ test <a name="$\chi^2$_test"></a>

Chi-square test of independence of variables in a contingency table.

<https://en.wikipedia.org/wiki/Pearson%27s_chi-squared_test>


```python
import pandas as pd
from scipy import stats

df = pd.read_csv('link')

res = stats.chi2_contingency(df)
print('p value:', res[1])
chi2, p_value, dof, exp = res
```

## Pearson correlation coefficient <a name="Pearson_correlation_coefficient"></a>

Pearson correlation coefficient and p-value for testing *non-correlation*.

The Pearson correlation coefficient measures the linear relationship
between two datasets. The calculation of the p-value relies on the assumption
that each dataset is normally distributed.

The p-value roughly indicates the probability of an uncorrelated system
producing datasets that have a Pearson correlation at least as extreme as the
one computed from these datasets.

```python
import pandas as pd
from scipy import stats

df = pd.read_csv('link')

res = stats.pearsonr(df[], df[])
print('Preason rho:', res[0])
print('p value:', res[1])
```

## A/B testing <a name="A/B_testing"></a>

Null-hypothesis is that success rates for both samples (p1 and p2) are equal.

```python
import stats from scipy
import numpy as np
import statmodels.api as sm

s1 = # successes in sample A
n1 = # number of tests, sample A
s2 = # successes in  sample B
n2 = # number of tests, sample B
p1 = s1/n1 # success rate for sample A
p2 = s2/n2 # success rate for sample B
p = (s1 + s2)/(n1 + n2) # success rate for both samples
z = abs((p2 - p1)/((p*(1-p)*((1/n1)+(1/n2)))**0.5)) # z-mark
p_value = (stats.norm.cdf(z))*2

# the same calculations with the library statmodels
z1, p_value1 = sm.stats.proportion_ztest([s1, s2], [n1, n2])

# chi2_contingency
# Be careful with this one!
arr = np.array([[s1, n1-s1], [s2, n2-s2]])
chi2, p_value3, dof, exp = stats.chi2_contingency(df)
z_analog = chi2**0.5
```

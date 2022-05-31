Нулевая гипотеза отклоняется, если значение p_value меньше выбранного $\alpha$
(вероятность ошибки первого рода)

## Тест нормальности Шапиро -- Уилка (Shapiro-–Wilk test)

Тест Шапиро -- Уилка проверяет нулевую гипотезу о том, что данные были получены
из нормального распределения.

<https://en.wikipedia.org/wiki/Shapiro%E2%80%93Wilk_test>

```python
import pandas as pd
from scipy import stats

df = pd.read_csv('link')

res = stats.shapiro(df[])
print('p value:', res[1])
```

Обычно используется в случае менее 2000 наблюдений.
В противном случае тест Колмогорова –- Смирнова предпочтительнее по
вычислительным соображениям.


## U-критерий Манна -- Уитни -- Уилкоксона (Mann–Whitney--Wilcoxon U test)

Используется для оценки различий между двумя независимыми выборками по уровню
какого-либо количественного признака.

Непараметрическая проверка нулевой гипотезы о том, что для случайно выбранных
значений X и Y из двух генеральных совокупностей вероятность того, что X больше, чем Y,
равна вероятности того, что Y больше, чем X.

P(x>y)=P(x<y)

Этот тест используется, когда центральная тенденция --- медиана
(**ненормальное распределение**: данные с выбросами, асимметричная (попробуйте
log) или бимодальная гистограмма).

<https://en.wikipedia.org/wiki/Mann%E2%80%93Whitney_U_test>

Предварительно:
1. Проверить нормальность
2. Проверить равенство дисперсий

```python
import pandas as pd
from scipy import stats

df = pd.read_csv('link')

res = stats.mannwhitneyu(df[], df[])
print('p value:', res[1])
```

## Тест Флигнера -- Киллина (Fligner--Killeen test)

Нулевая гипотеза состоит в том, что дисперсии двух выборок не различаются.

(в качестве альтернативы: тест Брауна -- Форсайта)

```python
import pandas as pd
from scipy import stats

df = pd.read_csv('link')

res = stats.fligner(df[], df[])
print('p value:', res[1])
```

## t-критерий Стьюдента (Student's t-test)

Среди наиболее часто используемых t-тестов:
* **Одновыборочный** тест, определяющий, имеет ли среднее значение генеральной
  совокупности значение, указанное в нулевой гипотезе.
* **Двухвыборочный** тест нулевой гипотезы, при которой средние значения двух
  генеральных совокупностей равны. Все такие тесты обычно называются t-тестами
  Стьюдента, хотя, строго говоря, это название следует использовать только в
  том случае, если дисперсии двух генеральных совокупностей также
  предполагаются равными; форма теста, используемого, когда это предположение
  отбрасывается, иногда называют t-тестом Уэлча. Эти тесты часто называют
  t-тестами для непарных или независимых выборок, поскольку они обычно
  применяются, когда статистические единицы, лежащие в основе двух сравниваемых
  выборок, не перекрываются.

<https://en.wikipedia.org/wiki/Student%27s_t-test>

Рассчитывает t-критерий для средних значений *двух независимых* выборок.

Это двусторонний тест с нулевой гипотезой о том, что 2 **независимых** (_ind)
выборки имеют идентичные средние (ожидаемые) значения. Этот тест предполагает,
что генеральные совокупности по умолчанию имеют одинаковые дисперсии.

Этот тест используется, когда центральная тенденция является средним значением,
а распределение **близко к нормальному**.

```python
import pandas as pd
from scipy import stats

df = pd.read_csv('link')

res = stats.ttest_ind(df[], df[], equal_var=False)
#equal_var=False is for not equal dispersions (see. Fligner-Killeen test)
print('p value:', res[1])
```

Рассчитывает t-критерий для **ДВУХ СВЯЗАННЫХ** (_rel) выборок.

Это двусторонний тест с нулевой гипотезой о том, что две связанные или
повторяющиеся выборки имеют одинаковые средние (ожидаемые) значения.

```python
import pandas as pd
from scipy import stats

df = pd.read_csv('link')

res = stats.ttest_rel(df[], df[])
print('p value:', res[1])
```

## Критерий согласия Пирсона ($\chi^2$ test)

Критерий хи-квадрат независимости переменных.

<https://en.wikipedia.org/wiki/Pearson%27s_chi-squared_test>

```python
import pandas as pd
from scipy import stats

df = pd.read_csv('link')

res = stats.chi2_contingency(df)
print('p value:', res[1])
chi2, p_value, dof, exp = res
```

## Коэффициент корреляции Пирсона (Pearson correlation coefficient)

Коэффициент корреляции Пирсона и p-значение для проверки *некорреляции*.

Коэффициент корреляции Пирсона измеряет линейную зависимость между двумя
наборами данных. Вычисление p-значения основано на предположении, что каждый
набор данных распределён нормально.

Значение p примерно указывает на вероятность того, что некоррелированная
система создаст наборы данных, которые имеют корреляцию Пирсона, по крайней
мере, такую же экстремальную, как корреляция, рассчитанная на основе этих
наборов данных.

```python
import pandas as pd
from scipy import stats

df = pd.read_csv('link')

res = stats.pearsonr(df[], df[])
print('Preason rho:', res[0])
print('p value:', res[1])
```

## A/B тестирование (A/B testing)

Нулевая гипотеза состоит в том, что вероятности успеха для обеих выборок (p1 и p2) равны.

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

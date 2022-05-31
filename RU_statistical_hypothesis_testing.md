1. [Тест Шапиро -- Уилка (Shapiro--Wilk test)](#Shapiro--Wilk_test) (проверка гипотезы о нормальности)
2. [U-критерий Манна -- Уитни -- Уилкоксона (Mann–Whitney--Wilcoxon U test)](#Mann–Whitney--Wilcoxon_U_test) 
(используется вместо t-критерия Стьюдента для данных, которые сильно отличающихся от нормальных)
4. [Тест Флигнера -- Киллина (Fligner--Killeen test)](#Fligner--Killeen_test) (проверка гипотезы о равенстве дисперсий)
5. [t-критерий Стьюдента (Student's t-test)](#Student's_t-test) (проверка гипотезы о равенстве средних значений)
6. [Критерий согласия Пирсона ($\chi^2$ test)](#$\chi^2$_test) (проверка гипотезы о независимости)
7. [Коэффициент корреляции Пирсона (Pearson correlation coefficient)](#Pearson_correlation_coefficient)
8. [A/B тестирование (A/B testing)](#A/B_testing)

Нулевая гипотеза $H_0$ отклоняется, если значение $p$ меньше выбранного $\alpha$
(вероятность ошибки первого рода)

## Тест Шапиро -- Уилка (Shapiro--Wilk test) <a name="Shapiro--Wilk_test"></a>

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

Обычно используется в случае менее 2000 наблюдений. В противном случае тест
Колмогорова –- Смирнова предпочтительнее по вычислительным соображениям.


## U-критерий Манна -- Уитни -- Уилкоксона (Mann–Whitney--Wilcoxon U test) <a name="Mann–Whitney--Wilcoxon_U_test"></a>

Используется вместо t-критерия Стьюдента, когда центральная тенденция ---
медиана, a данные сильно отличаются от нормальных (данные с выбросами,
асимметричная (попробуй логарифмировать) или бимодальная гистограмма).

Используется для оценки различий между двумя независимыми выборками по уровню
какого-либо количественного признака.

Непараметрическая проверка нулевой гипотезы о том, что для случайно выбранных
значений X и Y из двух генеральных совокупностей вероятность того, что X
больше, чем Y, равна вероятности того, что Y больше, чем X.

P(x>y)=P(x<y)

<https://en.wikipedia.org/wiki/Mann%E2%80%93Whitney_U_test>

Предварительно:
1. Проверить нормальность
2. Проверить равенство дисперсий

```python
import pandas as pd
from scipy import stats

df = pd.read_csv('link')

res = stats.mannwhitneyu(df[], df[])
# (df[df['group'] == 'group_1']['characteristic'], df[df['group'] == 'group_2']['characteristic'])
print('p value:', res[1])
```

## Тест Флигнера -- Киллина (Fligner--Killeen test) <a name="Fligner--Killeen_test"></a>

Нулевая гипотеза состоит в том, что дисперсии двух выборок не различаются.

(в качестве альтернативы: тест Брауна -- Форсайта)

```python
import pandas as pd
from scipy import stats

df = pd.read_csv('link')

res = stats.fligner(df[], df[])
# (df[df['group'] == 'group_1']['characteristic'], df[df['group'] == 'group_2']['characteristic']) 
print('p value:', res[1])
```

## t-критерий Стьюдента (Student's t-test) <a name="Student's_t-test"></a>

Этот критерий используется, когда центральная тенденция является средним
значением, а распределение **близко к нормальному**! В противном случае смотри
[U-критерий Манна -- Уитни -- Уилкоксона)](#Mann–Whitney--Wilcoxon_U_test).

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

scipy.stats.ttest_ind --- это двусторонний тест с нулевой гипотезой о том, что 2 **независимых** (_ind)
выборки имеют идентичные средние (ожидаемые) значения. Этот тест по умолчанию
предполагает, что генеральные совокупности имеют одинаковые
дисперсии (equal_var=True) (смотри [тест Флигнера -- Киллина](#Fligner--Killeen_test)).

```python
import pandas as pd
from scipy import stats

df = pd.read_csv('link')

res = stats.ttest_ind(df[], df[], equal_var=False) 
# (df[df['group'] == 'group_1']['characteristic'], df[df['group'] == 'group_2']['characteristic'], equal_var=False)
# equal_var=False is for not equal dispersions (see. Fligner-Killeen test)
print('p value:', res[1])
```

Рассчитывает t-критерий для **ДВУХ СВЯЗАННЫХ** (_rel) выборок.

scipy.stats.ttest_rel --- это двусторонний тест с нулевой гипотезой о том, что две связанные или
повторяющиеся выборки имеют одинаковые средние ожидаемые значения.

```python
import pandas as pd
from scipy import stats

df = pd.read_csv('link')

res = stats.ttest_rel(df[], df[])
# (df[df['group'] == 'group_1']['characteristic'], df[df['group'] == 'group_2']['characteristic'], equal_var=True)
# equal_var=True is for equal dispersions (see. Fligner-Killeen test)
print('p value:', res[1])
```

## Критерий согласия Пирсона ($\chi^2$ test) <a name="$\chi^2$_test"></a>

Критерий хи-квадрат независимости переменных.

Критерий согласия Пирсона --- непараметрический метод, который позволяет
оценить значимость различий между фактическим (выявленным в результате
исследования) количеством исходов или качественных характеристик выборки,
попадающих в каждую категорию, и теоретическим количеством, которое можно
ожидать в изучаемых группах при справедливости нулевой гипотезы. Выражаясь
проще, метод позволяет оценить статистическую значимость различий двух или
нескольких относительных показателей (частот, долей).

Является наиболее часто употребляемым критерием для проверки гипотезы о
принадлежности наблюдаемой выборки некоторому теоретическому закону
распределения.

Функция scipy.stats.chi2_contingency вычисляет статистику хи-квадрат и значение
$p$ для проверки гипотезы о независимости наблюдаемых частот в наблюдаемой
таблице сопряжённости.

Строки в таблице сопряжённости --- исследуемые группы; столбцы --- исход 1
(успех) и исход 2 (неудача); значения в ячейках --- количество соответствующих
исходов.

<https://en.wikipedia.org/wiki/Pearson%27s_chi-squared_test>

```python
import pandas as pd
from scipy import stats

contingency_table = pd.read_csv('link') # таблица сопряжённости

res = stats.chi2_contingency(contingency_table)
print('p value:', res[1])
chi2, p_value, dof, exp = res
```

## Коэффициент корреляции Пирсона (Pearson correlation coefficient) <a name="Pearson_correlation_coefficient"></a>

Коэффициент корреляции Пирсона и $p$-значение для проверки *некорреляции*.

Коэффициент корреляции Пирсона измеряет линейную зависимость между двумя
наборами данных. Вычисление $p$-значения основано на предположении, что каждый
набор данных распределён **нормально**.

Как и другие коэффициенты корреляции, этот коэффициент колеблется от -1 до +1,
при этом 0 означает отсутствие корреляции. Корреляции, равные -1 или +1,
подразумевают точную линейную зависимость.

Значение $p$ примерно указывает на вероятность того, что некоррелированная
система создаст наборы данных, которые имеют корреляцию Пирсона, по крайней
мере, такую же экстремальную, как корреляция, рассчитанная на основе этих
наборов данных.

```python
import pandas as pd
from scipy import stats

df = pd.read_csv('link')

res = stats.pearsonr(df[], df[])
# (df['characteristic_1'], df['characteristic_2']) 
print('Preason rho:', res[0])
print('p value:', res[1])
```

## A/B тестирование (A/B testing) <a name="A/B_testing"></a>

Нулевая гипотеза состоит в том, что вероятности успеха для обеих выборок (p1 и
p2) равны.

### Метод 1:

```python
import stats from scipy

s1 = # int, число успехов   выборка A (successes in sample A)
n1 = # int, число испытаний выборка A (number of tests, sample A)
s2 = # int, число успехов   выборка B (successes in sample B)
n2 = # int, число испытаний выборка B (number of tests, sample B)
p1 = s1/n1 # оценка вероятности успеха выборка A (success rate for sample A)
p2 = s2/n2 # оценка вероятности успеха выборка B (success rate for sample B)
p = (s1 + s2)/(n1 + n2) # оценка вероятности успеха выборка A+B (success rate for both samples)

z = abs((p2 - p1)/((p*(1-p)*((1/n1)+(1/n2)))**0.5)) # z-метка (z-mark)
p_value = (stats.norm.cdf(z))*2
print('p value: ', p_value)
```

### Метод 2:

Те же вычисления с библиотекой statmodels

```python
import statmodels.api as sm

s1 = # int, число успехов   выборка A (successes in sample A)
n1 = # int, число испытаний выборка A (number of tests, sample A)
s2 = # int, число успехов   выборка B (successes in sample B)
n2 = # int, число испытаний выборка B (number of tests, sample B)

z1, p_value1 = sm.stats.proportion_ztest([s1, s2], [n1, n2])
print('p value: ', p_value1)
```

### Метод 3:

Вычисление с использованием chi2_contingency. Осторожнее с этим методом!

```python
import stats from scipy
import numpy as np

s1 = # int, число успехов   выборка A (successes in sample A)
n1 = # int, число испытаний выборка A (number of tests, sample A)
s2 = # int, число успехов   выборка B (successes in sample B)
n2 = # int, число испытаний выборка B (number of tests, sample B)

contingency_table = np.array([[s1, n1-s1], [s2, n2-s2]]) # таблица сопряжённости
chi2, p_value3, dof, exp = stats.chi2_contingency(contingency_table)

z_analog = chi2**0.5
p_value3 = (stats.norm.cdf(z_analog))*2
print('p value: ', p_value3)
```

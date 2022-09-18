### $\pi$ -- Policy

$$ \pi \left( s, a \right) = Pr \left( a = a | s = s \right) $$

r -- reward  
s -- state  
a -- action  
t -- step  

### $V$ -- Value

$$ V_{\pi} \left( s \right) = \mathbb{E} \left( \sum_{t} \gamma^{t} r_t | s_{0}
= s \right) $$

$V$ -- expectation of how much reward I'll get in the future if I start in
the state $s_{0}$ and enact policy $\pi$  
$\gamma$ -- discount rate  

### $Q \left( s, a \right)$ -- Quality of state/action pair

$$ Q^{update} \left( s_{t}, a_{t} \right) = Q^{old} \left( s_{t}, a_{t} \right)
+ \alpha \left( r_{t} + \gamma \max_{a} Q \left( s_{t+1}, a \right)
- Q^{old} \left( s_{t}, a_{t} \right) \right) $$

---

$$ R \left( s', s, a \right) = Pr \left( r_{k+1} | s_{k+1} = s', s_{k} = s,
a_{k} = a \right) $$

$$ P \left( s', s, a \right) = Pr \left( s_{k+1} = s' | s_{k} = s, a_{k} = a
\right) $$

$P$ -- вероятность перехода в $s'$ при условии ...  
$R$ -- вероятность награды $r_{k+1}$ при условии ...  

### Value function (функция полезности действий) 

$$ V_{\pi} \left( s \right) = \mathbb{E} \left( \sum_{k} \gamma^{k} r_{k} |
s_{0} = s \right) $$

$$ V \left( s \right) = \max_{\pi} \mathbb{E} \left( \sum_{k=0}^{\infty}
\gamma^{k} r_{k} | s_{0} = s \right) $$

$$ V \left( s \right) = \max_{\pi} \mathbb{E} \left( r_{0} +
\sum_{k=1}^{\infty} \gamma^{k} r_{k} | s_{1} = s' \right) $$

$r_{0}$ -- награда при $s, s_{0}, a_{0}$

### Суммарная дисконтированная награда:

$$ \check{R}_{t} = r \left( s_{t}, a_{t} \right) + \gamma r \left( s_{t+1},
a_{t+1} \right) + \gamma^2 r \left( s_{t+2}, a_{t+2} \right) + \dots $$

### Bellman Equation:

$$ V \left( s \right) =\max_{\pi} \mathbb{E} \left( r_{0} + \gamma V \left( s'
\right) \right) $$

$$ \pi = \arg \max_{\pi} \mathbb{E} \left( r_{0} + \gamma V \left( s' \right)
\right) $$

---

### Value iteration

$$ V \left( s \right) = \max_{a} \sum_{s'} P \left( s' | s, a \right) \left( R
\left( s', s, a \right) + \gamma V \left( s' \right) \right) $$

$$ \pi \left( s, a \right) = \arg \max_{a} \sum_{s'} P \left( s' | s, a \right)
\left( R \left( s', s, a \right) + \gamma V \left( s' \right) \right) $$

### Pilicy iteration

$$ V_{\pi} \left( s \right) = \mathbb{E} \left( R \left( s', s, \pi \left( s
\right) \right) + \gamma V_{\pi} \left( s' \right) \right) = \sum_{s'} P \left(
s' | s, \pi \left( s \right) \right) \left( R \left( s', s, \pi \left( s
\right) \right) + \gamma V_{\pi} \left( s' \right) \right) $$

$$ \pi \left( s \right) = \arg\max_{a} \mathbb{E} \left( R \left( s', s, a
\right) + \gamma V_{\pi} \left( s' \right) \right) $$

### Quality function

$$ Q \left( s, a \right) = \mathbb{E} \left( R \left( s', s, a \right) + \gamma
V \left( s' \right) \right) = \sum_{s'} P \left( s' | s, a \right) \left( R
\left( s', s, a \right) + \gamma V \left( s' \right) \right) $$

$$ V \left( s \right) = \max_{a} Q \left( s, a \right) $$

$$ \pi \left( s, a \right) = \arg \max_{a} Q \left( s, a \right) $$

## Monte-Carlo learning

$$ R_{\Sigma} = \sum_{k=1}^{n} \gamma^{k} r_{k} $$

$R_{\Sigma}$ -- total reward over episode

$$ V^{new} \left( s_{k} \right) = V^{old} \left( s_{k} \right) + \frac{1}{n}
\left( R_{\Sigma} - V^{old} \left( s_{k} \right) \right) , \quad \forall k \in
[1, \dots, n] $$

$n$ -- number of steps

$$ Q^{new} \left( s_{k}, a_{k} \right) = Q^{old} \left( s_{k}, a_{k} \right) +
\frac{1}{n} \left( R_{\Sigma} - Q^{old} \left( s_{k}, a_{k} \right) \right) ,
\quad \forall k \in [1, \dots, n] $$

$R_{\Sigma}$ -- total actual reward over episode  
$Q^{old} \left( s_{k}, a_{k} \right)$ -- total estimated reward over episode

## Temporal difference learning: TD(0) 

$$ V \left( s_{k} \right) = \mathbb{E} \left( r_{k} + \gamma V \left( s_{k+1}
\right) \right) $$

$$ V^{new} \left( s_{k} \right) = V^{old} \left( s_{k} \right) + \alpha \left(
\overbrace{ \underbrace{ r_{k} + \gamma V^{old} \left( s_{k+1} \right)
}_{\text{TD target estimate} R_{\Sigma}} - V^{old} \left( s_{k} \right)
}^{\text{TD Error}} \right) $$

## Temporal difference learning: TD(N)

$$ V \left( s_{k} \right) = \mathbb{E} \left( r_{k} + \gamma r_{k+1} + \gamma^2
V \left( s_{k+2} \right) \right) $$

$$ V^{new} \left( s_{k} \right) = V^{old} \left( s_{k} \right) + \alpha \left(
\overbrace{ \underbrace{ r_{k} + \gamma r_{k+1} + \gamma^2 V^{old} \left(
s_{k+2} \right) }_{\text{TD target estimate } R_{\Sigma}} - V^{old} \left(
s_{k} \right) }^{\text{TD Error}} \right) $$

$$ R_{\Sigma}^{n} = r_{k} + \gamma r_{k+1} + \gamma^{2} r_{k+2} + \dots +
\gamma^{n} r_{k+n} + \gamma^{n+1} V \left( s_{k+n+1} \right) = \sum_{j=0}^{n}
\gamma^{j} r_{k+j} + \gamma^{n+1} V \left( s_{k+n+1} \right) $$

## Temporal difference learning: TD-$\lambda$




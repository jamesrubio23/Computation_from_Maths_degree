# Computational_Algebra
**Algorithms' implementation in MAPLE!**

  1.-**Euclides' algorithm**:
    Euclid's algorithm, is an efficient method for computing the greatest common divisor (GCD) of two integers (numbers), the largest number that divides 
    them both without a remainder. 
    
  1.1.-**Euclides' extended algorithm**:
    There is a theorem that says that if g = gcd(a,b), then there exist s and t tq g = sa + bt. euclid's algorithm extended compute those s and t 
    plus g. What it does to do this is add some more variables (c1,c2,d1 and d2) and some more instructions so that throughout the loop the 
    invariant c1*a+c2*b=c, d1*a+d2*b=d is fulfilled. When the loop ends and g=c, we are left with s=c1 and t=c2.
    
  2.-**Chinese Reaminder Theorem**:
    If R is a ring, A1,...,An are comaximal ideals two by two, A= A1...An and pr_i is the projection of R/A to R/Ai, then f = pr_1 x ... x pr_n: R/A -> R/A1 x ... x R/An 
    is an isomorphism of rings. 
    
  3.-**Greatest common divisor in a domain of unique factorization**:
      There is no general algorithm that covers every domain, we did for R[x] as R is a DFU. 
    
  4.-**Inverse**:
    If K = R/m is a field, with R a Euclidean domain and m maximal ideal, the inverse can be calculated by applying the extended euclid algorithm. 
    gcd(k,m)=1, since m is prime, and if 1 = sk+tm, then s is the inverse of k, since sk=sk+tm=1 mod m.
    
  5.-**Irreducibility test**: 
    Theorem: x^(q^d) - x is the product of all irreducible monic polynomials of Fq[x] whose degree divide d 
    Conclusion: f monic polynomial of degree n is irreducible if and only if f | x^(q^n)-x y gcd(x^(q^(n/t))-x,f) = 1 for all t prime divisor of n.
  
  6.-**Discret logarithm**:
    Calculate the discret logarithm in base g in a finite field where g is primitive.
  
  7.-**Types of factorization**:
    Equal degree factorization, distinct degree factorization and square free factorization.
  
  8.-**Berlekamps algorithm**:
    Factorize polynomials in a finite field. 
  
  9.-**Factorization**:
    Factorization in the ring of polynomials Z[x].
  
  10.-**Primality test, AKS algorithm**:
    Decides in polynomial time if a number is prime or not.
  
    

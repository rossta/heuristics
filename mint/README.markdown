Mint
====

http://cs.nyu.edu/courses/fall10/G22.2965-001/mint.html
 
Description
-----------

You are in charge of designing the denominations of coins. In the U.S., the denominations are penny, nickel, dime, quarter, half dollar, and dollar. Ignore the dollar coin for now. You have made a study of the subdollar prices and have determined that each multiple of 5 cents price is N times as likely as a non-multiple of 5 cents. For example, if N = 4, then 15 cents is four times as likely to be the price as 43 cents. But any 5 cent multiple is equally likely as any other 5 cent multiple and ditto for the non-5 cent multiples. The N will be given in class and your programs will have 2 minutes to solve each of the following two problems. (N will be 1 or greater but may not be an integer.)

1) 
Your first job is to design a set of 5 coin denominations such that the expected number of coins required to give exact change for a purchase is minimized given these constraints. This is called the Exact Change Number. Using the U.S. denominations, the Exact Change Number for 43 cents can be realized by one quarter, one dime, one nickel, and three pennies, thus giving a total of 6.

2) 
Let the Exchange Number of a purchase be the number of coins given from the buyer to the seller plus the number given in change to the buyer from the seller. For an item costing 43 cents using the U.S. denominations, the Exchange Number can be realized by having the buyer pay 50 cents and receiving a nickel and two pennies in return, giving a total of only 4. You can assume the availability of 1 dollar. So, the Exchange Number for 99 cents is 1 since a penny is returned after handing the seller 1 dollar. Your second job is to design a set of 5 coin denominations such that the Exchange Number of coins required for a purchase is minimized given these constraints.

For both jobs, please print out the average number of coins passed around and give me the number for each coin.
Hint: dynamic programming is a good start. You can use either one dimensional dynamic programming or two dimensional dynamic programming in the spirit of string matching. That is the inner loop. As for the outer loop, you might have to think whether any coin sizes are impossible. You might also find it useful to evaluate the cost on multiples of 5s separately from the costs on non-multiples of 5.

Discussion
----------

1) 
Assuming U.S. coin denominations, 1, 5, 10, 25, 50, the minimum exact change number is for any price M is a function f of M as follows:

  f(M) = min { f(M - 1) + 1, f(M - 5) + 1, f(M - 10) + 1, f(M - 25) + 1,  f(M - 50) + 1 }

For any coin set of denominations {d1, d2, d3, d4, d5}, we substitute to get:

  f(M) = min { f(M - d1) + 1, f(M - d2) + 1, f(M - d3) + 1, f(M - d4) + 1,  f(M - d5) + 1 }

Dynamic program in pseudocode:

  coin_set = [1..5]
  total_change_number = 0
  M = [1..99]
  N = 4 (or other arbitrary probability that price is multiple of 5)
  for i in [1..99]
    min = infinity
    for j in [0..4]
      if coin_set[j] <= i and min > M[i-coin_set[j]] + 1
        min = M[i - coin_set[j]] + 1
      end
    end
    M[i] = min
    if i mod 5 = 0
      total_change_number = total_change_number + M[i] * N
    else
      total_change_number = total_change_number + M[i]
    end
  end

1 cent must be present in coin set, so we may skip one inner loop. 
We may also abandon a coin set if total_change_number ever exceeds pre-calculated result for US denominations (as a starting point) or subsequent optimal coin_set.
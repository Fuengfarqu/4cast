def mean
  mean = self.reduce(:+)/self.length.to_f
  return mean
 end
 
 def randn
   begin 
   rg1 = (rand*2)-1 
   rg2 = (rand*2)-1 
   q = rg1**2 + rg2**2
   end while (q == 0 || q > 1)
   p = Math.sqrt((-2*Math.log(q))/q)
 
   rn1 = rg1 * p
   rn2 = rg2 * p
   return rn1, rn2
  end
 
 monte_carlo = 10
 ren1_sim = Array.new
 ren2_sim = Array.new
 
 monte_carlo.times {
  (1..20).each{ |i|
  (1..250).each { |j|
   r = randn() 
     ren1= * Math.exp(1 + 1 * r[0]) 
     # ren1 is an array with prices, mu_ren1 and sigma_ren1 are individual values
 
     ren2= * Math.exp(2 + 21 * r[0] + 22 * r[1])
     # chol_21 and chol_22 are also individual values
 
      ren1_sim.push(ren1)
      ren2_sim.push(ren2)
    } 
   }
  }
  puts ren1_sim.mean
  puts "\n\n\n\n\n"
  puts ren2_sim.mean


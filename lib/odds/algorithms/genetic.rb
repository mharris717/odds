require "gga4r"

class GeneticAlgorithm
  def logger
    @logger
  end
  def generations
    @generations
  end
  def population
    @population
  end

  def top_combined(n)
    res_sum = Hash.new { |h,k| h[k] = 0.0 }
    best_fitted(n).each do |obj|
      obj.bankroll_hash.each do |parlay_name,roll_perc|
        res_sum[parlay_name] += roll_perc
      end
    end

    res = {}
    res_sum.each do |parlay_name,perc_sum|
      res[parlay_name] = perc_sum / n.to_f
    end
    
    ParlayPercs.new(:bankroll_hash => res)
  end
end

class Array
  def rand_el
    i = (rand()*size.to_f).to_i
    self[i]
  end
end



class ParlayPercs
  include FromHash
  attr_accessor :bankroll_hash

  def fitness
    @fitness ||= sims.profit(bankroll_hash)
  end

  def actual_profit
    @actual_profit ||= sims.profit(bankroll_hash, :actual => true)
  end

  def to_s_fitness
    "#{fitness.to_i}/#{actual_profit.to_i}"
  end

  def recombine(other)
    res = {}

    my_weight = 0.5 # rand*0.7 + 0.15
    other_weight = 1.0-my_weight
    bankroll_hash.each do |parlay_name,roll_perc|
      other_perc = other.bankroll_hash[parlay_name]
      raise "bad" unless other_perc
      combined_perc = roll_perc*my_weight + other_perc*other_weight
      res[parlay_name] = combined_perc
    end
    self.class.new(:bankroll_hash => res)
  end 

  def mutate_one
    increase_parlay = parlays.rand_el
    decrease_parlay = (parlays - [increase_parlay]).rand_el 

    increase_room = (0.4 - bankroll_hash[increase_parlay.name])
    decrease_room = bankroll_hash[decrease_parlay.name] - 0.02
    room = [increase_room,decrease_room].min
    room = 0 if room < 0

    adjustment_amount = [rand()*0.02,room].min

    if adjustment_amount > 0
      bankroll_hash[increase_parlay.name] += adjustment_amount
      bankroll_hash[decrease_parlay.name] -= adjustment_amount
      @fitness = nil
      true
    else
      false
    end
  end

  def mutate
    20.times do
      return if mutate_one
    end
    raise "can't mutate"
  end

  class << self
    def make_rand
      nums = parlays.size.of { rand() }

      nums = nums.map_centered_on_sum(1)
      nums = nums.map_restrict_to_range(0.05..0.25)
      nums = nums.map_centered_on_sum(1)

      res = {}
      parlays.each_with_index do |parlay,i|
        res[parlay.name] = nums[i]
      end
      new(:bankroll_hash => res)
    end
  end
end

class Array
  def map_centered_on_sum(target_sum)
    self_sum = sum
    map { |x| x.to_f / self_sum.to_f * target_sum.to_f }
  end
  def map_restrict_to_range(r)
    map do |n|
      if n > r.end
        r.end
      elsif n < r.begin
        r.begin
      else
        n
      end
    end
  end
end

class Array
  def to_s_bankroll_percs
    arrs = []
    arrs << map { |x| x.fitness }.sort.reverse
    arrs << map { |x| x.actual_profit }.sort.reverse

    arrs.map do |arr|
      sub = [arr[0],arr[-1]]
      sub.inspect
    end.join(" ")
  end
end

def run_genetic
  population = 100.of { ParlayPercs.make_rand }
  ga = GeneticAlgorithm.new(population, :max_population => 10000)
  ga.logger.level = Logger::FATAL

  puts "Initial Fitness: #{population.to_s_bankroll_percs}"

  500.times do |i|
    print "#{i} #{Time.now}" if i%1 == 0 && i > 0
    ga.evolve
    print " Size: #{ga.population.size}" if i%1 == 0 && i > 0
    best = ga.best_fit
    best_combined = ga.top_combined(100)
    puts " Fitness: #{best.to_s_fitness}" if i%1 == 0 && i > 0
    if i%1 == 0 && i > 0
      puts "Top"
      best.bankroll_hash.each do |name,perc|
        puts "#{name}: #{perc.to_s_perc}"
      end
      puts "\n\nCombined"
      best_combined.bankroll_hash.each do |name,perc|
        puts "#{name}: #{perc.to_s_perc}"
      end
      puts "\n\n"
    end
    
  end

  best = ga.best_fit
  best_combined = ga.top_combined(100)
  puts "Final Fitness: #{best.to_s_fitness}"
  puts "Final Fitness Combined: #{best_combined.to_s_fitness}"

  best.bankroll_hash.each do |name,perc|
    puts "#{name}: #{perc}"
  end

  ga
end

run_genetic

def run_prof
  profile_result = RubyProf.profile do
    run_genetic
  end

  File.open("profile2.html","w") do |f|
    printer = RubyProf::GraphHtmlPrinter.new(profile_result)
    printer.print(f, {})
  end
end


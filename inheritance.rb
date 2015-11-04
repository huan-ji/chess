class Employee
  attr_reader :salary, :name, :employees, :boss
  def initialize(name, title, salary, boss)
    @name, @title, @salary= name, title, salary
    boss_assign(boss)
  end

  def boss_assign(boss)

    if boss != nil
      ObjectSpace.each_object Employee do |employee|
        if boss == employee.name
          @boss = employee
          employee.employees << self
          employee.boss.employees << self unless employee.boss.nil?
        end
      end
    end
  end


  def bonus(multiplier)
    bonus = @salary * multiplier
  end
end

class Manager < Employee
  def initialize(name, title, salary, boss)
    super(name, title, salary, boss)
    @employees = []
  end

  def bonus(multiplier)
    bonus = 0
    @employees.each do |employee|
      bonus += employee.salary
    end
    bonus = bonus * multiplier
  end

end

ned = Manager.new("Ned","Founder",1000000,nil)
darren = Manager.new("Darren", "TA Manager", 78000, "Ned")
shawna = Employee.new("Shawna", "TA", 12000, "Darren")
david = Employee.new("David", "TA", 10000, "Darren")

p ned.bonus(5) # => 500_000
p darren.bonus(4) # => 88_000
p david.bonus(3) # => 30_000

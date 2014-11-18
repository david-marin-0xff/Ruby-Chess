class Employee
  attr_accessor :name, :title, :salary, :boss

  def initialize(name, title, salary, boss=nil)
    @name = name
    @title = title
    @salary = salary
    @boss = boss
  end

  def bonus(multiplier)
    salary * multiplier
  end
end

class Manager < Employee
  attr_accessor :employees

  def bonus(multiplier)
    sub_salaries = 0

    employees.each do |emp|
      sub_salaries += emp.bonus(1)
      sub_salaries += emp.salary if emp.is_a?(Manager)
    end

    sub_salaries * multiplier
  end
end

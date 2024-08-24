# lab 3 OOP
# Yehia Mohamed Youssef

class Person:
    def __init__(self, name, money, mood, healthRate):
        self.name = name
        self.money = money
        self.mood = mood
        self.healthRate = healthRate

    def sleep(self, hours):
        if hours == 7:
            self.mood = 'happy'
        elif hours < 7:
            self.mood = 'tired'
        else:
            self.mood = 'lazy'

    def eat(self, meals):
        if meals == 3:
            self.healthRate = 100
        elif meals == 2:
            self.healthRate = 75
        elif meals == 1:
            self.healthRate = 50

    def buy(self, items):
        self.money -= items * 10  # Decrease money by 10 L.E for each item


class Office:
    employeesNum = 0  # Class variable for total number of employees

    def __init__(self, name):
        self.name = name
        self.employees = []

    def get_all_employees(self):
        return self.employees

    def get_employee(self, emp_id):
        for employee in self.employees:
            if employee.emp_id == emp_id:
                return employee
        return None

    def hire(self, employee):
        self.employees.append(employee)
        Office.employeesNum += 1

    def fire(self, emp_id):
        employee = self.get_employee(emp_id)
        if employee:
            self.employees.remove(employee)
            Office.employeesNum -= 1

    def deduct(self, emp_id, deduction):
        employee = self.get_employee(emp_id)
        if employee:
            employee.salary -= deduction

    def reward(self, emp_id, reward):
        employee = self.get_employee(emp_id)
        if employee:
            employee.salary += reward

    def check_lateness(self, emp_id, moveHour, targetHour=9):
        employee = self.get_employee(emp_id)
        if employee:
            lateness = self.calculate_lateness(targetHour, moveHour, employee.distanceToWork, employee.car.velocity)
            if lateness > 0:
                self.deduct(emp_id, 10)
            else:
                self.reward(emp_id, 10)

    @staticmethod
    def calculate_lateness(targetHour, moveHour, distance, velocity):
        if velocity == 0:
            return float('inf')  # If velocity is 0, assume infinite lateness (car is stopped)

        time_needed = distance / velocity
        arrival_time = moveHour + time_needed
        return max(arrival_time - targetHour, 0)

    @classmethod
    def change_emps_num(cls, num):
        cls.employeesNum = num


class Car:
    def __init__(self, name, fuelRate, velocity):
        self.name = name
        self._fuelRate = fuelRate  # Use a property for validation
        self._velocity = velocity  # Use a property for validation

    @property
    def fuelRate(self):
        return self._fuelRate

    @fuelRate.setter
    def fuelRate(self, value):
        if 0 <= value <= 100:
            self._fuelRate = value
        else:
            raise ValueError("Fuel rate must be between 0 and 100.")

    @property
    def velocity(self):
        return self._velocity

    @velocity.setter
    def velocity(self, value):
        if 0 <= value <= 200:
            self._velocity = value
        else:
            raise ValueError("Velocity must be between 0 and 200.")

    def run(self, velocity, distance):
        self.velocity = velocity
        fuel_needed = distance / 10  # Simplified fuel consumption model
        if self.fuelRate >= fuel_needed:
            self.fuelRate -= fuel_needed
            remaining_distance = 0
        else:
            remaining_distance = distance - (self.fuelRate * 10)
            self.fuelRate = 0
        self.stop(remaining_distance)

    def stop(self, remaining_distance):
        self.velocity = 0
        if remaining_distance > 0:
            print(f"Car stopped with {remaining_distance}km left to destination.")
        else:
            print("Car stopped. You have arrived at your destination.")


class Employee(Person):
    def __init__(self, name, money, mood, healthRate, emp_id, car, email, salary, distanceToWork):
        super().__init__(name, money, mood, healthRate)
        self.emp_id = emp_id
        self.car = car
        self.email = email
        self.salary = salary
        self.distanceToWork = distanceToWork

    def drive(self, distance, velocity):
        if self.car:
            self.car.run(velocity, distance)
        else:
            print("No car assigned to this employee.")

    def refuel(self, gasAmount=100):
        if self.car:
            new_fuel_rate = self.car.fuelRate + gasAmount
            self.car.fuelRate = min(new_fuel_rate, 100)  # Ensure fuelRate doesn't exceed 100
        else:
            print("No car assigned to this employee.")


# Scenario 1: Multiple Employees with Different Cars
car1 = Car("Honda", 30, 150)
car2 = Car("BMW", 70, 180)
car3 = Car("Ford", 50, 100)

employee1 = Employee("Alice", 300, "happy", 90, 1, car1, "alice@example.com", 6000, 20)
employee2 = Employee("Bob", 400, "neutral", 80, 2, car2, "bob@example.com", 7000, 25)
employee3 = Employee("Charlie", 500, "lazy", 85, 3, car3, "charlie@example.com", 8000, 30)

office = Office("TechCorp")
office.hire(employee1)
office.hire(employee2)
office.hire(employee3)

# Drive Cars
employee1.drive(50, 100)
employee2.drive(30, 120)
employee3.drive(80, 90)

# Refuel Cars
employee1.refuel(40)
employee2.refuel(20)
employee3.refuel(60)

# Check Lateness
office.check_lateness(1, 7)
office.check_lateness(2, 8)
office.check_lateness(3, 9)


# Scenario 2: Deducting and Rewarding Employees
office.deduct(1, 500)  # Deduct 500 from Alice's salary
office.deduct(2, 300)  # Deduct 300 from Bob's salary

office.reward(3, 1000)  # Reward Charlie with 1000
office.reward(1, 200)   # Reward Alice with 200

# Print Salaries
print(f"Alice's salary: {employee1.salary}")
print(f"Bob's salary: {employee2.salary}")
print(f"Charlie's salary: {employee3.salary}")

# Scenario 3: Firing and Rehiring an Employee
office.fire(2)  # Fire Bob

# Check Employees List
print("Employees after firing Bob:")
for emp in office.get_all_employees():
    print(emp.name)

# Rehire the Employee
office.hire(employee2)  # Rehire Bob

# Check Employees List Again
print("Employees after rehiring Bob:")
for emp in office.get_all_employees():
    print(emp.name)

# Scenario 4: Handling Edge Cases

# Drive Without Enough Fuel
employee1.drive(500, 150)  # Attempt to drive 500km at 150km/h with low fuel

# Refuel Beyond Capacity
employee3.refuel(200)  # Attempt to refuel beyond the maximum capacity of 100

# Check Lateness with Zero Velocity
car4 = Car("Tesla", 50, 0)  # Create a car with zero velocity
employee4 = Employee("David", 250, "neutral", 80, 4, car4, "david@example.com", 6500, 10)
office.hire(employee4)
office.check_lateness(4, 8)  # Check lateness for David

# Scenario 5: Employee Performing Various Actions
employee1.sleep(5)  # Alice sleeps for 5 hours
employee1.eat(2)    # Alice eats 2 meals
employee1.buy(3)    # Alice buys 3 items
print(f"Alice's mood: {employee1.mood}, Health Rate: {employee1.healthRate}, Money: {employee1.money}")

# Employee Drives to Work
employee2.drive(25, 110)  # Bob drives 25km at 110km/h
office.check_lateness(2, 7)  # Check if Bob is late
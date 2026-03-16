class employee:
    def __init__(self, id, name, salary):
        self.id = id
        self.name = name
        self.salary = salary

    def DisplayDetails(self):
        print(self.id, self.name, self.salary)

emp = employee(101, "Ravi", 50000)
emp.DisplayDetails()

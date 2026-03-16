"""
Employee management module.
Demonstrates clean OOP code following pylint standards.
"""


class Employee:
    """
    Represents an employee with basic payroll details.
    """

    def __init__(self, emp_id, name, salary):
        """
        Initialize employee details.

        :param emp_id: Employee ID
        :param name: Employee name
        :param salary: Monthly salary
        """
        self.emp_id = emp_id
        self.name = name
        self.salary = salary

    def display_details(self):
        """
        Display employee details.
        """
        print(self.emp_id, self.name, self.salary)

    def annual_salary(self):
        """
        Calculate annual salary.
        """
        return self.salary * 12


emp = Employee(101, "Ravi", 50000)
emp.display_details()
print("Annual Salary:", emp.annual_salary())

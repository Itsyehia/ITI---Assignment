# 1
def getFromUser():
    numbers = []

    for i in range(5):
        number = float(input(f"Enter number {i + 1}: "))
        numbers.append(number)

    return numbers


# 2
def count_vowels(input_string):
    vowels = "aeiouAEIOU"
    count = 0

    for char in input_string:
        if char in vowels:
            count += 1

    return count


# 3
def find_char_locations(input_string, char='i'):
    locations = []

    for index, c in enumerate(input_string):
        if c == char:
            locations.append(index)

    if locations:
        print(f"'{char}' is found at {locations}")
    else:
        print(f"'{char}' is not found ")

    return locations


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    numbers = getFromUser()

    AscNumbers = sorted(numbers)

    numbers.sort(reverse=True)
    descNumbers = numbers

    print("1-")
    print("Sorted numbers in descending order:", descNumbers)
    print("Sorted numbers in ascending  order:", AscNumbers)

    print("2-count vowels in a string: ", count_vowels("test input"))

    print("3-", find_char_locations("test input contains char i"))

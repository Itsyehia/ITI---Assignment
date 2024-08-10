# 1 largest int divisor
def max_divisible(div, bound):
    return bound - (bound % div)


# 2 palindrome
def is_palindrome(s):
    cleaned_str = ''.join(char.lower() for char in s if char.isalnum())
    return cleaned_str == cleaned_str[::-1]


# 3 Concatenate lists
def concatenate_lists(list1, list2):
    return list1 + list2


# 4 bool to str
def bool_to_string(flag):
    return str(flag)


# 5 sorted dictionary
def names_to_dict(names):
    name_dict = {}

    for name in names:
        first_letter = name[0].lower()

        if first_letter not in name_dict:
            name_dict[first_letter] = []

        name_dict[first_letter].append(name)

    sorted_name_dict = {k: sorted(v) for k, v in sorted(name_dict.items())}

    return sorted_name_dict


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    # 1
    div = 3
    bound = 10
    result = max_divisible(div, bound)
    print(result)

    # 2
    test_str = "A man, a plan, a canal, Panama"
    print(is_palindrome(test_str))
    print(is_palindrome("abac"))
    print(is_palindrome("aabaa"))

    # 3
    list1 = [1, 2, 3]
    list2 = [4, 5, 6]
    print(concatenate_lists(list1, list2))

    # 4
    flag = True
    print(bool_to_string(flag))

    # 5
    names = ["Alice", "Bob", "Charlie", "Anna", "Brian", "Catherine"]
    print(names_to_dict(names))

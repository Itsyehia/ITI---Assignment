# Yehia Mohamed 
# 1 Given an array of strings, return another array containing all of its longest strings.
def find_longest_strings(inputArray):
    max_length = max(len(s) for s in inputArray)
    
    return [s for s in inputArray if len(s) == max_length]

inputArray = ["aba", "aa", "ads", "vcd", "aba"]
print(find_longest_strings(inputArray))



#######################################################
# 2 You have k apple boxes full of apples. Each square box of size m contains m × m apples. You just noticed two interesting properties about the boxes:
def apple_boxes_difference(k):
    yellow_apples = 0
    red_apples = 0
    
    for i in range(1, k + 1):
        if i % 2 == 0:
            red_apples += i * i
        else:
            yellow_apples += i * i
            
    return red_apples - yellow_apples

k = 5
print(apple_boxes_difference(k))

#######################################################
# 3 you are implementing your own HTML editor.

def find_end_tag(startTag):
    end_pos = startTag.find(' ')
    if end_pos == -1:
        end_pos = startTag.find('>')

    # get tag name
    tag_name = startTag[1:end_pos]

    return f"</{tag_name}>"

# Example usage
startTag1 = "<button type='button' disabled>"
startTag2 = "<i>"
print(find_end_tag(startTag1))  #  </button>
print(find_end_tag(startTag2))  #  </i>

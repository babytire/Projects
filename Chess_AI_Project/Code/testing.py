#notable links


#github code: https://github.com/AnshGaikwad/Chess-World/blob/master/play.py

#quiescence search: https://en.wikipedia.org/wiki/Quiescence_search
# why it's inefficient: https://chess.stackexchange.com/questions/27257/chess-engine-quiescence-search-increases-required-time-by-a-factor-of-20


def quick_sort(arr, low, high):

    if(low < high):
        partition_index = partition(arr, low, high)
        quick_sort(arr, low, partition_index - 1)
        quick_sort(arr, partition_index + 1, high)

def partition (arr, low, high):
    
    pivot = arr[high]
    i = low - 1

    j = low
    for j in range(low, high):
        if arr[j][0] <= pivot[0]:
            i += 1
            temp = arr[i]
            arr[i] = arr[j]
            arr[j] = temp

    temp = arr[i + 1]
    arr[i + 1] = arr[int(high)]
    arr[high] = temp

    return i+1

x = [[7, "tacos"], [2, "burrito"], [35, 'no'], [17, 'chicken'], [1, 'lel'], [30, 'lel']]
print(x)
quick_sort(x, 0, 5)
print(x)
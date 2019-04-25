//
//  SortClass.swift
//  SortDemo
//
//  Created by Cuicui You 尤翠翠 on 2019/1/25.
//  Copyright © 2019年 Cuicui You 尤翠翠. All rights reserved.
/*
 算法稳定性：
     假定在待排序的记录序列中，存在多个具有相同的关键字的记录，若经过排序，这些记录的相对次序保持不变，即在原序列中，r[i]=r[j]，且r[i]在r[j]之前，而在排序后的序列中，r[i]仍在r[j]之前，则称这种排序算法是稳定的；否则称为不稳定的。
 
 
 */

import UIKit

enum SortTypeEnum: Int {
    case BubbleSort = 0     //冒泡排序
    case SelectSort         //选择排序
    case InsertSort         //插入排序
    case ShellSort          //希尔排序
    case HeapSort           //堆排序
    case MergeSort          //归并排序
    case QuickSort          //快速排序
    case RadixSort          //快速排序
}

/// 排序类的简单工厂
class SortFactory {
    static func create(type: SortTypeEnum) -> SortType {
        switch type {
        case .BubbleSort:
            return BubbleSort()
            
        case .SelectSort:
            return SimpleSelectionSort()
            
        case .InsertSort:
            return InsertSort()
            
        case .ShellSort:
            return ShellSort()
            
        case .HeapSort:
            return HeapSort()
            
        case .MergeSort:
            return MergingSort()
            
        case .QuickSort:
            return QuickSort()
            
        case .RadixSort:
            return RadixSort()
        }
    }
}


typealias SortResultClosure = (_ index: Int, _ value: Int) -> Void
typealias SortSuccessClosure = (Array<Int>) -> Void

class SortBaseClass {
    var everyStepClosure: SortResultClosure!
    var sortSuccessClosure: SortSuccessClosure!
    
    func displayResult(index: Int, value: Int) {
        if everyStepClosure != nil {
            everyStepClosure(index, value)
            Thread.sleep(forTimeInterval: 0.001)
        }
        
    }
    
    func successSort(sortList:Array<Int>) -> Void {
        if self.sortSuccessClosure != nil {
            self.sortSuccessClosure(sortList)
        }
    }
    
    func setEveryStepClosure(everyStepClosure: @escaping SortResultClosure,
                             sortSuccessClosure: @escaping SortSuccessClosure) -> Void {
        self.everyStepClosure = everyStepClosure
        self.sortSuccessClosure = sortSuccessClosure
    }
}

/// 冒泡排序：时间复杂度----O(n^2)
class BubbleSort: SortBaseClass, SortType {
    func sort(items: Array<Int>) -> Array<Int> {
        //print("冒泡排序：")
        var list = items
        for i in 0..<list.count {
            var j = list.count - 1
            while j > i {
                if list[j - 1] > list[j]  { //前边的大于后边的则进行交换
                    let temp = list[j]
                    list[j] = list[j - 1]
                    list[j - 1] = temp
                    
                    displayResult(index: j, value: list[j])
                    displayResult(index: j-1, value: list[j-1])
                    
                }
                j = j - 1
            }
        }
        self.successSort(sortList: list)
        return list
    }
}


/// 插入排序-O(n^2)
/*
 5 直接插入排序：
     直接插入排序就是从待排序列中选出一个元素，插入到已经有序的元素之中，直到所有的元素都插入到有序序列中所有的元素就全部有序了。
     通常的做法就是将第一个元素看做是有序的元素（即待排序列的第一个元素看做是有序序列），然后我们将第二个元素和有序序列（即
第一个元素）作比较，按正确的序列插入到序列中去。然后在将第三个元素和前面有序序列（即整个待排序列的前两个元素）作比较，将第
三个插入到前两个元素中去，使得前三个元素有序。以此类推，直到所有的元素都有序。
 */

class InsertSort: SortBaseClass, SortType{
    func sort(items: Array<Int>) -> Array<Int> {
        //print("插入排序")
        var list = items
        for i in 1..<list.count {   //循环无序数列
            //print("第\(i)轮插入：")
            //print("要选择插入的值为：\(list[i])")
            var j = i
            while j > 0 {           //循环有序数列，插入相应的值
                if list[j] < list[j - 1]  {
                    
                    let temp = list[j]
                    list[j] = list[j-1]
                    list[j-1] = temp
                    
                    displayResult(index: j, value: list[j])
                    displayResult(index: j-1, value: list[j-1])
                    
                    j = j - 1
                } else {
                    break
                }
            }
            //print("插入的位置为：\(j)")
            //print("本轮插入完毕, 插入结果为：\n\(list)\n")
        }
        self.successSort(sortList: list)
        return list
    }
}

//希尔排序：时间复杂度----O(n^(3/2))
/*
  将待排序列进行分段排序，数据基本有序后，然后利用直接插入排序的特长完成排序
  1.用增量法进行排序，例如此次增量为4 即下标为0与下标为4的进行比较排序，调换位置，下标为1和下标为5的进行比较，调换位置...
  2.第一次排序完成后，进行第二次排序，增量除2，即为2. 过程重复上述步骤
  3.第三次增量为1，即按照直接插入排序方法进行排序 （增量为1时，就是对整个序列做最后的调整）
 
 */
class ShellSort: SortBaseClass, SortType {
    func sort(items: Array<Int>) -> Array<Int> {
        //print("希尔排序")
        var list = items
        var step: Int = list.count / 2
        while step > 0 {
            //print("步长为\(step)的插入排序开始：")
            for i in 0..<list.count {
                var j = i + step
                while j >= step && j < list.count {
                    if list[j] < list[j - step]  {
                        let temp = list[j]
                        list[j] = list[j-step]
                        list[j-step] = temp
                        
                        displayResult(index: j, value: list[j])
                        displayResult(index: j-step, value: list[j-step])
                        
                        j = j - step
                    } else {
                        break
                    }
                }
            }
            //print("步长为\(step)的插入排序结束")
            //print("本轮排序结果为：\(list)\n")
            step = step / 2     //缩小步长
        }
        self.successSort(sortList: list)
        return list
    }
}

/// 简单选择排序－O(n^2)
/*
 每一趟从待排序的数据元素中选出最小（最大）的元素，顺序放在待排序的数列最前，直到全部待排序的数据元素全部排完。
 【过程】
 
   初始关键字：『 8，5，2，6，9，3，1，4，0，7 』
 
   第一趟排序后：0，『5，2，6，9，3，1，4，8，7』
 
   第二趟排序后：0，1，『2，6，9，3，5，4，8，7』
 
   第三趟排序后：0，1，2，『6，9，3，5，4，8，7』
 
   第四趟排序后：0，1，2，3，『9，6，5，4，8，7』
 
*/
class SimpleSelectionSort: SortBaseClass, SortType {
    
    func sort(items: Array<Int>) -> Array<Int> {
        var list = items
        // 需要遍历获得最小值的次数
        // 要注意一点，当要排序 N 个数，已经经过 N-1 次遍历后，已经是有序数列
        for i in 0..<list.count {
            var temp = 0
            var index = i // 用来保存最小值得索引
            
            // 寻找第i个小的数值
            for j in i + 1..<list.count {
                if (list[index] > list[j]) {
                    index = j
                }
            }
            
            // 将找到的第i个小的数值放在第i个位置上
            temp = list[index]
            list[index] = list[i]
            list[i] = temp
            
            displayResult(index: i, value: list[i])
            displayResult(index: index, value: list[index])
        }
        self.successSort(sortList: list)
        return list
    }
    
}
    
    /*
    func sort(items: Array<Int>) -> Array<Int> {
        //print("简单选择排序")
        var list = items
        for i in 0..<list.count {
            //print("第\(i+1)轮选择，选择下标的范围为\(i)----\(list.count)")
            var j = i + 1
            var minValue = list[i]
            var minIndex = i
            
            //寻找无序部分中的最小值
            while j < list.count {
                if minValue > list[j] {
                    minValue = list[j]
                    minIndex = j
                }
                displayResult(index: j, value: list[j])
                j = j + 1
            }
            //print("在后半部分乱序数列中，最小值为：\(minValue), 下标为：\(minIndex)")
            //与无序表中的第一个值交换，让其成为有序表中的最后一个值
            if minIndex != i {
                //print("\(minValue)与\(list[i])交换")
                let temp = list[i]
                list[i] = list[minIndex]
                list[minIndex] = temp
                
                displayResult(index: i, value: list[i])
                displayResult(index: minIndex, value: list[minIndex])
            }
            //print("本轮结果为：\(list)\n")
        }
        self.successSort(sortList: list)
        return list
        
    }

}
 */


/// 堆排序 (O(nlogn))
class HeapSort: SortBaseClass, SortType {
    
    func sort(items: Array<Int>) -> Array<Int> {
        //print("堆排序：\(items)")
        var list = items
        var endIndex = items.count - 1
        
        //创建大顶堆，其实就是将list转换成大顶堆层次的遍历结果
        heapCreate(items: &list)
        
        //print("原始堆：\(list)")
        while endIndex >= 0 {
            //将大顶堆的顶点（最大的那个值）与大顶堆的最后一个值进行交换
            //print("将list[0]:\(list[0])与list[\(endIndex)]:\(list[endIndex])交换")
            let temp = list[0]
            list[0] = list[endIndex]
            list[endIndex] = temp
            
            displayResult(index: 0, value: list[0])
            displayResult(index: endIndex, value: list[endIndex])
            
            endIndex -= 1   //缩小大顶堆的范围
            
            //对交换后的大顶堆进行调整，使其重新成为大顶堆
            heapAdjast(items: &list, startIndex: 0,endIndex: endIndex + 1)
            //print("调整后:\(list)\n")
        }
        self.successSort(sortList: list)
        return list
    }
    
    
    /// 构建大顶堆的层次遍历序列（f(i) > f(2i), f(i) > f(2i+1) i > 0）
    ///
    /// - parameter items:    构建大顶堆的序列
    func heapCreate(items: inout Array<Int>) {
        var i = items.count
        while i > 0 {
            heapAdjast(items: &items, startIndex: i - 1, endIndex:items.count )
            i -= 1
        }
    }
    
    /// 对大顶堆的局部进行调整，使其该节点的所有父类符合大顶堆的特点
    ///
    /// - parameter items:    list
    /// - parameter endIndex: 当前要调整的节点
    func heapAdjast(items: inout Array<Int>, startIndex: Int, endIndex: Int) {
        let temp = items[startIndex]
        var fatherIndex = startIndex + 1                 //父节点下标
        var maxChildIndex = 2 * fatherIndex //左孩子下标
        while maxChildIndex <= endIndex {
            //比较左右孩子并找出比较大的下标
            if maxChildIndex < endIndex && items[maxChildIndex-1] < items[maxChildIndex] {
                maxChildIndex = maxChildIndex + 1
            }
            
            //如果较大的那个子节点比根节点大，就将该节点的值赋给父节点
            if temp < items[maxChildIndex-1] {
                items[fatherIndex-1] = items[maxChildIndex-1]
                displayResult(index: fatherIndex-1, value: items[fatherIndex-1])
            } else {
                break
            }
            fatherIndex = maxChildIndex
            maxChildIndex = 2 * fatherIndex
        }
        items[fatherIndex-1] = temp
        displayResult(index: fatherIndex-1, value: items[fatherIndex-1])
    }
    
}



/// 归并排序O(nlogn)
class MergingSort: SortBaseClass, SortType {
    var tempArray: Array<Array<Int>> = []
    func sort(items: Array<Int>) -> Array<Int> {
        tempArray.removeAll()
        //将数组中的每一个元素放入一个数组中
        for item in items {
            var subArray: Array<Int> = []
            subArray.append(item)
            tempArray.append(subArray)
        }
        
        //对这个数组中的数组进行合并，直到合并完毕为止
        while tempArray.count != 1 {
            var i = 0
            while i < tempArray.count - 1 {
                //print("将\(tempArray[i])与\(tempArray[i+1])合并")
                tempArray[i] = mergeArray(firstList: tempArray[i], secondList: tempArray[i + 1])
                tempArray.remove(at: i + 1)
                for subIndex in 0..<tempArray[i].count{
                    let index = self.countSubItemIndex(endIndex: i, subItemIndex: subIndex)
                    self.displayResult(index: index, value: tempArray[i][subIndex])
                    
                }
                i = i + 1
            }
        }
        self.successSort(sortList: tempArray.first!)
        return tempArray.first!
    }
    
    
    /// 归并排序中的“并”--合并：将两个有序数组进行合并
    ///
    /// - parameter firstList:  第一个有序数组
    /// - parameter secondList: 第二个有序数组
    ///
    /// - returns: 返回排序好的数组
    func mergeArray(firstList: Array<Int>, secondList: Array<Int>) -> Array<Int> {
        var resultList: Array<Int> = []
        var firstIndex = 0
        var secondIndex = 0
        
        while firstIndex < firstList.count && secondIndex < secondList.count {
            if firstList[firstIndex] < secondList[secondIndex] {
                resultList.append(firstList[firstIndex])
                firstIndex += 1
            } else {
                resultList.append(secondList[secondIndex])
                secondIndex += 1
            }
        }
        
        while firstIndex < firstList.count {
            resultList.append(firstList[firstIndex])
            firstIndex += 1
        }
        
        while secondIndex < secondList.count {
            resultList.append(secondList[secondIndex])
            secondIndex += 1
        }
        
        return resultList
    }
    
    func countSubItemIndex(endIndex: Int, subItemIndex: Int) -> Int {
        var sum = 0
        for i in 0..<endIndex {
            sum += tempArray[i].count
        }
        
        return sum + subItemIndex
    }
}


/// 快速排序O(nlogn)
/*
  1.首先在这个序列中随便找一个数作为基准数，现以第一个数6作为基准数（可随机从序列中选择一个）
  2.分别从初始序列“6  1  2 7  9  3  4  5 10  8”两端开始“探测”。先从右往左找一个小于6的数，再从左往右找一个大于6的数，然后交换他们（每次查找都是先从右侧开始查找小的，再从左侧查找大于基准值的数）
 
 */
class QuickSort: SortBaseClass, SortType {
    func sort(items: Array<Int>) -> Array<Int> {
        var list = items
        //print("快速排序开始：")
        quickSort(list: &list, low: 0, high: list.count-1)
        //print("快速排序结束！")
        self.successSort(sortList: list)
        return list
    }
    
    
    /// 快速排序
    ///
    /// - parameter list: 要排序的数组
    /// - parameter low: 数组的上界
    /// - parameter high: <#high description#>
    private func quickSort(list: inout Array<Int>, low: Int, high: Int) {
        if low < high {
            let mid = partition(list: &list, low: low, high: high)
            quickSort(list: &list, low: low, high: mid - 1)   //递归前半部分
            quickSort(list: &list, low: mid + 1, high: high)  //递归后半部分
        }
    }
    
    /// 将数组以第一个值为准分成两部分，前半部分比该值要小，后半部分比该值要大
    ///
    /// - parameter list: 要二分的数组
    /// - parameter low:  数组的下界
    /// - parameter high: 数组的上界
    ///
    /// - returns: 分界点
    private func partition(list: inout Array<Int>, low: Int, high: Int) -> Int {
        var low = low
        var high = high
        let temp = list[low]
        //print("low[\(low)]:\(list[low]), high[\(high)]:\(list[high])")
        while low < high {
            
            while low < high && list[high] >= temp {
                high -= 1
            }
            list[low] = list[high]
            displayResult(index: low, value: list[low])
            
            while low < high && list[low] <= temp {
                low += 1
            }
            list[high] = list[low]
            displayResult(index: high, value: list[high])
        }
        list[low] = temp
        displayResult(index: low, value: list[low])
        //print("mid[\(low)]:\(list[low])")
        //print("\(list)\n")
        return low
    }
}

//基数排序
class RadixSort: SortBaseClass, SortType {
    func sort(items: Array<Int>) -> Array<Int> {
        var list = items
        if list.count > 0 {
            radixSort(list: &list)
        }
        self.successSort(sortList: list)
        return list
    }
    
    private func radixSort(list: inout Array<Int>) {
        var bucket = createBucket()
        let maxNumber = listMaxItem(list: list)
        let maxLength = numberLength(number: maxNumber)
        
        for digit in 1...maxLength {
            //入桶
            for item in list {
                let baseNumber = fetchBaseNumber(number: item, digit: digit)
                bucket[baseNumber].append(item) //根据基数入桶
            }
            
            //出桶
            var index = 0
            for i in 0..<bucket.count {
                while !bucket[i].isEmpty {
                    list[index] = bucket[i].remove(at: 0)
                    displayResult(index: index, value: list[index])
                    index += 1
                }
            }
        }
    }
    
    /// 创建10个桶
    ///
    /// - returns: 返回创建好的桶子
    private func createBucket() -> Array<Array<Int>> {
        var bucket: Array<Array<Int>> = []
        for _ in 0..<10 {
            bucket.append([])
        }
        return bucket
    }
    
    
    /// 计算序列中最大的那个数
    ///
    /// - parameter list: 数列
    ///
    /// - returns: 返回该数列中最大的值
    private func listMaxItem(list: Array<Int>) -> Int {
        var maxNumber = list[0]
        for item in list {
            if maxNumber < item {
                maxNumber = item
            }
        }
        return maxNumber
    }
    
    
    /// 获取数字的长度
    ///
    /// - parameter number: 该数字
    ///
    /// - returns: 返回该数字的长度
    func numberLength(number: Int) -> Int {
        return "\(number)".characters.count
    }
    
    
    /// 获取相应位置的数字
    ///
    /// - parameter number: 操作的数字
    /// - parameter digit:  位数
    ///
    /// - returns: 返回该位数上的数字
    func fetchBaseNumber(number: Int, digit: Int) -> Int{
        if digit > 0 && digit <= numberLength(number: number) {
            var numbersArray: Array<Int> = []
            for char in "\(number)".characters {
                numbersArray.append(Int("\(char)")!)
            }
            return numbersArray[numbersArray.count - digit]
        }
        return 0
    }
    
    
    
    /*
     0 - 1 背包问题
     
     */
    
    func zeroOneBagpack() {
        
        
        
    }
    
    /*
     贪心算法
     
     */
    
    func greedy() {
        
    }
    
    /*
      五大经典算法分为
     1、分治法
     2、动态规划算法
     3、贪心算法
     4、回溯法
     5、分支限界法
     */
    /*
     Q: 动态规划算法 https://baijiahao.baidu.com/s?id=1570689459307346&wfr=spider&for=pc
        三要素： 最优子结构  边界 状态转移公式即关系式
        通过最优子结构进行建模：最优子结构和最终问题的关系 即 关系式
     
     What - 分阶段求解决策问题，即把一个复杂的问题分阶段进行简化，逐步简化成简单的问题
     
     */
    func dynamicProgramming() {
        
        
        
        
    }
    
    
    
    
    
    
    
    
}


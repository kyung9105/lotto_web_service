require('open-uri')
require('json')

class HomeController < ApplicationController
    def index
    end
    
    def check_lotto
        get_info = JSON.parse open('http://www.nlotto.co.kr/common.do?method=getLottoNumber&drwNo=').read
        
        hash ={} #전체 lotto 의 값을 저장할 변수
        
        hash_key=[]
        (1..100).each do |x|
            hash_key << x.to_s.to_sym
        end
        
        numbers= (1..45).to_a
        
        (1..100).each do |i|
            hash[i.to_s.to_sym] = numbers.sample(6)
        end
        
        lotto_numbers=[]
        get_info.each do |key, value|
            lotto_numbers << value if key.include? "drwtNo"
        end
        
        lotto_numbers.sort!
        
        bonus_number = get_info["bnusNo"]
        
        final_result = {"1등":0, "2등":0, "3등":0, "4등":0, "5등":0, "꼴등":0 }
        
        hash_key.each do |x|
            my_result = lotto_numbers & hash[x]
            lotto_count = my_result.count
            
            if lotto_count == 6
                result = "1등"
            elsif lotto_count == 5 && my_result.include?(bonus_number)
                result = "2등"
            elsif lotto_count == 4
                result = "3등"
            elsif lotto_count == 3
                result = "4등"
            elsif lotto_count == 2
                result = "5등"
            else
                result = "꼴등"
            end
            
            final_result[result.to_sym] += 1
        end
        
        
        @lotto_numbers1 = lotto_numbers[0]
        @lotto_numbers2 = lotto_numbers[1] 
        @lotto_numbers3 = lotto_numbers[2] 
        @lotto_numbers4 = lotto_numbers[3] 
        @lotto_numbers5 = lotto_numbers[4]
        @lotto_numbers6 = lotto_numbers[5] 
        @bonus_number = bonus_number
        @final_result = final_result
        @hash = hash
    end
end

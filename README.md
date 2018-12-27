## CPBL
The analysis of basic sabermetrics applied in CPBL. (continue)      
用簡單的賽柏計量學來分析中華職棒大聯盟 (待續)       

## 前言 (Foreword)
The basic data visualization of R language applied to analyze the performance of batters and pitchers in CPBL.         
用R語言，針對中華職棒(2018)的野手與投手表現，進行基礎的視覺化分析。     
 
### 原始資料 (Rawdata)     
* [CPBL](http://www.cpbl.com.tw/stats/all.html)     

## 開始 (start) 
### 棒球統計 (Baseball statistics) 
* Batter: 
 * wOBA:
 * WRAA:
 * K%:
 * BB%:
 * BABIP:   
* Pitcher: FIP, K/9    

### 套件 (Packages)  
* dplyr, ggplot2, gridExtra, data.table  

### 範例 (example)  
* K% and BB%     
![image](https://github.com/Guan-Yi/CPBL/blob/master/KB.jpg)    

## 參考資料 (Reference)  
* [FanGraphs](https://www.fangraphs.com/library/)    
* [CPBL](http://www.cpbl.com.tw/stats/all.html)   
* [台灣棒球維基館](http://twbsball.dils.tku.edu.tw/wiki/index.php?title=%E9%A6%96%E9%A0%81)    
* [PTT_Baseball](https://www.ptt.cc/bbs/Baseball/M.1508090433.A.834.html)    

## 心得       
* 分析過程中可能存在人為誤差，故結果僅供參考。   
* 在公式上有一些參數還沒有校估，故目前是先採用MLB的參數(FanGraphs)。                           
* 尚未完成，逐步修訂中  

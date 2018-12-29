## CPBL is wonderful 
The analysis of basic sabermetrics applied in CPBL.     
用簡單的棒球統計學來分析中華職棒大聯盟     
   
## 簡介
針對中華職棒大聯盟(2018)的野手與投手表現，用R語言來計算出棒球統計學中常見的指標，並進行視覺化分析。             
    
## 棒球統計 (Baseball statistics) 
### 打者 (Batter)  
* Weighted On-Base Average (wOBA)
* Weighted Runs Above Average (wRAA)
* Batting Average on Balls In Play (BABIP) = (H - HR) / (AB - SO - HR + SF)
* K% =  K / PA
* BB% = BB / PA
     
### 投手 (Pitcher)
* Fielding Independent Pitching (FIP)
* K/9 = (SO * 9) / IP 
* BB/9 = (SO * 9) / IP
    
## 方法
### 工具
* R 3.4.4   
* RStudio 1.1.442
      
### 套件  
* dplyr  
* ggplot2    
* gridExtra  
* data.table     

### 資料
* 資料來源：CPBL官方網站
* 有效樣本：PA >= 50 或 IP >= 10
     
### 結果
#### 打者部分：
![img](https://github.com/Guan-Yi/CPBL/blob/master/result/woba.jpg)    
![img](https://github.com/Guan-Yi/CPBL/blob/master/result/K%25.jpg)     
![img](https://github.com/Guan-Yi/CPBL/blob/master/result/KBB%25.jpg)     
![img](https://github.com/Guan-Yi/CPBL/blob/master/result/BABIP.jpg)     
![img](https://github.com/Guan-Yi/CPBL/blob/master/result/AOS.jpg)     
![img](https://github.com/Guan-Yi/CPBL/blob/master/result/KBB%25T.jpg)    
    
#### 投手部分：    
![img](https://github.com/Guan-Yi/CPBL/blob/master/result/FIP.jpg)    
![img](https://github.com/Guan-Yi/CPBL/blob/master/result/KBB9.jpg)   
![img](https://github.com/Guan-Yi/CPBL/blob/master/result/KBB9T.jpg)   

#### 跨年度：
![img](https://github.com/Guan-Yi/CPBL/blob/master/result/avg1718.jpg)

## 參考資料 (Reference)  
* [FanGraphs](https://www.fangraphs.com/library/)    
* [CPBL](http://www.cpbl.com.tw/stats/all.html)   
* [台灣棒球維基館](http://twbsball.dils.tku.edu.tw/wiki/index.php?title=%E9%A6%96%E9%A0%81)    
* [PTT_Baseball](https://www.ptt.cc/bbs/Baseball/M.1508090433.A.834.html)    
* [樞紐棒球](https://shunyubaseball.wordpress.com/)

## 備註
* 圖表可以提供一些有趣的資訊，打破觀賞球賽時的刻板印象。
* 分析過程中可能存在人為誤差。   
* 公式參數未進行校估，故計算結果未必符合現況。                           
* 本文尚未完成，逐步修訂中  
* 一切資訊以官方提供為主，本文僅供參考。

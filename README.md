## CPBL
The analysis of basic sabermetrics applied in CPBL.     
用簡單的賽柏計量學來分析中華職棒大聯盟     

## 簡介
用R語言，針對中華職棒(2018)的野手與投手表現，進行基礎的視覺化分析。     
 
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

## 方法
### 工具
* R 3.4.4   
### 套件  
* dplyr  
* ggplot2    
* gridExtra  
* data.table     

### 範例  

      
## 參考資料 (Reference)  
* [FanGraphs](https://www.fangraphs.com/library/)    
* [CPBL](http://www.cpbl.com.tw/stats/all.html)   
* [台灣棒球維基館](http://twbsball.dils.tku.edu.tw/wiki/index.php?title=%E9%A6%96%E9%A0%81)    
* [PTT_Baseball](https://www.ptt.cc/bbs/Baseball/M.1508090433.A.834.html)    

## 心得       
* 分析過程中可能存在人為誤差。   
* 公式參數未進行校估，故計算結果未必符合現況，僅供參考。                           
* 本文尚未完成，逐步修訂中  

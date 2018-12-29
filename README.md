## CPBL is wonderful 
The analysis of basic sabermetrics applied in CPBL.     
用簡單的棒球統計學來分析中華職棒大聯盟     
   
## 簡介
針對中華職棒大聯盟(2018)的野手與投手表現，用R語言來計算出棒球統計學中常見的指標，並進行視覺化分析。             
    
## 棒球統計 (Baseball statistics) 
### 打者 (Batter)  
* On-base percentage Plus Slugging Percentage (OPS) = OBP + SLG
* Weighted On-Base Average (wOBA)   
<div align=center><img width="660" height="51" src='https://github.com/Guan-Yi/CPBL/blob/master/formula/woba_formula.jpg'/></div>  

* Weighted Runs Above Average (wRAA) = ((wOBA - League wOBA) / wOBA Scale) * PA  

* Batting Average on Balls In Play (BABIP)  
<div align=center><img width="209" height="51" src='https://github.com/Guan-Yi/CPBL/blob/master/formula/BABIP_formula.jpg'/></div>  

* K% =  K / PA  
* BB% = BB / PA  
     
### 投手 (Pitcher)
* ERA+ = (League ERA / ERA) * 100
* Fielding Independent Pitching (FIP)  
<div align=center><img width="545" height="51" src='https://github.com/Guan-Yi/CPBL/blob/master/formula/FIP_formula.jpg'/></div>  

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
* 有效樣本：該年度 PA >= 50 或 IP >= 10
     
### 結果
#### 打者部分：
![img](https://github.com/Guan-Yi/CPBL/blob/master/result/woba_rbi.jpg)  
![img](https://github.com/Guan-Yi/CPBL/blob/master/result/wraa_g.jpg)
![img](https://github.com/Guan-Yi/CPBL/blob/master/result/babip_r.jpg)
![img](https://github.com/Guan-Yi/CPBL/blob/master/result/%E5%90%84%E9%9A%8A%E6%89%93%E8%80%85%E4%B8%89%E5%9C%8D%E7%9B%92%E7%8B%80%E5%9C%96.jpg)
![img](https://github.com/Guan-Yi/CPBL/blob/master/result/%E5%90%84%E9%9A%8A%E6%89%93%E8%80%85K%E5%92%8CBB%E7%9B%92%E7%8B%80%E5%9C%96.jpg)

#### 投手部分：    
![img](https://github.com/Guan-Yi/CPBL/blob/master/result/fip_era.jpg)
![img](https://github.com/Guan-Yi/CPBL/blob/master/result/fip_erap.jpg)
![img](https://github.com/Guan-Yi/CPBL/blob/master/result/k9_bb9.jpg)
![img](https://github.com/Guan-Yi/CPBL/blob/master/result/%E5%90%84%E9%9A%8A%E6%8A%95%E6%89%8B%E6%95%B8%E6%93%9A%E7%9B%92%E7%8B%80%E5%9C%96.jpg)

#### 2017 vs. 2018：
![img](https://github.com/Guan-Yi/CPBL/blob/master/result/%E6%89%93%E8%80%85%E4%B8%89%E5%9C%8D_1718%E6%AF%94%E8%BC%83.jpg)

## 參考資料 (Reference)  
* [FanGraphs](https://www.fangraphs.com/library/)    
* [CPBL](http://www.cpbl.com.tw/stats/all.html)   
* [台灣棒球維基館](http://twbsball.dils.tku.edu.tw/wiki/index.php?title=%E9%A6%96%E9%A0%81)    
* [PTT_Baseball](https://www.ptt.cc/bbs/Baseball/M.1508090433.A.834.html)    
* [樞紐棒球](https://shunyubaseball.wordpress.com/)

## 備註
* 圖表可以提供一些有趣的資訊，打破觀賞球賽時的刻板印象。
* 分析過程中可能存在人為誤差。   
* 公式參數未進行詳細校估，故計算結果未必符合現況。                           
* 一切資訊以官方提供為主，本文僅供參考。  

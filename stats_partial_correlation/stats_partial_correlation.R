library(tidyverse)

#データの読み込み
teams=read_csv("teams.csv")
boxscore=read_csv("games_boxscore_202021.csv")

#2020-21シーズンのB1のデータがほしいのでteamsから絞り込む
teams=teams %>% filter(Season=="2020-21") %>% filter(League=="B1")

#teamsをleft_joinしてboxscoreからB1のデータを絞り込む
boxscore=teams %>% left_join(boxscore,by="TeamId")

#選手の平均スタッツを計算する
boxscore=boxscore %>% group_by(Player) %>% summarise_all(mean)

#「バスケのスタッツを眺めるアプリ」で使ったスタッツを抽出(OE,eFG,TS%,PPPは除く)
boxscore=boxscore[,c(1,14,16:34)]
boxscore=boxscore %>% dplyr::select(-BSR,-F,-FD,-DUNK)

#相関係数を可視化する
library(corrplot)
boxscore %>% dplyr::select(-Player) %>% cor(.) %>% corrplot.mixed()

#偏相関係数を可視化する
library(ppcor)

#得点xリバウンドxアシストxターンオーバーの組み合わせを調べる
#出場時間をパーシャルアウトした得点とリバウンドの偏相関係数
boxscore %>% dplyr::select(MIN,PTS,TR) %>% pcor()#0.5536

#出場時間をパーシャルアウトした得点とアシストの偏相関係数
boxscore %>% dplyr::select(MIN,PTS,AS) %>% pcor()#-0.025

#出場時間をパーシャルアウトした得点とターンオーバーの偏相関係数
boxscore %>% dplyr::select(MIN,PTS,TO) %>% pcor()#0.339

#出場時間をパーシャルアウトしたリバウンドとアシストの偏相関係数
boxscore %>% dplyr::select(MIN,TR,AS) %>% pcor()#-0.283

#出場時間をパーシャルアウトしたリバウンドとターンオーバーの偏相関係数
boxscore %>% dplyr::select(MIN,TR,TO) %>% pcor()#0.184

#出場時間をパーシャルアウトしたアシストとターンオーバーの偏相関係数
boxscore %>% dplyr::select(MIN,AS,TO) %>% pcor()#0.554







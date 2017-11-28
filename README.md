# Stock-Simulation

Hey World,

PlayTrade is a stock simulation chart game. This game allows you to reblance your portfolio daily. Stock ticker and time interval are unknown, and your decisions are made only base on the stock chart.
This programe is a practical guide of the book -- Trading in the zone. It can be used to help you debug yourself, do mental training and be more prepared before investing your real money into the stock market.
Matlab version is R2015a.
There is some stock data under the 'stocks' folder. For more historical stock data, you can download from https://www.kaggle.com/borismarjanovic/price-volume-data-for-all-us-stocks-etfs
Stock data must be saved under 'stocks' folder, otherwise you have to make some changes of the codes to run this program.
PlayTrade.m is the main file. Type in 'PlayTrade' in command window to active the interface.
Stock tickers that has been simulated will be saved in includedticker.csv. If you want to simulate this stock for a second time, you need to go to this csv. file and delete this ticker.
Your performance will be saved in performance.csv.
WARNING!!! Don't use excel along with this program!!! 
Since I'm using windows 8, any xlswrite or xlsread will lead to memory leak. 
I write a command 'system('taskkill /F /IM EXCEL.EXE')' to solve this program, but all excel files will be shut down by this command...
For any problems or more information, you can email to krystal.jn.zhang@gmail.com or follow our wechat official platform: Hello_Baby_Unicorn

Love,

Krystal Zhang


宝宝们好，

PlayTrade是一个股票交易模拟的游戏。这个游戏让你可以每天重置你的仓位。股票代码以及时间都是随机产生的，你所有的交易决定都仅仅基于股价走势。
这个程序可以被看做是《股票交易心理战》的一个实际应用版本。它可以帮你找出自己心理上的缺陷，在进入股市前更加有准备。
Matlab版本是R2016a。
stocks文件夹下已经有一些股票数据。更多历史数据可以前往kaggle下载：https://www.kaggle.com/borismarjanovic/price-volume-data-for-all-us-stocks-etfs
数据需要被存在stocks的文件夹内，否则需要修改代码才能运行。
PlayTrade.m是主文件。在指令窗口输入“PlayTrade”来打开界面。
已经被模拟过的股票代码会被存在includedticker.csv文件下面，如果你想要重新模拟，你需要到这个csv.文件下面删除这个代码。
每次模拟的结果都会被保存在performance.csv文件下面。
不要在运行程序的时候使用excel！！！excel文件会被自动关闭！！！
如果有其他问题，可以发送邮件到krystal.jn.zhang@gmail.com，或者关注我们的微信公众号Hello_Baby_Unicorn。

比心，

小K

function stockmat = RandomSelectLocalData

% RandomSelectLocalData randomly select a stock data that not traded previously
%The historical stock data is downloaded from https://www.kaggle.com/borismarjanovic/price-volume-data-for-all-us-stocks-etfs
%
% Created by Krystal Zhang
% Email: krystal.jn.zhang@gmail.com
% Wechat Official Account: Hello_Baby_Unicorn
% Nov. 23. 2017

your_folder = 'C:\workplace\MATLAB\BabyMatlab\Stocks\';
d = dir([your_folder '\*.txt']);
file = {d.name};

% Load file names that already played
[num, txt, raw] = xlsread('C:\workplace\MATLAB\BabyMatlab\LocalPlay\includedticker.csv');
existing_file = {''};
for i = 1: length(raw(:,1))
    existing_file{i} = char(raw(i,1));
end

stockmat = ([]);
ticker = QualifiedStock;
CTresult = CheckTicker(existing_file, file);

% Check if generated stocks belong to qualified stocks
while ismember(CTresult.temp1, ticker) == 0
    CTresult = CheckTicker(existing_file, file);
    if ismember(CTresult.temp1, ticker) == 1
        break
    end
end
target = CTresult.temp1;

% Add new generated stock to stocks that are traded previously
existing_file{length(existing_file) + 1} = char(target);
existing_file = existing_file(1: end)';
xlswrite('C:\workplace\MATLAB\BabyMatlab\LocalPlay\includedticker.csv', existing_file);

filename = char(strcat('C:\workplace\MATLAB\BabyMatlab\Stocks\', CTresult.temp));
data = importdata(filename);

% Choose random trading interval. One year for observation, and one year for trading
len = length(data.data(:, 1));
plug = randi(len);
DataString = data.textdata(2:end, 1);
formatIn = 'yyyy-mm-dd';
newdate = datenum(DataString, formatIn);
if len > 250 * 2
    if plug < len - 250 * 2
        starts = plug;
        ends = starts + 250 * 2;
    else
        ends = len;
        starts = ends - 250 * 2;
    end
else
    starts = 1;
    ends = len;
end

stockmat(1).DateRange = newdate(starts:ends, 1);
stockmat(1).DayHigh = data.data(starts:ends, 2);
stockmat(1).DayLow = data.data(starts:ends, 3);
stockmat(1).DayOpen = data.data(starts:ends, 1);
stockmat(1).DayClose = data.data(starts:ends, 4);
stockmat(1).DayVol = data.data(starts:ends, 5);
stockmat(1).target = target;

system('taskkill /F /IM EXCEL.EXE');


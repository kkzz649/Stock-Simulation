function ticker = QualifiedStock;

% Created by Krystal Zhang
% Email: krystal.jn.zhang@gmail.com
% Wechat Official Account: Hello_Baby_Unicorn
% Nov. 23. 2017

[num, txt, raw]  = xlsread('C:\workplace\MATLAB\BabyMatlab\LocalPlay\stockticker.csv');

%Choose stocks that have market cap over USD1 billion
ticker = {''};
for k = 1: length(raw(:, 2))
    str = raw{k, 2};
    if ('B' == str(end))
         temp1 = lower(raw{k, 1});
         ticker{end +1} = char(double(temp1));
    end
end
ticker = ticker';



% ticker = {''};
% for k = 1: length(raw(:, 2))
%     str = raw(k, 2);
%     str = str{1};
%     if ('B' == str(end))
%         temp1 = raw(k, 1);
%         ticker{end + 1} = temp1;
%     end
% end
% 
% ticker1 = {''};
% for iter1 = 2: length(ticker)
%     ticker_temp = ticker(iter1);
%     ticker_temp_temp = ticker_temp{1};
%     if ticker_temp_temp{1} == 1
%         continue;
%     end
%     ticker1{end+1} = cellfun(@lower, ticker(iter1));
% end
% 
% ticker2 = '';
% for iter2 = 2: length(ticker1)
%     ticker2(iter2) = char(ticker1{iter2});
% end


% your_folder = 'C:\workplace\MATLAB\BabyMatlab\Stocks\';
% d = dir([your_folder '\*.txt']);
% f = {d.name};
% f = f';
% 
% tempA = {''};
% swich1 = 0;
% tempC = '';
% for i = 1: length(f)
%     tempB = f{i};
%     for j = 1: length(tempB)
%         if tempB(j) == '.'
%             switch1 = 1;
%             break;
%         end
%         tempC = strcat(tempC, tempB(j));
%     end
%     tempA{i} = tempC;
%     tempC = '';
%     switch1 = 0;
% end
% tempA = tempA';


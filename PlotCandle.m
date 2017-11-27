function PlotCandle(high, low, open, close, ends)

% Created by Krystal Zhang
% Email: krystal.jn.zhang@gmail.com
% Wechat Official Account: Hello_Baby_Unicorn
% Nov. 23. 2017

middle = 0.5;
hwbody = middle/2;
hwshad = hwbody/10;
xbody = middle+[-hwbody hwbody hwbody -hwbody -hwbody];
xshad = middle+[-hwshad hwshad hwshad -hwshad -hwshad];
days = (1: ends);

colors = close < open;
colors = char(colors * 'r' + (1-colors) * 'g');

for i = 1: ends
    patch(days(i)+xshad,[low(i), low(i), ...
        high(i), high(i), low(i)], 'k');
    patch(days(i)+xbody,[open(i), open(i), ...
        close(i), close(i), open(i)],colors(i));
end

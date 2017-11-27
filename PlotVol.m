function PlotVol(open, close, vol, ends)

% Created by Krystal Zhang
% Email: krystal.jn.zhang@gmail.com
% Wechat Official Account: Hello_Baby_Unicorn
% Nov. 23. 2017

middle = 0.5;
hwbody = middle/2;
xbody = middle+[-hwbody hwbody hwbody -hwbody -hwbody];
days = (1 : ends);

colors = close < open;
colors = char(colors * 'r' + (1-colors) * 'g');

for i = 1 : ends
    patch(days(i) + xbody, [0, 0, vol(i), vol(i), 0], colors(i));
end

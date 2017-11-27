function singleCandle(high, low, open, close, a)

% Created by Krystal Zhang
% Email: krystal.jn.zhang@gmail.com
% Wechat Official Account: Hello_Baby_Unicorn
% Nov. 23. 2017

middle = 0.5;
hwbody = middle/2;
hwshad = hwbody/10;
xbody = middle+[-hwbody hwbody hwbody -hwbody -hwbody];
xshad = middle+[-hwshad hwshad hwshad -hwshad -hwshad];

colors = close < open;
colors = char(colors * 'r' + (1-colors) * 'g');

patch(a+xshad, [low, low, high, high, low], 'k');
patch(a+xbody, [open, open, close, close, open],colors);
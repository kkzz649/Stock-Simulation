function singleVol(open, close, vol, a)

% Created by Krystal Zhang
% Email: krystal.jn.zhang@gmail.com
% Wechat Official Account: Hello_Baby_Unicorn
% Nov. 23. 2017

middle = 0.5;
hwbody = middle/2;
xbody = middle+[-hwbody hwbody hwbody -hwbody -hwbody];

colors = close < open;
colors = char(colors * 'r' + (1-colors) * 'g');

patch(a + xbody, [0, 0, vol, vol, 0], colors);

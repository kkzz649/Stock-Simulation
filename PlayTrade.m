function varargout = PlayTrade(varargin)

% PlayTrade is a stock trading chart game that allows you to play offline. 
% The historical stock data is downloaded from https://www.kaggle.com/borismarjanovic/price-volume-data-for-all-us-stocks-etfs
% The stock data includes one year for observation and one year for playing.
% This game allows you to reblance your portfolio daily. 
% You can choose to buy, sell, short, cover or hold the stock.
% Stock ticker and time interval are unknown, and your decisions are made only base on the stock chart.
%
% Created by Krystal Zhang
% Email: krystal.jn.zhang@gmail.com
% Wechat Official Account: Hello_Baby_Unicorn
% Nov. 23. 2017
%
% PLAYTRADE MATLAB code for PlayTrade.fig
%      PLAYTRADE, by itself, creates a new PLAYTRADE or raises the existing
%      singleton*.
%
%      H = PLAYTRADE returns the handle to a new PLAYTRADE or the handle to
%      the existing singleton*.
%
%      PLAYTRADE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLAYTRADE.M with the given input arguments.
%
%      PLAYTRADE('Property','Value',...) creates a new PLAYTRADE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PlayTrade_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PlayTrade_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PlayTrade

% Last Modified by GUIDE v2.5 26-Nov-2017 18:27:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @PlayTrade_OpeningFcn, ...
    'gui_OutputFcn',  @PlayTrade_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before PlayTrade is made visible.
function PlayTrade_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PlayTrade (see VARARGIN)

% Choose default command line output for PlayTrade
handles.output = hObject;

set(handles.slider1, 'Enable', 'on');
set(handles.uitable1,'ColumnName', ...
    {'L/S' 'Enter Price' 'Exit Price' 'Shares' 'P/L ($)' 'P/L(%)'})

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PlayTrade wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PlayTrade_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbuttonPlotGarph.
function pushbuttonPlotGarph_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPlotGarph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Period;
global High;
global Low;
global Open;
global Close;
global Vol;
global ticker;

global Cash;
% global BP;
global PLd;
global initial;

global rows;
global Buy;
global Short;

filename = 'C:\workplace\MATLAB\BabyMatlab\LocalPlay\DayTrading\balance.csv';
[initial] = xlsread(filename);
system('taskkill /F /IM EXCEL.EXE');
rows = 0;
PLd = 0;
Cash = initial(1,1);
% BP = initial(1,2);
Buy = 1;
Short = 1;
set(handles.uitable1,'data', cell(size(get(handles.uitable1,'data'))));
set(handles.editCash, 'String', sprintf('$%.2f', Cash));
% set(handles.editBP, 'String', sprintf('$%.2f', BP));
set(handles.editPLp, 'String', sprintf('%.2f%%', 0));
set(handles.editPLd, 'String', sprintf('$%.2f', 0));
set(handles.editShare, 'String', 'N/A');
set(handles.editCB, 'String', 'N/A');
set(handles.editMP, 'String', 'N/A');
set(handles.editPL, 'String', 'N/A');
set(handles.editPL, 'ForegroundColor', 'k');
set(handles.editPLd, 'ForegroundColor', 'k');
set(handles.editPLp, 'ForegroundColor', 'k');

stockmat = RandomSelectLocalData;

Period = stockmat.DateRange;
High = stockmat.DayHigh;
Low = stockmat.DayLow;
Open = stockmat.DayOpen;
Close = stockmat.DayClose;
Vol = stockmat.DayVol;

ticker = stockmat.target;

Ends = round(size(Period, 1)/2);

set(handles.slider1, 'max', size(Period, 1));
set(handles.slider1, 'min', 120);

global count;
global colors;
global xlim_max;
count = Ends;
colors = 'b';
xlim_max = count + 5;
set(handles.slider1, 'Value', count);

cla(handles.axes1, 'reset');
axes(handles.axes1);
PlotCandle(High, Low, Open, Close, Ends);
xlim(handles.axes1, [count - 120, xlim_max]);

cla(handles.axes2, 'reset');
axes(handles.axes2);
PlotVol(Open, Close, Vol, Ends);
xlim(handles.axes2, [count - 120, xlim_max]);

set(handles.pushbuttonNB, 'Enable', 'on');
set(handles.pushbuttonBuy, 'Enable', 'on');
set(handles.pushbuttonSell, 'Enable', 'off');
set(handles.pushbuttonShort, 'Enable', 'on');
set(handles.pushbuttonCover, 'Enable', 'off');

% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in pushbuttonNB.
function pushbuttonNB_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonNB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Period;
global High;
global Low;
global Open;
global Close;
global Vol;
global count;
global ticker;

global greenline;
global redline;
global x;
global y;
global colors;
global xlim_max;

global Cash;
global Shares;
% global BP;
global PLd;
global initial;
global BuyPrice;
global ShortPrice;
global Buy;
global Short;

count = count + 1;
set(handles.slider1, 'Value', count);

if colors == 'g'
    PL = (Close(count) - BuyPrice) / BuyPrice * 100;
end
if colors == 'r'
    PL = (ShortPrice - Close(count)) / ShortPrice * 100;
end
if colors == 'g' || colors == 'r'
    if PL > 0
        set(handles.editPL, 'ForegroundColor', 'green');
    else
        set(handles.editPL, 'ForegroundColor', 'red');
    end
    set(handles.editMP, 'String', sprintf('$%.2f', Close(count)));
    set(handles.editPL, 'String', sprintf('%.2f%%', PL));
end

axes(handles.axes1);
singleCandle(High(count), Low(count), Open(count), Close(count), count);

if colors == 'g' || colors == 'r'
    hold on;
    NBx = [x(1, 1), count + 0.5];
    NBy = [y(1, 1), Close(count)];
    if colors == 'g'
        delete(greenline);
        greenline = plot(NBx, NBy, 'g');
    else
        delete(redline);
        redline = plot(NBx, NBy, 'r');
    end
    axes(handles.axes2);
    singleVol(Open(count), Close(count), Vol(count), count);
else
    axes(handles.axes2);
    singleVol(Open(count), Close(count), Vol(count), count);
end

xlim_max = count + 5;
xlim(handles.axes1, [count - 120, xlim_max]);
xlim(handles.axes2, [count - 120, xlim_max]);

if count == size(Period, 1)
%     if count == round(size(Period, 1)/2) + 15
    
    set(handles.pushbuttonNB, 'Enable', 'off');
    set(handles.pushbuttonBuy, 'Enable', 'off');
    set(handles.pushbuttonSell, 'Enable', 'off');
    set(handles.pushbuttonShort, 'Enable', 'off');
    set(handles.pushbuttonCover, 'Enable', 'off');
    
    xlim(handles.axes1, [round(size(Period, 1)/2) + 1, size(Period, 1)]);
    xlim(handles.axes2, [round(size(Period, 1)/2) + 1, size(Period, 1)]);
    
    if Buy == 0
        Gain_Loss = (Close(count) - BuyPrice) * Shares;
        Cash = Cash + Close(count) * Shares;
        %         BP = BP + Close(count) * Shares;
        set(handles.editCash, 'String', sprintf('$%.2f', Cash));
        %         set(handles.editBP, 'String', sprintf('$%.2f', BP));
    end
    
    if Short == 0
        Gain_Loss = (ShortPrice - Close(count)) * Shares;
        %         BP = BP + ShortPrice * Shares + Gain_Loss;
        Cash = Cash - Close(count) * Shares;
        set(handles.editCash, 'String', sprintf('$%.2f', Cash));
        %         set(handles.editBP, 'String', sprintf('$%.2f', BP));
    end
    
    if Buy == 0 || Short == 0
        PLd = PLd + Gain_Loss;
        PLp = (PLd / initial(1,1)) * 100;
        set(handles.editPLp, 'String', sprintf('%.2f%%', PLp));
        set(handles.editPLd, 'String', sprintf('$%.2f', PLd));
        if PLd > 0
            set(handles.editPLp, 'ForegroundColor', 'green');
            set(handles.editPLd, 'ForegroundColor', 'green');
        else
            set(handles.editPLp, 'ForegroundColor', 'red');
            set(handles.editPLd, 'ForegroundColor', 'red');
        end
    end
    
    pathname = 'C:\workplace\MATLAB\BabyMatlab\LocalPlay\DayTrading\';
    date = datestr(Period(1,1), 'yymmdd');
    saveDataName = char(strcat(pathname, ticker, date));
    saveas(handles.axes1, saveDataName, 'bmp');
    saveas(handles.axes1, saveDataName, 'fig');
    
    filename = 'C:\workplace\MATLAB\BabyMatlab\LocalPlay\DayTrading\balance.csv';
    balance = {get(handles.editCash, 'String'), get(handles.editBP, 'String')};
    xlswrite(filename, balance);
    
    GL = get(handles.editPLp, 'String');
    perform(GL);
    
    system('taskkill /F /IM EXCEL.EXE');    
    msgbox('TRADING GAME ENDS!! HAPPY!!');
    return;
end



% --- Executes on button press in pushbuttonBuy.
function pushbuttonBuy_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonBuy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global ticker;
global Period;
global High;
global Low;
global Open;
global Close;
global Vol;
global xlim_max;
global count;

global Cash;
global BuyPrice;
global Shares;
global Buy;

count = count + 1;
Buy = 0;

if count == size(Period, 1)
%     if count == round(size(Period, 1)/2) + 15
    
    set(handles.pushbuttonNB, 'Enable', 'off');
    set(handles.pushbuttonBuy, 'Enable', 'off');
    set(handles.pushbuttonSell, 'Enable', 'off');
    set(handles.pushbuttonShort, 'Enable', 'off');
    set(handles.pushbuttonCover, 'Enable', 'off');
    
    xlim(handles.axes1, [round(size(Period, 1)/2) + 1, size(Period, 1)]);
    xlim(handles.axes2, [round(size(Period, 1)/2) + 1, size(Period, 1)]);
    
    pathname = 'C:\workplace\MATLAB\BabyMatlab\LocalPlay\DayTrading\';
    date = datestr(Period(1,1), 'yymmdd');
    saveDataName = char(strcat(pathname, ticker, date));
    saveas(handles.axes1, saveDataName, 'bmp');
    saveas(handles.axes1, saveDataName, 'fig');
    
    filename = 'C:\workplace\MATLAB\BabyMatlab\LocalPlay\DayTrading\balance.csv';
    balance = {get(handles.editCash, 'String'), get(handles.editBP, 'String')};
    xlswrite(filename, balance);
    
    GL = get(handles.editPLp, 'String');
    perform(GL);
    
    system('taskkill /F /IM EXCEL.EXE');
    msgbox('TRADING GAME ENDS!! HAPPY!!');
    return;
end

set(handles.slider1, 'Value', count);

BuyPrice = Close(count - 1);
set(handles.editCB, 'String', sprintf('$%.2f', BuyPrice));

Shares = floor(Cash / BuyPrice);
set(handles.editShare, 'String', Shares);

set(handles.editMP, 'String', sprintf('$%.2f', Close(count)));

PL = (Close(count) - BuyPrice) / BuyPrice * 100;
set(handles.editPL, 'String', sprintf('%.2f%%', PL));
if PL > 0
    set(handles.editPL, 'ForegroundColor', 'green');
else
    set(handles.editPL, 'ForegroundColor', 'red');
end

Cash = Cash - Shares * BuyPrice;
set(handles.editCash, 'String', sprintf('$%.2f', Cash));
% set(handles.editBP, 'String', sprintf('$%.2f', BP));

axes(handles.axes1);
singleCandle(High(count), Low(count), Open(count), Close(count), count);
hold on;

text(count - 1, High(count - 1),...
    '$\textcircled{L}$', 'Interpreter', 'latex', ...
    'Color', 'g', 'FontSize', 14, 'FontWeight', 'bold');

global greenline;
global x;
global y;
global colors;
colors = 'g';
x = [count - 1 + 0.5, count + 0.5];
y = [Close(count - 1), Close(count)];
greenline = plot(x, y, 'g');

axes(handles.axes2);
singleVol(Open(count), Close(count), Vol(count), count);

xlim_max = count +5;
xlim(handles.axes1, [count - 120, xlim_max]);
xlim(handles.axes2, [count - 120, xlim_max]);

set(handles.pushbuttonBuy, 'Enable', 'off');
set(handles.pushbuttonSell, 'Enable', 'on');
set(handles.pushbuttonShort, 'Enable', 'off');
set(handles.pushbuttonCover, 'Enable', 'off');


% --- Executes on button press in pushbuttonSell.
function pushbuttonSell_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global ticker;
global Period;
global High;
global Low;
global Open;
global Close;
global Vol;
global count;
global colors;
global xlim_max;

global Cash;
% global BP;
global BuyPrice;
global Shares;
global PLd;
global initial;

global rows;
global Buy;

Buy = 1;
colors = 'b';
count = count + 1;
set(handles.slider1, 'Value', count);

set(handles.editShare, 'String', 'N/A');
set(handles.editCB, 'String', 'N/A');
set(handles.editMP, 'String', 'N/A');
set(handles.editPL, 'String', 'N/A');
set(handles.editPL, 'ForegroundColor', 'k');

Gain_Loss = (Close(count - 1) - BuyPrice) * Shares;
Cash = Cash + Close(count -1) * Shares;
% BP = BP + Close(count -1) * Shares;
set(handles.editCash, 'String', sprintf('$%.2f', Cash));
% set(handles.editBP, 'String', sprintf('$%.2f', BP));

PLd = PLd + Gain_Loss;
PLp = (PLd / initial(1,1)) * 100;
set(handles.editPLp, 'String', sprintf('%.2f%%', PLp));
set(handles.editPLd, 'String', sprintf('$%.2f', PLd));
if PLd > 0
    set(handles.editPLp, 'ForegroundColor', 'green');
    set(handles.editPLd, 'ForegroundColor', 'green');
else
    set(handles.editPLp, 'ForegroundColor', 'red');
    set(handles.editPLd, 'ForegroundColor', 'red');
end

rows = rows + 1;
data = get(handles.uitable1, 'Data');
PL = (Close(count - 1) - BuyPrice) / BuyPrice * 100;
data(rows, 1:6) = {'L', sprintf('$%.2f', BuyPrice), ...
    sprintf('$%.2f', Close(count - 1)), Shares,  ...
    sprintf('$%.2f', Gain_Loss), sprintf('%.2f%%', PL)};
% performance(rows) = [PLd / initial(1,1)];
set(handles.uitable1,'Data', data);

axes(handles.axes1);
singleCandle(High(count), Low(count), Open(count), Close(count), count);
hold on;
text(count - 1, High(count-1),...
    '$\textcircled{X}$', 'Interpreter', 'latex', ...
    'Color', 'g', 'FontSize', 14, 'FontWeight', 'bold');

axes(handles.axes2);
singleVol(Open(count), Close(count), Vol(count), count);

xlim_max = count +5;
xlim(handles.axes1, [count - 120, xlim_max]);
xlim(handles.axes2, [count - 120, xlim_max]);

if count == size(Period, 1)
%     if count == round(size(Period, 1)/2) + 15
    
    set(handles.pushbuttonNB, 'Enable', 'off');
    set(handles.pushbuttonBuy, 'Enable', 'off');
    set(handles.pushbuttonSell, 'Enable', 'off');
    set(handles.pushbuttonShort, 'Enable', 'off');
    set(handles.pushbuttonCover, 'Enable', 'off');
    
    xlim(handles.axes1, [round(size(Period, 1)/2) + 1, size(Period, 1)]);
    xlim(handles.axes2, [round(size(Period, 1)/2) + 1, size(Period, 1)]);
    
    pathname = 'C:\workplace\MATLAB\BabyMatlab\LocalPlay\DayTrading\';
    date = datestr(Period(1,1), 'yymmdd');
    saveDataName = char(strcat(pathname, ticker, date));
    saveas(handles.axes1, saveDataName, 'bmp');
    saveas(handles.axes1, saveDataName, 'fig');
    
    filename = 'C:\workplace\MATLAB\BabyMatlab\LocalPlay\DayTrading\balance.csv';
    balance = {get(handles.editCash, 'String'), get(handles.editBP, 'String')};
    xlswrite(filename, balance);
    
    GL = get(handles.editPLp, 'String');
    perform(GL);
    
    system('taskkill /F /IM EXCEL.EXE');
    msgbox('TRADING GAME ENDS!! HAPPY!!');
    return;
end

set(handles.pushbuttonBuy, 'Enable', 'on');
set(handles.pushbuttonSell, 'Enable', 'off');
set(handles.pushbuttonShort, 'Enable', 'on');
set(handles.pushbuttonCover, 'Enable', 'off');



% --- Executes on button press in pushbuttonShort.
function pushbuttonShort_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonShort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global ticker;
global Period;
global High;
global Low;
global Open;
global Close;
global Vol;
global count;
global xlim_max;

% global BP;
global ShortPrice;
global Shares;
global Cash;
global Short;

count = count + 1;
set(handles.slider1, 'Value', count);
Short = 0;

if count == size(Period, 1)
%     if count == round(size(Period, 1)/2) + 15
    
    set(handles.pushbuttonNB, 'Enable', 'off');
    set(handles.pushbuttonBuy, 'Enable', 'off');
    set(handles.pushbuttonSell, 'Enable', 'off');
    set(handles.pushbuttonShort, 'Enable', 'off');
    set(handles.pushbuttonCover, 'Enable', 'off');
    
    xlim(handles.axes1, [round(size(Period, 1)/2) + 1, size(Period, 1)]);
    xlim(handles.axes2, [round(size(Period, 1)/2) + 1, size(Period, 1)]);
    
    pathname = 'C:\workplace\MATLAB\BabyMatlab\LocalPlay\DayTrading\';
    date = datestr(Period(1,1), 'yymmdd');
    saveDataName = char(strcat(pathname, ticker, date));
    saveas(handles.axes1, saveDataName, 'bmp');
    saveas(handles.axes1, saveDataName, 'fig');
    
    filename = 'C:\workplace\MATLAB\BabyMatlab\LocalPlay\DayTrading\balance.csv';
    balance = {get(handles.editCash, 'String'), get(handles.editBP, 'String')};
    xlswrite(filename, balance);
    
    GL = get(handles.editPLp, 'String');
    perform(GL);
    
    system('taskkill /F /IM EXCEL.EXE');
    msgbox('TRADING GAME ENDS!! HAPPY!!');
    return;
end

ShortPrice = Close(count - 1);
set(handles.editCB, 'String', sprintf('$%.2f', ShortPrice));

Shares = floor(Cash / ShortPrice);
set(handles.editShare, 'String', Shares);

set(handles.editMP, 'String', sprintf('$%.2f', Close(count)));

PL = (ShortPrice - Close(count)) / ShortPrice * 100;
set(handles.editPL, 'String', sprintf('%.2f%%', PL));
if PL > 0
    set(handles.editPL, 'ForegroundColor', 'green');
else
    set(handles.editPL, 'ForegroundColor', 'red');
end

% BP = BP - Shares * ShortPrice;
% set(handles.editBP, 'String', sprintf('$%.2f', BP));

Cash = Cash + Shares * ShortPrice;
set(handles.editCash, 'String', sprintf('$%.2f', Cash));

axes(handles.axes1);
singleCandle(High(count), Low(count), Open(count), Close(count), count);
hold on;

text(count - 1, High(count - 1),...
    '$\textcircled{S}$', 'Interpreter', 'latex', ...
    'Color', 'r', 'FontSize', 14, 'FontWeight', 'bold');

global redline;
global x;
global y;
global colors;

colors = 'r';
x = [count - 1 + 0.5, count + 0.5];
y = [Close(count - 1), Close(count)];
redline = plot(x, y, 'r');

axes(handles.axes2);
singleVol(Open(count), Close(count), Vol(count), count);

xlim_max = count +5;
xlim(handles.axes1, [count - 120, xlim_max]);
xlim(handles.axes2, [count - 120, xlim_max]);

set(handles.pushbuttonBuy, 'Enable', 'off');
set(handles.pushbuttonSell, 'Enable', 'off');
set(handles.pushbuttonShort, 'Enable', 'off');
set(handles.pushbuttonCover, 'Enable', 'on');


% --- Executes on button press in pushbuttonCover.
function pushbuttonCover_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonCover (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global ticker;
global Period;
global High;
global Low;
global Open;
global Close;
global Vol;
global count;
global colors;
global xlim_max;

global Cash;
% global BP;
global ShortPrice;
global Shares;
global PLd;
global initial;

global rows;
% global performance;
global Short;

Short = 1;
colors = 'b';
count = count + 1;
set(handles.slider1, 'Value', count);

set(handles.editShare, 'String', 'N/A');
set(handles.editCB, 'String', 'N/A');
set(handles.editMP, 'String', 'N/A');
set(handles.editPL, 'String', 'N/A');
set(handles.editPL, 'ForegroundColor', 'k');

Gain_Loss = (ShortPrice - Close(count - 1)) * Shares;
% BP = BP + ShortPrice * Shares + Gain_Loss;
Cash = Cash - Close(count - 1) * Shares;
set(handles.editCash, 'String', sprintf('$%.2f', Cash));
% set(handles.editBP, 'String', sprintf('$%.2f', BP));

PLd = PLd + Gain_Loss;
PLp = (PLd / initial(1,1)) * 100;
set(handles.editPLp, 'String', sprintf('%.2f%%', PLp));
set(handles.editPLd, 'String', sprintf('$%.2f', PLd));
if PLd > 0
    set(handles.editPLp, 'ForegroundColor', 'green');
    set(handles.editPLd, 'ForegroundColor', 'green');
else
    set(handles.editPLp, 'ForegroundColor', 'red');
    set(handles.editPLd, 'ForegroundColor', 'red');
end

rows = rows + 1;
data = get(handles.uitable1, 'Data');
PL = (ShortPrice - Close(count - 1)) / ShortPrice * 100;
data(rows, 1:6) = {'S', sprintf('$%.2f', ShortPrice), ...
    sprintf('$%.2f', Close(count - 1)), Shares, ...
    sprintf('$%.2f', Gain_Loss), sprintf('%.2f%%', PL)};
% performance(rows) = [PLd / initial(1,1)];
set(handles.uitable1,'Data', data);

axes(handles.axes1);
singleCandle(High(count), Low(count), Open(count), Close(count), count);
hold on;
text(count - 1, High(count - 1),...
    '$\textcircled{X}$', 'Interpreter', 'latex', ...
    'Color', 'r', 'FontSize', 14, 'FontWeight', 'bold');

axes(handles.axes2);
singleVol(Open(count), Close(count), Vol(count), count);

xlim_max = count +5;
xlim(handles.axes1, [count - 120, xlim_max]);
xlim(handles.axes2, [count - 120, xlim_max]);

if count == size(Period, 1)
%     if count == round(size(Period, 1)/2) + 15
    
    set(handles.pushbuttonNB, 'Enable', 'off');
    set(handles.pushbuttonBuy, 'Enable', 'off');
    set(handles.pushbuttonSell, 'Enable', 'off');
    set(handles.pushbuttonShort, 'Enable', 'off');
    set(handles.pushbuttonCover, 'Enable', 'off');
    
    xlim(handles.axes1, [round(size(Period, 1)/2) + 1, size(Period, 1)]);
    xlim(handles.axes2, [round(size(Period, 1)/2) + 1, size(Period, 1)]);
    
    pathname = 'C:\workplace\MATLAB\BabyMatlab\LocalPlay\DayTrading\';
    date = datestr(Period(1,1), 'yymmdd');
    saveDataName = char(strcat(pathname, ticker, date));
    saveas(handles.axes1, saveDataName, 'bmp');
    saveas(handles.axes1, saveDataName, 'fig');
    
    filename = 'C:\workplace\MATLAB\BabyMatlab\LocalPlay\DayTrading\balance.csv';
    balance = {get(handles.editCash, 'String'), get(handles.editBP, 'String')};
    xlswrite(filename, balance);
    
    GL = get(handles.editPLp, 'String');
    perform(GL);
    
    system('taskkill /F /IM EXCEL.EXE');
    msgbox('TRADING GAME ENDS!! HAPPY!!');
    return;
end

set(handles.pushbuttonBuy, 'Enable', 'on');
set(handles.pushbuttonSell, 'Enable', 'off');
set(handles.pushbuttonShort, 'Enable', 'on');
set(handles.pushbuttonCover, 'Enable', 'off');



% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% global Period;
global xlim_max;

slidervalue = get(handles.slider1, 'Value' );

xlim_min = 1;

xlimL = floor(slidervalue) - 120;
if xlimL < xlim_min
    xlimL = xlim_min;
end

xlim(handles.axes1, [xlimL, xlim_max]);
xlim(handles.axes2, [xlimL, xlim_max]);

% Update handles structure
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function editPL_Callback(hObject, eventdata, handles)
% hObject    handle to editPL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editPL as text
%        str2double(get(hObject,'String')) returns contents of editPL as a double


% --- Executes during object creation, after setting all properties.
function editPL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editPL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editMP_Callback(hObject, eventdata, handles)
% hObject    handle to editMP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMP as text
%        str2double(get(hObject,'String')) returns contents of editMP as a double


% --- Executes during object creation, after setting all properties.
function editMP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editCash_Callback(hObject, eventdata, handles)
% hObject    handle to editCash (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editCash as text
%        str2double(get(hObject,'String')) returns contents of editCash as a double

Cash = set(handles.editCash, 'Value', 100000);
set(handles.editCash,'String',sprintf('%.2f', Cash))


% --- Executes during object creation, after setting all properties.
function editCash_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editCash (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editBP_Callback(hObject, eventdata, handles)
% hObject    handle to editBP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editBP as text
%        str2double(get(hObject,'String')) returns contents of editBP as a double


% --- Executes during object creation, after setting all properties.
function editBP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editPLd_Callback(hObject, eventdata, handles)
% hObject    handle to editPLd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editPLd as text
%        str2double(get(hObject,'String')) returns contents of editPLd as a double


% --- Executes during object creation, after setting all properties.
function editPLd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editPLd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editPLp_Callback(hObject, eventdata, handles)
% hObject    handle to editPLp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editPLp as text
%        str2double(get(hObject,'String')) returns contents of editPLp as a double


% --- Executes during object creation, after setting all properties.
function editPLp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editPLp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editCB_Callback(hObject, eventdata, handles)
% hObject    handle to editCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editCB as text
%        str2double(get(hObject,'String')) returns contents of editCB as a double


% --- Executes during object creation, after setting all properties.
function editCB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editShare_Callback(hObject, eventdata, handles)
% hObject    handle to editShare (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editShare as text
%        str2double(get(hObject,'String')) returns contents of editShare as a double


% --- Executes during object creation, after setting all properties.
function editShare_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editShare (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

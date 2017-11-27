function perform(GL)

% peform(GL) records your performance of each chart
%
% Created by Krystal Zhang
% Email: krystal.jn.zhang@gmail.com
% Wechat Official Account: Hello_Baby_Unicorn
% Nov. 23. 2017

 filename = 'C:\workplace\MATLAB\BabyMatlab\LocalPlay\performance.csv';
[num, txt, raw] = xlsread(filename);
performance = {''};

% Load performance and check if it read includes 'NaN'
    % if yes, replace 'NaN' with blank cell
for k = 1 : length(raw(1,:))
    performance{1, k} = char(raw(1,k));
    for i = 2: length(raw(:,1))
        if isnan(raw{i, k}) == 1
            performance{i, k} = [];
        else
            performance{i, k} = num2str(raw{i,k});
        end
    end
end

% Add new traded stock performance to the csv. file
datenow = datestr(today, 'mm/dd/yyyy');
width = length(raw(1, :));
if today == datenum(performance{1, width})
    for i = 1: length(performance(:, width))
        if isempty(performance{i, width}) == 1
            performance{i, width} = GL;
            break;
        end
    end
else
    performance{1, width + 1} =datenow;
    performance{2, width + 1} = GL;
end

xlswrite(filename, performance);
system('taskkill /F /IM EXCEL.EXE');







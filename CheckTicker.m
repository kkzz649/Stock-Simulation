function CTresult = CheckTicker(existing_file, file)

% Created by Krystal Zhang
% Email: krystal.jn.zhang@gmail.com
% Wechat Official Account: Hello_Baby_Unicorn
% Nov. 23. 2017

CTresult = struct([]);

% Check if new filename that generated randomly belongs to previous traded stocks
temp = file{randi(numel(file))};
while ismember(temp, existing_file) == 1
    temp = file{randi(numel(file))};
    if ismember(temp, existing_file) == 0
        break
    end
end

% Extract ticker from filename
temp1 = '';
for i = 1: length(temp)
    if temp(i) == '.'
        break;
    end
    temp1 = strcat(temp1, temp(i));
end

CTresult(1).temp = temp;
CTresult(1).temp1 = temp1;
function y = weight(x,flag)
if strcmp(flag, 'row')
    for i = 1:size(x, 1)
        y(i) = sum(x(i,:)== ones(1, size(x,2)));
    end
end
if strcmp(flag,'column')
    for j = 1:size(x, 2)
        y(j) = sum(x(:,j)== ones( size(x,1),1));
    end
end
end
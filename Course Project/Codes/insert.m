% insert one bit to postition after insertion
% pos in [1: len(x) +1]
function y = insert(x, bit, pos)
       len = length(x);
       if pos == 1
           y(1) = bit;
           y(2: len +1) = x(1:len);
       end
       if pos == len +1
           y(1:len) = x(1:len);
           y(len + 1) = bit;
       end
       if pos >1 && pos < len + 1
           for i =1: pos -1
               y(i) = x(i);
           end
           y(pos) = bit;
           for i = pos +1: len + 1
               y(i) = x(i-1);
           end
       end
end
               
       
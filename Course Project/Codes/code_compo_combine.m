% combine the u,p_0,p_1 into a codeword for rate = 0.5 (punctured) Turbo code
function y = code_compo_combine(u,p_0,p_1)
y=[];
len = length(u);
for i =1:len
    y(2*i-1) = u(i);
    if mod(i,2) ==1
        y(2*i) = p_0(i);
    else if mod(i,2) == 0
            y(2*i) = p_1(i);
        end
    end
end
end
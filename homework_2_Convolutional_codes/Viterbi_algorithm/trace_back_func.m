% trace back decoding
function [prev_state,decoded_bit]=trace_back_func(curr_state,Prev_PPM_vec,Prev_BM_vec)
% Prev_PPM_vec-- partial path metric vector for the previous section
%,Prev_BM_vec-- branch metric vector for the previous branches
    if(curr_state==1) % state S0   input==0
        if Prev_PPM_vec(1)+Prev_BM_vec(1) >= Prev_PPM_vec(5)+Prev_BM_vec(9)
            prev_state=1;
            decoded_bit=0;
        else
            prev_state=5;
            decoded_bit=0;
        end
    end
    
     if(curr_state==2) % state S1  input==1   2*j
        if Prev_PPM_vec(1)+Prev_BM_vec(2) >= Prev_PPM_vec(5)+Prev_BM_vec(10)
            prev_state=1;
            decoded_bit=1;
        else
            prev_state=5;
            decoded_bit=1;
        end
     end
     
      if(curr_state==3) % state S2 input==0    2*j-1
        if Prev_PPM_vec(2)+Prev_BM_vec(3) >= Prev_PPM_vec(6)+Prev_BM_vec(11)
            prev_state=2;
            decoded_bit=0;
        else
            prev_state=6;
            decoded_bit=0;
        end
      end
      
     if(curr_state==4) % state S3 input==1
        if Prev_PPM_vec(2)+Prev_BM_vec(4) >= Prev_PPM_vec(6)+Prev_BM_vec(12)
            prev_state=2;
            decoded_bit=1;
        else
            prev_state=6;
            decoded_bit=1;
        end
     end
    
      if(curr_state==5) % state S4 ipt==0
        if Prev_PPM_vec(3)+Prev_BM_vec(5) >= Prev_PPM_vec(7)+Prev_BM_vec(13)
            prev_state=3;
            decoded_bit=0;
        else
            prev_state=7;
            decoded_bit=0;
        end
      end
    
       if(curr_state==6) % state S5 ipt==1
        if Prev_PPM_vec(3)+Prev_BM_vec(6) >= Prev_PPM_vec(7)+Prev_BM_vec(14)
            prev_state=3;
            decoded_bit=1;
        else
            prev_state=7;
            decoded_bit=1;
        end
       end
     if(curr_state==7) % state S6 ipt==0
        if Prev_PPM_vec(4)+Prev_BM_vec(7) >= Prev_PPM_vec(8)+Prev_BM_vec(15)
            prev_state=4;
            decoded_bit=0;
        else
            prev_state=8;
            decoded_bit=0;
        end
     end
     if(curr_state==8) % state S7 ipt==1
        if Prev_PPM_vec(4)+Prev_BM_vec(8) >= Prev_PPM_vec(8)+Prev_BM_vec(16)
            prev_state=4;
            decoded_bit=1;
        else
            prev_state=8;
            decoded_bit=1;
        end
     end      
end % func
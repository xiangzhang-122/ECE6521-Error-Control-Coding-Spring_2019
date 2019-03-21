%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% General Log-MAP BCJR Decoding Algorithm %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This version works only for arbitray number of shift registers(m)

function [alpha, beta, LLR, dec_seq] = mogen_log_map_bcjr( recv_signal, trellis, SNR, ap_llr, term_flag )
% this function deals with arbitrary # of shift registers
% SNR:= E_s/N_0 = rate * E_b/N_0 bir snr, not symbol snr
% term_flag ='term'/'non_term'indicates whether the code is terminated or
% not
format long;
N=length(recv_signal); % received signal
m = log2(trellis.numStates) ;
n=log2(trellis.numOutputSymbols);% n=2 
kk=log2(trellis.numInputSymbols);   %kk =1
R=kk/n;  % rate 
LLR=zeros(1,N*R);   
L_a = ap_llr;  % zeros(1, N*R)
L_c = 4*SNR;    % channle relialibily L_c = 4*E_s/N_0
%-------------------- branch metric: gamma---------------------------------
% k=1:m --beginning stage
% k = N*R -m +1:N*R-- ending stage
gamma = zeros(N*R,trellis.numStates,trellis.numStates); 
    for k=1:N*R         
        for s_cur =1:trellis.numStates
            for s_next=1:trellis.numStates
            [flag,input]=ismember(s_next - 1,trellis.nextStates(s_cur,:));   %current state = s-1 (s-th state), 'in' is input, State vlaues starts from zero 
            % input = 1(-1) or 2(+1) 
            if flag==1      
                gamma(k, s_next, s_cur) = (2*input-3)* L_a(k)/2 + (L_c/2)* dot(recv_signal(n*k-n+1:n*k), 2*de2bi(oct2dec(trellis.outputs(s_cur,input)),n,'left-msb')-1); 
            end   
            end
        end  % end current state s 
    end  % end for k
 % gamma values are also assigned to links that do not present in the first and last section.
 % be careful when updating alpha and beta
  
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% terminated code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 if strcmp(term_flag, 'term')
    %------------------------------- alpha update (log domain)------------------------------
    alpha = zeros(N*R+1,trellis.numStates); 
    indi = zeros(m+1, trellis.numStates); 
    indi(m+1,:)= 1: trellis.numStates;
    % m-by-2^m ,represents the presented ststes in the first m+1 states array
    % elements of indi represent the index of state instead of state value
    % itself, state_index = state_value +1 
    %  case 1: only 2 states
    if m ==1
        for i =1:2   % initial for k =2
            alpha(2, trellis.nextStates(1,i) + 1) = gamma(1, trellis.nextStates(1,i) + 1 , 1 ) ;
        end
    end
    %case 2:  more than 2 states, initial indi
    if m >=2
        indi(1,1) =1;
        for k =1:m-1
            for i= 1: 2^(k-1)
                indi(k+1, 2*i-1) = trellis.nextStates(indi(k,i),1) +1;% input =-1
                indi(k+1, 2*i) = trellis.nextStates(indi(k,i),2)+1;% input =1            
            end
        end
%       indi
        for k =2:m+1
            for ii = 1: 2^(k-1)   % anchor state, alpha(k,)
                gg=[];
                for jj= 1:2^(k-2)   % left state   alpha(k-1,)
                    [flag, ~] = ismember(indi(k,ii)-1, trellis.nextStates(indi(k-1,jj),:));
                    if flag ==1
                        gg =[gg, gamma(k-1, indi(k, ii), indi(k-1, jj)) + alpha(k-1,indi(k-1,jj))];
                    end
                end
                alpha(k, indi(k, ii)) = max_star(gg);
            end
        end  % end for
    end   % end if m >= 2
    % alpha starting stage
    for k= m+2:N*R+1      % k=m+2:N*R +1
            for s_cur = 1:trellis.numStates  % current state
                gg=[]; % to store (2) incoming branches of alpha
                for s_pre = 1:trellis.numStates   % previous state
                    [flag, ~] = ismember(s_cur-1, trellis.nextStates(s_pre,:));
                    if flag == 1
                        gg =[gg, gamma(k-1, s_cur, s_pre) + alpha(k-1,s_pre)];
                    end
                end
                alpha(k, s_cur) = max_star(gg);
            end
    end

    %----------------------------beta update --------------------------
    beta = zeros(N*R+1,trellis.numStates);
    paki = zeros(N*R+1, trellis.numStates);
    %@@@@@ CASE 1
    if m ==1      
        for s = 1:trellis.numStates  % most right side
            [flag,~] = ismember(1-1 , trellis.nextStates(s,:));
                if flag == 1
                    beta(N*R, s) = gamma(N*R, 1, s) + beta(N*R+1, 1);
                end
        end
        for k=N*R-m +1 :-1:2  % k-1 is 'current'         
            for s_cur =1:trellis.numStates     
                a = gamma(k-1, trellis.nextStates(s_cur,1)+1, s_cur)+ beta(k, trellis.nextStates(s_cur,1)+1);
                b = gamma(k-1, trellis.nextStates(s_cur,2)+1, s_cur)+ beta(k, trellis.nextStates(s_cur,2)+1);
                beta(k-1,s_cur) = max_star([a,b]);
            end      
        end
    end % if m==1
    %@@@CASE 2
    if m>= 2 
        paki(N*R+1,1)=1;
        for k = N*R+1:-1:N*R+2-m  % initialize paki  paki is updates until k =NR-m +1
            cnt = 1;
            for ii =1: 2^(N*R+1-k)   % next state
                for jj = 1:trellis.numStates     % current (k-1) state
                    [flag, ~] =ismember(paki(k, ii)-1, trellis.nextStates(jj,:) );
                    if flag == 1
                        paki(k-1, cnt) = jj;
                        cnt = cnt+1;
                    end
                end
            end
        end
%         paki
        for k = N*R+1:-1:N*R+2-m    % update left side
            for ii = 1: 2^(N*R +1-k+1)  % current 'k-1'  paki(k-1,:)
                gg=[];
                for jj = 1:2^(N*R+1-k)  % next state   paki(k,:)
                    [flag,~] = ismember(paki(k, jj)-1, trellis.nextStates(paki(k-1, ii),:));
                    if flag ==1 
                       gg =[gg, gamma(k-1, paki(k,jj), paki(k-1,ii) ) + beta(k,paki(k,jj))];
                    end
                end
                beta(k-1, paki(k-1, ii)) = max_star(gg);    % update until beta(N*R-m +1)
            end
        end
        for k = N*R +1-m:-1: 2  % update left side until beta(1,)
            for s_le =1:trellis.numStates   
                a = gamma(k-1, trellis.nextStates(s_le,1)+1, s_le)+ beta(k, trellis.nextStates(s_le,1)+1);
                b = gamma(k-1, trellis.nextStates(s_le,2)+1, s_le)+ beta(k, trellis.nextStates(s_le,2)+1);
                beta(k-1,s_le) = max_star([a,b]);   % this line s_cur is changed to s_le
            end 
        end
%         for k = m+1:-1:2  % update left side
%             for ll= 1: 2^(k-2)
%                 a = gamma(k-1, trellis.nextStates(indi(k-1, ll),1)+1,  indi(k-1,ll))+ beta(k, trellis.nextStates(indi(k-1,ll),1)+1);
%                 b = gamma(k-1, trellis.nextStates(indi(k-1, ll),2)+1,  indi(k-1,ll))+ beta(k, trellis.nextStates(indi(k-1,ll),2)+1);
%                 beta(k-1,indi(k-1, ll)) = max_star([a,b]);
%             end
%         end
    end % if m>=2

    %---------------------------------LLR compute----------------------------------
    %@@@CASE 1: m =1
    if m ==1
        %initial LLR(1)
        for s =1 : trellis.numStates
            [flag,input] = ismember(s-1,trellis.nextStates(1,:));
             if flag==1 && input== 1  % -1
                nn = alpha(1,1) + gamma(1,s, 1)+ beta(2,s);
             end
             if flag==1 && input== 2  % +1
                 pp = alpha(1,1) + gamma(1,s, 1)+ beta(2,s);
             end
        end
        LLR(1) = pp - nn;
        for k=2:1:N*R-1   % middle part
            nn=[];  % store components of max_star
            pp=[];
             for s_le=1:trellis.numStates
                for s_ri=1:trellis.numStates    
                   [flag,input] = ismember(s_ri-1,trellis.nextStates(s_le,:));
                   if flag==1 && input==1 % input=-1
                      nn = [nn, alpha(k,s_le)+ gamma(k, s_ri,s_le) + beta(k+1,s_ri)];
                   end
                   if flag==1 && input==2 % input=+1
                      pp = [pp, alpha(k,s_le)+ gamma(k, s_ri,s_le) + beta(k+1,s_ri)];
                   end
                end
             end
            LLR(k)=max_star(pp)- max_star(nn);
        end    %end k
        ppp=0;
        nnn=0;
        for s_cur =1 : trellis.numStates    % LLR(N*R)
            [flag,input] = ismember(1-1,trellis.nextStates(s_cur,:));
            if flag==1 && input== 1
                nnn = alpha(N*R, s_cur) + gamma(N*R,1, s_cur)+ beta(N*R+1,1);
            else if flag==1 && input== 2
                ppp = alpha(N*R, s_cur) + gamma(N*R,1, s_cur)+ beta(N*R+1,1);
                end
            end
        end
        LLR(N*R) = ppp - nnn;
    end % end if m==1

    %@@@CASE 2: m >=2
    if m >= 2
        LLR= zeros(1,N*R);
        for k =1:m   % starting stage, using indi
            pp=[];
            nn =[];
            for ll = 1: 2^(k-1)  % left state
                for rr = 1: 2^(k)   % right state
                    [flag, input] = ismember( indi(k+1,rr)-1, trellis.nextStates(indi(k, ll),:));
                    if flag == 1 && input ==1 % input = -1
                        nn = [nn, alpha(k, indi(k,ll)) +  gamma(k, indi(k+1, rr), indi(k,ll)) + beta(k+1,indi(k+1,rr)) ];
                    else if flag == 1 && input ==2 % input = +1
                        pp = [pp, alpha(k, indi(k,ll)) +  gamma(k, indi(k+1, rr), indi(k,ll)) + beta(k+1,indi(k+1,rr)) ];
                        end
                    end
                end

            end
             LLR(k) = max_star(pp) - max_star(nn);
        end   % for k
        for k =N*R-m +1:N*R    % ending stage
                pp=[];
                nn =[];
            for ll = 1: 2^(N*R+1-k)  % left state
                for rr = 1: 2^(N*R-k)   % right state
                    [flag, input] = ismember( paki(k+1,rr)-1, trellis.nextStates(paki(k, ll),:));
                    if flag == 1 && input ==1 % input = -1
                        nn = [nn, alpha(k, paki(k,ll)) +  gamma(k, paki(k+1, rr), paki(k,ll)) + beta(k+1,paki(k+1, rr)) ];
                    else if flag == 1 && input ==2 % input = +1
                        pp = [pp, alpha(k, paki(k,ll)) +  gamma(k, paki(k+1, rr), paki(k,ll)) + beta(k+1,paki(k+1, rr)) ];
                        end
                    end
                end            
            end
           LLR(k) = max_star(pp)- max_star(nn); 
        end
        for k = m+1: N*R - m   % full-fledged stage
            nn=[];  
            pp=[];
             for s_le=1:trellis.numStates
                for s_ri=1:trellis.numStates    
                   [flag,input] = ismember(s_ri-1,trellis.nextStates(s_le,:));
                   if flag==1 && input==1 % input=-1
                      nn = [nn, alpha(k,s_le)+ gamma(k, s_ri,s_le) + beta(k+1,s_ri)];
                   end
                   if flag==1 && input==2 % input=+1
                      pp = [pp, alpha(k,s_le)+ gamma(k, s_ri,s_le) + beta(k+1,s_ri)];
                   end
                end
             end
             LLR(k)=max_star(pp)- max_star(nn);  
        end  % for k

    end  % end CASE m>= 2
    %------------------------ hard decoding ----------------------------------
    for i =1:N*R
         if LLR(i)>=0
             dec_seq(i) = 1;
         else
             dec_seq(i) = 0;
         end
    end
 end   % end if strcmp(term_flag, 'term')
 
 
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% unterminated code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 if strcmp(term_flag, 'non_term')
     %------------------------------- alpha update (log domain)------------------------------
    alpha = zeros(N*R+1,trellis.numStates); 
    indi = zeros(m+1, trellis.numStates); 
    indi(m+1,:)= 1: trellis.numStates;
    % m-by-2^m ,represents the presented ststes in the first m+1 states array
    % elements of indi represent the index of state instead of state value
    % itself, state_index = state_value +1 
    %  case 1: only 2 states
    if m ==1
        for i =1:2   % initial for k =2
            alpha(2, trellis.nextStates(1,i) + 1) = gamma(1, trellis.nextStates(1,i) + 1 , 1 ) ;
        end
    end
    %case 2:  more than 2 states, initial indi
    if m >=2
        indi(1,1) =1;
        for k =1:m-1
            for i= 1: 2^(k-1)
                indi(k+1, 2*i-1) = trellis.nextStates(indi(k,i),1) +1;% input =-1
                indi(k+1, 2*i) = trellis.nextStates(indi(k,i),2)+1;% input =1            
            end
        end
%       indi
        for k =2:m+1
            for ii = 1: 2^(k-1)   % anchor state, alpha(k,)
                gg=[];
                for jj= 1:2^(k-2)   % left state   alpha(k-1,)
                    [flag, ~] = ismember(indi(k,ii)-1, trellis.nextStates(indi(k-1,jj),:));
                    if flag ==1
                        gg =[gg, gamma(k-1, indi(k, ii), indi(k-1, jj)) + alpha(k-1,indi(k-1,jj))];
                    end
                end
                alpha(k, indi(k, ii)) = max_star(gg);
            end
        end  % end for
    end   % end if m >= 2
    % alpha starting stage


    for k= m+2:N*R+1      % k=m+2:N*R +1
            for s_cur = 1:trellis.numStates  % current state
                gg=[]; % to store (2) incoming branches of alpha
                for s_pre = 1:trellis.numStates   % previous state
                    [flag, ~] = ismember(s_cur-1, trellis.nextStates(s_pre,:));
                    if flag == 1
                        gg =[gg, gamma(k-1, s_cur, s_pre) + alpha(k-1,s_pre)];
                    end
                end
                alpha(k, s_cur) = max_star(gg);
            end
    end

    %----------------------------beta update --------------------------
    beta = zeros(N*R+1,trellis.numStates);
%     paki = zeros(N*R+1, trellis.numStates);% not useful in unterminated case 
    %@@@@@ CASE 1
    if m ==1      
        for s = 1:trellis.numStates  % most right side
            [flag,~] = ismember(1-1 , trellis.nextStates(s,:));
                if flag == 1
                    beta(N*R, s) = gamma(N*R, 1, s) + beta(N*R+1, 1);
                end
        end
        for k=N*R-m +1 :-1:2  % k-1 is 'current'         
            for s_cur =1:trellis.numStates     
                a = gamma(k-1, trellis.nextStates(s_cur,1)+1, s_cur)+ beta(k, trellis.nextStates(s_cur,1)+1);
                b = gamma(k-1, trellis.nextStates(s_cur,2)+1, s_cur)+ beta(k, trellis.nextStates(s_cur,2)+1);
                beta(k-1,s_cur) = max_star([a,b]);
            end      
        end
    end % if m==1
    %@@@CASE 2
    if m>= 2 
%         paki(N*R+1,1)=1;
%         for k = N*R+1:-1:N*R+2-m  % initialize paki  paki is updates until k =NR-m +1
%             cnt = 1;
%             for ii =1: 2^(N*R+1-k)   % next state
%                 for jj = 1:trellis.numStates     % current (k-1) state
%                     [flag, ~] =ismember(paki(k, ii)-1, trellis.nextStates(jj,:) );
%                     if flag == 1
%                         paki(k-1, cnt) = jj;
%                         cnt = cnt+1;
%                     end
%                 end
%             end
%         end
%         paki
%         for k = N*R+1:-1:N*R+2-m    % update left side
%             for ii = 1: 2^(N*R +1-k+1)  % current 'k-1'  paki(k-1,:)
%                 gg=[];
%                 for jj = 1:2^(N*R+1-k)  % next state   paki(k,:)
%                     [flag,~] = ismember(paki(k, jj)-1, trellis.nextStates(paki(k-1, ii),:));
%                     if flag ==1 
%                        gg =[gg, gamma(k-1, paki(k,jj), paki(k-1,ii) ) + beta(k,paki(k,jj))];
%                     end
%                 end
%                 beta(k-1, paki(k-1, ii)) = max_star(gg);    % update until beta(N*R-m +1)
%             end
%         end
        for k = N*R +1:-1: 2  %update beta(,) from the end to the beginning stage 
            for s_le =1:trellis.numStates   
                a = gamma(k-1, trellis.nextStates(s_le,1)+1, s_le)+ beta(k, trellis.nextStates(s_le,1)+1);
                b = gamma(k-1, trellis.nextStates(s_le,2)+1, s_le)+ beta(k, trellis.nextStates(s_le,2)+1);
                beta(k-1,s_le) = max_star([a,b]);   % this line s_cur is changed to s_le
            end 
        end
    end % if m>=2
    %---------------------------------LLR compute----------------------------------
    %@@@CASE 1: m =1
    if m ==1
        %initial LLR(1)
        for s =1 : trellis.numStates
            [flag,input] = ismember(s-1,trellis.nextStates(1,:));
             if flag==1 && input== 1  % -1
                nn = alpha(1,1) + gamma(1,s, 1)+ beta(2,s);
             end
             if flag==1 && input== 2  % +1
                 pp = alpha(1,1) + gamma(1,s, 1)+ beta(2,s);
             end
        end
        LLR(1) = pp - nn;
        for k=2:1:N*R-1   % middle part
            nn=[];  % store components of max_star
            pp=[];
             for s_le=1:trellis.numStates
                for s_ri=1:trellis.numStates    
                   [flag,input] = ismember(s_ri-1,trellis.nextStates(s_le,:));
                   if flag==1 && input==1 % input=-1
                      nn = [nn, alpha(k,s_le)+ gamma(k, s_ri,s_le) + beta(k+1,s_ri)];
                   end
                   if flag==1 && input==2 % input=+1
                      pp = [pp, alpha(k,s_le)+ gamma(k, s_ri,s_le) + beta(k+1,s_ri)];
                   end
                end
             end
            LLR(k)=max_star(pp)- max_star(nn);
        end    %end k
        ppp=0;
        nnn=0;
        for s_cur =1 : trellis.numStates    % LLR(N*R)
            [flag,input] = ismember(1-1,trellis.nextStates(s_cur,:));
            if flag==1 && input== 1
                nnn = alpha(N*R, s_cur) + gamma(N*R,1, s_cur)+ beta(N*R+1,1);
            else if flag==1 && input== 2
                ppp = alpha(N*R, s_cur) + gamma(N*R,1, s_cur)+ beta(N*R+1,1);
                end
            end
        end
        LLR(N*R) = ppp - nnn;
    end % end if m==1

    %@@@CASE 2: m >=2
    if m >= 2
        LLR= zeros(1,N*R);
        for k =1:m   % starting stage, using indi
            pp=[];
            nn =[];
            for ll = 1: 2^(k-1)  % left state
                for rr = 1: 2^(k)   % right state
                    [flag, input] = ismember( indi(k+1,rr)-1, trellis.nextStates(indi(k, ll),:));
                    if flag == 1 && input ==1 % input = -1
                        nn = [nn, alpha(k, indi(k,ll)) +  gamma(k, indi(k+1, rr), indi(k,ll)) + beta(k+1,indi(k+1,rr)) ];
                    else if flag == 1 && input ==2 % input = +1
                        pp = [pp, alpha(k, indi(k,ll)) +  gamma(k, indi(k+1, rr), indi(k,ll)) + beta(k+1,indi(k+1,rr)) ];
                        end
                    end
                end

            end
             LLR(k) = max_star(pp) - max_star(nn);
        end   % for k
%         for k =N*R-m +1:N*R    % ending stage
%                 pp=[];
%                 nn =[];
%             for ll = 1: 2^(N*R+1-k)  % left state
%                 for rr = 1: 2^(N*R-k)   % right state
%                     [flag, input] = ismember( paki(k+1,rr)-1, trellis.nextStates(paki(k, ll),:));
%                     if flag == 1 && input ==1 % input = -1
%                         nn = [nn, alpha(k, paki(k,ll)) +  gamma(k, paki(k+1, rr), paki(k,ll)) + beta(k+1,paki(k+1, rr)) ];
%                     else if flag == 1 && input ==2 % input = +1
%                         pp = [pp, alpha(k, paki(k,ll)) +  gamma(k, paki(k+1, rr), paki(k,ll)) + beta(k+1,paki(k+1, rr)) ];
%                         end
%                     end
%                 end            
%             end
%            LLR(k) = max_star(pp)- max_star(nn); 
%         end
        for k = m+1: N*R   % full-fledged stage
            nn=[];  
            pp=[];
             for s_le=1:trellis.numStates
                for s_ri=1:trellis.numStates    
                   [flag,input] = ismember(s_ri-1,trellis.nextStates(s_le,:));
                   if flag==1 && input==1 % input=-1
                      nn = [nn, alpha(k,s_le)+ gamma(k, s_ri,s_le) + beta(k+1,s_ri)];
                   end
                   if flag==1 && input==2 % input=+1
                      pp = [pp, alpha(k,s_le)+ gamma(k, s_ri,s_le) + beta(k+1,s_ri)];
                   end
                end
             end
             LLR(k)=max_star(pp)- max_star(nn);  
        end  % for k

    end  % end CASE m>= 2
    %------------------------ hard decoding ----------------------------------
    for i =1:N*R
         if LLR(i)>=0
             dec_seq(i) = 1;
         else
             dec_seq(i) = 0;
         end
    end
 end   % end if strcmp(term_flag, 'term')
end % function
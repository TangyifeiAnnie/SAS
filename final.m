% the most basic program, put the unimproved and improved algorithm
% together
clear all;
close all;
clc
n=4; % the number of the receiving antennas
k=8; % the number of the users
m=20; % the number of the RBs
h=h_generate(k,m,n); % generate the channel matrix
M=[]; % M is used to save the available pairs
RBToUsers=zeros(m,2);
remainingRB=1:1:m;
% the first step: find the best pair for every single RB
for i=1:m
    [user1,user2]=Find1(h,i);
    % Find1 function is used to find the corresponding best user pair for
    % each RB (the i_th)
    if user1 > user2
        nouse=user2;
        user2=user1;
        user1=nouse;
    end
    % make sure the index of the user1 is smaller than that of user2
    M=[M,[user1;user2]];
end
%!!!!!!!!! we should remove the duplicate pair from M first
RBindex=[];
while (~isempty(remainingRB))&&(~isempty(M))
    [selectedRB, u1,u2]=Find2(remainingRB,M,n,h);
    pair=[u1;u2];
    % the pair decoupling process
    % selectedRB is of uint type and pair is of 2*1 array type
    remainingRB=removeRB(selectedRB,remainingRB);
    M=removepair(pair,M);
    RBToUsers(selectedRB,:)=pair';
    RBindex=[RBindex,selectedRB];
end
RBindex=sort(RBindex);
len=length(RBindex);
% remaining RB allocation part
% first we cover the two end sides
for i=1:(RBindex(1))
    RBToUsers(i,:)=RBToUsers(RBindex(1),:);
end
for i=RBindex(len):m
    RBToUsers(i,:)=RBToUsers(RBindex(len),:);
end
% then we have to handle the inside parts which has two different user pair
% on two sides 
for i=1:len-1
    for j=(RBindex(i)+1):(RBindex(i+1)-1)
        h11=squeeze(h(RBToUsers(RBindex(i),1),j,:));
        h12=squeeze(h(RBToUsers(RBindex(i),2),j,:));
        h21=squeeze(h(RBToUsers(RBindex(i+1),1),j,:));
        h22=squeeze(h(RBToUsers(RBindex(i+1),2),j,:));
        c1=capacity_(h11,h12,n)+capacity_(h12,h11,n);
        c2=capacity_(h21,h22,n)+capacity_(h22,h21,n);
        if c1>=c2
            RBToUsers(j,:)=RBToUsers(RBindex(i),:);
        else
            for w=j:(RBindex(i+1)-1)
                RBToUsers(w,:)=RBToUsers(RBindex(i+1),:); 
                % is once the pair on the right hand side is prefered, we
                % allocate the remaining RBs to the righhand side user
                % pair!
            end
            break
        end
    end
end
 % after the joint user pairing and resource allocation we have to
 % calculate the capacity of the derived result
capacity=0;
 for i=1:m
     h1=squeeze(h(RBToUsers(i,1),i,:));
     h2=squeeze(h(RBToUsers(i,2),i,:));
     capacity=capacity+capacity_(h1,h2,n)+capacity_(h2,h1,n);
 end
 
 
 
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%    improved   algotirhm   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 M=[]; % M is used to save the available pairs
RBToUsers=zeros(m,2);
remainingRB=1:1:m;
% the first step: find the best pair for every single RB
for i=1:m
    [user1,user2]=Find1_(h,i);
    % Find1 function is used to find the corresponding best user pair for
    % each RB (the i_th)
    if user1 > user2
        nouse=user2;
        user2=user1;
        user1=nouse;
    end
    % make sure the index of the user1 is smaller than that of user2
    M=[M,[user1;user2]];
end
%!!!!!!!!! we should remove the duplicate pair from M first
RBindex=[];
while (~isempty(remainingRB))&&(~isempty(M))
    [selectedRB, u1,u2]=Find2(remainingRB,M,n,h);
    pair=[u1;u2];
    % the pair decoupling process
    % selectedRB is of uint type and pair is of 2*1 array type
    remainingRB=removeRB(selectedRB,remainingRB);
    M=removepair(pair,M);
    RBToUsers(selectedRB,:)=pair';
    RBindex=[RBindex,selectedRB];
end
RBindex=sort(RBindex);
len=length(RBindex);
% remaining RB allocation part
% first we cover the two end sides
for i=1:(RBindex(1))
    RBToUsers(i,:)=RBToUsers(RBindex(1),:);
end
for i=RBindex(len):m
    RBToUsers(i,:)=RBToUsers(RBindex(len),:);
end
% then we have to handle the inside parts which has two different user pair
% on two sides 
for i=1:len-1
    for j=(RBindex(i)+1):(RBindex(i+1)-1)
        h11=squeeze(h(RBToUsers(RBindex(i),1),j,:));
        h12=squeeze(h(RBToUsers(RBindex(i),2),j,:));
        h21=squeeze(h(RBToUsers(RBindex(i+1),1),j,:));
        h22=squeeze(h(RBToUsers(RBindex(i+1),2),j,:));
        c1=capacity_(h11,h12,n)+capacity_(h12,h11,n);
        c2=capacity_(h21,h22,n)+capacity_(h22,h21,n);
        if c1>=c2
            RBToUsers(j,:)=RBToUsers(RBindex(i),:);
        else
            for w=j:(RBindex(i+1)-1)
                RBToUsers(w,:)=RBToUsers(RBindex(i+1),:); 
                % is once the pair on the right hand side is prefered, we
                % allocate the remaining RBs to the righhand side user
                % pair!
            end
            break
        end
    end
end
 % after the joint user pairing and resource allocation we have to
 % calculate the capacity of the derived result
improved_capacity=0;
 for i=1:m
     h1=squeeze(h(RBToUsers(i,1),i,:));
     h2=squeeze(h(RBToUsers(i,2),i,:));
     improved_capacity=improved_capacity+capacity_(h1,h2,n)+capacity_(h2,h1,n);
 end
clc;
clear all; 
close all;
input=randi([0 1],1,100000);%the input for Modulation 
input_s=zeros(1,100000);%the input sample for Modulation  
output=zeros(1,100000);%the output for Demodulation 
counter_errors=0;%for counting the number of Error in EbN0  
output_sample=[];
ber_sim=[];
ber_th=[];
i = 0;
Eb=1;%the energy of per bits 
EbN0dB= 0;
%% sampling
while i<(length(input)) 
    i=i+1;
if input(1,i)==0
    input_s(1,i)=-1*sqrt(Eb);
end
if input(1,i)~=0 
    input_s(1,i)=1*sqrt(Eb);
end
end
%% Making the noise 
x=randn(1,length(input));
y=randn(1,length(input));
% receiver
while EbN0dB<10
    EbN0dB=EbN0dB+1;
    counter_errors=0;
    N0=Eb/(10^(EbN0dB/10));
    white_noise=sqrt(N0/2)*(x+(1j*y));
    output_sample=input_s+white_noise;
for counter=1:length(output) %convert the sample to bits 
if output_sample(counter)>=0
    output(counter)=1;
end
if output_sample(counter)<0
     output(counter)=0;
end
 if input(counter)~=output(counter)
     counter_errors=counter_errors+1;
 end
end
ber_sim(1,EbN0dB)=(counter_errors/length(input));
ber_th(1,EbN0dB)=qfunc(sqrt((2*Eb)/N0));
%The Q function is related to the complementary error function, erfc, according to
%Q(x)=1/2*erfc(x/sqrt2)
end
EbN0=1:10;
semilogy(EbN0,ber_sim,'-*r',EbN0,ber_th,'-ok','linewidth',1.5);
grid on;




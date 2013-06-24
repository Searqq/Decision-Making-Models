
function f = funcOUtele(t1,t2,p)

global Xzero = 0;


T = t2-t1;			% time
N = 2^12;		% how fine
dt = T / N;		% intervals


randn('state',sum(100*clock))		% clock to change the seed with each run

dW = sqrt(dt) * randn(1,N);

R = 4;
Dt = R * dt;
L = N / R;

Xem = zeros(1,L);
Xtemp = Xzero;
lambda = -1;
c = 0.75;
mu = p;


for j = 1:L
 Winc = sum(dW(R * (j-1) + 1 : R * j));
 Xtemp = Xtemp + (lambda * Xtemp + mu) * Dt + c * Winc;
 Xem(j) = Xtemp;
end

len = length(Xem);
timeint = [0:Dt:T];


%for i = 1:len
%	 if Xem(i) > B
%		timestore(count) = timeint(i);
%		break;
%    
%    elseif Xem(i) < B2
%  	    timestore2(count) = timeint(i);
% 	    break;
%    end
%end


timesteps = (t2 - t1) / length(Xem);

xs = [t1:timesteps:t2];
xslen = length(xs);
ys = [Xzero,Xem];
yslen = length(ys);
plot(xs,ys,'r--');
Xzero = Xem(L);

end

clf;

B1 = 2;     % barrier value
B2 = -B1;

Bs = [B1,B2];

intervnum = 10;
endint = 2 * intervnum + 1;
randtimes1 = [exprnd(1,1,intervnum)];
new1 = zeros(1,2*intervnum);

for r = 1:intervnum
    new1(2*r) = randtimes1(r);
end

randtimes2 = [exprnd(2,1,intervnum)];
new2 = zeros(1,2*intervnum);

for r = 1:intervnum
    new2(2*r-1) = randtimes2(r);
end

randtimes = zeros(1,endint);

for k = 2:endint
    if mod(k,2) == 1
        randtimes(k) = new1(k-1);
    
    elseif mod(k,2) == 0
        randtimes(k) = new2(k-1);
    end
end



for j = 2:(endint)
    randtimes(j) = randtimes(j) + randtimes(j-1);
end
line([0,0],[0,0])



for i = 2:endint
    if Bs(mod(i,2)+1) == B1
        funcOUtele(randtimes(i-1),randtimes(i),1)
        hold on
    elseif Bs(mod(i,2)+1) == B2
        funcOUtele(randtimes(i-1),randtimes(i),-1)
        hold on
    end
end

for i = 2:endint
    hold on
    line([randtimes(i-1),randtimes(i)],[Bs(mod(i,2)+1),Bs(mod(i,2)+1)])
end 

hold off
axis([0-0.5,randtimes(endint)+0.5,B2-0.5,B1+0.5])
set(gca,'XTick',[0:1:ceil(randtimes(endint))+0.5])

clear all
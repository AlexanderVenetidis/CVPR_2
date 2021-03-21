F1_PVT = load('.\F1_PVT.mat').PVT_outmat  ;

PV = F1_PVT(11:30 ,[1 2]);
PT = F1_PVT(11:30,[1 3]);
TV = F1_PVT(11:30,[3 2]);
classes = F1_PVT(11:30, 4);
clr = [1 0 0; 0 1 0; 0 0 1; 1 1 0; 1 0 1; 0 0 0];

figure()
lda(PV, classes,clr,'PV data and separation', 1000,1200,2000,2100);
figure()
lda(PT, classes,clr,'PT data and separation', 1000,1200,1900,2000);
figure()
lda(TV, classes,clr,'TV data and separation', 1900,2000,2000,2100);
    
function lda(in, classes, clr, tit, xmin, xmax, ymin, ymax)
    [X,Y] = meshgrid(linspace(xmin,xmax),linspace(ymin,ymax));
    X = X(:); Y = Y(:);
    [C,err,P,logp,coeff] = classify([X Y],in,...
                                    classes,'linear');
    set(0,'DefaultLegendAutoUpdate','off')
    for i=0:10:10
        scatter(in(i+1:i+10,1),in(i+1:i+10,2),30,clr(i/10+2, :), 'filled')
        hold on;
    end
    legend('foam', 'car sponge');
    title(tit);

    gscatter(X,Y,C,'rb','.',1,'off');
    K = coeff(1,2).const;
    L = coeff(1,2).linear; 
    % Function to compute K + L*v + v'*Q*v for multiple vectors
    % v=[x;y]. Accepts x and y as scalars or column vectors.
    f = @(x,y) K + L(1)*x + L(2)*y;
    h2 = fimplicit(f,[1000 1200 2000 2100]);
    set(h2,'Color','m','LineWidth',2,'DisplayName','Decision Boundary')
    
end




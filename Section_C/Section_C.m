load('.\F1_PVT.mat');

F1_PVT = PVT_outmat;

%Using data for black foam and sponge 
PV = F1_PVT(11:30 ,[1 2]);
PT = F1_PVT(11:30,[1 3]);
TV = F1_PVT(11:30,[3 2]);
PVT = F1_PVT(11:30,1:3);
classes = F1_PVT(11:30, 4);
clr = [1 0 0; 0 1 0; 0 0 1; 1 1 0; 1 0 1; 0 0 0];

figure()
lda(PV, classes,clr,'PV data and separation - Foam/Car sponge','Pressure', 'Vibration','foam', 'car sponge', 1000,1250,2000,2100);
figure()
lda(PT, classes,clr,'PT data and separation - Foam/Car sponge','Pressure', 'Temperature','foam', 'car sponge', 1000,1250,1900,2000);
figure()
lda(TV, classes,clr,'TV data and separation - Foam/Car sponge','Temperature','Vibration','foam', 'car sponge', 1900,2000,2000,2100);
figure()
lda3d(PVT, classes,clr,'PVT data and separation - Foam/Car sponge','foam', 'car sponge', 1900,2000,2000,2100,1900,2000);


%Using data for acrylic and steel vase 
PV = F1_PVT([1:10 51:60] ,[1 2]);
PT = F1_PVT([1:10 51:60],[1 3]);
TV = F1_PVT([1:10 51:60],[3 2]);
PVT = F1_PVT([1:10 51:60],1:3);
classes = F1_PVT([1:10 51:60], 4);

figure()
lda(PV, classes,clr,'PV data and separation - Acrylic/Steel vase',...
    'Pressure', 'Vibration','acrylic vase','steel', 1150,1350,2000,2100);
figure()
lda(PT, classes,clr,'PT data and separation - Acrylic/Steel vase',...
    'Pressure', 'Temperature','acrylic vase','steel', 1150,1350,1900,2000);
figure()
lda(TV, classes,clr,'TV data and separation - Acrylic/Steel vase',...
    'Temperature','Vibration','acrylic vase','steel', 1900,2000,2000,2100);
figure()
lda3d(PVT, classes,clr,'PVT data and separation - Acrylic/Steel vase',...
    'acrylic vase','steel',1900,2000,2000,2100,1900,2000);





function lda(in, classes, clr, tit,xname, yname,obj1, obj2, xmin, xmax, ymin, ymax)
    [X,Y] = meshgrid(linspace(xmin,xmax),linspace(ymin,ymax));
    X = X(:); Y = Y(:);
    [C,err,P,logp,coeff] = classify([X Y],in,...
                                    classes,'linear');
    set(0,'DefaultLegendAutoUpdate','off')
    for i=0:10:10
        scatter(in(i+1:i+10,1),in(i+1:i+10,2),30,clr(i/10+2, :), 'filled')
        hold on;
    end
    legend(obj1,obj2);
    
    set(gca,'fontsize',17)
    title(tit,'Fontsize',18);


    gscatter(X,Y,C,'rb','.',1,'off');
    K = coeff(1,2).const;
    L = coeff(1,2).linear; 
    % Function to compute K + L*v + v'*Q*v for multiple vectors
    % v=[x;y]. Accepts x and y as scalars or column vectors.
    f = @(x,y) K + L(1)*x + L(2)*y
    h2 = fimplicit(f);
    set(h2,'Color','m','LineWidth',2,'DisplayName','Decision Boundary');
    hold on;
    xlabel(xname,'Fontsize',17);
    ylabel(yname,'Fontsize',17);
    
    
end



function lda3d(in, classes, clr, tit,obj1,obj2, xmin, xmax, ymin, ymax, zmin, zmax)
    [X,Y,Z] = meshgrid(linspace(xmin,xmax),linspace(ymin,ymax),linspace(zmin,zmax));
    X = X(:); Y = Y(:); Z = Z(:);
    [C,err,P,logp,coeff] = classify([X Y Z],in,...
                                    classes,'linear');
    set(0,'DefaultLegendAutoUpdate','off')
    for i=0:10:10
        scatter3(in(i+1:i+10,1),in(i+1:i+10,2),in(i+1:i+10,3),30,clr(i/10+2, :), 'filled');
        hold on;
    end
    legend(obj1,obj2);
    xlabel('Pressure','Fontsize',17);
    ylabel('Vibration','Fontsize',17);
    zlabel('Temperature','Fontsize',17);
    set(gca,'fontsize',17)
    title(tit,'Fontsize',22);

%     gscatter3b(X,Y,Z,C,'rb','.',1,'off');
    K = coeff(1,2).const;
    L = coeff(1,2).linear;
    % Function to compute K + L*v + v'*Q*v for multiple vectors
    % v=[x;y]. Accepts x and y as scalars or column vectors.
    f = @(x,y,z) K + L(1)*x + L(2)*y + L(3)*z;
    h2 = fimplicit3(f,'r', 'FaceAlpha',0.6, 'MeshDensity', 2);
%     set(h2,'Color','m','LineWidth',2,'DisplayName','Decision Boundary');
    hold on;
    
    
end




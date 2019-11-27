    try 

    %     uncomment the following block and same %http post block twice below in the
    %     script when connecting to hardware
    %http post
    %     thingSpeakURL = 'http://192.168.0.2:5000/master';
    %     data = struct('Switch','ON');
    %     options = weboptions('MediaType','application/json');
    %     response = webwrite(thingSpeakURL,data,options);
    
    disp('started')
    t = tcpip('0.0.0.0', 9998, 'NetworkRole', 'server');

    fopen(t);
    disp('TCP Server Created')

    %run the following block once at the beginning to start amp
    %disp('Till Here')
%     ampinit('10.10.10.51');
%     ampon
%     ampstart
    disp('Amp Started')
    classification_results = [];
counter =1;

disp('ready with data');
while(true)

    while t.BytesAvailable == 0

        pause(1)
    end
    disp('Inside While')
    res = '';
    res = char(fread(t,t.BytesAvailable))';
    disp(res)
% disp('T1')
%     if (res == 'RTLI')
%         res_num = 1;
%     elseif (res == 'LTLI')
%         res_num = 2;
%     elseif (res == 'RTCI')
%         res_num = 3;   
%     elseif (res == 'LTCI')
%         res_num = 4;   
%     elseif (res == 'REST')
%         res_num = 5;
%     else
%         res_num = 6;
%     end
% disp('T2')
    counter = counter+1;
    data_collect = ampcollect(5000)';
%    disp(['data chunk size' num2str(size(data_collect))]);
%    disp(data_collect)

    try
        data_collect = (10.0*data_collect(1:33,:))/6.0;
        x_decimate = zeros(32,1250);
        x = data_collect;
        
        for i = 1:32
            x_decimate(i,:) = decimate(x(i,:),4);
        end

        disp(['data chunk size decimated :' num2str(size(x_decimate))]);
        
        %IMP check dimension of res and feed it in next function%
 
        sub_no = 14;
        res_num = 1;
   [result,accuracy]  = online_csp(x_decimate,1,'WTR_CSP',3:6,3:4,3,sub_no,8,30);
   output = result.classes    ;
   disp(['Output: ' num2str(output)]);
   
        
    catch exception
        fprintf('%s',exception.identifier);
    continue
    end
    
%     disp('Decision Making')
% %     if (res == 'RTLI')
% %         res_num = 1;
%     elseif (res == 'LTLI')
%         res_num = 2;
%     elseif (res == 'REST')
%         res_num = 3;   
%     elseif (res == 'RTCI')
%         res_num = 4;   
%     elseif (res == 'LTCI')
%         res_num = 5;
%     end
    
    %classification_results = [classification_results;result res_num];
    %results_ = [result res_num]
%     disp('Hardware Control')
    
       
%http postfor hardware control
%     thingSpeakURL = 'http://192.168.0.2:5000/switch';
%     data = result;
%     if data == 1
%         name = 'Fan';
%     elseif data == 2
%          name = 'Lamp';
%     elseif data == 4
%          name = 'Buzzer';       
%     elseif data == 5
%          name = 'Charger';
%     end
    
%     data = struct('Feed',name);
%     options = weboptions('MediaType','application/json');
%     response = webwrite(thingSpeakURL,data,options)
    
    disp('segment processed');

end
    fclose(t);

    catch exception
    fprintf('Baahar ka catch');
    fprintf('%s',exception.identifier);
    fclose(t);
   
    end   
    disp('out of the while');
    
%http post
%     thingSpeakURL = 'http://192.168.0.2:5000/master';
%     data = struct('Switch','OFF');
%     options = weboptions('MediaType','application/json');
%     response = webwrite(thingSpeakURL,data,options)
    

% t = tcpip('0.0.0.0', 30000, 'NetworkRole', 'server');
% fopen(t);
% 
% data = fread(t, t.BytesAvailable);
% print(data)
% %res=native2unicode(data(1))+native2unicode(data(2))+native2unicode(data(3))+native2unicode(data(4))
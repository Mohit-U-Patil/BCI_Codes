    try 
sub_no = 1;
classifier_name= 'RLDA';

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
    true_class = '';
    true_class = char(fread(t,t.BytesAvailable))';
    disp(true_class)
    
    class2collect = {'RTIM', 'LTIM', 'RTCI', 'LTCI'};
    to_collect =  ismember(true_class,class2collect);
    if (to_collect == 0)
        continue;
    end
    
%   true class received 
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
    result = zeros(22);
    tic;
    result_4class = zeros(1);
    [result_4class, classify] = OVO_OVR_Classification(x_decimate(3:6,:), sub_no, 3:6, classifier_name, 8, 30,'sym9', 6, 'SURE', 'Soft', 'LevelIndependent');
    
    result(2) = result_4class(1);
    result(3) = classify(1);%6 predictions of OVO for 4 classes
    result(4) = classify(2);
    result(5) = classify(3);
    result(6) = classify(4);
    result(7) = classify(5);
    result(8) = classify(6);
    result(9) = classify(7);%4 predictions of OVR for 4 classes
    result(10) = classify(8);
    result(11) = classify(9);
    result(12) = classify(10); %result(13) is the main accuracy
    result(14) = classify(11);
    result(15) = classify(12);
    result(16) = classify(13); % direction-action classification result
    result(17) = classify(14); % action-direction classification result
    result(18) = classify(15); % block 2 classification result
    result(19) = classify(16); % block 3 classification result
    result(20) = classify(17); % block 4 classification result
    result(21) = classify(18); % block 5 classification result
    result(22) = classify(19); % block 6 classification result

    %put output = result(1,xxx) according to choice x.
    output = result(22);

   disp(['Output: ' num2str(output)]);
%    output is the output of classification algorithm. 
%    compare the output and res and send back 0 or 1 on basis of the strcmp
%    output. 

    if (output == 1)
        prediction = 'RTIM';
    elseif (output == 2)
        prediction = 'LTIM';
    elseif (output == 3)
        prediction = 'RTCI';
    elseif (output == 4)
        prediction = 'LTCI';
    else
        disp('Invalid Prediction');
        prediction = 'invalid';
    end
    
   if (strcmp(true_class, prediction)) 
        bit_to_send = '1';
   else
        bit_to_send = '0';
   end
      
   fwrite(t,bit_to_send,'char');
   % fwrite sends binary data.Have to sort whether to use write() or
   % fwrite().
        
    catch exception6
        fprintf('%s',exception.identifier);
    continue
    end
    

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
    data_collect = [];
    output = [];
    prediction = [];
    bit_to_send = [];
    true_class = [];
    disp('Reset Done')

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
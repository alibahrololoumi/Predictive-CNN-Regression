matfileAdd = input('Enter The File location of .mat file(e.g. D:\University\File containing the .mat file\ .mat file name ): ' , 's');
testtadd = input('Enter The File location of Digitized iamge of Top Column(e.g. D:\University\File containing the images ): ' , 's');
testbadd = input('Enter The File location of Digitized iamge of Bottom Column (e.g. D:\University\File containing the images ): ' , 's');
testjadd = input('Enter The File location of Digitized iamge of Joint Column (e.g. D:\University\File containing the images ): ' , 's');
load(matfileAdd);
Xscale=1024; 
Yscale=1024;
BinaryLevel=0.8;
XTestt=imageDatastore(testtadd);
XTestj=imageDatastore(testjadd);
XTestb=imageDatastore(testbadd);
NumberOfSamplesTest =numel(XTestj.Files); 
xTest=zeros(Xscale,Yscale,1,NumberOfSamplesTest); 
yTest=zeros(NumberOfSamplesTest,1); 
for counter92=1:NumberOfSamplesTest
  jointpic=imread(XTestj.Files{counter92});
  [hj,wj]=size(jointpic);
  topcolumnpic=imread(XTestt.Files{counter92});
  [ht,wt]=size(topcolumnpic);
  botomcolumnpic=imread(XTestb.Files{counter92});
  [hb,wb]=size(botomcolumnpic);
  if wb==1024 && hb==1024
      if botomcolumnpic(20,20)==0
          if botomcolumnpic(12,120)==0
             if botomcolumnpic(220,220)==0
                 if botomcolumnpic(330,330)==0
                         botomcolumnpic(:,:)=255;
                         botomcolumnpic= imresize(botomcolumnpic,[ht,wt]);
                         [hb,wb]=size(botomcolumnpic);
                 end
            end
          end
      end
  end
  if hj==hb
    sumh=ht+hb+hj;
  ph=1024/sumh;
    checkjh=floor(hj*ph);
    
    checkjw=wj*ph;
    
    jointpic= imresize(jointpic,[hj*ph,wt*ph]);
    topcolumnpic= imresize(topcolumnpic,[ht*ph,wt*ph]);
    botomcolumnpic= imresize(botomcolumnpic,[ht*ph,wt*ph]);  
    finalax= cat(1,topcolumnpic,jointpic,botomcolumnpic);
    padwfinalax=floor((1024-floor(wt*ph))/2);
    finalax=padarray(finalax,[0 padwfinalax],255,'both');
    [hff,wff]=size(finalax);
    while hff>1024
        finalax(hff,:)=[];
        [hff,wff]=size(finalax);
    end
    while wff>1024
        finalax(:,wff)=[];
        [hff,wff]=size(finalax);
    end
  end
  if hj>hb
  sumh=ht+hb+hj;
  ph=1024/sumh;
    checkjh=1024-floor(hj*ph+ht*ph+hb*ph);
    checkjh=floor(hj*ph)+checkjh;
    x=wj*ph;
    x=floor(x);
    checkew=(1024-x)/2;
    checkjw=wj*ph;
    if mod(checkew,2)==1
        
        checkew=checkew-1;
    end
    jointpic= imresize(jointpic,[checkjh,checkjw]);
    topcolumnpic= imresize(topcolumnpic,[ht*ph,wt*ph]);
    botomcolumnpic= imresize(botomcolumnpic,[hb*ph,wb*ph]);
    
    padingbtc=floor(checkjh-floor(ht*ph));
    padingbtc=padingbtc-1;
    topcolumnpic=padarray(topcolumnpic,[padingbtc 0],0,'pre');
    botomcolumnpic=padarray(botomcolumnpic,[padingbtc 0],0,'post');
    finalax= cat(1,topcolumnpic,jointpic,botomcolumnpic);
    [hf,wf]=size(finalax);
    for i=1:padingbtc
        finalax(hf,:)=[];
        finalax(1,:)=[];
        hf=hf-2;
    end
    padwfinalax=floor((1024-floor(wt*ph))/2);
    
    
    finalax=padarray(finalax,[0 padwfinalax],255,'both');
    [hff,wff]=size(finalax);
    
    while hff>1024
        finalax(hff,:)=[];
        [hff,wff]=size(finalax);
    end
    while wff>1024
        finalax(:,wff)=[];
        [hff,wff]=size(finalax);
    end
  end
  if hj<hb
    sumh=ht+hb+hj;
    ph=1024/sumh;
    checkjh=1024-floor(hj*ph+ht*ph+hb*ph);
    checkjh=floor(hj*ph)+checkjh;
    x=wj*ph;
    x=floor(x);
    checkew=(1024-x)/2;
    sumw=wt+wb+wj;
    phw=1024/sumw;
    checkjw=1024-floor(wj*phw+wt*phw+wb*phw);
    checkjw=floor(wj*phw)+checkjw;
    
    
    
    if mod(checkjw,2)==1
        
        checkjw=checkjw-1;
    end
    jointpic= imresize(jointpic,[checkjh,checkjw]);
    topcolumnpic= imresize(topcolumnpic,[ht*ph,checkjw]);
    botomcolumnpic= imresize(botomcolumnpic,[hb*ph,checkjw]);
    checkpoint1=76;
     padingj=floor(floor(ht*ph)-checkjh);
     jointpic=padarray(jointpic,[padingj 0],0,'pre');
     finalax= cat(1,topcolumnpic,jointpic,botomcolumnpic);
     [hf,wf]=size(topcolumnpic);
     for i=1:padingj
        finalax(hf+1,:)=[];
        checkpoint2=44;
     end
    padwfinalax=floor((1024-floor(wt*phw))/2); 
    if mod(padwfinalax,2)==1
         padwfinalax=padwfinalax+1;       
    end
    finalax=padarray(finalax,[0 padwfinalax],255,'both');
    [hff,wff]=size(finalax);
    
    while hff>1024
        finalax(hff,:)=[];
        [hff,wff]=size(finalax);
    end
    while wff>1024
        finalax(:,wff)=[];
        [hff,wff]=size(finalax);
    end
  end  
  finalax=im2bw(finalax,BinaryLevel);
  xTest(:,:,1,counter92) = finalax;

end
YPredictedTest=predict(net,xTest);
disp('Predicted drift : ');
disp(YPredictedTest(1,1));

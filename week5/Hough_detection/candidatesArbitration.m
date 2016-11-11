function windCandidates = candidatesArbitration(windowCandidates)
% Window candidates arbitration
del=[];
for i = 1:size(windowCandidates,1)
    if nnz(del == i) == 0
        for j = i + 1:size(windowCandidates, 1)
           if nnz(del==j)==0
%                if strcmp(window_method,'convolution') || strcmp(window_method,'template_matching')
%                    if abs(windowCandidates(i,2) - windowCandidates(j,2))<=max([windowCandidates(i,3),windowCandidates(j,3)])/2
%                        windowCandidates(i,1)=min(windowCandidates(i,1),windowCandidates(j,1));
%                        windowCandidates(i,2)=min(windowCandidates(i,2),windowCandidates(j,2));
%                        windowCandidates(i,3)=max(windowCandidates(i,3),windowCandidates(j,3));
%                        windowCandidates(i,4)=max(windowCandidates(i,4),windowCandidates(j,4));
%                        del=[del j];
%                    end
                   
%                else    
                   dist=norm(windowCandidates(i)-windowCandidates(j));
                   if dist<200
                       windowCandidates(i,1)=min(windowCandidates(i,1),windowCandidates(j,1));
                       windowCandidates(i,2)=min(windowCandidates(i,2),windowCandidates(j,2));
                       windowCandidates(i,3)=max(windowCandidates(i,3),windowCandidates(j,3));
                       windowCandidates(i,4)=max(windowCandidates(i,4),windowCandidates(j,4));
                       del=[del j];
                   end
%                end               
           end
        end
    end
end
windowCandidates(del,:)=[];  
windCandidates = windowCandidates;
end
function frankScore = F_frankScore(score_1, score_2, p)

%fusing two scores by frank norm
    if p<= 0
        error('p must be a positive number')
    end
    
    tempVar_a = ((p.^score_1-1).*(p.^score_2-1))/(p-1) ;
    frankScore = log(1 + tempVar_a) / log(p)  ;
    
end

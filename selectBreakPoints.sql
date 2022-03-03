SELECT * FROM [IN_PLAY_DATA]
    WHERE 
        [IN_PLAY_DATA_SCORE] = '[*30-40]' OR
        [IN_PLAY_DATA_SCORE] = '[*15-40]' OR
        [IN_PLAY_DATA_SCORE] = '[*0-40]' OR
        [IN_PLAY_DATA_SCORE] = '[*40-A*]' OR
        [IN_PLAY_DATA_SCORE] = '[40-30*]' OR
        [IN_PLAY_DATA_SCORE] = '[40-15*]' OR
        [IN_PLAY_DATA_SCORE] = '[40-0*]' OR
        [IN_PLAY_DATA_SCORE] = '[A-40*]';




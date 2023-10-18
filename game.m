% EXPLANATION OF SPRITE SHEET (othelloIcons.png)
% The majority of the sprite sheet corresponds to ASCII shifted over 1 for
% ease of use with Matlab. Since Matlab treats 'abc' as an array like
% [97 98 99], the ASCII codes for the respective letters, the sprite sheet
% was made such that the indexes 97, 98, and 99 correspond to a, b, and c.
% This is true for all printable characters.
% OTHER SPRITE VALUES
% 1: Empty green tile 2: Black piece with border 3: White piece with border
% 4: Empty tile       5: Black piece no border   6: White piece no border
% 7: All black        8: Light green (selection) 9: All yellow
% 10: Chinese symbol  11: Switch icon





clc
clear
close all

% create board from personal icon set
symbols = gameEngine("othelloIcons.png",16,16,4,[0,140,0]);

% get language from user ( 1 => English, 2 => Spanish )
board = zeros(10,19) + 7;
board(4:7,2:18) = 4;
board(2,7:13) = 'REVERSI';
board(4,9:11) = ['A' 11 10]; % internationally understood translate icons
board(5,2:8) = 'English';
board(5,12:18) = 'Español';
language = 0;
drawScene(symbols,board);
select = zeros(10,19) + 4;
while true
    drawScene(symbols,select,board);
    % if player selected a language, wait for a second then switch screens
    if language ~= 0
        pause(.05);
        if language == 3
            pause(.3)
        end
        break;
    end
    % select is empty aside from yellow boxes to go under selections
    select = zeros(10,19) + 4;
    [row, col] = getMouseInput(symbols);
    if row == 5
        if col > 1 && col < 9
            language = 1;
            select(5,2:8) = 9;
        elseif col > 11 && col < 19
            language = 2;
            select(5,12:18) = 9;
        end
    elseif row == 6
        if col > 1 && col < 14
            language = 3;
            % name of this language only appears if clicked as easter egg
            board(6,2:13) = 'tlhIngan Hol';
            select(6,2:13) = 9;
        end
    end
end

% build main screen board
if language == 1
    board(4,2:18) = 'PLAYER1   PLAYER2';
    board(5,2:18) = ' Human     Human ';
    board(6,2:18) = ' AI123     AI123 ';
    board(7,2:18) = '      Start      ';
    board(9,5:15) = 'How to play';
elseif language == 2
    board(4,2:18) = 'JUGADOR1 JUGADOR2';
    board(5,2:18) = ' Humano   Humano ';
    board(6,2:18) = ' IA 123   IA 123 ';
    board(7,2:18) = '     Empezar     ';
    board(9,4:16) = 'Cómo se Juega';
elseif language == 3
    board(4,2:18) = 'QujwI''1   QujwI''2';
    board(5,2:18) = ' Human     Human ';
    board(6,2:18) = 'De'' 123   De'' 123';
    board(7,2:18) = '      tagh!      ';
end

% default variables, the difficulty is automatically stored as 2 in case a
% user just clicks 'AI'
start = false;
p1isAI = false;
p2isAI = false;
difficulty1 = 2;
difficulty2 = 2;
% MAIN MENU SCREEN
while true
    % select is empty aside from yellow boxes to go under selections
    select = zeros(10,19) + 4;
    % puts yellow under selections for Player 1
    if p1isAI
        if language == 1
            select(6,3:4) = 9;
            select(6,4+difficulty1) = 9;
        elseif language == 2
            select(6,3:4) = 9;
            select(6,5+difficulty1) = 9;
        elseif language == 3
            select(6,2:4) = 9;
            select(6,5+difficulty1) = 9;
        end
    else
        if language == 1
            select(5,3:7) = 9;
        elseif language == 2
            select(5,3:8) = 9;
        elseif language == 3
            select(5,3:7) = 9;
        end
    end
    % puts yellow under selections for Player 2
    if p2isAI
        if language == 1
            select(6,13:14) = 9;
            select(6,14+difficulty2) = 9;
        elseif language == 2
            select(6,12:13) = 9;
            select(6,14+difficulty2) = 9;
        elseif language == 3
            select(6,12:14) = 9;
            select(6,15+difficulty2) = 9;
        end
    else
        if language == 1
            select(5,13:17) = 9;
        elseif language == 2
            select(5,12:17) = 9;
        elseif language == 3
            select(5,13:17) = 9;
        end
    end
    % draws the menu
    drawScene(symbols,select,board);
    % if player selected start, wait for a second then switch screens
    [row, col] = getMouseInput(symbols);
    % if player selects start
    if (language == 1 && row == 7 && col > 7 && col < 13) || ...
       (language == 2 && row == 7 && col > 6 && col < 14) || ...
       (language == 3 && row == 7 && col > 7 && col < 13)
        % put yellow under start
        if language == 1
            select(7,8:12) = 9;
        elseif language == 2
            select(7,7:13) = 9;
        elseif language == 3
            select(7,8:12) = 9;
        end
        drawScene(symbols,select,board);
        pause(.05);
        % exits the loop
        break;
    % if player selects human
    elseif row == 5
        if (language == 1 && col > 2 && col < 8) || ...
           (language == 2 && col > 2 && col < 9) || ...
           (language == 3 && col > 2 && col < 8)
            p1isAI = false;
        elseif (language == 1 && col > 12 && col < 18) || ...
               (language == 2 && col > 11 && col < 18) || ...
               (language == 3 && col > 12 && col < 18) 
            p2isAI = false;
        end
    % if player selects AI, assign difficulty
    elseif row == 6
        if (language == 1 && col > 2 && col < 8) || ...
           (language == 2 && col > 2 && col < 9) || ...
           (language == 3 && col > 1 && col < 9)
            p1isAI = true;
            if language == 1 && col > 4
                % '- 4' is the spacing between the column and the actual
                % number (in English)
                difficulty1 = col - 4;
            elseif language == 2 && col > 5
                difficulty1 = col - 5;
            elseif language == 3 && col > 5
                difficulty1 = col - 5;
            end
        elseif (language == 1 && col > 12 && col < 18) || ...
               (language == 2 && col > 11 && col < 18) || ...
               (language == 3 && col > 10 && col < 19)
            p2isAI = true;
            if language == 1 && col > 14
                difficulty2 = col - 14;
            elseif language == 2 && col > 14
                difficulty2 = col - 14;
            elseif language == 3 && col > 15
                difficulty2 = col - 15;
            end
        end
    % if player selects how to play, show tutorial
    elseif (language == 1 && row == 9 && col > 4 && col < 16) || ...
           (language == 2 && row == 9 && col > 3 && col < 17)
        % show selection for .05 seconds
        if language == 1
            select(9,5:15) = 9;
        elseif language == 2
            select(9,4:16) = 9;
        end
        drawScene(symbols,select,board);
        pause(.05);
        showTutorial(symbols, language);
    end
end

% reset board
board = newBoard(language);
% start game on black's turn (black always goes first)
blacksTurn = true;
% keep track of who can move, stop game if neither black/white can
whiteCanMove = true;
blackCanMove = true;

% MAIN GAME LOOP
quit = false;
while ~quit

    % for whoever's turn it is, check if they can move while looking
    % through board
    if blacksTurn
        blackCanMove = false;
    else
        whiteCanMove = false;
    end
    % iterate through all spaces on the board (board(2:9,2:9))
    for boardRow = 2:9
        for boardCol = 2:9
            % gets rid of highlight spaces
            if board(boardRow, boardCol) == 8
                board(boardRow, boardCol) = 1;
            end
            % decide whether or not a player can move in a given space
            if board(boardRow, boardCol) == 1
                % iterate through directions from current space
                for scopeRow = -1:1
                    for scopeCol = -1:1
                        % move testRow/testCol in current direction
                        testRow = boardRow + scopeRow;
                        testCol = boardCol + scopeCol;
                        % while the pieces in this direction are
                        % opponent's color
                        while board(testRow, testCol) == 2 + blacksTurn
                            testRow = testRow + scopeRow;
                            testCol = testCol + scopeCol;
                            % if new test space is player's color, then 
                            % this is playable space (and player is
                            % able to play)
                            if board(testRow, testCol) == 3 - blacksTurn
                                board(boardRow, boardCol) = 8;
                                if blacksTurn
                                    blackCanMove = true;
                                else
                                    whiteCanMove = true;
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    % if player can move, then they will. Otherwise either turn is
    % skipped or if nobody can play game ends
    if (blacksTurn && blackCanMove) || (~blacksTurn && whiteCanMove)
        % this puts the current score at the bottom
        board = setCounts(board);
        % label current turn and draw game
        board(4, 17) = 6 - blacksTurn;
        drawScene(symbols, board);
        % title can have comments from last move, so remove it
        title("");
        % if a human has a turn
        if (blacksTurn && ~p1isAI) || (~blacksTurn && ~p2isAI)
            % get a location to play from the player
            row = 1;
            col = 1;
            % until player clicks a highlighted space
            while board(row,col) ~= 8
                [row, col] = getMouseInput(symbols);
                if board(row,col) ~= 8
                    % if the player clicks redo
                    if (row == 7 && (col > 10 && col < 19))
                        % show selection
                        select = zeros(10,19) + 4;
                        select(7,11:18) = 9;
                        drawScene(symbols,select,board);
                        pause(.05);
                        % reset board
                        board = newBoard(language);
                        % start game on black's turn (black always goes first)
                        blacksTurn = true;
                        % keep track of who can move, stop game if neither black/white can
                        whiteCanMove = true;
                        blackCanMove = true;
                        break;
                    elseif (row == 9  && (col > 10 && col < 19))
                        % show selection
                        select = zeros(10,19) + 4;
                        select(9,11:18) = 9;
                        drawScene(symbols,select,board);
                        pause(.05);
                        % quit game
                        quit = true;
                        break;
                    else
                        if language == 1
                            title("Error: Invalid Space");
                        elseif language == 2
                            title("Error: Espacio Inválido");
                        end
                    end
                end
            end
        % if AI has a turn
        else
            % delay between AI moves
            pause(.2);
            % sets difficulty to that of either black or white,
            % depending on which color current AI is playing
            difficulty = blacksTurn * difficulty1 + ~blacksTurn * difficulty2;
            [row, col] = getAIMove(board, blacksTurn, difficulty);
        end
        % place piece on the board and switch turn to other player if move
        % is valid (otherwise the game was probably reset)
        if (row > 1 && row < 10) && (col > 1 && col < 10)
            board = updateBoard(board, row, col, blacksTurn);
            blacksTurn = ~blacksTurn;
        end
    elseif ~blackCanMove && ~whiteCanMove
        % stop game if neither one can play until input

        % replace the turn label with "GAMEOVER"
        if language == 1
            board(4,11:18) = 'GAMEOVER';
        elseif language == 2
            board(4,11:18) = ' EL FIN ';
        end
        % set final score
        board = setCounts(board);
        drawScene(symbols,board);
        title("");

        row = 1;
        col = 1;
        % await input
        while true
            [row, col] = getMouseInput(symbols);
            % redo button is clicked
            if (row == 7 && (col > 10 && col < 19))
                % show selection
                select = zeros(10,19) + 4;
                select(7,11:18) = 9;
                drawScene(symbols,select,board);
                pause(.05);
                % reset board
                board = newBoard(language);
                % start game on black's turn (black always goes first)
                blacksTurn = true;
                % keep track of who can move, stop game if neither black/white can
                whiteCanMove = true;
                blackCanMove = true;
                break;
            % quit button clicked
            elseif (row == 9  && (col > 10 && col < 19))
                % show selection
                select = zeros(10,19) + 4;
                select(9,11:18) = 9;
                drawScene(symbols,select,board);
                pause(.05);
                % exit game
                quit = true;
                break;
            end
        end
    else 
        % skip turn if one user can't play
        blacksTurn = ~blacksTurn;
    end
end
close;

function board = newBoard(language)
    % set up starting board to all black
    board = zeros(10,19) + 7;
    % set game area to green grid
    board(2:9,2:9) = 1;
    % set up message area (turn, score, control)
    board(2:9,11:18) = 4;
    board(5:6,11:18) = 7;
    board(8,11:18) = 7;
    if language == 1
        board(2,12:17) = 'Score:';
        board(4,12:16) = 'Turn:';
        board(7,13:16) = 'Redo';
        board(9,13:16) = 'Quit';
    elseif language == 2
        board(2,11:18) = 'Puntaje:';
        board(4,11:16) = 'Turno:';
        board(7,12:17) = 'Replay';
        board(9,12:17) = 'Cerrar';
    elseif language == 3
        board(2,11:18) = 'pe''''egh:';
        board(4,11:16) = 'yiQuj:';
        board(7,13:16) = 'tagh';
        board(9,13:15) = 'bup';
    end
    board(3,11) = 5;
    board(3,18) = 6;
    % place starting pieces
    board(5,5) = 2;
    board(6,6) = 2;
    board(5,6) = 3;
    board(6,5) = 3;

end
function board = setCounts(board)   
    % update score on board

    blackCt = getCount(board, 2);
    whiteCt = getCount(board, 3);
    board(3,13) = 4;
    board(3, 12:12+(blackCt>9)) = num2str(blackCt);
    board(3,16) = 4;
    board(3, 17-(whiteCt>9):17 ) = num2str(whiteCt);
end

function count = getCount(board, value)
    % return the number of value on the playable board

    count = 0;
    % get number of pieces on board with value
    for boardRow = 2:9
        for boardCol = 2:9
            if board(boardRow, boardCol) == value
                count = count + 1;
            end
        end
    end
end
function showTutorial(symbols, language)
    if language == 1
        buildBook("RULES: Black always starts. For every move, " + ...
        "every line between the piece you play and another piece of " + ...
        "your color separated only by pieces of the opponent's " + ...
        "color gets flipped to your color. You may only play in " + ...
        "places where you are able to flip pieces, conveniently " + ...
        "highlighted in this application. If one player is unable " + ...
        "to play on their turn, the other player gets an extra " + ...
        "turn. The game ends when no players are able to play, and " + ...
        "the winner is determined by the player with the most " + ...
        "pieces of their color. STRATEGY: Take control of the " + ...
        "corners. In most games in which one player has 3 of the " + ...
        "corners, that player wins. Similarly, it is important to " + ...
        "take control of the edges. GAME INSTRUCTIONS: For each of " + ...
        "player 1 and player 2 (black and white respectively), " + ...
        "select human for if they are to be played by a human or AI " + ...
        "with the corresponding difficulty level if they are to be " + ...
        "played by an AI. Click start to begin the game.",symbols);
    elseif language == 2
        buildBook("REGLAS: Negro siempre empieza. Para cada turno, " + ...
        "cada línea seperada solamente por piezas del color del " + ...
        "adversario se voltea a tu color. Solamente puedes poner " + ...
        "una pieza en un lugar en cual puedes voltear piezas, " + ...
        "destacados en esta aplicación. Si un jugador no se puede " + ...
        "jugar, el otro jugador gana extra turno. El juego termina " + ...
        "cuando nadie puede jugar, y se sabe el ganador por quién " + ...
        "tenga la mayoría de las piezas. ESTRATEGÍA: Toma control " + ...
        "de las esquinas, y también de los bordes.",symbols);
    end
end
function buildBook(text, symbols)
    % prints all of text with precondition that no word in text is longer
    % than 16 characters in a "book" in which one can search through the
    % pages.

    % get array of all words in text
    words = split(text);
    line = 2;
    col = 2;
    pageCt = 1;
    % standard blank green page with black border
    newPage = zeros(10,19) + 7;
    newPage(2:9,2:18) = 4;
    newPage(9,2) = '<';
    newPage(9,18) = '>';
    newPage(9,10) = '×';
    % initialize board with single page
    board = newPage;
    % gets rid of first '<'
    board(9,2) = 4;
    while ~isempty(words)
        % get char array of first word
        word = convertStringsToChars(words(1));
        % remove first word
        words = words(2:end);
        % if word can't fit on current line
        if col + length(word) > 19
            col = 2;
            % add a page if lines run out, otherwise go to next line
            if line == 8
                board = [board, newPage];
                line = 2;
                pageCt = pageCt + 1;
            else
                line = line + 1;
            end
        end
        % add word to board
        board(line,(pageCt-1)*19+col:(pageCt-1)*19+col+length(word)-1) = word;
        % increase col accordingly
        col = col + length(word) + 1;
    end
    % remove final increase page button
    board(9,18 + (pageCt-1)*19) = 4;
    % display book
    page = 1;
    % runs the book until user clicks 'end'
    while true
        drawScene(symbols,board(1:end,19*(page-1)+1:19*page));
        [row, col] = getMouseInput(symbols);
        if row == 9
            % clicked end
            if col == 10
                break;
            % clicking back arrow    
            elseif col == 2 && page > 1
                page = page - 1;
            %clicking front arrow
            elseif col == 18 && page < pageCt
                page = page + 1;
            end
        end
    end
end

function board = updateBoard(board, row, col, blacksTurn)
    % place a piece at the indicated space. Must be a playable space.
    for scopeRow = -1:1
        for scopeCol = -1:1
            % test if line can flip in this direction
            testRow = row + scopeRow;
            testCol = col + scopeCol;
            canFlipLine = false;
            while board(testRow, testCol) == 2 + blacksTurn
                testRow = testRow + scopeRow;
                testCol = testCol + scopeCol;
                if board(testRow, testCol) == 3 - blacksTurn
                    canFlipLine = true;
                end
            end
            % flip line if it can in this direction
            if canFlipLine 
                while testRow ~= row + scopeRow || testCol ~= col + scopeCol
                    testRow = testRow - scopeRow;
                    testCol = testCol - scopeCol;
                    board(testRow, testCol) = 3 - blacksTurn;
                end
            end
        end
    end
    board(row,col) = 3 - blacksTurn;
end

function [row, col] = getAIMove(board, blacksTurn, difficulty)
    % returns the row and column that the AI chooses.
    [rows, cols, scores] = getScores(board, blacksTurn);
    scores = difficulty .^ (scores + 1);

    % select a random number up to the the sum of the scores and select the
    % choose the row and column associated with where that random number
    % falls on the scores array.
    sumScores = rand*sum(scores,'all');
    count = 0;
    for i = 1:length(scores)
        count = count + scores(i);
        if count > sumScores
            row = rows(i);
            col = cols(i);
            break;
        end
    end
end
function [rows, cols, scores] = getScores(board, blacksTurn) 
    % for each space on the board with an 8, the row and col for that space
    % is added to the rows and cols arrays and the score (calculated from
    % consideration of several variables) is 
    % added to the scores array.
    
    % length is how many highlighted spaces on the board
    length = getCount(board, 8);
    rows = zeros(1,length);
    cols = zeros(1,length);
    scores = zeros(1,length);
    i = 1;
    for row = 2:9
        for col = 2:9
            if board(row, col) == 8
                rows(i) = row;
                cols(i) = col;
                % tests what would happen if player puts piece here
                testBoard = updateBoard(board, row, col, blacksTurn);
                opportunities = 0;
                % sum of space types of all current player's flipped pieces
                plScore = 0;
                for testRow = 2:9
                    for testCol = 2:9
                        if testBoard(testRow, testCol) == 8
                            opportunities = opportunities + getSpaceType(testRow, testCol);   
                        elseif testBoard(testRow, testCol) == 3 - blacksTurn
                            plScore = plScore + getSpaceType(testRow,testCol);
                        end
                    end
                end
                % calculate score
                scores(i) = getSpaceType(row, col)*10 + plScore - opportunities/2 + 100*(getCount(testBoard, 8) == 0);
                % should rarely ever be this low, but possible. Regardless,
                % must be positive.
                if scores(i) < .1
                    scores(i) = .1;
                end
                
                i = i + 1;
            end
        end
    end

end

function spaceType = getSpaceType(row, col)
    % return spaceType as a number [0,5] as labeled on the strategy sheet
    % based on the type of space is at the given row and column
    
    if (row == 5 || row == 6) && (col == 5 || col == 6)
        spaceType = 4;
    % Inner Square around center
    elseif((row == 4 || row == 7) && (col == 4 || col == 7))
        spaceType = 3;
    % Square outside of the inner square, making the corners of this square
    % 0
    elseif((row >=3 && row <= 8) && (col >= 3 && col <= 8))
        spaceType = 2;
        % Make corners 0
        if((row == 3 || row == 8) && (col == 3 || col == 8))
            spaceType = 0;
        end
    % The rest of the spaces are defaulted to 4 besides the corners and the
    % adjacent spaces
    else
        spaceType = 4;
        % Make corners 5
        if((row == 2 || row == 9) && (col == 2 || col == 9))
            spaceType = 5;
        % Make adjacent spaces 1
        elseif(((row == 3 || row == 8) && (col == 2 || col == 9)) || ((row == 2 || row == 9) && (col == 3 || col == 8)))   
            spaceType = 1;
        end
    end
end
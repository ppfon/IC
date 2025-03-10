% Define the folder names for the main categories, decimal subfolders,
% and strategy subfolders (ordered as specified: q0p1500, q1500p0, q1000p1000).
mainFolders = {'aarc', 'apoc', 'bpsc', 'pnsc', 'rpoc'};
decimalFolders = {'0.1818', '0.3333', '0.5714'};
strategyFolders = {'q0p1500', 'q1500p0', 'q1000p1000'};

% Initialize a cell array to store the CSV data with preallocation
csvData = cell(length(mainFolders)*4, 7); % Preallocate for efficiency

% Initialize a row counter
rowCounter = 1;

% Add strategy folder names as headers
csvData{rowCounter, 1} = ''; % First cell is empty
csvData{rowCounter, 2} = strategyFolders{1};
csvData{rowCounter, 4} = strategyFolders{2};
csvData{rowCounter, 6} = strategyFolders{3};
rowCounter = rowCounter + 1;

% Add "ativo" and "reativo" labels
csvData{rowCounter, 2} = 'ativo';
csvData{rowCounter, 3} = 'reativo';
csvData{rowCounter, 4} = 'ativo';
csvData{rowCounter, 5} = 'reativo';
csvData{rowCounter, 6} = 'ativo';
csvData{rowCounter, 7} = 'reativo';
rowCounter = rowCounter + 1;

% Loop through each main folder
for m = 1:length(mainFolders)
    % Add the main folder name as a header row in the CSV data
    csvData{rowCounter, 1} = upper(mainFolders{m});
    rowCounter = rowCounter + 1;
    
    % Loop through each decimal folder within the main folder
    for d = 1:length(decimalFolders)
        % Initialize a row for the current decimal folder
        csvRow = {decimalFolders{d}};
        
        % Loop through each strategy folder
        for s = 1:length(strategyFolders)
            % Construct the full file path for 'ativo' and 'reativo'
            ativoFile   = fullfile(mainFolders{m}, decimalFolders{d}, strategyFolders{s}, 'ativo', 'stgy.mat');
            reativoFile = fullfile(mainFolders{m}, decimalFolders{d}, strategyFolders{s}, 'reativo', 'stgy.mat');
            
            % Initialize variables for rows (dimensions of the matrices)
            rowsAtivo = NaN;
            rowsReativo = NaN;
            
            % Load the 'stgy' variable from the ativo folder
            try
                data = load(ativoFile, 'stgy');
                rowsAtivo = size(data.stgy, 1);
            catch ME
                warning('Could not load %s: %s', ativoFile, ME.message);
            end
            
            % Load the 'stgy' variable from the reativo folder
            try
                data = load(reativoFile, 'stgy');
                rowsReativo = size(data.stgy, 1);
            catch ME
                warning('Could not load %s: %s', reativoFile, ME.message);
            end
            
            % Append the A and R values to the CSV row
            csvRow{end+1} = rowsAtivo;
            csvRow{end+1} = rowsReativo;
        end
        
        % Add the row to the CSV data
        csvData(rowCounter, :) = csvRow;
        rowCounter = rowCounter + 1;
    end
    
    % Add an empty row for separation between main folders
    csvData{rowCounter, 1} = '';
    rowCounter = rowCounter + 1;
end

% Write the CSV data to a file
writecell(csvData, 'output.csv');
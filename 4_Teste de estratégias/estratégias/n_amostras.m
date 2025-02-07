% Define the folder names for the main categories, decimal subfolders,
% and strategy subfolders (ordered as specified: q0p1500, q1500p0, q1000p1000).
mainFolders = {'aarc', 'apoc', 'bpsc', 'pnsc', 'rpoc'};
decimalFolders = {'0.1818', '0.3333', '0.5714'};
strategyFolders = {'q0p1500', 'q1500p0', 'q1000p1000'};

% Loop through each main folder
for m = 1:length(mainFolders)
    % Print main folder name in uppercase for consistency
    fprintf('%s:\n', upper(mainFolders{m}));
    
    % Loop through each decimal folder within the main folder
    for d = 1:length(decimalFolders)
        % Initialize the line with the decimal folder followed by a separator
        outputLine = sprintf('%s | ', decimalFolders{d});
        
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
            
            % Append the formatted string for the current strategy folder to the output line
            % Format: <strategy> : A = <ativo_rows> R = <reativo_rows>
            outputLine = [outputLine, sprintf('%s : A = %d R = %d | ', strategyFolders{s}, rowsAtivo, rowsReativo)];
        end
        
        % Remove the trailing " | " from the output line
        if length(outputLine) >= 3
            outputLine = outputLine(1:end-3);
        end
        
        % Print the line for the current decimal folder
        fprintf('%s\n', outputLine);
    end
    % Add a blank line for better readability between main folders
    fprintf('\n');
end

% --- Symbolic Setup ---
syms L C R RL v i vg vg_ref v_ref fs
K = [L 0; 0 C];
A1 = [-R 0; 0 -1/RL];
A2 = [-R -1; 1 -1/RL];
D_sym = v_ref/vg_ref;
D_linha_sym = (1 - D_sym);

% Calculate symbolic averaged matrices
A_sym = D_sym * A1 + D_linha_sym * A2;
B_sym = D_sym * B1 + D_linha_sym * B2;

% Calculate symbolic Quiescent Operating Point
U_sym = [vg_ref];
X_sym = -inv(A_sym)*B_sym*U_sym;

% Calculate the symbolic Duty Cycle Input Matrix F
F_sym = (A1 - A2)*X_sym + (B1 - B2)*U_sym;

% Form the symbolic Standard State and Input Matrices
A_std_sym = inv(K) * A_sym;
B_std_sym = inv(K) * F_sym;

% Define symbolic Desired Pole Locations
p_sym = [-fs/10, -fs/10];

% --- Numerical Substitution and Calculation ---
fprintf('--- Substituting Numerical Values ---\n');

% Define new numerical values
N = 3;
P_ref = 3000;
vg_ref_val = 200;
v_ref_val = 500;
L_val = (4/N)*1e-3;
C_val = 14e-3;
R_val = 0.55/N;
RL_val = (v_ref_val^2)/P_ref;
fs_val = 9e3;

% Create lists of symbolic variables and numerical values for substitution
sym_vars = {vg_ref, v_ref, L, C, R, RL, fs};
num_vals = {vg_ref_val, v_ref_val, L_val, C_val, R_val, RL_val, fs_val};

% Substitute values into the symbolic matrices and convert to double
A_std_num = double(subs(A_std_sym, sym_vars, num_vals));
B_std_num = double(subs(B_std_sym, sym_vars, num_vals));
p_num = double(subs(p_sym, sym_vars, num_vals));

%% Final Step: Calculate the Numerical Gain Matrix using 'acker'
fprintf('--- Calculating Final Numerical Gain Matrix ---\n');

% Use acker() instead of place() for repeated poles in single-input systems
K_gain_num = acker(A_std_num, B_std_num, p_num);

fprintf('Calculated Numerical Gain Matrix (K_gain):\n');
disp(K_gain_num);
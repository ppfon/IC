selec = SELECAO;

switch (selec) {

    case 2: // AARC
    kp_pos = 1; kp_neg = 1; kq_pos = 1; kq_neg = 1;
    break;

    case 3: // PNSC
    kp_pos = 1; kp_neg = -1; kq_pos = 1; kq_neg = -1;
    break;

    case 4: // BPSC
    kp_pos = 1; kp_neg = 0; kq_pos = 1; kq_neg = 0;
    break;

    case 5: // APOC 
    kp_pos = 1; kp_neg = -1; kq_pos = 1; kq_neg = 1;
    break;

    case 6: // RPOC
    kp_pos = 1; kp_neg = 1; kq_pos = 1; kq_neg = -1;
    break;
}

omega = 2*PI*60;

termo1 = ( (kp_pos + kp_neg) * P_ref) / (kp_pos + kp_neg * u * u);
termo2 = ( (kq_pos - kq_neg) * Q_ref) / (kq_pos + kq_neg * u * u);

p_mag = u * sqrt( termo1 * termo1 + termo2 * termo2);

termo3 = ( (kq_pos + kq_neg) * Q_ref) / (kq_pos + kq_neg * u * u);
termo4 = ( (kp_pos - kp_neg) * P_ref) / (kp_pos + kp_neg * u * u);

q_mag = u * sqrt( termo3 * termo3 + termo4 * termo4);

// Instantâneo

termo5 = ( (kp_pos + kp_neg) * v_pos_mod * v_neg_mod * cos(2 * omega * tempo + theta_pos - theta_neg) * P_ref )
        / (kp_pos * v_pos_mod * v_pos_mod + kp_neg * v_neg_mod * v_neg_mod);

termo6 = ( (kq_pos - kq_neg) * v_pos_mod * v_neg_mod * sin(2 * omega * tempo + theta_pos - theta_neg) * Q_ref )
        / (kq_pos * v_pos_mod * v_pos_mod + kq_neg * v_neg_mod * v_neg_mod);

p_inst = termo5 + termo6;

termo7 = ( (kq_pos + kq_neg) * v_pos_mod * v_neg_mod * cos(2 * omega * tempo + theta_pos - theta_neg) * Q_ref )
        / (kq_pos * v_pos_mod * v_pos_mod + kq_neg * v_neg_mod * v_neg_mod);

termo8 = ( (kp_pos - kp_neg) * v_pos_mod * v_neg_mod * sin(2 * omega * tempo + theta_pos - theta_neg) * P_ref )
        / (kp_pos * v_pos_mod * v_pos_mod + kp_neg * v_neg_mod * v_neg_mod);

q_inst = termo7 - termo8;

Output(0) = p_mag;
Output(1) = q_mag;
Output(2) = p_inst;
Output(3) = q_inst;
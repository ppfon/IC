//..............Contador Para a interrupção e PWM
count = count + inc;

if(count == PRD) inc = -1;
if(count == 0) inc = 1;

//............................................................Interrupção........................................................................................................
if(count == PRD)
{
  Vdc1 = Vdc_ref * (Iref1 * Vb1 / (Iref1 * Vb1 + Iref2 * Vb2));
  Vdc2 = Vdc_ref * (Iref2 * Vb2 / (Iref1 * Vb1 + Iref2 * Vb2));
  if (mode == 1)
  {
    t1 = 1;
    t2 = 0;
    b1 = 0;
    b2 = 1;
  }

  if (mode == 2)
  {
    t1 = 0;
    t2 = 0;
    b1 = 1;
    b2 = 0;
  }
}

Output(0) = t1;
Output(1) = t2;
Output(2) = b1;
Output(3) = b2;
Output(4) = Vdc1;
Output(5) = Vdc2;
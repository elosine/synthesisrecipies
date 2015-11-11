(
SynthDef(\chippy, {
	arg pitch = 60, t_tr=1, dur=0.25, h1=3, h2=5, amp=1;
	var freq,sig, env;
	freq = pitch.midicps;
	env = EnvGen.ar( Env.perc(0.01, dur), t_tr );
	sig = AY.ar( AY.freqtotone(freq), AY.freqtotone(freq*h1), AY.freqtotone(freq*h2), 0.25,3,15,10,7);
	Out.ar(0, sig*env*amp);
}).add;
)
h = [2,3,4,5, 6];
a = Synth(\chippy, [\pitch, 60, \dur, 0.25, \t_tr, 1, \h1, h.choose, \h2, h.choose]);
a.set(\pitch, 60, \dur, 0.25, \t_tr, 1, \h1, h.choose, \h2, h.choose); //c
a.set(\pitch, 55, \dur, 0.25, \t_tr, 1, \h1, h.choose, \h2, h.choose); //g
a.set(\pitch, 52, \dur, 0.25, \t_tr, 1, \h1, h.choose, \h2, h.choose); //e
a.set(\pitch, 57, \dur, 0.25, \t_tr, 1, \h1, h.choose, \h2, h.choose);//a
a.set(\pitch, 59, \dur, 0.25, \t_tr, 1, \h1, h.choose, \h2, h.choose);//b
a.set(\pitch, 58, \dur, 0.25, \t_tr, 1, \h1, h.choose, \h2, h.choose);//a#
a.set(\pitch, 57, \dur, 0.25, \t_tr, 1, \h1, h.choose, \h2, h.choose);//a
a.set(\pitch, 55, \dur, 0.25, \t_tr, 1, \h1, h.choose, \h2, h.choose);//g
a.set(\pitch, 64, \dur, 0.25, \t_tr, 1, \h1, h.choose, \h2, h.choose);//e
a.set(\pitch, 67, \dur, 0.25, \t_tr, 1, \h1, h.choose, \h2, h.choose);//g
a.set(\pitch, 69, \dur, 0.25, \t_tr, 1, \h1, h.choose, \h2, h.choose);//a
a.set(\pitch, 65, \dur, 0.25, \t_tr, 1, \h1, h.choose, \h2, h.choose);//f
a.set(\pitch, 67, \dur, 0.25, \t_tr, 1, \h1, h.choose, \h2, h.choose);//g
a.set(\pitch, 64, \dur, 0.25, \t_tr, 1, \h1, h.choose, \h2, h.choose);//e
a.set(\pitch, 60, \dur, 0.25, \t_tr, 1, \h1, h.choose, \h2, h.choose);//c
a.set(\pitch, 62, \dur, 0.25, \t_tr, 1, \h1, h.choose, \h2, h.choose);//e
a.set(\pitch, 59, \dur, 0.25, \t_tr, 1, \h1, h.choose, \h2, h.choose);//b

{SinOsc.ar()}.play



(
SynthDef( \synthbass,{
	arg gate=1, atk=0.01, rel=0.07, crv= -6,
	fatk=0.01, fdky=0.14, fsus=0.1, frel=0.07, fcrv= 0,
	ffrq1=1800, rq1=0.6, dky=0, sus=1;
	var freq1, osc1, vol, amp, env,
	osc2, osc3, freq2, freq3,
	sig, pitch, fenv, sigR;
	pitch = \pitch.kr(60, 0.017);
	freq1 = pitch.midicps;
	freq2 = (pitch+0.06).midicps;
	freq3 = (pitch-12).midicps;
	amp = \amp.kr(0.85, 0.040);
	env = EnvGen.ar( Env.adsr(atk, dky, sus, rel, curve:crv), gate, doneAction:2);
	fenv = EnvGen.ar( Env.adsr(fatk, fdky, fsus, frel, curve:fcrv), gate);
	osc1 = SawDPW.ar(freq1);
	osc2 = SawDPW.ar(freq2);
	osc3 = SinOsc.ar(freq3);
	sig = Mix.ar([osc1, osc2, osc3]);
	sig = RLPF.ar( sig, (ffrq1*fenv)+80, rq1 );
	sig = sig.softclip;
	sigR = DelayC.ar(sig, 0.2, 0.03);
	Out.ar(0, [sig, sigR]*env*amp);
}).add;
)
a = Synth(\synthbass);
a.set(\gate, 1, \pitch, 53);
a.set(\gate, 0);

a.free;

t = TempoClock(101/60);

(
Pbind(
	\instrument, \synthbass,
	\pitch, Pseq( [39, 51, 49, 51, 39, 42, 44, 46, 49, 46, 49, 51, 39, 51, 49, 51, 51, 58, 54, 51, \rest ], 4),
	\dur, Pseq( [0.5, 0.5, 0.25, 0.5, 0.25, 0.25, 0.25, 0.25, 0.5, 0.25, 0.25, 0.25, 0.5, 0.5, 0.25, 0.5, 0.25, 0.5, 0.5, 0.5, 0.5 ], 4 ),
	\amp, Pseq([0.45],inf)
).play(t);

)
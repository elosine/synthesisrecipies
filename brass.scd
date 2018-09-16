//Link to tutorial
// https://www.propellerheads.se/blog/thor-demystified-13-an-introduction-to-filters
(
SynthDef(\brass, {
	arg freq=260, gate=1, amp=0.85,
	ffreq=15000, res=0.2;
	var sig, env, fenv, lfo1;
	lfo1 = SinOsc.ar(60).range(14200, 15700);
	fenv = EnvGen.ar( Env.adsr( 0.08, 0.03, 0.7, 0.08, curve:0), gate);
	env = EnvGen.ar( Env.adsr(0.005, 0, 1, 0.005, curve:0), gate, doneAction:2);
	sig = Saw.ar(freq);
	sig = MoogLadder.ar( sig, lfo1*fenv, res);
	sig = JPverb.ar(sig, 0.8, 0, 0.5);
	Out.ar(0, sig*env*amp);
}).add
)

a = Synth(\brass);
a.set(\gate, 0, \ffreq, 5000);
a.set(\gate, 0);

t = TempoClock(101/60);
(
Pbind(
	\instrument, \brass,
	\midinote, Pseq( [39, 51, 49, 51, 39, 42, 44, 46, 49, 46, 49, 51, 39, 51, 49, 51, 51, 58, 54, 51, \rest ], 8),
	\ctranspose, 24,
	\dur, Pseq( [0.5, 0.5, 0.25, 0.5, 0.25, 0.25, 0.25, 0.25, 0.5, 0.25, 0.25, 0.25, 0.5, 0.5, 0.25, 0.5, 0.25, 0.5, 0.5, 0.5, 0.5 ], 8 ),
	\amp, Pseq([0.8],inf)
).play(t)
)
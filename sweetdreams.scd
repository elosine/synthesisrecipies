s.options.memSize = 81920;
s.options.numOutputBusChannels = 8;
s.options.numInputBusChannels = 8;
(
SynthDef( \eurythmics, {
	arg pitch=60, amp=0.9, gate=1;
	var osc1, osc2, pitch2, sig, env, lfo;
	lfo = SinOsc.kr( TRand.kr(3, 5, gate) ).range(0.1, 0.1.neg);
	env = EnvGen.ar( Env.adsr(0.08, 0, 1, 0.2, curve: 2.neg), gate, doneAction:2);
	pitch2 = pitch + 0.07 +lfo;
	pitch = pitch + lfo;
	osc1 = SawDPW.ar( pitch.midicps );
	osc2 = SawDPW.ar( pitch2.midicps );
	sig = Mix.ar( [osc1, osc2] );
	sig = JPverb.ar( sig, 0.4, 0.5, 0.5);
	// Out.ar(0, [sig, DelayC.ar(sig, 0.2, 0.02)]*env*amp);
 Out.ar(0, sig*env*amp);

}).add;
)

t = TempoClock(128/60);
(
Pbind(
	\instrument, \eurythmics,
	\pitch, Pseq( [ 36, 36, 60, 60, 51, 63, 48, 60, 44, 44, 56, 60, 43, 43, 55, 60  ], 32),
	\dur, Pseq( [0.5], inf),
).play(t);
)
s.meter
{Out.ar(2, [SoundIn.ar(0), SoundIn.ar(1)])}.play

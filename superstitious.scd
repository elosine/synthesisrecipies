(
SynthDef( \wonder, {
	arg freq=440, gate=1,
	predelay=0.01, speed= 0.005, depth=0.03, ph_diff=0.5, //0.03
	amp=0.5, och=0,
	atk=0.001, sus=0.4, rel=0.03, pluckamp=4;
	var sig, env, modulators, numDelays = 12, sigd, pluck, coef;
	var s2del = TRand.kr(0.05, 0.07, gate); //0.07
	var hpf = TRand.kr(1650, 1750, gate); //1700
	var lpf = TRand.kr(3500, 4500, gate); //4000
	var decay = TRand.kr(0.08, 0.11, gate);//0.1
	env = EnvGen.ar( Env.adsr(atk,decay, sus, rel), gate, doneAction:2);
	sig = Pulse.ar( freq, 0.29);
	sig = RHPF.ar(sig, hpf, 0.8);
	sig = RLPF.ar(sig, lpf, 0.8);
	// pluck = Pluck.ar( WhiteNoise.ar(0.2), gate, (freq*2).reciprocal, (freq*2).reciprocal, rel*24, 0.1);
	coef = TRand.kr(0.01, 0.06, gate);
	pluck = Pluck.ar( WhiteNoise.ar(0.1)+sig, gate, freq.reciprocal, freq.reciprocal, rel*24, coef);
	sigd = DelayC.ar(sig, 0.2, s2del);

	sig = sig*numDelays.reciprocal;
	modulators = Array.fill( numDelays, { arg i;
		LFPar.kr( speed * rrand(0.94, 1.06), ph_diff * i, depth, predelay )
	});
	sig = DelayC.ar(sig, 0.5, modulators);
	sig = sig.sum;

	sig = Decimator.ar( (sig+sigd), 44100, 6 );
	sig = (pluck*pluckamp)+sig;
	// Out.ar(och, sig*env*amp);
	Out.ar(0, [ sig , DelayC.ar( sig, 0.2, 0.02)]*env*amp);
	// Out.ar(0, [ pluck , DelayC.ar( pluck, 0.2, 0.02)]*env*amp);
}).add;
)

t = TempoClock(101/60);
(
{
	Pbind(
		\instrument, \wonder,
		\midinote, Pseq( [56, 58, \rest, 61, \rest, 63, \rest ], 1),
		\ctranspose, -12,
		\dur, Pseq([0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25 ], 1),
		\amp, Pseq([ 1], inf)
	).play(t);

	1.75.wait;

	Pbind(
		\instrument, \wonder,

		\midinote, Pseq( [
			51,  63, \rest, 61, \rest, 63, \rest, 66, \rest, 61, \rest, 58, 61, 63,
			56, \rest, 58, \rest, 61, \rest, 63, \rest, 66, \rest, 61, \rest, 58, 61, 63 ,

			51,  63, \rest, 61, \rest, 63, \rest, 66, \rest, 61, \rest, 58, 61, 63,
			56, \rest, 58, \rest, 61, \rest, 63, \rest, 66, \rest, 61, \rest, 58, 61, 63 ], 8),

		\ctranspose, -12,

		\dur, Pseq([
			0.5, 0.25, 0.25/*r*/, 0.25, 0.25/*r*/, 0.25, 0.25/*r*/, 0.25, 0.5/*r*/, 0.25, 0.25/*r*/, 0.25, 0.25, 0.25,
			0.25, 0.25/*r*/, 0.25, 0.25/*r*/, 0.25, 0.25/*r*/, 0.25, 0.25/*r*/, 0.25, 0.5/*r*/, 0.25, 0.25/*r*/, 0.25, 0.25, 0.25,

			0.5, 0.25, 0.25/*r*/, 0.25, 0.25/*r*/, 0.25, 0.25/*r*/, 0.25, 0.5/*r*/, 0.25, 0.25/*r*/, 0.25, 0.25, 0.25,
			0.25, 0.25/*r*/, 0.25, 0.25/*r*/, 0.25, 0.25/*r*/, 0.25, 0.25/*r*/, 0.25, 0.5/*r*/, 0.25, 0.25/*r*/, 0.25, 0.25, 0.25 ], 8),

		\amp, Pseq([ 1], inf)

	).play(t);

	Pbind(
		\instrument, \wonder,

		\midinote, Pseq([
			\rest, 58, 60, 61, 60, 58, \rest, 58, 60, \rest, 58
		], 1),

		\ctranspose, -12,

		\dur, Pseq([
			0.667/*r*/, 0.667, 0.667, 0.667, 0.667, 0.667, 2/*r*/, 0.33, 0.33, 0.18/*r*/, 0.5
		], 1),

		\amp, Pseq([0.25], inf),
		\och, Pseq([0], inf)

	).play(t);


}.fork(t)
)

t = TempoClock(101/60);

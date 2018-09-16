(
s.options.memSize = 81920;
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
	env = EnvGen.ar( Env.adsr(atk, dky, sus, rel, curve:crv), gate );
	fenv = EnvGen.ar( Env.adsr(fatk, fdky, fsus, frel, curve:fcrv), gate, doneAction:2);
	osc1 = SawDPW.ar(freq1);
	osc2 = SawDPW.ar(freq2);
	osc3 = SinOsc.ar(freq3);
	sig = Mix.ar([osc1, osc2, osc3]);
	sig = RLPF.ar( sig, (ffrq1*fenv)+80, rq1 );
	sig = sig.softclip;
	sigR = DelayC.ar(sig, 0.2, 0.03);
	Out.ar(0, [sig, sigR]*env*amp);
}).add;

SynthDef(\brass, {
	arg freq=260, gate=1, amp=0.85,
	ffreq=15000, res=0.5;
	var sig, env, fenv, lfo1;
	lfo1 = SinOsc.ar(60).range(14200, 15700);
	fenv = EnvGen.ar( Env.adsr( 0.08, 0.03, 0.7, 0.08, curve:0), gate);
	env = EnvGen.ar( Env.adsr(0.005, 0, 1, 0.005, curve:0), gate, doneAction:2);
	sig = Saw.ar(freq);
	sig = MoogLadder.ar( sig, lfo1*fenv, res);
	sig = JPverb.ar(sig, 0.8, 0, 0.5);
	Out.ar(0, sig*env*amp);
}).add;

~wtb1  = Buffer.read(s, "/Users/yangj14/Documents/GitHub/synthesisrecipies/WavetableSynthesis/wavetables/WT7.aif");
~wtb2 = Buffer.read(s, "/Users/yangj14/Documents/GitHub/synthesisrecipies/WavetableSynthesis/wavetables/WT10.aif");

SynthDef( \lead, {
	arg gate=1, atk=0.03, rel=0.2, crv = 0,
	ffreqhi=15000, ffreqlo=100,
	fatk=0.01, fdecay= 1.2, fsusl=0.18, frel=1, fcrv= -2,
	osamp1=0.5, osamp2=0.5, osamp3=1,
	detune1= -0.08, detune2= 0.08, detune3=0.02,
	lfo1w=3, lfo1freq=45, lfo2freq = 6, lfo3freq = 0.1,
	glide=0.7, wtbuf, offset=0.65;
	var osc1, freq1, pitch1;
	var osc2, freq2, pitch2;
	var osc3, freq3, pitch3;
	var pitch, amp;
	var sig, sig2;
	var env, fenv;
	var lfo1, lfo2, lfo3;
	//Envelopes
	env = EnvGen.ar( Env.asr(atk, 1, rel, crv), gate, doneAction:2 );
	fenv = EnvGen.ar( Env.adsr(fatk, fdecay, fsusl, frel, curve:fcrv), gate );
	//lfos
	lfo1 = SinOsc.kr(lfo1freq*fenv);
	lfo2 = SinOsc.kr(lfo2freq);
	lfo3 = SinOsc.kr(lfo3freq);
	//Pitch/Frequency/Amp
	pitch = \pitch.kr(60, glide);
	pitch1 = pitch + (lfo2*detune1);
	pitch2 = pitch + (lfo2*detune2);
	pitch3 = pitch + (lfo3*detune3);
	freq1 = pitch.midicps;
	freq2 = pitch2.midicps;
	freq3 = pitch3.midicps;
	amp = \amp.kr(0.85, 0.017);
	//Oscillators
	osc1 = Saw.ar(freq1);
	osc2 = Saw.ar(freq2);
	osc3  = VOsc3.ar(wtbuf+offset, freq3, freq3+0.37, freq3+0.43, 0.3333);
	//Mix-Filter-Make Stereo
	sig = Mix.ar( [osc1*osamp1, osc2*osamp2, osc3*osamp3] );
	sig = RLPF.ar(sig, (((ffreqhi*fenv)+ffreqlo).cpsmidi+(lfo1*lfo1w)).midicps );
	sig2 = DelayC.ar(sig, 0.2, 0.05);
	Out.ar(0, [sig, sig2]*amp*env);
}).add;

)



t = TempoClock(101/60);
(
{
	Pbind(
		\instrument, \synthbass,
		\pitch, Pseq( [ \rest, 42, 39, 37], 1),
		\dur, Pseq( [0.25, 0.5, 0.5, 0.5], 1 ),
		\amp, Pseq([0.45], inf)
	).play(t);

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
			56, \rest, 58, \rest, 61, \rest, 63, \rest, 66, \rest, 61, \rest, 58, 61, 63 ], 6),
		\ctranspose, -12,
		\dur, Pseq([
			0.5, 0.25, 0.25/*r*/, 0.25, 0.25/*r*/, 0.25, 0.25/*r*/, 0.25, 0.5/*r*/, 0.25, 0.25/*r*/, 0.25, 0.25, 0.25,
			0.25, 0.25/*r*/, 0.25, 0.25/*r*/, 0.25, 0.25/*r*/, 0.25, 0.25/*r*/, 0.25, 0.5/*r*/, 0.25, 0.25/*r*/, 0.25, 0.25, 0.25,

			0.5, 0.25, 0.25/*r*/, 0.25, 0.25/*r*/, 0.25, 0.25/*r*/, 0.25, 0.5/*r*/, 0.25, 0.25/*r*/, 0.25, 0.25, 0.25,
			0.25, 0.25/*r*/, 0.25, 0.25/*r*/, 0.25, 0.25/*r*/, 0.25, 0.25/*r*/, 0.25, 0.5/*r*/, 0.25, 0.25/*r*/, 0.25, 0.25, 0.25 ], 6),
		\amp, Pseq([ 1], inf)
	).play(t);

	Pbind(
		\instrument, \synthbass,
		\pitch, Pseq( [39, \rest, 39, \rest, 39, \rest, 39, \rest, 39, \rest, 39, \rest, 39,  42, 39, 37], 8),
		\dur, Pseq( [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5], 8 ),
		\amp, Pseq([0.45],inf)
	).play(t);

	16.wait;

	//Clav 2
	Pbind(
		\instrument, \wonder,
		\midinote, Pseq([
			\rest, 58, 60, 61, 60, 58, \rest, 58, 60, \rest, 58, \rest
		], 10),
		\ctranspose, -12,
		\dur, Pseq([
			// 0.667/*r*/, 0.667, 0.667, 0.667, 0.667, 0.667, 2/*r*/, 0.33, 0.33, 0.25/*r*/, 0.5, 0.5
			0.667/*r*/, 0.667, 0.667, 0.667, 0.667, 0.667, 2/*r*/, 0.33, 0.33, 0.33, 0.5, 0.5
		], 10),
		\amp, Pseq([0.45], inf),
		\och, Pseq([0], inf)
	).play(t);

	14.wait;

	Pbind(
		\instrument, \lead,
		\pitch, Pseq( [73, 75, 75, 73, 78, 75, \rest, 75, 73, 70, 66, 68, 66, \rest], 4),
		\dur, Pseq( [0.5, 0.5, 0.5, 0.25, 0.5, 3.25, 2.5, 0.5, 0.5, 0.5, 0.25, 0.5, 3.25,2.5 ], 4 ),
		\amp, Pseq([0.55],inf),
		\res, Pseq([0.05], inf),
		\amp, Pseq([0.3], inf)
	).play(t);

	34.wait;

	Pbind(
		\instrument, \synthbass,
		\pitch, Pseq( [39, 51, 49, 51, 39, 42, 44, 46, 49, 46, 49, 51, 39, 51, 49, 51, 51, 58, 54, 51, \rest ], 4),
		\dur, Pseq( [0.5, 0.5, 0.25, 0.5, 0.25, 0.25, 0.25, 0.25, 0.5, 0.25, 0.25, 0.25, 0.5, 0.5, 0.25, 0.5, 0.25, 0.5, 0.5, 0.5, 0.5 ], 4 ),
		\amp, Pseq([0.45],inf)
	).play(t);

	Pbind(
		\instrument, \brass,
		\midinote, Pseq( [39, 51, 49, 51, 39, 42, 44, 46, 49, 46, 49, 51, 39, 51, 49, 51, 51, 58, 54, 51, \rest ], 4),
		\ctranspose, 24,
		\dur, Pseq( [0.5, 0.5, 0.25, 0.5, 0.25, 0.25, 0.25, 0.25, 0.5, 0.25, 0.25, 0.25, 0.5, 0.5, 0.25, 0.5, 0.25, 0.5, 0.5, 0.5, 0.5 ], 4 ),
		\amp, Pseq([0.55],inf),
		\res, Pseq([0.2], inf)
	).play(t);

	Pbind(
		\instrument, \brass,
		\midinote, Pseq( [39, 51, 49, 51, 39, 42, 44, 46, 49, 46, 49, 51, 39, 51, 49, 51, 51, 58, 54, 51, \rest ], 4),
		\ctranspose, 24,
		\dur, Pseq( [0.5, 0.5, 0.25, 0.5, 0.25, 0.25, 0.25, 0.25, 0.5, 0.25, 0.25, 0.25, 0.5, 0.5, 0.25, 0.5, 0.25, 0.5, 0.5, 0.5, 0.5 ], 4 ),
		\amp, Pseq([0.55],inf),
		\res, Pseq([0.05], inf)
	).play(t)

}.fork(t)
)

t = TempoClock(101/60);

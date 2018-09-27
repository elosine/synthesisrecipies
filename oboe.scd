(
SynthDef(\holliger, {
	arg gate=1, pitch=72, amp=0.5;
	var sig, env, fsig1, fsig2, freq, noise, venv, vfreqenv, vibrato;
	freq = pitch.midicps;
	//this fades in the vibrato so the initial attack and first part of the note has no vibrato and it kicks in after
	venv = EnvGen.ar(Env.asr( 0.6, 1, 0.03, 5), gate);
	//this speeds up the vibrato (needs tweeking)
	vfreqenv = EnvGen.ar(Env.asr( 0.9, 1, 0.03, 2), gate).range(0, 7);
	env = EnvGen.ar( Env.adsr( 0.2, 0, 1, 0.1), gate, doneAction:2);
	// Oscillator: pulse, width = 85-90%
	sig = Pulse.ar( freq, 0.88, 0.1 );
	//oboes have formants at 1100Hz, the bwfreq argument determines the number of harmonics to include in this case 4
	//Formants are resonant frequencies that are static and don't necessarily change with pitch
	fsig1 = Formant.ar( freq, 1100, freq*4);
	 fsig2 = Formant.ar( freq, 3000, freq*4);
	//play with the mix of these three oscillators
	sig = Mix.ar([sig*0.5, fsig1*0.5, fsig2*0.35]);
	//I like this filter play with the 'q' and 'saturation, values; the 2 in the mode arg gives you a band pass filter
	sig = BMoog.ar( sig, 1700, 0.8, 2, 0.2 );
	//Add a little filtered noise for breath sound
noise = DFM1.ar( WhiteNoise.ar(0.1), 1500, 0.9, 0.5, 0, 0.0002);
	sig = Mix.ar([ sig, noise*0.5]);
	//add amplitude modulation vibrato; unlike string instruments, double reeds can't alter pitch with embouchure so they alter volume with breath; this starts at volume 0.5 and adds up to 0.2 in volume, can tweek this number to get more/less depth
	vibrato = 0.5 + (LFTri.ar(vfreqenv).range(0, 0.2) * venv);
	sig = sig*vibrato; //multiply to get amplitude change
	//stereoize and add reverb, if you don't want reverb just Haas
	sig = [ sig, DelayC.ar( sig, 0.2, 0.02) ];
	Out.ar(0, sig*env*amp);
}).add;
)
a = Synth(\holliger, [\pitch,78, \gate, 1]);

t = TempoClock.new(96/60);
(
Pbind(
	\instrument, \holliger,
	\pitch, Pseq( [72, 65, 67, 68, 70, 72, 68, 72, 68, 72, 65, 68, 65, 61, 68, 65], 4),
	\dur, Pseq( [2, 0.5, 0.5, 0.5, 0.5, 1.5, 0.5, 1.5, 0.5, 1.5, 0.5, 0.5, 0.5, 0.5, 0.5, 4], 4 )
).play(t);
)
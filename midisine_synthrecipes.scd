
/*1*/ s.boot;

(///2////
SynthDef( \midisine,{
	arg trig=0, atk=0.01, rel=0.1, crv= -3;
	var freq, synth, vol, pitch, amp, env;
	pitch = \pitch.kr(60, 0.017);
	amp = \amp.kr(0.85, 0.017);
	freq = pitch.midicps;
	env = EnvGen.ar( Env.asr(atk, 1, rel, crv), trig );
	synth = SinOsc.ar(freq);
	Out.ar(0, synth*env*amp);
}).add;

SynthDef( \synthbass,{
	arg trig=0, atk=0.01, rel=0.07, crv= -6,
	fatk=0.01, fdky=0.14, fsus=0.1, frel=0.07, fcrv= 0,
	ffrq1=1800, rq1=0.9, dky=0, sus=1;
	var freq1, osc1, vol, amp, env,
	osc2, osc3, freq2, freq3,
	sig, pitch, fenv, sigR;
	pitch = \pitch.kr(60, 0.017);
	freq1 = pitch.midicps;
	freq2 = (pitch+0.06).midicps;
	freq3 = (pitch-12).midicps;
	amp = \amp.kr(0.85, 0.040);
	env = EnvGen.ar( Env.adsr(atk, dky, sus, rel, curve:crv), trig );
	fenv = EnvGen.ar( Env.adsr(fatk, fdky, fsus, frel, curve:fcrv), trig);
	osc1 = SawDPW.ar(freq1);
	osc2 = SawDPW.ar(freq2);
	osc3 = SinOsc.ar(freq3);
	sig = Mix.ar([osc1, osc2, osc3]);
	sig = RLPF.ar( sig, (ffrq1*fenv)+80, rq1 );
	sig = sig.softclip;
	sigR = DelayC.ar(sig, 0.2, 0.03);
	Out.ar(0, [sig, sigR]*env*amp);
}).add;

SynthDef( \lead, {
	arg trig=0, atk=0.03, rel=1.5, crv = 0,
	ffreqhi=15000, ffreqlo=100,
	fatk=0.01, fdecay= 1.2, fsusl=0.18, frel=1, fcrv= -2,
	osamp1=0.5, osamp2=0.5, osamp3=1,
	detune1= -0.08, detune2= 0.08, detune3=0.02,
	lfo1w=3, lfo1freq=45, lfo2freq = 6, lfo3freq = 0.1,
	glide=0.7;
	var osc1, freq1, pitch1;
	var osc2, freq2, pitch2;
	var osc3, freq3, pitch3;
	var pitch, amp;
	var sig, sig2;
	var env, fenv;
	var lfo1, lfo2, lfo3;
	//Envelopes
	env = EnvGen.ar( Env.asr(atk, 1, rel, crv), trig );
	fenv = EnvGen.ar( Env.adsr(fatk, fdecay, fsusl, frel, curve:fcrv), trig );
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
	osc3  = VOsc3.ar(4.8, freq3, freq3+0.37, freq3+0.43, 0.3333);
	//Mix-Filter-Make Stereo
	sig = Mix.ar( [osc1*osamp1, osc2*osamp2, osc3*osamp3] );
	sig = RLPF.ar(sig, (((ffreqhi*fenv)+ffreqlo).cpsmidi+(lfo1*lfo1w)).midicps );
	sig2 = DelayC.ar(sig, 0.2, 0.05);
	Out.ar(0, [sig, sig2]*amp*env);
}).add;

OSCdef( \trig, {|msg| ~mt.set(\trig, msg[1].asFloat)}, "/trig" );
OSCdef( \pitch, {|msg| ~mt.set(\pitch, msg[1].asFloat)}, "/pitch" );
OSCdef( \amp, {|msg| ~mt.set(\amp, msg[1].asFloat)}, "/amp" );

)

/*3*/ ~mt = Synth(\lead);

~mt.free;


(
SynthDef(\seanpuffy, {
	arg pitch=60, del=0.003, decay=0.3;
	var sig;
	sig = SawDPW.ar( pitch.midicps);
	sig = CombC.ar( sig, 1, del, decay);
	Out.ar( 0, sig );
}).add;
)

a = Synth(\seanpuffy);
//adjust it manually to find the low and high range you would like
a.set(\del, 0.0013, \decay, 0.3);

//Time varying
(
SynthDef(\seanpuffy, {
	arg pitch=60, del=0.003, decay=0.3, lfreq=0.05;
	var sig, lfo;
	lfo = SinOsc.kr( lfreq ).range(0.0013, 0.0045);
	sig = SawDPW.ar( pitch.midicps);
	sig = CombC.ar( sig, 1, lfo, decay);
	Out.ar( 0, sig );
}).add;
)

a = Synth(\seanpuffy);
a.set(\lfreq, 0.5);

//try different sources like two saw waves or some other harmonic rich source

(
SynthDef(\seanpuffy, {
	arg pitch=60, del=0.003, decay=0.3, lfreq=0.05;
	var sig, lfo;
	lfo = SinOsc.kr( lfreq ).range(0.0013, 0.0045);
	sig = SawDPW.ar( pitch.midicps) + SawDPW.ar( (pitch+0.03).midicps) ;
	sig = CombC.ar( sig, 1, lfo, decay);
	Out.ar( 0, sig );
}).add;
)

a = Synth(\seanpuffy);
a.set(\lfreq, 0.5);

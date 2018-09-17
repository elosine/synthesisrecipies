(
SynthDef(\chippy, {
	arg pitch = 60, t_tr=1, len=0.25,amp=1;
	var freq, sig, env, h1, h2;
	freq = pitch.midicps;
	h1 = TIRand.kr(2, 7, Impulse.kr(4));
	h2 = TIRand.kr(2, 7, Impulse.kr(4));
	env = EnvGen.ar( Env.perc(0.01, len), t_tr, doneAction:2 );
	sig = AY.ar( AY.freqtotone(freq), AY.freqtotone(freq*h1), AY.freqtotone(freq*h2), 0.25,3,15,10,7);
	Out.ar(0, [sig, DelayC.ar(sig, 0.2, 0.015)]*env*amp);
}).add;
)

t = TempoClock(88/60);
(
{

	Pbind( //Bass
		\instrument, \chippy,
		\pitch,  Pseq( [ [38, 50] ], 6 ),
		\dur,  Pseq ( [8], inf),
		\len,  Pseq ( [8], inf)
	).play(t);

	Pbind( //Piano Right Hand
		\instrument, \chippy,
		\pitch,  Pseq( [ [ 64/*e*/, 66/*F#*/, 69/*A*/ ] , [64, 66, 69], 57/*A*/, [64, 66, 69], [64, 66, 69], 57], 9),
		\dur,  Pseq ( [ 1, 0.5, 0.5, 1, 0.5, 0.5 ], 9),
		\len,  Pseq ( [ 1, 0.5, 0.5, 1, 0.5, 0.5 ], 9)
	).play(t);

	Pbind( //Piccolo High Strings 1
		\instrument, \chippy,
		\pitch,  Pseq( [ \rest, 78 /*F#*/, 79, 76, 78, 74, 69, \rest, 78 /*F#*/, 79, 76, 78, 74, 81], 2),
		\dur,  Pseq ( [ 2,  0.5, 0.5, 0.5, 0.5, 2, 2, 2,  0.5, 0.5, 0.5, 0.5, 2, 2], 3),
		\len,  Pseq ( [ 2,  0.5, 0.5, 0.5, 0.5, 2, 2, 2,  0.5, 0.5, 0.5, 0.5, 2, 2], 3),
		\legato, 1
	).play(t);

	32.wait;

	Pbind( //Mrs Potts
		\instrument, \chippy,
		\pitch,  Pseq( [
			\rest, 54 /*F#*/, 57 /*A*/, 61, 62 /*D*/, 55, /*G*/
			\rest, 54 /*F#*/, 57 /*A*/, 61, 62 /*D*/, 64 /*e*/

		], 1),
		\dur,  Pseq ( [ 2, 0.5, 0.5, 0.5, 0.5, 4, 2, 0.5, 0.5, 0.5, 0.5, 4], 1),
		\len,  Pseq ( [ 2, 0.5, 0.5, 0.5, 0.5, 4, 2, 0.5, 0.5, 0.5, 0.5, 4], 1),
		\legato, 1
	).play(t);

	Pbind( //Piano Right Hand
		\instrument, \chippy,

		\pitch,  Pseq( [
			\rest,
			[ 62/*D*/, 67/*G*/, 69/*A*/ ] , [62,67,69] , [62,67,69] , [62,67,69],
			[64, 66, 69],  [64, 66, 69], 57, [62, 66, 69], [62, 66, 69], 57,
			[ 62/*D*/, 67/*G*/, 69/*A*/ ] , [62,67,69] , [62,67,69] , [62,67,69],
		], 1),

		\dur,  Pseq ( [
			4,
			1, 1, 1, 1,
			1, 0.5, 0.5, 1, 0.5, 0.5,
			1,1,1,1
		], 1),

		\len,  Pseq ( [
			4,
			1, 1, 1, 1,
			1, 0.5, 0.5, 1, 0.5, 0.5,
			1,1,1,1
		], 1)
	).play(t);

	Pbind( //oboe
		\instrument, \chippy,
		\pitch,  Pseq( [
			\rest, 71 /*B*/, 73 /*C*/, 73, 74 /*D*/, 76, /*E*/
			\rest, 71, 73

		], 1),
		\dur,  Pseq ( [ 6, 0.5, 0.5, 0.5, 0.5, 2, 4, 1, 1], 1),
		\len,  Pseq ( [ 6, 0.5, 0.5, 0.5, 0.5, 2, 4, 1, 1], 1),
		\legato, 1
	).play(t);


}.fork(t);
)
t = TempoClock(88/60);

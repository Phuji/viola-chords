program chords;

type
  TSemitone = 1..12;
  TFinger = 0..6;
  TChord = set of TSemitone;
  TChordType = (ctMajor7, ctMinor7, ctDominant, ctDiminished);

const
  NOTE_NAMES: array[TSemitone] of string = ('A ', 'B♭', 'B ', 'C ', 'C#', 'D ', 'E♭', 'E ', 'F ', 'F#', 'G ', 'A♭');
  SHARPS: array[TSemitone] of string = ('A ', 'A#', 'B ', 'C ', 'C#', 'D ', 'D#', 'E ', 'F ', 'F#', 'G ', 'G#');
  FLATS: array[TSemitone] of string = ('A ', 'B♭', 'B ', 'C ', 'D♭', 'D ', 'E♭', 'E ', 'F ', 'G♭', 'G ', 'A♭');
  INCLUDE_KEY: array[TSemitone] of Boolean = (True, True, True, True, False, True, False, True, True, False, True, False);
  VIOLA_STRINGS: array[1..4] of TSemitone = (4, 11, 6, 1);
  CHORD_NAMES: array[TChordType] of string     = ('Major 7   ', 'Minor 7   ',  'Dominant  ',  'Diminished');
  CHORD_SEMITONES: array[TChordType] of TChord = ([0, 4, 7, 11], [0, 3, 7, 10], [0, 4, 7, 10], [0, 3, 6, 9]);

function NoteInChord(const Key, Note: TSemitone; const OpenString: Boolean; const Chord: TChord): string;
var
  interval: Byte;
begin
  if Note >= Key then interval := Note - Key else interval := Note - Key + 12;
  // If key has flats then use flat accidentals otherwise use sharp accidentals
  if interval in Chord then
    if (Key in [2, 7, 9, 12]) then Exit(FLATS[note]) else Exit(SHARPS[note]);

  if OpenString then Exit('x ') else Exit('| ');
end;

procedure BuildChords;
var
  rootNote, openString, note: TSemitone;
  finger: TFinger;
  chord: TChordType;
  row: string;
begin
  WriteLn('Viola Chords');
  for rootNote in TSemitone do
    if INCLUDE_KEY[rootNote] then
    begin
      WriteLn('');
      row := NOTE_NAMES[rootNote];
      for chord in TChordType do
        row := row + ' ' + CHORD_NAMES[chord];
      WriteLn(row);

      for finger in TFinger do
      begin
        row := '';
        for chord in TChordType do
        begin
          row := row + '   ';
          for openString in VIOLA_STRINGS do
          begin
            if openString + finger <= 12 then note := openString + finger else note := openString + finger - 12;
            row := row + NoteInChord(rootNote, note, finger = 0, CHORD_SEMITONES[chord]);
          end;
        end;
        WriteLn(row);
      end;
    end;
end;

begin
  BuildChords;
end.


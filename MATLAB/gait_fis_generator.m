% gait_fis_generator.m
fis = mamfis('Name','GaitClassification');

% === Input: Stride Length ===
fis = addInput(fis, [0 10], 'Name', 'StrideLength');
fis = addMF(fis, 'StrideLength', 'trapmf', [0 0 1 2], 'Name', 'VeryShort');
fis = addMF(fis, 'StrideLength', 'trimf', [1 2 4], 'Name', 'Short');
fis = addMF(fis, 'StrideLength', 'trimf', [3 5 6], 'Name', 'Medium');
fis = addMF(fis, 'StrideLength', 'trimf', [5 7 8], 'Name', 'Long');
fis = addMF(fis, 'StrideLength', 'trapmf', [7.5 8.5 10 10], 'Name', 'VeryLong');

% === Input: Step Symmetry ===
fis = addInput(fis, [0 100], 'Name', 'StepSymmetry');
fis = addMF(fis, 'StepSymmetry', 'trimf', [0 10 25], 'Name', 'Poor');
fis = addMF(fis, 'StepSymmetry', 'trimf', [25 37.5 50], 'Name', 'Fair');
fis = addMF(fis, 'StepSymmetry', 'trimf', [50 62.5 75], 'Name', 'Good');
fis = addMF(fis, 'StepSymmetry', 'trimf', [75 90 100], 'Name', 'VeryGood');

% === Input: Joint Angles ===
fis = addInput(fis, [0 90], 'Name', 'JointAngles');
fis = addMF(fis, 'JointAngles', 'trimf', [0 15 30], 'Name', 'Low');
fis = addMF(fis, 'JointAngles', 'trimf', [30 45 60], 'Name', 'Medium');
fis = addMF(fis, 'JointAngles', 'trimf', [60 75 90], 'Name', 'High');

% === Output: Gait Pattern ===
fis = addOutput(fis, [0 100], 'Name', 'GaitPattern');
fis = addMF(fis, 'GaitPattern', 'trapmf', [0 0 30 45], 'Name', 'Limping');
fis = addMF(fis, 'GaitPattern', 'trimf', [40 55 70], 'Name', 'Shuffling');
fis = addMF(fis, 'GaitPattern', 'trapmf', [65 80 100 100], 'Name', 'Normal');

% === Rules ===
rules = [
    "StrideLength==VeryShort & StepSymmetry==Poor & JointAngles==Low => GaitPattern=Limping (1)"
    "StrideLength==Short & StepSymmetry==Fair & JointAngles==Low => GaitPattern=Shuffling (1)"
    "StrideLength==Medium & StepSymmetry==Good & JointAngles==Medium => GaitPattern=Normal (1)"
    "StrideLength==Long & StepSymmetry==Good & JointAngles==High => GaitPattern=Normal (1)"
    "StrideLength==Short & StepSymmetry==Poor & JointAngles==Medium => GaitPattern=Limping (1)"
    "StrideLength==Long & StepSymmetry==Fair & JointAngles==Medium => GaitPattern=Shuffling (1)"
    "StrideLength==VeryLong & StepSymmetry==VeryGood & JointAngles==High => GaitPattern=Normal (1)"
];
fis = addRule(fis, rules);

% Save the FIS
writeFIS(fis, 'gait_fis');

disp('FIS created and saved as gait_fis.fis');

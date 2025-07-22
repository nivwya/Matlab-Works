fis = readfis('tipper.fis');
output = evalfis([8 9], fis);  % Example input: FoodQuality=8, Service=9
disp(['Tip: ', num2str(output), '%']);
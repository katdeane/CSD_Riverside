function CFout = icheckCF(homedir,CFin,Name)

cd(homedir); cd output/batCF/
scrSize   = get(0, 'ScreenSize');
scrHeight = scrSize(4);
scrWidth  = scrSize(3);

% pull up figures ot check against 
uiopen([Name ' CF CSD.fig'],1)
h = gcf;
h.Position = [0 0 scrWidth/2 scrHeight];
uiopen([Name ' CF Tuning Curves Amp.fig'],1)
h = gcf;
h.Position = [scrWidth/2 0 scrWidth/2 scrHeight];

% ask question
answer = questdlg(['Is the CF ' num2str(CFin) ' correct?'], ...
	'Choice', ...
	'Yes','No','No');
% Handle response
switch answer
    case 'Yes'
        CFout = CFin;
    case 'No'
        prompt = {'Enter the correct CF'};
        dlgtitle = 'CF=';
        answer = inputdlg(prompt,dlgtitle);
        CFout = str2num(answer{:});
end

close all
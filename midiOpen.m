function n = midiOpen(str)

% MIDIOPEN helper function to open a MIDI input or output device from a
% grapical dialog
%
% Use as
%   midiOpen('input')
% or
%   midiOpen('output')
%
% See also midiIn midiOut

% This file is part of EEGSYNTH, see https://github.com/oostenveld/eegsynth-matlab
% for the documentation and details.
%
%    FieldTrip is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    FieldTrip is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with FieldTrip. If not, see <http://www.gnu.org/licenses/>.

switch str
  case 'input'
    L = midiIn('L');
    sel = [L.input]==1;
  case 'output';
    L = midiOut('L');
    sel = [L.output]==1;
end % switch

h = dialog;
set(h, 'MenuBar', 'none')
set(h, 'Name', sprintf('Select MIDI %s device', str))

hpos = 10;
vpos = 10;
for i=1:length(L)
  if sel(i)
    uicontrol(h, 'style', 'pushbutton', 'position', [hpos vpos 240 20], 'tag', num2str(i), 'string', L(i).name, 'callback', @cb_interface);
    vpos = vpos + 30;
  end
end

% update the size according to the number of buttons
pos = get(h, 'position');
pos(3) = 260;
pos(4) = vpos;
set(h, 'position', pos);

uiwait(h);
if ishandle(h)
  n = str2num(guidata(h)); %#ok<*ST2NM>
  delete(h);
  switch str
    case 'input'
      midiIn('O', n);
    case 'output';
      midiOut('O', n);
  end % switch
else
  % figure has been closed
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUBFUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cb_interface(h, varargin)
guidata(get(h, 'parent'), get(h, 'tag'));
uiresume(get(h, 'parent'));
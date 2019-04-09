clc; close all;
%Show debug options
global DEBUG;
DEBUG = false;
global allSettings
allSettings = {}
%Initialize global variables
global Interactables; % The list of all interactables
Interactables = {};
global frameLength;
frameMultiplier = 2;
frameLength = 1024 * frameMultiplier;
global Fs;
Fs = 44100;
global inputDevice;
global outputDevice;

global test
test = [];

%Open the GUI
GUI();

function GUI %drag_drop
global input

figure('WindowButtonUpFcn',@dropObject,'units','normalized','Position',[0 0 0.4 0.4],'WindowButtonMotionFcn',@dragObject, 'ButtonDownFcn', @selectObject); % 'WindowButtonUpFcn',@dropObject
input = newNode('in', 'In',[0.05 0.55 0.15 0.15],@selectObject);

output = newNode('out','Out',[0.8 0.55 0.15 0.15], @selectObject);

% Flanger = newNode('flanger','Flanger',[0.3 0.8 0.15 0.15],@selectObject);
% Lowpass = newNode('lowpass','Low Pass',[0.5 0.8 0.15 0.15],@selectObject);
% Highpass = newNode('highpass','High Pass',[0.4 0.6 0.15 0.15],@selectObject);

%settingsTest(Highpass);

% spectrumNode = newNode('spectrum', 'Spectrum', [0.2 0.2 0.15 0.15], @selectObject)
%TestNode = newNode('in','Test Node',[0.55 0.55 0.15 0.15], @selectObject);

button = newButton([0.9 0.05 .06 .10], @selectObject);

selectedObject = [];

%If an object is clicked on, it updates the selected object
    function selectObject(hObject,eventdata)
        selectedObject = findInteractableFromAnnoObject(hObject);    
         if ~isempty(selectedObject)
             
             if ~isempty(selectedObject.anno)
                selectedObject.select();
                createMenu(selectedObject);
             end
         end
    end

%When the mouse button is released call the drop function of the
%selected object and set the selectedObject to be empty
    function dropObject(hObject,eventdata)
                
        if ~isempty(selectedObject)
            
            if ~isempty(selectedObject.anno)
                    selectedObject.drop(); 
                    selectedObject = []; 
            end

        end             
    end

    %When the mouse is being moved, call drag function of the selected
    %object
    function dragObject(hObject,eventdata)
        if ~isempty(selectedObject)
            
            if ~isempty(selectedObject.anno)
                selectedObject.drag();
            end
            
        end
    end

    function createMenu(object)
        
        if isa(object, 'CreateButton')
            if object.isClicked == true
                
                pos = [object.anno.Position(1) object.anno.Position(2)];
                newSelection([pos(1)-0.13 pos(2)+0.03 0.1 0.1],'Flanger',@selectObject);
                newSelection([pos(1)-0.07 pos(2)+0.07 0.1 0.1],'Low Pass',@selectObject);
                newSelection([pos(1)-0.13 pos(2)-0.06 0.1 0.1],'Spectrum',@selectObject);
                newSelection([pos(1)-0.01 pos(2)+0.07 0.1 0.1],'HighPass',@selectObject);
                
            else
                % Delete the effect selection textboxes using specified
                % parameters
                delete(findall(gcf,'LineStyle','none'))
                delete(findall(gcf,'LineWidth',0.6))
                
            end
        end
        
        
        if isa(object, 'EffectSelector')
            button.resetDefault();
            object.anno.Position(3) = 0.15;
            object.anno.Position(4) = 0.15;
            
            switch object.Name
                case 'Flanger'
                    Flanger = newNode('flanger','Flanger',object.anno.Position,@selectObject);
                case 'Low Pass'
                    Lowpass = newNode('lowpass','Low Pass',object.anno.Position,@selectObject);
                case 'Spectrum'
                    Echo = newNode('spectrum','Spectrum',object.anno.Position,@selectObject);
                case 'HighPass'
                    HighPass = newNode('highpass','High Pass',object.anno.Position,@selectObject);
                    
            end
            delete(findall(gcf,'LineStyle','none'))
            delete(findall(gcf,'LineWidth',0.6))
        end
        
        
    end


end


% Functions to create new interactable items
function node = newNode(effect, name, position, select)
    
    node = [];
    switch effect
        case 'in'
            node = InputNode(position,name,select);
        case 'out'
            node = OutputNode(position,name,select);
        case 'flanger'
            node = FlangerNode(position,name,select);
        case 'lowpass'
            node = LowpassNode(position, name, select);
        case 'highpass'
            node = HighpassNode(position, name, select);
        case 'spectrum'
            node = SpectrumNode(position, name, select);
            
    end
    
    if ~strcmp(effect, 'in')
        node.inSocket = newSocket('in', node, select); % Reference property in node class
    end
    if ~strcmp(effect, 'out')
        node.outSocket = newSocket('out', node, select);
    end    

    
    global Interactables %Makes the global 'interactables' referencable
    Interactables{end+1} = node; % Adds the node to the end of interactables list

    return
end

function selection = newSelection(position, name, select)
         selection = EffectSelector(position, name, select);
         global Interactables %Makes the global 'interactables' referencable
        Interactables{end+1} = selection; % Adds the node to the end of interactables list
end

function button = newButton(position, select)
         button = CreateButton(position,select);
%          annotation('line',[position(1)+position(3)/2 position(1)+position(3)/2],[position(2)+position(4)/4 position(2)+position(4)-position(4)/4]);
%          annotation('line',[position(1)+position(3)/4 position(1)+position(3)-position(3)/4],[position(2)+position(4)/2 position(2)+position(4)/2]);
         global Interactables %Makes the global 'interactables' referencable
        Interactables{end+1} = button; % Adds the node to the end of interactables list
end
% Function to create the in and out connection ellipses
function socket = newSocket(type, node, select)
    if strcmp(type,'in')
        socket = InSocket(node, 'ellipse','Position','ButtonDownFcn',select);
    elseif strcmp(type,'out')
        socket = OutSocket(node, 'ellipse','Position','ButtonDownFcn',select);         
    end
    global Interactables %Makes the global 'interactables' referencable
    Interactables{end+1} = socket; % Adds the node to the end of interactables list

    return
end

%Finds the node that has the given annotation inside it
function interactable = findInteractableFromAnnoObject(annotation)

    %Find Node class by looking for the
    global Interactables
    for i = 1:length(Interactables)
        if Interactables{i}.anno == annotation
            interactable = Interactables{i};
            return
        end
    end
    interactable = [];
end

%Sets all the connectionLines to be black
function updateConnectionPath(inNode)

    %Find Node class by looking for the
    global Interactables
    
    %Set everything to black first
    for i = 1:length(Interactables)
        if isa(Interactables{i}, 'InSocket') || isa(Interactables{i}, 'OutSocket')
            try
                if ~isempty(Interactables{i}.connectionLine)
                    Interactables{i}.connectionLine.Color = 'k';
                end
            catch
            end
        end

    end
    
    %Change connection lines color in the path from in to out 
    node = inNode;
    connected = false;
    try
        
    %check if in is connected to the output node
    while ~isempty(node)
        if isa(node, 'OutputNode')
            connected = true;
            break;
            
        elseif ~isempty(node.outSocket.nextNode)
            node = node.outSocket.nextNode;
        
        else
            node = [];
        end
    end
    
    %Only change the color if the input is connected to the output node
    if connected == false
        return;
    end
   
    % Change color of all the lines that connects from in to output
    node = inNode;
    while ~isempty(node)
        if isa(node, 'OutputNode')
            return
        end
        
        if ~isempty(node.outSocket.connectionLine)
            node.outSocket.connectionLine.Color = 'r';
            if ~isempty(node.outSocket.nextNode)
                node = node.outSocket.nextNode;
            else
                node = [];
            end
        else
            node = [];
        end
    end
    catch
    end
    
end



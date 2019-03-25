clc; close all;
%Show debug options
global DEBUG;
DEBUG = false;

%Initialize global variables
global Interactables; % The list of all interactables
Interactables = {};
global frameLength;
frameLength = 2048;
global Fs;
Fs = 44100;
global inputDevice;
global outputDevice;

%Open the GUI
GUI();

function GUI %drag_drop
global input

figure('WindowButtonUpFcn',@dropObject,'units','normalized','Position',[0 0 0.4 0.4],'WindowButtonMotionFcn',@dragObject); % 'WindowButtonUpFcn',@dropObject
input = newNode('in', 'In',[0.05 0.35 0.15 0.15],@selectObject);

output = newNode('out','Out',[0.8 0.35 0.15 0.15], @selectObject);

Flanger = newNode('flanger','Flanger',[0.3 0.8 0.15 0.15],@selectObject);
%Lowpass = newNode('in','Low Pass',[0.5 0.8 0.15 0.15],@selectObject);


%TestNode = newNode('in','Test Node',[0.55 0.55 0.15 0.15], @selectObject);

selectedObject = [];

while true
   input.retrieveBuffer();
   drawnow();
end



%If an object is clicked on, it updates the selected object
    function selectObject(hObject,eventdata)
        selectedObject = findInteractableFromAnnoObject(hObject);        
         if ~isempty(selectedObject)
             
             if ~isempty(selectedObject.anno)
                selectedObject.select();
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


end


% Functions to create new interactable items
function node = newNode(effect, name, position, select)
    
    node = [];
    switch effect
        case 'in'
            node = InputNode(position,name,select)
        case 'out'
            node = OutputNode(position,name,select)
        case 'flanger'
            node = FlangerNode(position,name,select);
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






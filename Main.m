clc; close all;

%Initialize global variables
global interactables; % The list of all interactables
interactables = {};

GUI();
function GUI %drag_drop


figure('WindowButtonUpFcn',@dropObject,'units','normalized','Position',[0 0 0.4 0.4],'WindowButtonMotionFcn',@dragObject); % 'WindowButtonUpFcn',@dropObject
input = newNode('In',[0.05 0.35 0.15 0.15],@selectObject);

output = newNode('Out',[0.8 0.35 0.15 0.15], @selectObject);

Flanger = newNode('Flanger',[0.3 0.8 0.15 0.15],@selectObject);
Lowpass = newNode('Low Pass',[0.5 0.8 0.15 0.15],@selectObject);


TestNode = newNode('Test Node',[0.55 0.55 0.15 0.15], @selectObject);

selectedObject = [];
% nextObject = []; 


%If an object is clicked on, it updates the selected object
    function selectObject(hObject,eventdata)
        selectedObject = findNodeFromAnnoObject(hObject);        
         if ~isempty(selectedObject)
            selectedObject.select();
         end
    end

%When the mouse button is released call the drop function of the
%selected object and set the selectedObject to be empty
    function dropObject(hObject,eventdata)
        if ~isempty(selectedObject)
            selectedObject.drop();
            selectedObject = []; 
        end             
    end



%When the mouse is being moved, call drag function of the selected
%object
    function dragObject(hObject,eventdata)
        if ~isempty(selectedObject)
            selectedObject.drag();
        end
    end

% Functions to create new interactable items
    function node = newNode(name, position, select)
        
        node = Node('textbox','Position',position,'String',name,'ButtonDownFcn',select);
        node.inConnection = newConnection([node.Position(1)-0.005 node.Position(2)+node.Position(4)/2 .01 .015],@selectObject); % Reference property in node class
        node.outConnection = newConnection([node.Position(1)+node.Position(3)-0.005 node.Position(2)+node.Position(4)/2 .01 .015],@selectObject);
        
        global interactables %Makes the global 'interactables' referencable
        interactables{end+1} = node; % Adds the node to the end of interactables list
        
        return
    end
end

% Function to create the in and out connection ellipses
function connection = newConnection(position, select)

connection = Connection('ellipse','Position',position,'ButtonDownFcn',select);
global interactables %Makes the global 'interactables' referencable
interactables{end+1} = connection; % Adds the node to the end of interactables list

return
end

%Finds the node that has the given annotation inside it
function foundNode = findNodeFromAnnoObject(annotation)

%Find Node class by looking for the
global interactables
for i = 1:length(interactables)
    if interactables{i}.anno == annotation
        foundNode = interactables{i};
        return
    end
end
foundNode = [];
end




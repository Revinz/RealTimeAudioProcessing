classdef DeleteButton < Interactable
    properties
        img
        axes;
        node;
    end
    methods
        
        function obj = DeleteButton(pos,fcn, node)
            [obj.img, map, alphachannel] = imread('Trashcan_icon.png');
            obj.axes = axes('pos', [pos(1)+pos(3)/2.7 pos(5)  0.05 0.09]); %Use axes to position the image
            image(obj.img, 'AlphaData', alphachannel);
            obj.axes.Visible = 'off'; %Make the plot axes invisible to only show the image.
            obj.node = node; %Reference to the node that created the delete button, so we can later delete the correct node
            %Annotation is used to make the button interactable
            obj.anno = annotation('ellipse','Position',[pos(1)+pos(3)/2.7 pos(2) 0.049 0.089],'ButtonDownFcn',fcn,'Color','r');
       end
        
        function removeNode(obj,node)
            obj.removeButton();
            global Interactables
                if isa(node, 'FlangerNode') || isa(node, 'LowpassNode') || isa(node, 'HighpassNode') || isa(node, 'SpectrumNode') || isa(node, 'DelayNode')
                    delete(node.anno);
                                        
                    node.inSocket.disconnectLine();
                    node.outSocket.disconnectLine();
                    for i = 1:length(Interactables)
                        try
                            if Interactables{i}.anno == node.anno
                                Interactables(i) = []; %Remove the node from the interactables list
                                Interactables(i-1) = [];
                                Interactables(i-2) = [];
                            end
                        catch
                        end
                    end
                    if ~isempty(node.settingsBgAnno)
                        try
                        delete(node.settingsBgAnno);
                        catch
                        end
                    end

                    
                    delete(node.inSocket.anno);
                    delete(node.outSocket.anno);
                    delete(node.inSocket);
                    delete(node.outSocket);
                    delete(node);
                end            
        end
        
        function removeButton(obj)
            global Interactables
            obj.img = [];
            delete(obj.axes);
            delete(obj.anno);
            Interactables{end} = [];
        end
        
        
        function select(obj)
        end
            
        function drag(obj)

        end
        
        function drop(obj)
        end
    end
end
classdef DeleteButton < Interactable
    properties
    end
    methods
        
        function obj = DeleteButton(pos,fcn)
            obj.anno = annotation('ellipse','Position',[pos(1)+pos(3)/2.7 pos(2) + 0.15 0.03 0.05],'ButtonDownFcn',fcn,'Color','r');
       end
        
        function removeNode(obj,node)
            delete(obj.anno);
            global Interactables
                if isa(node, 'FlangerNode') || isa(node, 'LowpassNode') || isa(node, 'HighpassNode')
                    delete(node.anno);
                    for i = 1:length(Interactables)
                        try
                            if Interactables{i}.anno == node.anno
                                Interactables(i) = [];
                                Interactables(i-1) = [];
                                Interactables(i-2) = [];
                                Interactables(end) = [];

                            end
                        catch
                        end
                    end
                    delete(node.settingsBgAnno);
                    delete(node.inSocket.anno);
                    delete(node.outSocket.anno);
                    delete(node.inSocket);
                    delete(node.outSocket);
                    delete(node);
                end            
        end
            
        function select(obj)
        end
            
        function drag(obj)

        end
        
        function drop(obj)
        end
    end
end
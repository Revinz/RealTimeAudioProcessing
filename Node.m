classdef Node < matlab.System
    properties 
        Name;
        Position;
        left;
        right;

    end
    methods
        function  obj = Node(type,stringPos,pos,stringName,name,button,fcn)
            annotation(type,stringPos,pos,stringName,name,button,fcn,'BackgroundColor','blue','FaceAlpha',0.3);
            obj.Name = name;
            obj.Position = pos;
            obj.left = annotation('ellipse','Position',[obj.Position(1)-0.005 obj.Position(2)+obj.Position(4)/2 .01 .015],'Color','red','FaceColor',[.9 .9 .9]);
            obj.right = annotation('ellipse','Position',[obj.Position(1)+obj.Position(3)-0.005 obj.Position(2)+obj.Position(4)/2 .01 .015],'Color','red','FaceColor',[.9 .9 .9]);

        end
%         function  obj = elli(obj)
%             annotation('ellipse','Position',[obj.Position(1) obj.Position(2) .05 .05])
% 
%         end
    end
end
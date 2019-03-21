classdef Node < matlab.System
    properties 
        Name;
        Position;
        %circleConnect;

    end
    methods
        function  obj = Node(type,stringPos,pos,stringName,name,button,fcn)
            annotation(type,stringPos,pos,stringName,name,button,fcn);
            obj.Name = name;
            obj.Position = pos;
            %obj.circleConnect = annotation('ellipse',stringPos,[pos(1)-pos(1)/10 pos(2)+(pos(4)/2) pos(3)/4 pos(4)/4]);
        end
    end
end
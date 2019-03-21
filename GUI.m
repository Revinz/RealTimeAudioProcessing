function GUI %drag_drop

clc; close all;
dragging = [];
orPos = [];

% onLine = false;
figure('WindowButtonUpFcn',@dropObject,'units','normalized','WindowButtonMotionFcn',@moveObject);

in = Node('textbox','Position',[0.05 0.35 0.15 0.15],'String','In','ButtonDownFcn',@dragObject)
out = Node('textbox','Position',[0.8 0.35 0.15 0.15],'String','Out','ButtonDownFcn',@dragObject);

flanger = Node('textbox','Position',[0.3 0.8 0.15 0.15],'String','Flanger','ButtonDownFcn',@dragObject);
lowpass = Node('textbox','Position',[0.5 0.8 0.15 0.15],'String','Low-pass','ButtonDownFcn',@dragObject);


%in = annotation('textbox','Position',[0.1 0.7 0.15 0.15],'String','in','ButtonDownFcn',@dragObject);
%out = annotation('textbox','Position',[0.6 0.7 0.15 0.15],'String','out','ButtonDownFcn',@dragObject);
%flanger = annotation('textbox','Position',[0.6 0.3 0.15 0.15],'String','Flanger','ButtonDownFcn',@dragObject);

% l = annotation('line',[in.Position(1)+in.Position(3) out.Position(1)], [in.Position(2)+(in.Position(4)/2) out.Position(2)+(out.Position(4)/2)]);
% l1 = annotation('line',[0 0], [0 0]);
% l2 = annotation('line',[0 0], [0 0]);
%
%     function connectObject(left,middle,right)
%
%         pos1 = [left.Position(1)+left.Position(3) middle.Position(1)];
%         pos2 = [left.Position(2)+(left.Position(4)/2) middle.Position(2)+(middle.Position(4)/2)];
%         l1.X = pos1;
%         l1.Y = pos2;
%
%         pos1 = [middle.Position(1)+middle.Position(3) right.Position(1)];
%         pos2 = [middle.Position(2)+(middle.Position(4)/2) right.Position(2)+(right.Position(4)/2)];
%         l2.X = pos1;
%         l2.Y = pos2;
%
%     end

    function dragObject(hObject,eventdata)
        dragging = hObject;
        orPos = get(gcf,'CurrentPoint');
        
    end
    function dropObject(hObject,eventdata)
        if ~isempty(dragging)
            newPos = get(gcf,'CurrentPoint');
            posDiff = newPos - orPos;
            
            
            set(dragging,'Position',get(dragging,'Position') + [posDiff(1:2) 0 0]);
            %dragging
            
            
            %             if (l.Position(2) > dragging.Position(2) && l.Position(2) < (dragging.Position(2)+0.15))
            %                 onLine = true;
            %
            %             else
            %                 onLine = false;
            %
            %             end
                         dragging = [];
        end
        
    end

    function moveObject(hObject,eventdata)
        if ~isempty(dragging)
            newPos = get(gcf,'CurrentPoint');
            try
                posDiff = newPos - orPos;
                
                orPos = newPos;
                set(dragging,'Position',get(dragging,'Position') + [posDiff(1:2) 0 0]);
                
                
%                 pos1 = [dragging.Position(1)+dragging.Position(3) out.Position(1)];
%                 pos2 = [dragging.Position(2)+(dragging.Position(4)/2) out.Position(2)+(out.Position(4)/2)];
%                 l.X = pos1;
%                 l.Y = pos2;
            catch
            end
            
        end
%         if onLine == true
%             
%                         l.X = [0 0];
%                         l.Y = [0 0];
%                         connectObject(in,dragging,out);
%             
%             
%         end
    end
end

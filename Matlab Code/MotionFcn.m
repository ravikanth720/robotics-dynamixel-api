function MotionFcn(FigH, EventData)
C = get (gca, 'CurrentPoint');
% find the selection type
selType = get(gcf,'SelectionType');

title(gca, ['(X,Y) = (', num2str(C(1,1)), ', ',num2str(C(1,2)), ')']);
function List = fun_get_list_field_option(option)
% fun_get_list_field_option(field) provide the possible value of the input 
% field required
switch option
    %---------------------------------------------------------------------%
    
    
    %---------------------------------------------------------------------%
    case 'Dynamics'
        List    = {'@fun_taylor',...
                   '@fun_rotation',...
                   '@fun_quaternion'};
    %---------------------------------------------------------------------%
    
    
    %---------------------------------------------------------------------%
    case 'Gradient'
        List    = {'cdiff',...
                   'var',...
                   'exact'};
    %---------------------------------------------------------------------%
    
    
    %---------------------------------------------------------------------%
%     case 'CoopPulse'
%         List    = {'on','off'};
    %---------------------------------------------------------------------%
    
    
    %---------------------------------------------------------------------%
    case 'Constraint'
        List    = dir('function/fun_constr/*.m');
        List    = strcat('@',{List.name});
        List    = cellfun(@(x) x(1:end-2), List, 'UniformOutput', false);
%         List    = {List.name};
    %--------------------------------------------------------------------%
    
    
    %---------------------------------------------------------------------%
    case 'Cost'
        List    = dir('function/fun_cost/*.m');
        List    = strcat('@',{List.name});
        List    = cellfun(@(x) x(1:end-2), List, 'UniformOutput', false);
%         List    = {List.name};
    %---------------------------------------------------------------------%
    
    
    %---------------------------------------------------------------------%
    otherwise
       List = 'Additional option';
end
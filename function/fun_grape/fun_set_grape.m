function option = fun_set_grape(varargin)
%-------------------------------------------------------------------------%



%-------------------------------------------------------------------------%
ListParameter   = fun_get_list_field();
ListOption      = cell(size(ListParameter));
for i1 = 1:length(ListOption)
    ListOption{i1}  = fun_get_list_field_option(ListParameter{i1});
end
%-------------------------------------------------------------------------%



%-------------------------------------------------------------------------%
option  = fun_get_default_grape();
Ninput  = ceil(nargin/2);
for i1 = 1:Ninput
    idx     = 2*(i1-1)+1;
    if ~ismember(varargin{idx},ListParameter)
        error([varargin{idx},' is not a valid parameter, the parameter fields are :',sprintf('\n\n'),strjoin(ListParameter,'\n')])
    end
    Idx     = find(strcmp(ListParameter,varargin{idx}));
    if idx+1 > nargin
        error(['input option of the field ',varargin{idx},' is missing',', this option can be :',sprintf('\n\n'),strjoin(ListOption{Idx},'\n')])
    else
        if ismember(varargin{idx+1},ListOption{Idx});
            option  = setfield(option,varargin{idx},varargin{idx+1});
        else
            error([varargin{idx+1},' is not a valid option for the parameter ',varargin{idx},' the parameter can be :',sprintf('\n\n'),strjoin(ListOption{Idx},'\n')])
        end
    end
end
name    = [option.Dynamics(1:5),'grad_',option.Dynamics(6:end),'_',option.Gradient];
if exist([name(2:end),'.m'],'file' ) == 2
    option.Gradient    = name;
else
    error(['The gradient option ',name,' is currently not available, choose another one'])
end
%-------------------------------------------------------------------------%
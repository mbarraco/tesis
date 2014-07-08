%% load_choice
function [file name] = load_choice
name = {'rotomat: r114 ';'rotomat: r88 ';'linea 1: L80';'linea 1: P72';'linea 1: P98'};
choice = menu('Elegir un archivo: ',name);
if (choice ==1 | choice ==2)
    aux = load('rotomat');
    if (choice==1)
        aux = aux.r114;
        name = name{1};
    else
        aux = aux.r88;
        name = name{2};
    end
else
    aux=load('linea1');
    if (choice==3)
        aux = aux.L80;
        name = name{3};
    elseif (choice==4)
        aux = aux.P72;
        name = name{4};
    else
        aux = aux.P98;
        name = name{5};
    end
end
file=aux;

end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%  Módulo 1 Block 1 Task 1  %%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Recorremos el directorio de .txt
    
    archivos = dir('*gt*'); %leo todo archivo que contiene gt en el nombre
    
    %Creamos una matriz donde se guardaran los filename en orden en función
    %a su tamaño (de menor área de bounding box a mayor en cada columna) y
    %en 6 filas en función al tipo de señal (A,B,C,D,E,F), así como
    %vectores auxiliares para cada tipo.
    
    auxA = {};
    auxB = {};
    auxC = {};
    auxD = {};
    auxE = {};
    auxF = {};
    
    for k = 2:length(archivos) 
		name = archivos(k).name; 
        fileID = fopen(name);
        tline = fgetl(fileID);
            
            if (strfind(tline,'A') ~= 0)
                auxA{end + 1} = name;
            
            elseif (strfind(tline,'B') ~= 0)
                auxB{end + 1} = name;
                        
            elseif (strfind(tline,'C') ~= 0)
                auxC{end + 1} = name;

            elseif (strfind(tline,'D') ~= 0)
                auxD{end + 1} = name;
                
            elseif (strfind(tline,'E') ~= 0)
                auxE{end + 1} = name;
                
            elseif (strfind(tline,'F') ~= 0)
                auxF{end + 1} = name;
            
            elseif tline == -1
                fclose(fileID);
                continue;
            end
        fclose(fileID);

    end
    
    
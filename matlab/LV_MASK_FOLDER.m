% Program: <LV_MASK_FOLDER.m>
% Author: Marc Bracons Cucó
% Affiliation: Department of Telecommunication and Systems Engineering, Autonomous University of Barcelona, Wireless Information Networking Group
% Copyright © 2023 Marc Bracons Cucó
%
% This program is proprietary software; you may not use, distribute, or modify it 
% without the explicit permission of the author.
%
% If you wish to use this program in your work, please, contact the author.

% Script que usa los desplazamientos calculados para recortar la region de
% interes

% Leer los datos del archivo excel
T = readtable('/home/win001/00_heart/LV_Fix.xlsx');
set(0,'DefaultFigureVisible','off')

for j = 1:height(T)
    % Obtener los valores de num_paciente, B y A de la fila actual
    num_paciente = num2str(T.pacient(j));
    B = T.vertical(j);
    A = T.horitzontal(j);
    tipo = T.type{j};
    
    % Construir la ruta de la carpeta correspondiente según el tipo
    carpeta_paciente = fullfile('/home/win001/00_heart/00_Dataset_CNN/02_LV_CNN', ['_' num_paciente]);
    
    % Cambiar a la carpeta del paciente
    cd(carpeta_paciente);

    % Cargar los datos de segmentación
    load('seg.mat');

    EpiX = SEG.EpiX;
    EpiY = SEG.EpiY;
    EpiX_2D = squeeze(EpiX);
    EpiY_2D = squeeze(EpiY);

    % Reemplazar los valores NaN por 0
    EpiX_2D_normalized = EpiX_2D;
    EpiX_2D_normalized(isnan(EpiX_2D_normalized)) = 0;

    EpiY_2D_normalized = EpiY_2D;
    EpiY_2D_normalized(isnan(EpiY_2D_normalized)) = 0;

    % Cargar EndoX y EndoY y normalizarlos
    EndoX = SEG.EndoX;
    EndoY = SEG.EndoY;
    EndoX_2D = squeeze(EndoX);
    EndoY_2D = squeeze(EndoY);

    % Reemplazar los valores NaN por 0
    EndoX_2D_normalized = EndoX_2D;
    EndoX_2D_normalized(isnan(EndoX_2D_normalized)) = 0;

    EndoY_2D_normalized = EndoY_2D;
    EndoY_2D_normalized(isnan(EndoY_2D_normalized)) = 0;

    % Obtener los nombres de archivo de la carpeta
    files = dir('*.png');
    file_names = {files.name};
    
    % Filtrar los nombres de archivo que empiezan con el número de paciente
    idx = startsWith(file_names, num_paciente);
    file_names = file_names(idx);
    
    % Convertir las partes numéricas de los nombres de archivo en valores numéricos
    file_nums = cellfun(@(x) str2num(x(find(x=='_',1,'last')+1:end-4)), file_names);
    
    % Ordenar los nombres de archivo según los valores numéricos en orden inverso
    [~, sort_idx] = sort(file_nums, 'descend');
    file_names = file_names(sort_idx);
    
    num_files = length(file_names);
    
    for i = 1:num_files
        % Cargar la imagen en orden inverso
        filename = file_names{i};
        img = imread(filename);
    
        % Desplazar los puntos A píxeles a la derecha
        EpiY_2D_normalized(:,i) = EpiY_2D_normalized(:,i) + A;
    
        % Desplazar los puntos B píxeles hacia abajo
        EpiX_2D_normalized(:,i) = EpiX_2D_normalized(:,i) + B;
    
        % Desplazar los puntos A píxeles a la derecha para Endo
        EndoY_2D_normalized(:,i) = EndoY_2D_normalized(:,i) + A;
    
        % Desplazar los puntos B píxeles hacia abajo para Endo
        EndoX_2D_normalized(:,i) = EndoX_2D_normalized(:,i) + B;
    
        % Crear la máscara de la zona de interés expandida para Epi y Endo
        EpiBW = poly2mask(EpiY_2D_normalized(:,i), EpiX_2D_normalized(:,i), size(img,1), size(img,2));
        EndoBW = poly2mask(EndoY_2D_normalized(:,i), EndoX_2D_normalized(:,i), size(img,1), size(img,2));
    
        % Combinar las máscaras Epi y Endo y pintar de blanco la zona entre las regiones
        combined_mask = EpiBW & ~EndoBW;
        img_masked = img;
        img_masked(combined_mask) = 255;
        img_masked(~combined_mask) = 0;

    
        % Crear la carpeta de destino para guardar las imágenes enmascaradas
        destination_folder = fullfile('/home/win001/00_heart/00_Dataset_CNN/02_LV_MASK', ['_' num_paciente]);
        if ~exist(destination_folder, 'dir')
            mkdir(destination_folder);
        end
    
        % Guardar la imagen modificada en la carpeta de destino
        [~, original_name, ext] = fileparts(filename);
        new_filename = ['masked_' original_name ext];

        imwrite(img_masked, fullfile(destination_folder, new_filename));
    
        % Esperar hasta que la imagen y la zona expandida se hayan dibujado completamente antes de pasar a la siguiente iteración
        drawnow;
    end
end

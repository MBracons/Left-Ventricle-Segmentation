# Left Ventricle Segmentation

## Descripción
Este proyecto contiene una serie de scripts diseñados para el procesamiento y análisis de imágenes médicas, con énfasis en la segmentación y manipulación del ventrículo izquierdo (LV) en imágenes de resonancia magnética (MRI). Los scripts están escritos en Python y MATLAB y abordan desde la aumentación de imágenes hasta el manejo y análisis específico de datos en formato CSV.

## Scripts
Descripción breve de cada script incluido en el proyecto:

### CNN_Image_Augmentation.ipynb
En este notebook de Python se aplican técnicas de aumentación de imágenes utilizadas para mejorar el rendimiento de los modelos de aprendizaje automático en tareas de visión por computadora.

### DATASET_CSV.ipynb
Este notebook facilita la creación y manipulación de datasets en formato CSV, preparándolos para su análisis o entrenamiento de modelos.

### LV_segmentation.ipynb
Notebook que implementa algoritmos de segmentación para identificar y aislar el ventrículo izquierdo en imágenes médicas.

### Mascara_recorte_all.ipynb
Automatiza el proceso de recorte de imágenes usando máscaras específicas para aislar regiones de interés.

### MAX_MIN_LV.ipynb
Calcula las segmentaciones máximas y mínimas en las imágenes de segmentación del ventrículo izquierdo, reduciendo la cantidad de imágenes que se necesitan para entrenar el modelo.

### MAX_SLICES.ipynb
Determina el número máximo de 'slices' o cortes en un conjunto de imágenes, útil para la normalización de datos en estudios comparativos.

### LV_MASK_FOLDER.m
Script de MATLAB que gestiona la organización de máscaras de segmentación del ventrículo izquierdo en carpetas estructuradas.

### SEG_TO_FOLDER.m
Facilita la tarea de segmentar imágenes y organizarlas automáticamente en carpetas correspondientes para un manejo más eficiente.

# sistema-gestion-bodega



Proyecto desarrollado como Trabajo de Aplicación Práctica (TAP) para la carrera de Técnico en Programación y Análisis de Sistemas de AIEP.

Descripción

Aplicación web desarrollada para administrar materiales y herramientas de una bodega, permitiendo controlar las entradas de productos, las asignaciones a trabajadores, las devoluciones de herramientas y las mermas.

Tecnologías utilizadas

Python

Flask

MySQL

HTML y CSS

Visual Studio Code

Funcionalidades

Administración de productos, trabajadores y proveedores.

Registro de entradas y actualización del inventario.

Asignación de materiales y herramientas a trabajadores.

Registro de devoluciones de herramientas.

Control de mermas.

Validación de stock disponible.

Consultas e informes de inventario.

Instalación

--Para clonar el repositorio

git clone https://github.com/marceloalfaro/sistema-gestion-bodega.git

--Para instalar las dependencias

python -m pip install -r requirements.txt

--Para importar la base de datos

Importar el archivo database/preansa_inventario.sql utilizando MySQL Workbench.

--Para configurar la conexión

Crear un archivo .env en la carpeta principal con las siguientes variables:

DB_HOST=localhost
DB_USER=root
DB_PASSWORD=TU_CONTRASEÑA
DB_NAME=preansa_inventario

--Para ejecutar la aplicación

python app.py

Abrir en el navegador:

http://127.0.0.1:5000

Metodología

El proyecto se organizó utilizando una metodología ágil basada en Scrum, con apoyo de Jira para la planificación y el seguimiento de tareas y subtareas.
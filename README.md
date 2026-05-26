# 🛠️ HelperDumper

**HelperDumper** es un addon especializado para *World of Warcraft (versión 3.3.5a)* diseñado para administradores de servidores y desarrolladores que utilizan emuladores basados en **TrinityCore** o **AzerothCore**. 

Su propósito es ofrecer una interfaz visual limpia, intuitiva y rápida para gestionar los volcados de datos (`.pdump` y `.npcbot dump`) de personajes y bots dentro del juego, eliminando la necesidad de recordar o teclear comandos largos en el chat.

---

## ✨ Características Principales

* **Interfaz de Usuario Estilizada:** Centraliza todas las opciones en un panel elegante con casillas oscurecidas de alta visibilidad.
* **Gestión de Personajes:** Rutas dedicadas para salvar personajes (`.pdump write`) y cargarlos (`.pdump load`).
* **Gestión Independiente de Bots:** Submenú optimizado para volcar configuraciones de NPCBots (`.npcbot dump write / load`) evitando mezclas accidentales.
* **Botón del Minimapa Inteligente:** Acceso directo e interactivo. Se puede arrastrar libremente por el borde del minimapa haciendo clic derecho.
* **Limpieza Rápida Avanzada:** Botón inteligente "X" que reestablece la interfaz y vacía el texto de inmediato ante cualquier conflicto de guardado.

---

## 🌐 Soporte de Doble Idioma (Multi-language)

El addon cuenta con un sistema de localización nativa integrada. Dispone de un **menú desplegable (Dropdown)** en la esquina inferior izquierda que permite alternar el idioma de toda la interfaz en tiempo real, sin necesidad de reiniciar el juego o recargar la interfaz (`/reload`):

* **Español (ES):** Textos, alertas y descripciones adaptadas completamente al castellano.
* **English (EN):** Traducción completa para entornos de desarrollo internacionales o servidores angloparlantes.

*Nota: El addon guarda tu preferencia de idioma automáticamente para tus próximas sesiones de juego.*

<img width="1366" height="705" alt="Wow 2026-05-26 13-12-27" src="https://github.com/user-attachments/assets/59bf2466-92fb-47f1-8ce1-4d4eed5938c1" />


⚠️ Notas de Aviso Importantes (Léase antes de usar)
Debido a la arquitectura de seguridad de World of Warcraft y de los emuladores, es fundamental entender el comportamiento del addon:

❗ Limitación Física del Servidor:
Los comandos de chat le ordenan al emulador generar o leer archivos reales (en formato .sql) alojados en el disco duro de la máquina donde corre el servidor. Los addons se ejecutan exclusivamente en el cliente del jugador y no tienen permisos ni capacidad técnica para borrar archivos del disco duro del servidor.

¿Cómo funciona el botón "X"?
Si intentas guardar un archivo con un nombre que ya existe en el host, el servidor rechazará la petición y el addon mostrará una alerta en letras doradas:

"Si el archivo ya existe, debes borrarlo manualmente. Los archivos se encuentran en el Core del servidor."

Al pulsar el botón "X" ocurre lo siguiente:

Limpia la caché interna del addon: Desbloquea el registro de la interfaz para que puedas volver a procesar la ventana.

Vacía el cuadro de texto instantáneamente: Limpia la casilla por completo para que puedas escribir un nombre alternativo (ej. MiArchivo_v2) de inmediato, sin tener que borrar el texto anterior letra por letra.

Nota: Para eliminar el archivo físico antiguo de raíz, un administrador debe entrar a la carpeta de volcados del servidor (pdumps/ o equivalente) y borrarlo de forma manual.

🔧 Instalación
Descarga los archivos del addon.

Asegúrate de que la carpeta contenedora se llame exactamente HelperDumper.

Copia la carpeta dentro del directorio de complementos de tu cliente:

World of Warcraft / Interface / AddOns /

Entra al juego (recuerda marcar la casilla "Accesorios antiguos" en la selección de personaje si es necesario).

⌨️ Comandos de Consola
Si prefieres no utilizar el botón del minimapa, puedes abrir o cerrar la ventana principal escribiendo el siguiente comando en el chat del juego:

/hdump

🛠️ Detalles Técnicos
Lenguaje: Lua

Estructura Visual: WoW Frame XML API (diseñado específicamente para el cliente 3.3.5a).

Persistencia: Guardado de variables por cuenta a través de HelperDumperDB (guarda idioma y posición del minimapa).

## 📂 Flujo de Navegación

La interfaz utiliza ventanas independientes y un sistema lineal para garantizar que el panel no se cierre de forma inesperada:

```text
[ Menú Principal ]
   ├── Salvar Personaje ──> (Soporte de borrado rápido de casilla)
   ├── Cargar Personaje
   └── Gestionar Bots
          ├── Salvar Bots ──> (Soporte de borrado rápido de casilla)
          └── Cargar Bots


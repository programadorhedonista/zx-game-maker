import platform
import sys

CURRENT_OS = platform.system()

if CURRENT_OS not in ["Windows", "Linux", "Darwin"]:
    print(f"Sistema operativo {CURRENT_OS} no soportado.")
    input("Pulse una tecla para cerrar...")
    sys.exit(1) 


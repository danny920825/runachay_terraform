# Despliegue de Solución con Docker Swarm para Runachay
  
  
## Prequisitos:
* Terraform
* AWS CLI Credenciales

## Archivos:

Los archivos se distribuyen de la siguiente manera:
  
En la raiz **/**
  
**main.tf:** Es el archivo que configura el proveedor. En este caso AWS. Al no escribir las credenciales, el proveedor buscará las credenciales de AWS CLI (Mejora la seguridad)
  
**runachay_swarm.tf:** Es el archivo que contiene el codigo de los recursos que se van a crear en AWS
  
En la carpeta **files**
  
**lider.sh:** Script para instalar Docker, Docker-Compose y crear el Swarm, a su vez, crea los tokens para que se puedan unir los demas nodos
**manager.sh y worker.sh:** Son los scripts que permiten crear los nodos manager y workers del cluster. Se unen mediante el token generado por el lider
  
  
## Puesta en marcha:
  
Lo primero es editar el **runachay_swarm.tf** y ajustar:
  
-Tipo de Instancia  
-Imagen AMI a usar  
-Key Pair  
-Subnet_ID  
-Grupos de Seguridad a usar en cada apartado
-Cantidad de managers y workers  

Una vez ajustado, ejecutar los siguientes comandos:  

`terraform init`  



Esto configura el proveedor de AWS para el proyecto basado en el **main.tf** y a su vez, configura de forma interna las variables de **access_key** y **secret_key**  
Luego, validamos la configuración usando:  

  
`terraform validate`  


Cuando todo esté OK, entonces pasar al siguiente

`terraform plan`  


Este comando nos va a dar una idea de todo lo que va a hacer. 

`terraform apply`  
confirmamos con "yes" y veremos como se crea el swarm.  


## Consideraciones:
Tanto el script de Manager como el de Workers tienen una pausa de 3m antes de unirse al swarm. Esto es debido a que si el lider no ha terminado de configurar todo lo necesario entonces esa operación falla.  
En futuras actualizaciones se trabajará en mecanismos para efectuar eso de una manera mas acorde al proyecto.  

## Pendiente (TO-DO):

Agregar los script de inicio y apagado de las instancias basado en la cantidad deseada por horarios establecidos.

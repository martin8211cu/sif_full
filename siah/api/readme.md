***SIAH APi Seguridad***
----
**Version 1.0.1** <br />
Servicios de autorizacion para los sistemas de SIAH


---
**Login**   
**Proposito:**  Firmar a un usuario dentro de la aplicacion

* **URL:** /login

* **Method:** `POST`

* **Headers:** <br />
 **Content-Type:** application/json
  
* **Data Params:**

```json
{
    "company": "full", 
    "username": "soin", 
    "password": "Full2018"
}
```

* **Success Response:** <br /> 
**Code:** 200 <br />
**Content:** 
```json
{
    { "token": "90533F832533E9CB2AF8E5831F8EF3ED" }
}
```
 
---
**Logout**   
**Proposito:**  Cerrar la sesion de un usuario en la aplicacion

* **URL:** /logout

* **Method:** `POST`
  
* **Headers:** <br />
**Content-Type** application/json <br />
**Token**  `token` 
 
* **Success Response:** <br />
**Code:** 200 <br />
**Content:** 
```json
{}
```
 
---
**Auth**   
**Proposito:**  Verificar si un permiso esta activo para el usuario firmado, en la empresa proporcionada

* **URL:** /auth/<_empresa_>/<_identificador_>

* **Method:** `GET`

* **Headers:** <br />  
**Content-Type** application/json
**Token**  `token` 

*  **URL Params**

   **Required:** <br />
   `empresa=[integer]` <br /> 

   `identificador=[string]`

* **Success Response:** <br />
**Code:** 200 <br />
**Content:**
```json
{
    { "tienePermiso": true}
}
```
 
---
**Auths**   
**Proposito:**  Devuelve la lista de todos los permisos a los que el usuario firmado tiene acceso, para la empresa proporciona, permite realizar una búsqueda por medio del contenido enviado en el filtro

* **URL:** /auths/<_empresa_>/<_filtro_>

* **Method:** `GET`

* **Headers:** <br />  
**Content-Type** application/json
**Token**  `token` 

*  **URL Params**

   **Required:** <br />
   `empresa=[integer]` <br />
   
   `identificador=[string]`
   
   **Optional:** <br />
    `filtro=[string]`

* **Success Response:**
**Code:** 200 <br />
**Content:** 
```json
{
    "permisos": ["permiso1", "permiso2", ... ,"permisoN"]
}
```

----

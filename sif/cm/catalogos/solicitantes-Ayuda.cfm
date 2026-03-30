<div class="ayuda">
<cfif Session.Compras.Solicitantes.Pantalla EQ "0">
<strong>Solicitantes:</strong>
<br>
<br>
La presente es una lista con los solicitantes existentes en el sistema, usted puede modificar uno de ellos o crear uno nuevo, para modificar u observar la informaci&oacute;n de uno de ellos presione el bot&oacute;n derecho del rat&oacute;n sobre la l&iacute;nea correspondiente al tipo de solicitud que desea. Para crear uno nuevo presione el bot&oacute;n &quot;Nuevo&quot;, que se encuentra en la parte inferior de la lista. 
<br>
<br>
<cfelseif Session.Compras.Solicitantes.Pantalla EQ "1">
<strong>Paso 1:</strong>
<br>
El solicitante permite identificar en la organización quien esta autorizado a realizar solicitar activos, artículos y/o servicios. El sistema permite crear el solicitante con base en:
<ol>
<li>Solicitantes asociado al número de empleado, si existe integración con Recursos Humanos.</li>
<li>Solicitantes asociado a los usuarios definidos en el portal.</li>
</ol>
<br>
<br>
<cfelseif Session.Compras.Solicitantes.Pantalla EQ "2">
<strong>Paso 2:</strong>
<br>
La asociación de Centros Funcionales al solicitante, permite al sistema saber quienes pueden solicitar bienes y/o servicios dentro de las áreas definidas en la organización.
<br>
<br>
<cfelseif Session.Compras.Solicitantes.Pantalla EQ "3">
<strong>Paso 3:</strong>
<br>
<br>
Si se necesita definir por solicitante a que bienes y/o servicios puede este tener acceso, el sistema permite asociar con base en las reglas definidas por tipo de solicitud/centro funcional, la clase de artículo, activos o servicios que este podría requerir.
<br>
<br>
</cfif>
</div>
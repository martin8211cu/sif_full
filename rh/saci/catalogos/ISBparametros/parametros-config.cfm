<cfset parametrosDesc = StructNew()>
<cfset parametrosDesc["10"] = "Plazo Máximo para Entrega de Documentación del Agente">
<cfset parametrosDesc["20"] = "Plazo para Análisis de Calidad de Servicio del Agente">
<cfset parametrosDesc["21"] = "Plazo para Análisis de Calidad a Corto Plazo del Servicio del Agente">
<cfset parametrosDesc["30"] = "Plazo para Reasignación de Prospectos">
<cfset parametrosDesc["40"] = "Plazo para Borrado Permanente de Logines Inactivos">
<cfset parametrosDesc["50"] = "Caracteres Válidos para Nomenclatura de Logines y Passwords">
<cfset parametrosDesc["60"] = "Máscara para Números Telefónicos y Fax">
<cfset parametrosDesc["70"] = "Protocolo de Autenticación, Acceso y Contabilización (AAA)">
<cfset parametrosDesc["80"] = "Inicio de Período de Restricción para Cambios en Forma de Cobro">
<cfset parametrosDesc["90"] = "Fin de Período de Restricción para Cambios en Forma de Cobro">
<cfset parametrosDesc["100"] = "Paquete de Acceso para Agente">
<cfset parametrosDesc["200"] = "Usuario para ejecución de Web Services e Interfaces">
<cfset parametrosDesc["220"] = "Usuario para ejecución automática de tareas programadas">
<cfset parametrosDesc["221"] = "Motivo de bloqueo por no cambiar contraseña">
<cfset parametrosDesc["222"] = "Vendedor Genérico para ventas de DSO y Registro de Agentes">
<cfset parametrosDesc["223"] = "Caracteres Válidos para Nombres de Paquete">
<cfset parametrosDesc["224"] = "Usar Paquetes para Interfaz">
<cfset parametrosDesc["225"] = "Motivo de Bloqueo automático de medios por Morosidad">
<cfset parametrosDesc["226"] = "Número de días para el cálculo de la fecha (histórica) en el pase de las llamadas inconsistentes (crudo)">
<cfset parametrosDesc["227"] = "Mostrar el tab de Contactos">
<cfset parametrosDesc["228"] = "Motivo de bloqueo para Inhabilitación de Agentes">
<!--- Facturación de Medios --->
<cfset parametrosDesc["300"] = "Habilitar envío de facturas">
<cfset parametrosDesc["301"] = "Cuenta de correo saliente">
<cfset parametrosDesc["302"] = "Hora del corte de facturación">
<cfset parametrosDesc["310"] = "Habilitar recibo de facturas">
<cfset parametrosDesc["311"] = "Servidor de correo POP">
<cfset parametrosDesc["312"] = "Usuario de correo POP">
<cfset parametrosDesc["313"] = "Contraseña de correo POP">
<cfset parametrosDesc["314"] = "Eliminar del servidor POP los correos leídos">
<cfset parametrosDesc["400"] = "Dominio para Correo (ldap/iPlanet)">
<cfset parametrosDesc["401"] = "Dominio alterno para Correo (ldap/iPlanet)">
<cfset parametrosDesc["402"] = "Nombre del servidor de correo (ldap mailhost)">
<cfset parametrosDesc["410"] = "URL del web service para comunicación con CISCO">
<cfset parametrosDesc["411"] = "URL del web service para comunicación con iPlanet">
<cfset parametrosDesc["412"] = "URL del web service para comunicación con iPass">
<!--- Interfaz Cisco Secure --->
<cfset parametrosDesc["500"] = "Habilitar interfaz con Cisco (Servidor de acceso)">
<cfset parametrosDesc["501"] = "Ruta de instrucciones CLI">
<cfset parametrosDesc["502"] = "Host de la base de datos">
<cfset parametrosDesc["503"] = "Puerto de la base de datos">
<cfset parametrosDesc["504"] = "Perfil padre para los grupos creados">
<cfset parametrosDesc["505"] = "Grupos de usuarios inhabilitados">
<cfset parametrosDesc["506"] = "Servidor que autoriza">
<cfset parametrosDesc["510"] = "Modo de ejecución del shell">
<!--- Interfaz iPlanet --->
<cfset parametrosDesc["520"] = "Habilitar interfaz con iPlanet (Servidor de correo)">
<cfset parametrosDesc["521"] = "Sufijo LDAP (ou=...)">
<cfset parametrosDesc["522"] = "Dominio alterno de correo">
<cfset parametrosDesc["523"] = "Servidor del correo">
<cfset parametrosDesc["524"] = "Host del LDAP">
<cfset parametrosDesc["525"] = "Usuario del LDAP (RDN)">
<cfset parametrosDesc["526"] = "Contraseña para LDAP">
<cfset parametrosDesc["527"] = "Puerto del LDAP">
<cfset parametrosDesc["528"] = "Habilitar atributos LDAP específicos para el correo">
<!--- Interfaz iPass --->
<cfset parametrosDesc["540"] = "Habilitar interfaz con iPass (Servidor de roaming)">
<cfset parametrosDesc["541"] = "Ruta de instrucciones shell">
<cfset parametrosDesc["542"] = "Dirección del archivo policy.txt">
<cfset parametrosDesc["550"] = "Modo de ejecución del shell">
<!--- Interfaz JMS --->
<cfset parametrosDesc["560"] = "JMS Provider URL">
<cfset parametrosDesc["561"] = "JMS Initial Context Factory">
<cfset parametrosDesc["562"] = "JMS Queue Connection Factory">
<cfset parametrosDesc["563"] = "JMS Queue Name">
<cfset parametrosDesc["564"] = "JMS maxMessages">
<cfset parametrosDesc["565"] = "JMS Receive timeout (ms)">

<cfset parametros = StructKeyArray(parametrosDesc)>

<!--- Carga de los valores de la tabla de parametros --->
<cfset paramValues = StructNew()>
<cfloop from="1" to="#ArrayLen(parametros)#" index="i">
	<cfinvoke component="saci.comp.ISBparametros" method="Get" returnvariable="valor">
		<cfinvokeargument name="Pcodigo" value="#parametros[i]#">
	</cfinvoke>
	<cfset paramValues[parametros[i]] = valor>
</cfloop>

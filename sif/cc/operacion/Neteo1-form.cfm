<!--- 
	Creado por: Ana Villavicencio
	Fecha: 23 de agosto del 2005
	Motivo: Correccion del titulo de la forma, cuando entraba por CxP dejaba el titulo "Cuentas por Cobrar".
			Esto porque solo existen un proceso de neteo de documentos y este se encuentra dentro de la carpeta 
			de CxC. Creando un archivo dentro de CxP y haciendo la llamada del proceso, hace la corrección. Además 
			cambios en la seguridad de CxP.
			Se crea este nuevo fuente para almacenar los datos del form de Neteo1, este se llama en Neteo1.cfm
			
	Modificado por: Ana Villavicencio
	Fecha: 12 de octubre del 2005
	Motivo: Se acomodaron las etiquetas de los campos del encabezado.
	
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_DocNet = t.Translate('LB_DocNet','Documento Neteo')>
<cfset LB_DocANetCXC = t.Translate('LB_DocANetCXC','Documento a Netear CXC')>
<cfset LB_DocANetCXP = t.Translate('LB_DocANetCXP','Documento a Netear CXP')>

<cfset MSG_NeteoDoct = t.Translate('MSG_NeteoDoct','Neteo de Documentos de CxC y CxP: No se permiten Anticipos de Efectivo','/sif/cc/operacion/Neteo1.xml')>
		<cfset MSG_AplAntCxC1 = t.Translate('MSG_AplAntCxC1','Aplicación de Anticipos de CxC: No se permiten Documentos de CxP','/sif/cc/operacion/Neteo1.xml')>
		<cfset MSG_AplAntCxC2 = t.Translate('MSG_AplAntCxC2','Aplicación de Anticipos de CxC: No se permiten Documentos a favor de CxC que no sean de Anticipos','/sif/cc/operacion/Neteo1.xml')>
		<cfset MSG_AplAntCxP1 = t.Translate('MSG_AplAntCxP1','Aplicación de Anticipos de CxP: No se permiten Documentos de CxC','/sif/cc/operacion/Neteo1.xml')>
		<cfset MSG_AplAntCxP2 = t.Translate('MSG_AplAntCxP2','Aplicación de Anticipos de CxP: No se permiten Documentos a favor que no sean de Anticipos','/sif/cc/operacion/Neteo1.xml')>
		<cfset MSG_NeteoAnt = t.Translate('MSG_NeteoAnt','Neteo de Anticipos de CxC y CxP: No se permiten Documentos que no son Anticipos de Efectivo','/sif/cc/operacion/Neteo1.xml')>

	<!--- Define el Tipo de Neteo para las pantallas comunes --->
	<cfset TipoNeteo = 1>
	<!--- Pasa Lave que puede venir por url al form --->
	<cfif isdefined("url.idDocumentoNeteo") and len(trim(url.idDocumentoNeteo))>
		<cfset form.idDocumentoNeteo = url.idDocumentoNeteo>
	</cfif>
	<!--- Pintado del Form  --->
	<br>
	<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
	  	<tr><td class="subTitulo" style="text-transform:uppercase" align="center"><cfoutput>#LB_DocNet#</cfoutput></td></tr>
	  	<tr><td><cfinclude template="Neteo-Common-formneteo.cfm"></td></tr>
	</table>
	<br>
	<cfif (modoneteo neq "ALTA")>
    <cfoutput>
	<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td valign="top" width="50%">
				<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
					<tr><td class="subTitulo" style="text-transform:uppercase" align="center">#LB_DocANetCXC#</td></tr>
				  	<tr><td>&nbsp;</td></tr>
				  	<tr><td valign="top"><cfinclude template="Neteo-Common-formcxc.cfm"></td></tr>
				  	<tr><td valign="top"><cfinclude template="Neteo-Common-listacxc.cfm"></td></tr>
				</table>
			</td>
			<td valign="top" width="50%">
				<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
					<tr><td class="subTitulo" style="text-transform:uppercase" align="center">#LB_DocANetCXP#</td></tr>
					<tr><td>&nbsp;</td></tr>
				  	<tr><td valign="top"><cfinclude template="Neteo-Common-formcxp.cfm"></td></tr>
				  	<tr><td valign="top"><cfinclude template="Neteo-Common-listacxp.cfm"></td></tr>
				</table>
			</td>
	  	</tr>
	</table>
    </cfoutput>
	<br>
	</cfif>
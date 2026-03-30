<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Titulo" Default="Catálogo de Cuentas Contables" 
returnvariable="LB_Titulo" xmlfile = "formRCuentas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Archivo" Default="Cuentas_Contables" 
returnvariable="LB_Archivo" xmlfile = "formRCuentas.xml"/>

<cf_templatecss>
<cfset fnsetParametrosReporte()>
<cfif isdefined("url.botonsel") and url.botonsel eq "Exportar">
	<cf_exportQueryToFile query="#rsProc#" separador="#chr(9)#" filename="#LB_Archivo##session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.txt" jdbc="false">
	<cfabort>
</cfif>
<cf_htmlReportsHeaders 
	title="#LB_Titulo#" 
	bodytag="style=""size:portrait; page:'letter';""" 
	filename="#LB_Archivo#_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls"
	irA="/cfmx/sif/cg/consultas/RCuentas.cfm" 
    method='get'
	>
<cfflush interval="64">
<table width="100%"  border="0" cellspacing="1" cellpadding="1">
	<tr>
		<td colspan="4" align="center"><strong><font size="4"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></font></strong></td>
	</tr>
	<tr>
		<td colspan="4" align="center"><strong><font size="3"><cf_translate key=LB_Titulo>Cat&aacute;logo de Cuentas Contables</cf_translate></font></strong></td>
	</tr>
	<tr>
		<td colspan="4" align="center"><strong><cf_translate key = LB_CuentaIni>Cuenta Inicial</cf_translate>:</strong>&nbsp;<cfoutput>#fmt1#</cfoutput>&nbsp;<strong>&nbsp;<cf_translate key = LB_CuentaFin>Cuenta Final</cf_translate>:</strong>&nbsp;<cfoutput>#fmt2#</cfoutput></td>
	</tr>
	<tr>
		<td width="30%"><cf_translate key=LB_Usuario>Usuario</cf_translate>:<cfoutput>#Session.Usuario#</cfoutput></td>
		<td width="49%" colspan="2">&nbsp;</td>
		<td width="21%" nowrap><cf_translate key=LB_Fecha>Fecha</cf_translate>: <cfoutput>#DateFormat(Now(),'DD/MM/YYYY')# #TimeFormat(Now(),'medium')#</cfoutput></td>
	</tr>
	<tr bgcolor="#0099CC" >
		<td nowrap height="20px"><font color="#FFFFFF"><strong><cf_translate key=LB_Cuenta>Cuenta</cf_translate></strong></font></td>
		<td colspan="2" nowrap height="20px"><font color="#FFFFFF"><strong><cf_translate key=LB_Descripcion>Descripci&oacute;n</cf_translate></strong></font></td>
		<td nowrap height="20px"><strong><font color="#FFFFFF"><cf_translate key = LB_Balance>Balance Normal</cf_translate></font></strong></td>
	</tr>
	<cfset Lvarcontador = 0>
	<cfoutput query="rsProc"> 
		<tr class="<cfif CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
			<td nowrap>&nbsp;#Cformato#</td>
			<td colspan="2" nowrap>#Cdescripcion#</td>
			<td nowrap>#Cbalancen#</td>
		</tr>
		<cfflush>
	</cfoutput>
	<tr>
		<td colspan="4" align="center">---------- <cf_translate key=LB_Fin>FIN DEL REPORTE</cf_translate> ----------</td>
	</tr>
</table>

<cffunction name="fnsetParametrosReporte" output="no" access="private">
	<cfparam name="Form.Cformato1" default="">
	<cfparam name="Form.Cformato2" default=""> 
	
	<!--- DATOS URL --->
	<cfif isdefined("url.Cformato1") and len(trim(url.Cformato1)) gt 0 >
		<cfset form.Cformato1 = trim(url.Cmayor_Ccuenta1) & "-" & trim(url.Cformato1) >
	<cfelseif isdefined("url.Cmayor_Ccuenta1") and len(trim(url.Cmayor_Ccuenta1)) gt 0 >
		<cfset form.Cformato1 = trim(url.Cmayor_Ccuenta1) >
	</cfif>
	
	<cfif isdefined("url.Cformato2") and len(trim(url.Cformato2)) gt 0 >
		<cfset form.Cformato2 = trim(url.Cmayor_Ccuenta2) & "-" & trim(url.Cformato2) >
	<cfelseif isdefined("url.Cmayor_Ccuenta2") and len(trim(url.Cmayor_Ccuenta2)) gt 0 >
		<cfset form.Cformato2 = trim(url.Cmayor_Ccuenta2) >
	</cfif>
	
	<cfset fmt1 = Form.Cformato1>
	<cfset fmt2 = Form.Cformato2>
	
	<cfquery name="rsEmpresa" datasource="#Session.DSN#">
		select Edescripcion 
		from Empresas
		where Ecodigo = #Session.Ecodigo#
	</cfquery>
	
	<cfquery name="rsProc" datasource="#session.dsn#">
		select Cformato, Cdescripcion, Cbalancen
		from CContables
		where Ecodigo = #Session.Ecodigo#
		<cfif len(trim(fmt1)) GT 0>
		  and Cformato >= '#fmt1#'
		</cfif>
		<cfif len(trim(fmt2)) GT 0>
		  and Cformato <= '#fmt2#'
		</cfif>
		order by Cformato
	</cfquery>
</cffunction>


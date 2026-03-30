<!--- 
	Modificado por:  Mauricio Esquivel
	Fecha:  12 de Octubre del 2008
	Documentación:
		Se agrega la posibilidad de incorporar cuerpo al correo electrónico con los Estados de Cuenta
		Si existe un archivo con el formato del cuerpo del correo se procesa. 
		En caso de que no exista el archivo, se procesa el cuerpo estándar del correo


	Modificado por: Ana Villavicencio
	Fecha: 07 de marzo del 2006
	Motivo: Agregar el filtro de Clasificación por dirección.

	Creado por Gustavo Fonseca H.
		Fecha: 23-11-2005
		Motivo: Separar el sql de la pantalla.
		Implementar la funcionalidad de mandar los Estados de Cuenta (Mes Cerrado) por correo electrónico.
		
--->

<!--- validaciones  --->
<cfquery name="rsParametros" datasource="#session.DSN#">
	select Pvalor as p1
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo = 310
</cfquery>

<cfif rsParametros.recordcount gt 0>
	<cfset p1 = rsParametros.p1>
<cfelse>
	<cf_errorCode	code = "50178" msg = "Debe definir el primer período en los parámetros.">
</cfif>

<cfquery name="rsParametros" datasource="#session.DSN#">
	select Pvalor as p2
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo = 320
</cfquery>

<cfif rsParametros.recordcount gt 0>
	<cfset p2 = rsParametros.p2>
<cfelse>
	<cf_errorCode	code = "50179" msg = "Debe definir el segundo período en los parámetros.">
</cfif>

<cfquery name="rsParametros" datasource="#session.DSN#">
	select Pvalor as p3
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo = 330
</cfquery>
<cfif rsParametros.recordcount gt 0>
	<cfset p3 = rsParametros.p3>
<cfelse>
	<cf_errorCode	code = "50180" msg = "Debe definir el tercer período en los parámetros.">
</cfif>

<cfquery name="rsParametros" datasource="#session.DSN#">
	select Pvalor as p4
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo = 340
</cfquery>
<cfif rsParametros.recordcount gt 0>
	<cfset p4 = rsParametros.p4>
<cfelse>
	<cf_errorCode	code = "50181" msg = "Debe definir el cuarto período en los parámetros.">
</cfif>

<!--- Parametros --->

<cfset LvarDEidCobrador = -1>
<cfif isdefined('url.DEidCobrador') and len(trim(url.DEidCobrador))>
	<cfset LvarDEidCobrador = url.DEidCobrador>
</cfif>
<cfset LvarSNCEid = -1>
<cfif isdefined('url.SNCEid') and len(trim(url.SNCEid))>
	<cfset LvarSNCEid = url.SNCEid>
</cfif>

<cfset LvarSNCEid_Orden = -1>
<cfif isdefined('url.SNCEid_Orden') and len(trim(url.SNCEid_Orden))>
	<cfset LvarSNCEid_Orden = url.SNCEid_Orden>
</cfif>

<cfset LvarSNCDvalor1 = ' '>
<cfif isdefined('url.SNCDvalor1') and len(trim(url.SNCDvalor1))>
	<cfset LvarSNCDvalor1 = url.SNCDvalor1>
</cfif>

<cfset LvarSNCDvalor2 = ' '>
<cfif isdefined('url.SNCDvalor2') and len(trim(url.SNCDvalor2))>
	<cfset LvarSNCDvalor2 = url.SNCDvalor2>
</cfif>

<cfset LvarSaldoCero = -1>
<cfif isdefined('url.SaldoCero') and len(trim(url.SaldoCero))>
	<cfset LvarSaldoCero = url.SaldoCero>
</cfif>

<cfset Lvarchk_cod_Direccion = -1>
<cfif isdefined('url.chk_cod_Direccion') and len(trim(url.chk_cod_Direccion))>
	<cfset Lvarchk_cod_Direccion = url.chk_cod_Direccion>
</cfif>

<cfset LvarTipoReporte = ' '>
<cfif isdefined('url.TipoReporte') and len(trim(url.TipoReporte))>
	<cfset LvarTipoReporte = url.TipoReporte>
</cfif>
<cfset Lvarordenado = -1>
<cfif isdefined('url.ordenado') and len(trim(url.ordenado))>
	<cfset Lvarordenado = url.ordenado>
</cfif>

<cfset LvarFormato = -1>
<cfif isdefined('url.Formato') and len(trim(url.Formato))>
	<cfset LvarFormato = url.Formato>
</cfif>

<cfset LvarCobrador = -1>
<cfif isdefined('url.Cobrador') and len(trim(url.Cobrador)) and url.cobrador NEQ 'Todos'>
	<cfset LvarCobrador = url.Cobrador>
</cfif>

<cfset Lvarorientacion = 0>
<cfif isdefined('url.orientacion') and len(trim(url.orientacion))>
	<cfset Lvarorientacion = url.orientacion>
</cfif>

<cfif isdefined('url.SNnumero') and len(trim(url.SNnumero))>
	<cfset LvarSNnumero = url.SNnumero>
<cfelse>
	<cfset LvarSNnumero = ' '>
</cfif>
	
<cfif isdefined('url.SNnumerob2') and len(trim(url.SNnumerob2))>
	<cfset LvarSNnumerob2 = url.SNnumerob2>
<cfelse>
	<cfset LvarSNnumerob2 = 'zzzzzzzzzzzzzzzzzzzzzzzzz'>
</cfif>

<cfif isdefined('url.SNcodigo') and len(trim(url.SNcodigo))>
	<cfset LvarSNcodigo = url.SNcodigo>
<cfelse>
	<cfset LvarSNcodigo = '0'>
</cfif>
	
<cfif isdefined('url.SNcodigob2') and len(trim(url.SNcodigob2))>
	<cfset LvarSNcodigob2 = url.SNcodigob2>
<cfelse>
	<cfset LvarSNcodigob2 = '99999999'>
</cfif>

<cfinclude template="Estado_Cuenta_ClasiFxMes_SQL_Email.cfm">

<cfset socios= CreaTemp1()>
<cfset movimientos= CreaTemp2()>


<cfif isdefined("url.chk_email")>
	<cfset tempfile=''>	
	<cfset Politicas = CreateObject("component", "home.Componentes.Politicas")>
	<cfset data = StructNew()>
	<cfset data.correo_cuenta = Politicas.trae_parametro_global("correo.cuenta")>	

	<cfset fechainicio  = createdate(url.periodo,url.mes,'01')>
	<cfset fechafinal  = dateadd('m',1,fechainicio)>
	<cfset fechafinal  = dateadd('l',-1,fechafinal)>

	<cfset fnSeleccionarSocios ( LvarSNnumero, LvarSNnumerob2, Lvarchk_cod_Direccion, LvarDEidCobrador, LvarSNCEid,LvarSNCDvalor1, LvarSNCDvalor2, "RSListaSocios")>

	<cfset i = 0>
	<cfset w = '0'>

	<cfoutput><h2><strong>Enviando correos...</strong></h2></cfoutput>
	<cfflush interval="20">
	<div style="width:400px;background-color:#000000"> <!--- Negro --->
		<div style="width:10px;background-color:#00CCFF;text-align:center" id="Lvardiv">&nbsp;</div> <!--- Celeste --->
	</div>

	<label id="LvarLabel"><cfoutput>#w/4# % Completado.</cfoutput></label>

	<cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 1>
		<cfset extension = "swf">
	<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 2>
		<cfset extension = "pdf">
	<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 3>
		<cfset extension = "xls">
	</cfif>


	<!--- Formato genérico para el cuerpo del archivo --->
	<cfset LvarTemplateCorreo = "Estado_Cuenta_CuerpoEmail_gen.cfm">
	
    <cfset rootdir = expandpath('')>
	<cfset directorio = "#rootdir#/sif/cc/reportes">
    <cfset directorio = replace(directorio, '\', '/', 'all') >
    <cfdirectory action="list" directory="#directorio#" name="rsListaEmail">
    
    <cfset LvarCuerpoEmail = 'Estado_Cuenta_CuerpoEmail_#session.Ecodigo#.cfm'>

    <cfset LvarBanderaFormatoEmpresa = 0>
    <cfloop query="rsListaEmail">
        <cfif findnocase(LvarCuerpoEmail, Name,1) GT 0>
            <!--- Encontrado --->
            <cfset LvarTemplateCorreo = LvarCuerpoEmail>
            <cfset LvarBanderaFormatoEmpresa = 1>
        </cfif>
    </cfloop>

	<cfset LvarFechaEstado = createdate(url.periodo, url.mes, 1)>
	<cfset LvarFechaEstado = dateadd('d', -1, dateadd('m', 1, LvarFechaEstado))> 
	<cfset LvarFechaEstado = Dateformat(LvarFechaEstado, 'DD/MM/YYYY')>

    <!--- Si encuentra un formato específico para la empresa lo utiliza --->
    
	<cfset tempfile = GetTempDirectory() & "\EstadoCuenta.#extension#">

	
	<cfloop query="RSListaSocios">
		<cfset LvarEmailContacto = RSListaSocios.EmailCobrador>
		<cfset LvarSNemail  = RSListaSocios.SNemail>
        <cfset LvarSNnumero = RSListaSocios.SNnumero>
        <cfset LvarSNcodigo = RSListaSocios.SNcodigo>
		<cfset LvarSNnombre = RSListaSocios.SNnombre>
		<cfset LvarSNnombre = replace(LvarSNnombre,","," ","all")>
		<cfset LvarSNnombre = replace(LvarSNnombre,";"," ","all")>
        <cfset Lvarid_direccion = RSListaSocios.id_direccion>

		<cfoutput><br>Enviando correo para #LvarSNnombre#...</cfoutput><br />

		<cfset LvarTemp= BorraTemporales(socios, movimientos)>
		<cfset i = i + 1 >

        <cfsavecontent variable="LvarCuerpoCorreo">
            <cfinclude template="#LvarTemplateCorreo#">
        </cfsavecontent>
		
		<cfset LvarTempRegistros=Generar(
				url.periodo, 
				url.mes, 
				LvarSNnumero, 
				LvarSNnumero, 
				LvarSNcodigo, 
				LvarSNcodigo,
				LvarDEidCobrador,
				LvarSNCEid,
				LvarSNCEid_Orden,
				LvarSNCDvalor1,
				LvarSNCDvalor2,
				LvarSaldoCero,
				Lvarchk_cod_Direccion,
				Lvarordenado,
				LvarTipoReporte,
				LvarFormato,
				LvarCobrador,
				Lvarorientacion,
				Lvarid_direccion
		)>

		<cfif LvarTempRegistros GTE 0>
			<cfset LvarEmailValid = IsValid('email',#LvarSNemail#)>
			<cfset LvarEnviado = true>
        	<cfif len(trim(LvarSNemail)) and LvarEmailValid>
            	<cftry>
                    <cfmail from="#data.correo_cuenta#" subject="Estado de Cuenta: año #url.periodo#, mes #url.mes#." 
                    spoolenable="no" to="'#LvarSNnombre#'<#LvarSNemail#>">
                        <cfmailparam file="#tempfile#">
                        <cfif LvarBanderaFormatoEmpresa eq 1>
                            <cfmailparam file="LogoPagina_#session.Ecodigo#.jpg">
                            <cfmailparam file="FondoPagina_#session.Ecodigo#.jpg">
                            <cfmailparam file="PiePagina_#session.Ecodigo#.jpg">
                        </cfif>
                        <cfmailpart type="html" wraptext="72">
                            #LvarCuerpoCorreo#
                        </cfmailpart>
                    </cfmail>
                    <cfcatch type="any">
                        <cfoutput><strong>NO enviado</strong>: No se pudo entregar el estado de cuenta a la siguiente dirección '#LvarSNemail#'...</cfoutput>
						<cfset LvarEnviado = false>
                    </cfcatch>
                 </cftry>
                <cffile action="delete" file="#tempfile#"> 
                <cfif LvarEnviado>
	                <cfoutput>Enviado a: #RSListaSocios.SNemail#</cfoutput>
                </cfif>
			<cfelse>
				<cfoutput><strong>NO enviado</strong> (La dirección de correo electrónico '#LvarSNemail#' no es correcta)...</cfoutput>
			</cfif>
		<cfelse>
			<cfoutput><strong>NO enviado</strong> (Estado de cuenta vacio o la dirección de correo electrónica no es correcta)...</cfoutput>
		</cfif>
		<cfset w = 400 * i  / RSListaSocios.recordcount>
		<script type="text/javascript">
			<cfoutput>
				document.getElementById('LvarLabel').innerHTML="#w/4# % Completado.";
			</cfoutput>
			var Lvardiv = document.all ? document.Lvardiv : document.getElementById('Lvardiv');
			document.all.Lvardiv.style.width = '<cfoutput>#w#</cfoutput>px';
		</script>
        <cfflush>
	</cfloop>
	<cfset LvarTemp= BorraTemporales(socios, movimientos)>	
<cfelse>
	<cfset tempfile=''>
    <cfset Lvarid_direccion = -1>
	<cfset LvarTemp=Generar(
				url.periodo, 
				url.mes, 
				LvarSNnumero, 
				LvarSNnumerob2, 
				LvarSNcodigob2, 
				LvarSNcodigo,
				LvarDEidCobrador,
				LvarSNCEid,
				LvarSNCEid_Orden,
				LvarSNCDvalor1,
				LvarSNCDvalor2,
				LvarSaldoCero,
				Lvarchk_cod_Direccion,
				Lvarordenado,
				LvarTipoReporte,
				LvarFormato,
				LvarCobrador,
				Lvarorientacion				
				)>
	<cfset LvarTemp= BorraTemporales(socios, movimientos)>
</cfif>


<form name="form1" action="Estado_Cuenta_ClasiFxMes.cfm">
<table border="0" cellpadding="0" cellspacing="0" width="400">
	<tr>
		<td nowrap="nowrap">&nbsp;</td>
		<td nowrap="nowrap">&nbsp;</td>
		<td nowrap="nowrap">&nbsp;</td>
		<td nowrap="nowrap">&nbsp;</td>
		<td nowrap="nowrap">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="5" nowrap="nowrap">Proceso de envio de correo terminado. Presione el botón para regresar.</td>
	</tr>
	<tr>
		<td colspan="5" nowrap="nowrap" align="center">
			<input type="submit" name="Regresar" value="Regresar">
		</td>
	</tr>
</table>
</form>


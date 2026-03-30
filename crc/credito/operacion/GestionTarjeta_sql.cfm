<cfoutput>
	<cfset dateToken = Now()>
	<cfif isDefined('form.Eliminar')>

		<cfquery name="q_folioC" datasource="#session.dsn#">
			select top(1) FolioCancelado from CRCTarjeta order by FechaCancelada desc;
		</cfquery>
		<cfif q_folioC.FolioCancelado eq ''>
			<cfset consecutivo = '00'>
		<cfelse>
			<cfset consecutivo = right(q_folioC.FolioCancelado, 2)>
		</cfif>
		<cfset consecutivo = NumberFormat(consecutivo,'0') + 1>
		<cfset consecutivo = right('0#consecutivo#', 2)>
		<cfset folioCancel = '#Left(form.TCNum,4)##DateFormat(dateToken,"yy")##DateFormat(dateToken,"mm")##consecutivo#'>

		<cfquery datasource="#session.dsn#">
			update CRCTarjeta set 
				  Estado = 'C' 
				, MotivoCancelado = 'Cancelada: #form.MotivoCancel#'
				, FolioCancelado = '#folioCancel#'
				, updatedat = CURRENT_TIMESTAMP
				, FechaCancelada = CURRENT_TIMESTAMP
				, usumodif = #session.usucodigo#
			where Numero = '#form.TCNum#'
		</cfquery>
		<cfset incidenciaID = registrarIncidencia('Eliminar','#form.TCNum#','#form.MotivoCancel# (#folioCancel#)')>
	</cfif>
	<cfif isDefined('form.Aplicar')>
		<cfquery datasource="#session.dsn#">
			update CRCTarjeta set 
			 	  Estado = 'A'
				, MotivoCancelado = 'Activada'
				, updatedat = CURRENT_TIMESTAMP
				, FechaActivada = CURRENT_TIMESTAMP
				, usumodif = #session.usucodigo#
			where Numero = '#form.TCNum#'
		</cfquery>
		<cfset MotivoCancel = "">
		<cfif isdefined("form.MotivoCancel")><cfset MotivoCancel = form.MotivoCancel></cfif>
		<cfset incidenciaID = registrarIncidencia('Aplicar','#form.TCNum#','#MotivoCancel#')>
	</cfif>
	<cfif isDefined('form.Regresar')>
		<cfquery datasource="#session.dsn#">
			update CRCTarjeta set  
				  Estado = 'A'
				, MotivoCancelado = 'Reactivada: #form.MotivoCancel#'
				, updatedat = CURRENT_TIMESTAMP
				, FechaActivada = CURRENT_TIMESTAMP
				, usumodif = #session.usucodigo#
			where Numero = '#form.TCNum#'
		</cfquery>
		<cfset incidenciaID = registrarIncidencia('Regresar','#form.TCNum#','#form.MotivoCancel#')>
	</cfif>


	<!---VALIDADOR--->

	<form action="GestionTarjeta.cfm" method="post" name="sql">
		<input name="modo" type="hidden" value="CAMBIO">
		<input name="TCNum" type="hidden" value="#form.TCNum#">
	</form>
</cfoutput>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

<cffunction  name="registrarIncidencia">
	<cfargument  name="tipo" required="true">
	<cfargument  name="TCnum" required="true">
	<cfargument  name="motivo" required="true">

	<cfset Cortes = createObject('component', 'crc.Componentes.cortes.CRCCortes')>
	<cfset currentCorte = Cortes.GetCorte(Now(), "#form.tipo#","#session.dsn#",session.ecodigo)>

	<cfquery name="q_usuario" datasource="#session.DSN#">
		select A.llave from UsuarioReferencia A 
			inner join DatosEmpleado B 
				on A.llave = B.DEid 
		where A.Usucodigo = #session.usucodigo# and STabla = 'DatosEmpleado';
	</cfquery>

	<cfquery name="q_cuenta" datasource="#session.DSN#">
		select CRCCuentasid from CRCTarjeta
			where Numero = '#arguments.TCNum#'
	</cfquery>

	<cfscript>
		switch(arguments.tipo){
			case 'Aplicar': mensaje = "Activacion de Tarjeta:"; break;
			case 'Eliminar': mensaje = "Cancelacion de Tarjeta:"; break;
			case 'Regresar': mensaje = "Reactivacion de Tarjeta:"; break;
			default: mensaje = "Gestion de Tarjeta:"; break;
		}
	</cfscript>

	<cfset mensaje="#mensaje# #arguments.TCnum# - #arguments.Motivo#">

	<cfset Incidencia = createObject('component', 'crc.Componentes.incidencias.CRCIncidencia')>
	<cfset nuevaIncidencia = Incidencia.crearIncidencia(CuentaID=q_cuenta.CRCCuentasid,Mensaje="#mensaje#")>
	
	<cfreturn nuevaIncidencia>
</cffunction>
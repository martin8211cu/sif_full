<cfcomponent>
		<cffunction name="get" access="public" returntype="query">
				<cfargument  name="dsn" required="false" default="#session.dsn#">
				<cfargument  name="Usucodigo" required="false" default="#session.Usucodigo#">
				<cfargument  name="Ecodigo" required="false" default="#session.Ecodigo#">
				<cfargument  name="soloTramites" required="false" default="true">

        <cfparam name="Beneficiario" default="#arguments.Usucodigo#">

        <cfinvoke component="sif.Componentes.Workflow.Management" method="getWorkload" returnvariable="workload">
            <cfinvokeargument name="Conexion"  value="#arguments.dsn#">
            <cfinvokeargument name="Usucodigo" value="#arguments.Usucodigo#">
            <cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#">
        </cfinvoke>

        <cfset myQuery = QueryNew("NotifyUrl,NotifyUsucodigoRef,Notifyfecha,NotifyAsunto,ProcessInstanceId,NotifyID", "VarChar,BigInt,Time,varchar,varchar,bigint")>

        <cfloop query="workload">
					<cfset newRow = QueryAddRow(MyQuery, 1)>
            <cfset temp = QuerySetCell(myQuery, "NotifyUrl", "/cfmx/sif/tr/consultas/aprobacion-detalle.cfm?from=aprobacion&ProcessInstanceId=#ProcessInstanceId#&ActivityInstanceId=#ActivityInstanceId#", currentrow)>
            <cfset temp = QuerySetCell(myQuery, "NotifyUsucodigoRef", Beneficiario, currentrow)>
            <cfset temp = QuerySetCell(myQuery, "Notifyfecha",STARTTIME, currentrow)>
            <cfset temp = QuerySetCell(myQuery, "NotifyAsunto",PROCESSDESCRIPTION&'<br>'&PROCESSINSTANCEDESCRIPTION, currentrow)>
            <cfset temp = QuerySetCell(myQuery, "ProcessInstanceId", ProcessInstanceId, currentrow)>
					<cfset temp = QuerySetCell(myQuery, "NotifyID", 0, currentrow)>
      	</cfloop>

        <cfset myQueryFinal = QueryNew("NotifyUrl,NotifyUsucodigoRef,Notifyfecha,NotifyAsunto,ProcessInstanceId,NotifyID", "VarChar,BigInt,Time,varchar,varchar,bigint")>

        <cfloop query="myQuery">
            <cfquery name="rsExisteNRP" datasource="#arguments.dsn#">
                select count(1) as cantidad from ESolicitudCompraCM where NRP is not null and ProcessInstanceid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ProcessInstanceId#">
            </cfquery>

            <cfif rsExisteNRP.cantidad eq 0>
                <cfset newRow = QueryAddRow(myQueryFinal, 1)>
                <cfset temp = QuerySetCell(myQueryFinal, "NotifyUrl", NotifyUrl, currentrow)>
                <cfset temp = QuerySetCell(myQueryFinal, "NotifyUsucodigoRef", NotifyUsucodigoRef , currentrow)>
                <cfset temp = QuerySetCell(myQueryFinal, "Notifyfecha", Notifyfecha , currentrow)>
                <cfset temp = QuerySetCell(myQueryFinal, "NotifyAsunto", NotifyAsunto , currentrow)>
                <cfset temp = QuerySetCell(myQueryFinal, "ProcessInstanceId", ProcessInstanceId, currentrow)>
				<cfset temp = QuerySetCell(myQueryFinal, "NotifyID", 0, currentrow)>

            </cfif>
        </cfloop>

				<cfif arguments.soloTramites>
					<cfset rsNotificaciones = getNotifyUser(Ecodigo = Arguments.Ecodigo, Usucodigo = arguments.Usucodigo)>
					<cfif rsNotificaciones.recordCount gt 0>
						<cfloop query="#rsNotificaciones#">
							<cfset newRow = QueryAddRow(myQueryFinal)>
							<cfset temp = QuerySetCell(myQueryFinal, "NotifyUrl", NotifyUrl)>
							<cfset temp = QuerySetCell(myQueryFinal, "NotifyUsucodigoRef", NotifyUsucodigoRef )>
							<cfset temp = QuerySetCell(myQueryFinal, "Notifyfecha", Notifyfecha )>
							<cfset temp = QuerySetCell(myQueryFinal, "NotifyAsunto", NotifyAsunto )>
							<cfset temp = QuerySetCell(myQueryFinal, "ProcessInstanceId", NotifyProceso)>
							<cfset temp = QuerySetCell(myQueryFinal, "NotifyID", NotifyId)>
						</cfloop>
					</cfif>
				</cfif>

       <!---- ordena por fecha mas vieja---->
        <cfquery dbtype="query" name="myQuery">
        	select distinct * from myQueryFinal order by Notifyfecha asc
       	</cfquery>

        <cfreturn myQuery>

    </cffunction>

	<cffunction name="getNotifyUser" access="public" returntype="query">
		<cfargument name="Ecodigo" type="numeric" default="#session.Ecodigo#">
    <cfargument name="Usucodigo" type="numeric" default="#session.Usucodigo#">

		<cfquery name="rsNotify" datasource="asp">
			select
				NotifyId,
				NotifyUrl,
				NotifyUsucodigoRef,
				Notifyfecha,
				NotifyAsunto,
				NotifyProceso
			from NotifyUser
			where 	NotifyEcodigo = #Arguments.Ecodigo#
				and NotifyUsucodigo = #Arguments.Usucodigo#
				and NotifyVisto = 0
		</cfquery>

		<cfreturn rsNotify>
	</cffunction>

	<cffunction name="updateNotifyUser" access="remote">
		<cfargument name="NotifyId" type="numeric">

		<cfquery datasource="asp">
			update NotifyUser
				set NotifyVisto = 1,
					NotifyVistoFecha = <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">
			where NotifyId = #arguments.NotifyId#
		</cfquery>

	</cffunction>

	<cffunction name="insertNotifyUser" access="remote">
		<cfargument name="url" type="string">
        <cfargument name="UsucodigoRef" type="numeric">
		<cfargument name="Asunto" type="string">
		<cfargument name="Proceso" type="string">
        <cfargument name="Usucodigo" type="numeric" default="#session.Usucodigo#">
		<cfargument name="Ecodigo" type="numeric" default="#session.Ecodigo#">
		<cfargument name="enviaCorreo" type="boolean" default="false">
		<cfquery datasource="asp">
			INSERT INTO NotifyUser(
				NotifyUrl
			    ,NotifyUsucodigo
			    ,NotifyUsucodigoRef
			    ,Notifyfecha
			    ,NotifyAsunto
			    ,NotifyEcodigo
			    ,NotifyProceso
			)VALUES(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.url#">
			    ,#Arguments.Usucodigo#
			    ,#Arguments.UsucodigoRef#
			    ,<cfqueryparam value="#now()#" cfsqltype="cf_sql_date">
			    ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Asunto#">
			    ,#Arguments.Ecodigo#
			    ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Proceso#">
			)
		</cfquery>

		<cfif arguments.enviaCorreo>
			<cfquery name="emailUser" datasource="#session.dsn#">
				select coalesce(dp.Pemail1,dp.Pemail2) email
				from Usuario u
				inner join DatosPersonales dp
				 on u.Usucodigo = dp.datos_personales
				where coalesce(dp.Pemail1,dp.Pemail2) is not null and ltrim(rtrim(coalesce(dp.Pemail1,dp.Pemail2))) <> ''
					and u.Usucodigo = #Arguments.Usucodigo#
			</cfquery>
			<cfif emailUser.recordCount>
				<cfset args = StructNew()>

				<cfquery datasource="#session.dsn#" name="datos_personales">
					select u.datos_personales,
						dp.Pnombre as nombre, dp.Papellido1 as apellido1, dp.Papellido2 as apellido2,
						dp.Pemail1 as email1, dp.Pcelular as celular
					from Usuario u
						join DatosPersonales dp
							on u.datos_personales = dp.datos_personales
					where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
				</cfquery>
				<cfset args.datos_personales = datos_personales>
				<cfset args.info = Arguments.asunto>
				<cfset args.url = Arguments.url>
				<cfset args.Usucodigo = Arguments.Usucodigo>
				<cfset args.CEcodigo = session.CEcodigo>
				<cfset request.MailArguments = args>

				<cfsavecontent variable="_mail_body">
					<cfoutput>
					<!--- <cfinclude template="/cfmx/commons/Componentes/mail-notifica.cfm"> --->
					<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
					<html>
					<head>
					<title><cf_translate key="LB_NotificacionTitulo">Notificaci&oacute;n del Sistema</cf_translate></title>
					<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
					<style type="text/css">
					<!--
					.style1 {
						font-size: 10px;
						font-family: "Times New Roman", Times, serif;
					}
					.style2 {
						font-family: Verdana, Arial, Helvetica, sans-serif;
						font-weight: bold;
						font-size: 14;
					}
					.style7 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 14; }
					.style8 {font-size: 14}
					-->
					</style>
					</head>

					<body>
					<cfparam name="hostname" default="localhost">
					<cfparam name="_password" default="">
					<cfparam name="_incluir_login" type="boolean" default="yes">

					<cfoutput>
					  <table border="0" cellpadding="4" cellspacing="0" style="border:2px solid ##999999; ">
					    <tr bgcolor="##999999">
					      <td colspan="2" height="8"></td>
					    </tr>
					    <tr bgcolor="##003399">
					      <td colspan="2" height="24"></td>
					    </tr>
					    <tr bgcolor="##999999">
					      <td colspan="2"> <strong><cf_translate key="LB_NotificacionTitulo">Notificaci&oacute;n del Sistema</cf_translate> #session.Enombre# </strong> </td>
					    </tr>
					    <tr>
					      <td width="70">&nbsp;</td>
					      <td width="476">&nbsp;</td>
					    </tr>
					    <tr>
					      <td><span class="style2"><cf_translate key="LB_De">De</cf_translate></span></td>
					      <td><span class="style7"> #Session.Enombre# </span></td>
					    </tr>
					    <tr>
					      <td><span class="style7"><strong><cf_translate key="LB_Para">Para</cf_translate></strong></span></td>

					      <cfif not IsDefined("Request.MailArguments.Transition")>
							  <td> <span class="style7"> #Request.MailArguments.datos_personales.nombre# #Request.MailArguments.datos_personales.apellido1# #Request.MailArguments.datos_personales.apellido2# </span></td>
						  <cfelse>
							  <td> <span class="style7"> #Request.MailArguments.datos_personales#</span></td>
						  </cfif>

					    </tr>
					    <tr>
					      <td><span class="style8"></span></td>
					      <td><span class="style8"></span></td>
					    </tr>
					    <tr>
							<td><span class="style8"></span></td>
							<td>
								<table>
									<tr>
										<td class="style7">
											#Request.MailArguments.info#
										</td>
									</tr>
									<tr>
										<td class="style7">
											<cf_translate key="LB_IngreseA">Ingrese a</cf_translate> <a href='http://#session.sitio.host##Request.MailArguments.url#'> <cf_translate key="LB_AprobacionTramites">Ver notificaci&oacute;n</cf_translate></a>
										</td>
							        </tr>
								</table>
							</td>
						</tr>
					    <tr>
					      <td><span class="style8"></span></td>
					      <td><span class="style8"></span></td>
					    </tr>
					  </table>
					</cfoutput>
					</body>
					</html>
				</cfoutput>
				</cfsavecontent>
				<cfinvoke component="asp.admin.correo.correoViaticos" method="enviar">
					<cfinvokeargument name="subject" value="#Arguments.Asunto#">
					<cfinvokeargument name="mailBody" value="#_mail_body#">
					<cfinvokeargument name="to" value="#emailUser.email#">
				</cfinvoke>
			</cfif>
		</cfif>

	</cffunction>

</cfcomponent>
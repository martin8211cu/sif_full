<cfapplication name="SIF_ASP">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>Sincronización de EmpleadoCFuncional</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
<cfset start = Now()>
Iniciando proceso <cfoutput> #TimeFormat(start,"HH:MM:SS")#</cfoutput><br>
Parametro 3500: Método para determinar el Centro Funcional de un Usuario<br>
<cfquery name="Caches" datasource="asp">
	select distinct c.Ccache, e.Ecodigo as EcodigoSDC, e.Ereferencia as Ecodigo, Enombre
	from Empresa e, ModulosCuentaE m, Caches c
	where e.Ecodigo <> 1
	  and e.CEcodigo = m.CEcodigo
	  and c.Cid = e.Cid
	  and m.SScodigo = 'SIF'
	  and m.SMcodigo = 'AF'
	  and e.Ereferencia is not null
	  <cfif isdefined("url.Ecodigo")>
	  	and e.Ereferencia = #url.Ecodigo#
	  </cfif>
</cfquery>
<cfloop query="Caches">
	<cfset lcache = Caches.Ccache>
	<cfset LvarEcodigo = Caches.Ecodigo>
	<cftry>
			<br>
			<cfoutput>
			<table>
				<tr>
					<td><strong>Cache = #Caches.CurrentRow#:</strong></td>
					<td><strong>#Caches.Ccache#</strong></td>
				</tr>
				<tr>
					<td><strong>Ecodigo = #Caches.Ecodigo#:</strong></td>
					<td><strong>#Caches.Enombre#</strong></td>
				</tr>
				<cfset LvarTipo1 = "N/A">
				<cfset LvarTipo2 = "N/A">
				<cftry>
					<cfquery name="rsParametros" datasource="#lcache#">
						select Pvalor
						  from Parametros
						 where Ecodigo = #Caches.Ecodigo#
						   and Pcodigo = 3500
					</cfquery>
					<cfset LvarTipo1 = rsParametros.Pvalor>
					<cfif rsParametros.Pvalor EQ "EMP">
						<cfset LvarTipo2 = "AF EmpleadoCentroFuncional">
					<cfelseif rsParametros.Pvalor EQ "USU">
						<cfset LvarTipo2 = "CF UsuarioCentroFuncional">
					<cfelse>
						<cfset LvarTipo1 = "DFL">
						<cfset LvarTipo2 = "RH LineaTiempo">
					</cfif>
				<cfcatch type="any">
				</cfcatch>
				</cftry>
				<tr>
					<td><strong>Parametro 3500:</strong></td>
					<td><strong>#LvarTipo2#</strong></td>
				</tr>
			</table>
			</cfoutput>

			<!--- Parametro 3500: EMP = EmpleadoCFuncional --->
			<cfif rsParametros.Pvalor EQ "EMP">
				<cfthrow message="<strong>EmpleadoCFuncional debe ser importada o darle mantenimiento directamente</strong>">
			</cfif>

			<cfquery name="rsSQL_ECF" datasource="#lcache#">
				select count(1) as cantidad
				  from EmpleadoCFuncional
				 where Ecodigo = #Caches.Ecodigo#
				   and <cf_dbfunction name="today" datasource="#lcache#"> between ECFdesde and ECFhasta
			</cfquery>

			<!--- Parametro 3500: USU = UsuarioCFuncional --->
			<cfif rsParametros.Pvalor EQ "USU">
				<cfquery name="rsSQL_UCF" datasource="#lcache#">
					select count(1) as cantidad
					  from UsuarioCFuncional
					 where Ecodigo = #Caches.Ecodigo#
				</cfquery>
				<cfif rsSQL_UCF.cantidad EQ 0>
					<cfthrow message="<strong>No hay definidos usuarios en UsuarioCFuncional</strong>">
				</cfif>
	
				<cfquery datasource="#lcache#">
					insert into EmpleadoCFuncional (DEid, CFid, Ecodigo, ECFdesde, ECFhasta,BMUsucodigo)
					select <cf_dbfunction name="to_number" args="ue.llave" datasource="#lcache#">
						 , ucf.CFid, ucf.Ecodigo
						 , <cf_dbfunction name="today" datasource="#lcache#">
						 , <cfqueryparam cfsqltype="cf_sql_date" value="#createDate(6100,1,1)#">
						 , 1
					  from UsuarioCFuncional ucf
  						inner join UsuarioReferencia ue on ue.Ecodigo = #Caches.EcodigoSDC# and ue.STabla = 'DatosEmpleado' and ue.Usucodigo = ucf.Usucodigo
					 where ucf.Ecodigo = #Caches.Ecodigo#
					   and	(
							select count(1)
							  from EmpleadoCFuncional
							 where Ecodigo	= ucf.Ecodigo
							   and DEid		= <cf_dbfunction name="to_number" args="ue.llave" datasource="#lcache#">
							   and CFid		= ucf.CFid
							   and <cf_dbfunction name="today" datasource="#lcache#"> between ECFdesde and ECFhasta
							) = 0
				</cfquery>

				<cfquery datasource="#lcache#">
					update EmpleadoCFuncional 
					   set ECFhasta = 
					   		(
							select <cf_dbfunction name="dateadd" args="-1,ECFdesde" datasource="#lcache#">
							  from EmpleadoCFuncional u
							 where Ecodigo	= EmpleadoCFuncional.Ecodigo
							   and DEid		= EmpleadoCFuncional.DEid
							   and ECFdesde >= EmpleadoCFuncional.ECFdesde
							   and ECFlinea > EmpleadoCFuncional.ECFlinea
							   and ECFhasta between EmpleadoCFuncional.ECFdesde and EmpleadoCFuncional.ECFhasta
							)
					  where Ecodigo = #Caches.Ecodigo#
					   and	
					   		(
							select count(1)
							  from EmpleadoCFuncional u
							 where Ecodigo	= EmpleadoCFuncional.Ecodigo
							   and DEid		= EmpleadoCFuncional.DEid
							   and ECFdesde >= EmpleadoCFuncional.ECFdesde
							   and ECFlinea > EmpleadoCFuncional.ECFlinea
							   and ECFhasta between EmpleadoCFuncional.ECFdesde and EmpleadoCFuncional.ECFhasta
							) > 0
				</cfquery>
				<cfquery datasource="#lcache#">
					delete from EmpleadoCFuncional 
					  where Ecodigo = #Caches.Ecodigo#
					   and	ECFdesde > ECFhasta
				</cfquery>

				<cfquery name="rsSQL_ECF" datasource="#lcache#">
					select count(1) as cantidad
					  from EmpleadoCFuncional
					 where Ecodigo = #Caches.Ecodigo#
				</cfquery>
	
				<font color="#0000FF">
				<cfoutput>
				<strong>Se Sincronizaron #rsSQL_ECF.cantidad# EmpleadoCFuncional desde UsuarioCentroFuncional</strong>
				</cfoutput>
				</font>
			<cfelse>
			<!--- Parametro 3500: *DFL* = RH LineaTiempo + RHPlazas --->
				<cfquery name="rsSQL_RH" datasource="#lcache#">
					select count(1) as cantidad
					  from LineaTiempo lt
						inner join RHPlazas pl
							 on pl.RHPid = lt.RHPid
							and pl.Ecodigo = lt.Ecodigo
					 where lt.Ecodigo = #Caches.Ecodigo#
					   and <cf_dbfunction name="today" datasource="#lcache#"> between lt.LTdesde and lt.LThasta
				</cfquery>
	
				<cfif rsSQL_RH.cantidad EQ 0>
					<cfthrow message="<strong>No hay definida linea del tiempo</strong>">
				</cfif>
	
				<cfif rsSQL_ECF.cantidad/rsSQL_RH.cantidad GT 1.10 >
					<cfthrow message="<strong>Existe más del 10% de empleados definidos en EmpleadoCFuncional (#rsSQL_ECF.cantidad#) que en LineaTiempo (#rsSQL_RH.cantidad#).  Revisar</strong>">
				</cfif>
	
				<cfquery datasource="#lcache#">
					insert into EmpleadoCFuncional (DEid, CFid, Ecodigo, ECFdesde, ECFhasta,BMUsucodigo)
					select 	lt.DEid, pl.CFid, lt.Ecodigo, lt.LTdesde, lt.LThasta,1
					  from LineaTiempo lt
						inner join RHPlazas pl
							 on pl.RHPid = lt.RHPid
							and pl.Ecodigo = lt.Ecodigo
					 where lt.Ecodigo = #Caches.Ecodigo#
					   and <cf_dbfunction name="today" datasource="#lcache#"> between lt.LTdesde and lt.LThasta
					   and	(
							select count(1)
							  from EmpleadoCFuncional
							 where Ecodigo	= lt.Ecodigo
							   and DEid		= lt.DEid
							   and ECFdesde = lt.LTdesde
							   and ECFhasta	= lt.LThasta
							) = 0
				</cfquery>
				<!--- Inserta Nuevos Empleados --->
				<cfquery datasource="#lcache#">
					delete from EmpleadoCFuncional 
					 where Ecodigo = #Caches.Ecodigo#
					   and
							(
							select count(1)
							  from LineaTiempo lt
								inner join RHPlazas pl
									 on pl.RHPid = lt.RHPid
							and pl.Ecodigo = lt.Ecodigo
							 where EmpleadoCFuncional.Ecodigo	= lt.Ecodigo
							   and EmpleadoCFuncional.DEid		= lt.DEid
							   and EmpleadoCFuncional.ECFdesde 	= lt.LTdesde
							   and EmpleadoCFuncional.ECFhasta	= lt.LThasta
							) = 0
				</cfquery>

				<cfquery name="rsSQL_ECF" datasource="#lcache#">
					select count(1) as cantidad
					  from EmpleadoCFuncional
					 where Ecodigo = #Caches.Ecodigo#
				</cfquery>
	
				<font color="#0000FF">
				<cfoutput>
				<strong>Se Sincronizaron #rsSQL_ECF.cantidad# EmpleadoCFuncional desde RH LineaTiempo</strong>
				</cfoutput>
				</font>
			</cfif>
		<cfcatch>
			Ocurrió un Error en el Cache <cfoutput>#Caches.Ccache#.</cfoutput><br>
			<font color="#FF0000">
			Error: <cfoutput>#cfcatch.Message# #cfcatch.Detail#</cfoutput>
			</font>
		</cfcatch>
	</cftry>
	<cfoutput>
	<BR>
	</cfoutput>
</cfloop>
<cfset finish = Now()>
<br><br>Proceso Terminado<cfoutput> #TimeFormat(finish,"HH:MM:SS")#</cfoutput><br>

</body>
</html>
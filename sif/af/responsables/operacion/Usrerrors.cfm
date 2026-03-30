<title>Lista de Usuarios</title>
<cf_dbfunction name="now" returnvariable="hoy">
<!---
PR = Pantalla de Retiros
PCTRC = Pantalla de Traspaso de Centro Custodia
--->

<cfif isdefined("URL.Pantorigen") and URL.Pantorigen eq "PR">

	<cfif isdefined("URL.EliminarError") and URL.EliminarError>
		<cfquery datasource="#Session.Dsn#">
			Delete from CRCRetiros
			where (select count(1) 
					from AFResponsables a
					  inner join Activos c
					  	on a.Aid 		= c.Aid
					   and a.Ecodigo 	= c.Ecodigo
					where a.Ecodigo = #Session.Ecodigo#		  
						and CRCRetiros.BMUsucodigo = #session.Usucodigo#		  			
						and c.Aplaca 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.Placa#">
						and a.Ecodigo 	= CRCRetiros.Ecodigo
						and a.Aid 		= CRCRetiros.Aid
						
						<cfif url.errornum eq 1>
							and exists( select 1 
										from CRDocumentoResponsabilidad  x
										where x.CRCCid = a.CRCCid
											and x.CRDRplaca = c.Aplaca )
						</cfif>
						<cfif url.errornum eq 2>
							and exists(	select 1 
										from AFTResponsables y
										where y.CRCCid = a.CRCCid
											and y.AFRid = a.AFRid )
						</cfif>
						<cfif url.errornum eq 3>
							and exists( select 1 
										from CRCRetiros z
										where z.Ecodigo = CRCRetiros.Ecodigo
											and z.Aid =  CRCRetiros.Aid
											and z.BMUsucodigo != CRCRetiros.BMUsucodigo )
						</cfif>
					) > 0
		</cfquery>		
		<script>			
			opener.window.location.reload();
			window.close();
		</script>
		<cfabort>
	</cfif>

	<cfif isdefined("URL.err") and URL.err eq 1>
		<cfset img = "<img border='0' src='/cfmx/sif/imagenes/stop.gif'>">
		<cfset msg = "Usuarios que tienen el activo <strong>" & #URL.Placa# & "</strong> en una mejora.">
		
		<cfquery name="rsErrores" datasource="#session.Dsn#">
			Select 
				'<img border=''0'' src=''/cfmx/sif/imagenes/stop.gif''>' as Usuimagen, 
				d.Usucodigo, 
				Usulogin, 
				<cf_dbfunction name="concat" args="dp.Pnombre ,' ',dp.Papellido1 ,' ',dp.Papellido2"> as NomUsuario
			from CRCRetiros Re
				inner join AFResponsables a
					on a.Aid = Re.Aid 
					and a.Ecodigo = Re.Ecodigo
				inner join Activos c
					on a.Aid = c.Aid
					and a.Ecodigo = c.Ecodigo
				inner join Usuario d
					on d.Usucodigo = Re.BMUsucodigo
				inner join DatosPersonales dp
					on dp.datos_personales = d.datos_personales
			where exists (	select 1 
					   		from CRDocumentoResponsabilidad  x
					   		where x.CRCCid = a.CRCCid
						   		and x.CRDRplaca= c.Aplaca) 
		
				and a.Ecodigo =  #session.Ecodigo# 
		   		and #hoy# between a.AFRfini and a.AFRffin
		   		and c.Aplaca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.Placa#">
		   		and Re.BMUsucodigo = #session.Usucodigo#
		</cfquery>
		
	<cfelseif isdefined("URL.err") and URL.err eq 2>
		<cfset img = "<img border='0' src='/cfmx/sif/imagenes/stop2.gif'>">
		<cfset msg = "Usuarios que tienen el activo <strong>" & #URL.Placa# & "</strong> en un traslado.">
		
		<cfquery name="rsErrores" datasource="#session.Dsn#">
		Select '<img border=''0'' src=''/cfmx/sif/imagenes/stop2.gif''>' as Usuimagen, d.Usucodigo, Usulogin, <cf_dbfunction name="concat" args="dp.Pnombre ,' ',dp.Papellido1 ,' ',dp.Papellido2"> as NomUsuario
		from CRCRetiros Re
		
				inner join AFResponsables a
					 on a.Ecodigo = Re.Ecodigo
					  and a.Aid 	     = Re.Aid
		
				inner join Activos c
					on a.Aid	   = c.Aid
					 and a.Ecodigo = c.Ecodigo
		
				inner join AFTResponsables z
					on z.CRCCid = a.CRCCid
					 and z.AFRid= a.AFRid 		
		
				inner join Usuario d
					on d.Usucodigo = z.Usucodigo <!--- Re.BMUsucodigo --->
		
				inner join DatosPersonales dp
					on dp.datos_personales = d.datos_personales
		
		where exists (select 1 
					   from AFTResponsables y
					   where y.CRCCid = a.CRCCid
						   and y.AFRid= a.AFRid) 
		
		   and a.Ecodigo =  #session.Ecodigo# 
		   and #hoy# between a.AFRfini and a.AFRffin
   		   and c.Aplaca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.Placa#">
		   and Re.BMUsucodigo = #session.Usucodigo#
		</cfquery>
		
	<cfelseif isdefined("URL.err") and URL.err eq 3>
		<cfset img = "<img border='0' src='/cfmx/sif/imagenes/stop3.gif'>">
		<cfset msg = "Usuarios que tienen el activo <strong>" & #URL.Placa# & "</strong> en un retiro.">
		
		<cfquery name="rsErrores" datasource="#session.Dsn#">
		Select '<img border=''0'' src=''/cfmx/sif/imagenes/stop3.gif''>' as Usuimagen, d.Usucodigo, Usulogin, <cf_dbfunction name="concat" args="dp.Pnombre ,' ',dp.Papellido1 ,' ',dp.Papellido2"> as NomUsuario
		from CRCRetiros Re
		
				inner join AFResponsables a
					 on a.Ecodigo = Re.Ecodigo
					  and a.Aid 	     = Re.Aid
		
				inner join Activos c
					on a.Aid	   = c.Aid
					 and a.Ecodigo = c.Ecodigo
		
				inner join Usuario d
					on d.Usucodigo = Re.BMUsucodigo
		
				inner join DatosPersonales dp
					on dp.datos_personales = d.datos_personales
		
		where exists (select 1 
					  from CRCRetiros z
					  where z.Ecodigo     =  Re.Ecodigo
						  and z.Aid	        =  Re.Aid
						  and z.BMUsucodigo != Re.BMUsucodigo )
		
		   and a.Ecodigo =  #session.Ecodigo# 
		   and #hoy# between a.AFRfini and a.AFRffin
   		   and c.Aplaca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.Placa#">
		</cfquery>
		
	</cfif>

<cfelseif isdefined("URL.Pantorigen") and URL.Pantorigen eq "PTR">

	<cfif isdefined("URL.EliminarError") and URL.EliminarError>
		<cfif isdefined("url.errornum") and len(trim(url.errornum)) gt 0 and url.errornum gt 0>
			<cfinvoke 
				component="sif.Componentes.AF_CambioResponsable"
				method="Anular">
				<cfinvokeargument name="AFTRid" value="#url.AFTRid#"/>
			</cfinvoke >
		</cfif>		
		<script>			
			opener.window.location.reload();
			window.close();
		</script>
		<cfabort>
	</cfif>


	<cfif isdefined("URL.err") and URL.err eq 1>
	
		<cfset img = "<img border='0' src='/cfmx/sif/imagenes/stop.gif'>">
		<cfset msg = "Usuarios que tienen el activo <strong>" & #URL.Placa# & "</strong> en un traspaso.">

		<cfquery name="rsErrores" datasource="#session.Dsn#">
		Select Aplaca, aftr2.Usucodigo, usr.Usulogin, <cf_dbfunction name="concat" args="dp.Pnombre ,' ',dp.Papellido1 ,' ',dp.Papellido2"> as NomUsuario
		from AFTResponsables aftr2, AFResponsables afr, Activos act, Usuario usr, DatosPersonales dp
		where aftr2.AFRid = afr.AFRid
			and act.Aid = afr.Aid
			and aftr2.Usucodigo = usr.Usucodigo
			and usr.datos_personales = dp.datos_personales
			and aftr2.AFTRtipo = 1
			and act.Ecodigo =  #session.Ecodigo# 
			and act.Aplaca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.Placa#">
			and #hoy# between afr.AFRfini and afr.AFRffin
		</cfquery>	
	
	</cfif>

<cfelseif isdefined("URL.Pantorigen") and URL.Pantorigen eq "PCTRC">
	
	<cfif isdefined("URL.EliminarError") and URL.EliminarError>
		<cfif isdefined("url.errornum") and len(trim(url.errornum)) gt 0 and url.errornum gt 0>
			<cfinvoke 
				component="sif.Componentes.AF_CambioResponsable"
				method="AnularByErrorNum">
				<cfinvokeargument name="ErrorNum" value="#url.ErrorNum#"/>
				<cfinvokeargument name="Tipo" value="2"/>
			</cfinvoke >
		</cfif>
		<script>
			opener.window.location.href = "CTRC_Traslados.cfm";
			//opener.window.location.reload();
			window.close();
		</script>
		<cfabort>
	</cfif>
	
	<cfif isdefined("URL.err") and URL.err eq 1>
	
		<cfset img = "<img border='0' src='/cfmx/sif/imagenes/stop.gif'>">
		<cfset msg = "Usuarios que tienen el activo <strong>" & #URL.Placa# & "</strong> en un traspaso.">
		
		<cfquery name="rsErrores" datasource="#session.Dsn#">
			Select 	Aplaca, 
					a.Usucodigo, 
					usr.Usulogin, 
					<cf_dbfunction name="concat" args="dp.Pnombre ,' ',dp.Papellido1 ,' ',dp.Papellido2"> as NomUsuario
			
			from AFTResponsables a 
					inner join AFResponsables  b
						on a.AFRid	= b.AFRid
					inner join Activos c
						on b.Aid = c.Aid
					   	and b.Ecodigo = c.Ecodigo
					inner join Usuario usr
						on a.Usucodigo = usr.Usucodigo
						inner join DatosPersonales dp
							on usr.datos_personales = dp.datos_personales
			
			where exists (	select 1  
							from AFTResponsables aftr2 
							where aftr2.AFTRid <> a.AFTRid  
								and aftr2.AFRid = a.AFRid  )			
			   and Aplaca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.Placa#">
  		</cfquery>

	</cfif>
	
</cfif>

<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
<table width="100%"  cellpadding="0" cellspacing="0" border="0">
<tr>
	<td><cfoutput>#img# #msg#</cfoutput></td>
</tr>
<tr>
	<td align="center">&nbsp;</td>
</tr>	
<tr>
	<td>
		<fieldset style="background-color:#F3F4F8;  border-top: 1px solid #CCCCCC; border-left: 1px solid #CCCCCC; border-right: 1px solid #CCCCCC; border-bottom: 1px solid #CCCCCC; ">
			<legend align="left" style="color:#003366;font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;">
			Lista de Usuarios
			</legend>				
			<table width="100%"  cellpadding="2" cellspacing="2" border="0">
					
				<tr>
					<td width="40%" align="left"><strong>Usuario</strong></td>
					<td><strong>Nombre</strong></td>
				</tr>											
				<cfoutput query="rsErrores">
				<tr>
					<td width="40%" align="left">#rsErrores.Usulogin#</td>
					<td>#rsErrores.NomUsuario#</td>
				</tr>	
				</cfoutput>
			</table>
		</fieldset>	
	</td>
</tr>
<tr><td>&nbsp;</td></tr>
<tr>
	<td align="center">
		<input type="button" name="btncerrar" value="Cerrar" onClick="javascript:window.close();">
		<cfif isdefined("URL.Pantorigen") and URL.Pantorigen eq "PR">
			<cfif isdefined("URL.err")>
				<cfif URL.err eq 1><cfset Verr = 1></cfif>
				<cfif URL.err eq 2><cfset Verr = 2></cfif>
				<cfif URL.err eq 3><cfset Verr = 3></cfif>
				<input type="button" name="btnborrarerr" value="Eliminar" onClick="javascript:EliminarError(<cfoutput>'#Verr#'</cfoutput>,'PR');">
			</cfif>
		</cfif>
		
		<cfif isdefined("URL.Pantorigen") and URL.Pantorigen eq "PTR">
			<cfif isdefined("URL.err")>
				<cfif URL.err eq 1><cfset Verr = 1></cfif>
				<input type="button" name="btnborrarerr" value="Eliminar" onClick="javascript:EliminarError(<cfoutput>'#Verr#'</cfoutput>,'PTR');">
			</cfif>		
		</cfif>
		
		<cfif isdefined("URL.Pantorigen") and URL.Pantorigen eq "PCTRC">
			<cfif isdefined("URL.err")>
				<cfif URL.err eq 1><cfset Verr = 1></cfif>
				<input type="button" name="btnborrarerr" value="Eliminar" onClick="javascript:EliminarError(<cfoutput>'#Verr#'</cfoutput>,'PCTRC');">
			</cfif>		
		</cfif>		
	</td>
</tr>
</table>

<cfset params="">
<cfif isdefined("URL.Placa") and URL.Placa neq "">
	<cfset params="&Placa=" & URL.Placa>
</cfif>
<cfif isdefined('url.AFTRid') and url.AFTRid GT 0>
	<cfset params = params & "&AFTRid=" & url.AFTRid>
</cfif>

<script>
function EliminarError(errornum,pantalla)
{
	if (pantalla == "PR")
	{
		pregunta = "Desea eliminar el retiro ?";
	}
	else
	{
		pregunta = "Desea eliminar el traspaso ?";
	}	
	if (confirm(pregunta)) {
		document.location.href="Usrerrors.cfm?EliminarError=true&errornum="+errornum+"&Pantorigen="+pantalla+"<cfoutput>#params#</cfoutput>";
		return false;
	}
	return false;
}
</script>
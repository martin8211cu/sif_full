<cfsetting enablecfoutputonly="yes">
<!--- <cfdump var="#form#">
<cfabort> --->

<cfquery name="roles" datasource="#session.DSN#">
	select rtrim(rol) as rol
		, Rolinfo 
	from Rol
	where activo = 1
</cfquery>

<cfif isdefined('roles') and roles.recordCount GT 0>
	<cfset xmlPersona = "<?xml version='1.0' encoding='ISO-8859-1' ?><Carta>">	
	<cfset xmlPersona = xmlPersona & "<roles>">
	
	<cfloop query="roles">
		<cfif roles.rol NEQ ''>
			<cfset xmlPersona = xmlPersona & "<rol>">	
			<cfset xmlPersona = xmlPersona & "
				<rol>" & #roles.rol#	& "</rol>
					<Rolinfo>
						<![CDATA[
							<fo:table>
								<fo:table-column column-width='0.25in' />
								<fo:table-column column-width='6.25in' />
								<fo:table-body>	
								
									<fo:table-row>
										<fo:table-cell><fo:block>*</fo:block></fo:table-cell>
										<fo:table-cell><fo:block>
										"& #roles.Rolinfo# &"
										</fo:block></fo:table-cell>
									</fo:table-row>
							</fo:table-body>
						</fo:table>
						]]>
					</Rolinfo>
				</rol>								
			">			
		</cfif>
	</cfloop>
	
	<cfset xmlPersona = xmlPersona & "</roles>">	
	<cfset xmlPersona = xmlPersona & "<AdminNombre>" & session.logoninfo.Pnombre & "</AdminNombre>">		
	<cfset xmlPersona = xmlPersona & "<Paquete>">

	<cfif isdefined('form.chk')>
		<cfset myArreglo = ListToArray(#form.chk#)>
		<!--- <cfdump var="#myArreglo#"> --->
		
			<cfloop index = "LoopCount" from = "1" to = "#ArrayLen(myArreglo)#">
				<cfquery name="sel_Usuario" datasource="#session.DSN#">
					<!--- 
						Este query es el mismo que en expedito.apply.jsp
					
						Leer los datos para imprimir en el contrato de afiliacion,
						y marcar en UsuarioPermiso que la carta ha sido impresa.
						Hay que verificar que haya permiso de leer el registro, y que la carta se pueda
						(re)imprimir:
						- Hay que tener permiso sobre el usuario:
							- porque soy pso
							- porque soy agente del usuario
							- porque soy administrador de la cta empresarial del usuario
						- El usuario debe estar en el proceso de afiliacion (Usutemporal = 1)
					 --->			
					select
						rtrim(up.rol) as rol, r.nombre as nombre_rol,
						isnull(u.Psexo,'M') as Psexo, u.Pnombre, isnull(u.Papellido1,'') as Papellido1,
						isnull(u.Papellido2,'') as Papellido2, u.Pid, isnull(u.Pemail1,'') as Pemail1, u.Usulogin as Usueplogin,
						up.id, e.nombre_comercial, convert(varchar,getDate(),103) as fecha
					from Usuario u, UsuarioPermiso up, Empresa e, Rol r
					where up.id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#myArreglo[LoopCount]#">
					  and up.activo = 1
					  and e.Ecodigo  =* up.Ecodigo
					  and u.Usucodigo = up.Usucodigo
					  and u.Ulocalizacion = up.Ulocalizacion
					  and u.Usutemporal = 1
					  and r.rol = up.rol
					  and r.activo = 1
					  
					<!--- 
						falta: validar autorizacion sobre los datos
						  SOY PSO
						  || SOY AGENTE DEL USUARIO Y EL ROL ES PERSONAL
						  || SOY ADMIN DE LA CTA EMP Y EL ROL ES EMPRESARIAL
					--->				  
					update UsuarioPermiso
					set fecha_impreso = getdate()
						 , num_impreso = num_impreso + 1
						 , BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
						 , BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.ulocalizacion#">
						 , BMUsulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">
						 , BMfechamod = getdate()
					where id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#myArreglo[LoopCount]#">
					  and activo = 1				  
				</cfquery>
				
				<!--- <cfdump var="#sel_Usuario#"> --->
				
	
				<cfif isdefined('sel_Usuario') and sel_Usuario.recordCount GT 0>
					<cfset NombreCom = "">
					<cfif sel_Usuario.nombre_comercial NEQ ''>
						<cfset NombreCom = sel_Usuario.nombre_comercial>
					<cfelse>
						<cfset NombreCom = "EL PORTAL">
					</cfif>
					<cfset fecha_hoy = LSDateFormat(Now(), "DD/MM/YYYY")>				
					<cfset xmlPersona = xmlPersona & "
						<persona>
							<rol>"& #sel_Usuario.rol# &"</rol>
							<Roldescripcion>"& #sel_Usuario.nombre_rol# &"</Roldescripcion>
							<Psexo>"& #sel_Usuario.Psexo# &"</Psexo>
							<Pnombre>"& #sel_Usuario.Pnombre# &"</Pnombre>
							<Papellido1>"& #sel_Usuario.Papellido1# &"</Papellido1>
							<Papellido2>"& #sel_Usuario.Papellido2# &"</Papellido2>
							<Pid>"& #sel_Usuario.Pid# &"</Pid>
							<Pemail1>"& #sel_Usuario.Pemail1# &"</Pemail1>
							<Usueplogin>"& #sel_Usuario.Usueplogin# &"</Usueplogin>
							<CEnombre>"& #NombreCom# &"</CEnombre>
							<fecha>"& #fecha_hoy# &"</fecha>
							<CAnumero>"& #sel_Usuario.id# &"</CAnumero>
						</persona>			
					">			
				</cfif>
				
				<cfif LoopCount MOD 20 EQ 0>
					<cfset xmlPersona = xmlPersona & "			
						</Paquete>
						<Paquete>
					">			
				</cfif>
			</cfloop>
	</cfif>
		
	<cfset xmlPersona = xmlPersona & "
			</Paquete>
			</Carta>">	
</cfif>
<!--- 
<cfoutput>#xmlPersona#</cfoutput>
<cfabort>
--->

<cfsavecontent variable="varXSL">
<cfoutput><cfinclude template="cartas/cartaXSL.cfm"></cfoutput>
</cfsavecontent>
<!---<cfoutput>#varXSL#</cfoutput>
<cfabort> --->

<cfquery name="pdfInsert" datasource="#session.DSN#">
	insert ReporteFO (FOxml, FOxsl, FOcreado, FOusuario)
	values (
	  <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#xmlPersona#">
	, <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#varXSL#">	
	, getdate()
	, <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">	)
	
	select @@identity as F0id
</cfquery>

<cfoutput>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>MiGestion</title>
<meta http-equiv="Content-Type" content="text/xml; charset=iso-8859-1">
</head>

	<#"frameset"# rows="100%," frameborder="NO" border="0" framespacing="0">
	  <frame name='pdfFrame' src='/fopweb/FopServlet/result.pdf?id=#pdfInsert.F0id#' />
	  <frame src="UntitledFrame-9" />
	</frameset>
	<noframes>
		<body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0"  >
			<object type="application/pdf" classid="clsid:CA8A9780-280D-11CF-A24D-444553540000" WIDTH="100%" HEIGHT="100%" ID="Pdf1">
				<param name="src" value='/fopweb/FopServlet/result.pdf?id=#pdfInsert.F0id#'>
			
				<embed SRC='/fopweb/FopServlet/result.pdf?id=#pdfInsert.F0id#' HEIGHT="100%" WIDTH="100%">
				<noembed>
					Usted no ha instalado el plugin de adobe acrobat reader
				</noembed> 
			</object>
		</body>
	</noframes>
</cfoutput>
</html>

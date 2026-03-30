<!--- <cfdump var="#form#">
  <cfdump var="#url#">
<cfabort>  --->
<cfset modo = "ALTA">

<!--- Toma centros funcionales hijos --->
<cfif isdefined("form.subcentros")>
	<cfquery name="rsCentrosHijos" datasource="#session.DSN#">
		select CFid
		from CFuncional
		where CFpath like '%/'||(select ltrim(rtrim(CFcodigo)) 
							from CFuncional 
							where CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">)
							||'/%'
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>
	
</cfif>

<cfif not isdefined("Form.btnNuevo")>
		<!--- Agregar Accion a Seguir --->
		<cfif isdefined("Form.Alta")>
			
			<cfif isdefined("rsCentrosHijos")>
				
				<!--- extender permiso de a subcentros funcionales--->
				<cfloop query="rsCentrosHijos">
					<cfquery name="rsVerificaUsuario" datasource="#session.DSN#">
						select 1
						from RHUsuariosMarcas
						where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
						and Usucodigo = <cfqueryparam value="#Form.Usuario#" cfsqltype="cf_sql_numeric">
						and CFid = <cfqueryparam value="#rsCentrosHijos.CFid#" cfsqltype="cf_sql_numeric">
					</cfquery>
					<cfif rsVerificaUsuario.RecordCount EQ 0>
						<cfquery name="ABC_Autorizacion" datasource="#Session.DSN#">
							<!---- if not exists (
								select 1
								from RHUsuariosMarcas
								where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
								and Usucodigo = <cfqueryparam value="#Form.Usuario#" cfsqltype="cf_sql_numeric">
								and CFid = <cfqueryparam value="#rsCentrosHijos.CFid#" cfsqltype="cf_sql_numeric">
							)---->
							insert RHUsuariosMarcas (Ecodigo, Usucodigo, CFid, RHUMtmarcas, RHUMgincidencias, RHUMpjornadas,RHUMjmasiva,RHTidtramite)
							values (<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">, 
									<cfqueryparam value="#Form.Usuario#" cfsqltype="cf_sql_numeric">,
									<cfqueryparam value="#rsCentrosHijos.CFid#" cfsqltype="cf_sql_numeric">,
									<cfif isdefined("Form.RHUMtmarcas")>1<cfelse>0</cfif>,
									<cfif isdefined("Form.RHUMgincidencias")>1<cfelse>0</cfif>,
									<cfif isdefined("Form.RHUMpjornadas")>1<cfelse>0</cfif>,
									<cfif isdefined("Form.RHUMjmasiva")>1<cfelse>0</cfif>,
									<cfif isdefined("Form.RHTidtramite") and form.RHTidtramite NEQ '-1'>
										<cfqueryparam value="#Form.RHTidtramite#" cfsqltype="cf_sql_numeric">
									<cfelse>null</cfif>
									)
						</cfquery>
					</cfif>
				</cfloop>
				
			</cfif>
			
			<cfquery name="rsVerificaUsuario" datasource="#session.DSN#">
				select 1
				from RHUsuariosMarcas
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and Usucodigo = <cfqueryparam value="#Form.Usuario#" cfsqltype="cf_sql_numeric">
				and CFid = <cfqueryparam value="#Form.CFid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cfif rsVerificaUsuario.RecordCount EQ 0>
				<!--- Agrega el centro padre--->
				<cfquery name="ABC_Autorizacion" datasource="#Session.DSN#">
					<!----if not exists (
						select 1
						from RHUsuariosMarcas
						where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
						and Usucodigo = <cfqueryparam value="#Form.Usuario#" cfsqltype="cf_sql_numeric">
						and CFid = <cfqueryparam value="#Form.CFid#" cfsqltype="cf_sql_numeric">
					)----->
					insert RHUsuariosMarcas (Ecodigo, Usucodigo, CFid, RHUMtmarcas, RHUMgincidencias, RHUMpjornadas,RHUMjmasiva,RHTidtramite)
					values (
						<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">, 
						<cfqueryparam value="#Form.Usuario#" cfsqltype="cf_sql_numeric">,
						<cfqueryparam value="#Form.CFid#" cfsqltype="cf_sql_numeric">,
						<cfif isdefined("Form.RHUMtmarcas")>1<cfelse>0</cfif>,
						<cfif isdefined("Form.RHUMgincidencias")>1<cfelse>0</cfif>,
						<cfif isdefined("Form.RHUMpjornadas")>1<cfelse>0</cfif>,
						<cfif isdefined("Form.RHUMjmasiva")>1<cfelse>0</cfif>,
						<cfif isdefined("Form.RHTidtramite") and form.RHTidtramite NEQ '-1'>
							<cfqueryparam value="#Form.RHTidtramite#" cfsqltype="cf_sql_numeric">
						<cfelse>null</cfif>
					)
				</cfquery>			
			</cfif>
			
			
		<!--- Actualizar Accion a Seguir --->
		<cfelseif isdefined("Form.Cambio")>
							
				<cfquery name="ABC_Autorizacion" datasource="#Session.DSN#">
					update RHUsuariosMarcas set 
						RHUMtmarcas = <cfif isdefined("Form.RHUMtmarcas")>1<cfelse>0</cfif>,
						RHUMgincidencias = <cfif isdefined("Form.RHUMgincidencias")>1<cfelse>0</cfif>,
						RHUMpjornadas = <cfif isdefined("Form.RHUMpjornadas")>1<cfelse>0</cfif>,
						RHUMjmasiva = <cfif isdefined("Form.RHUMjmasiva")>1<cfelse>0</cfif>
						<cfif isdefined("Form.RHTidtramite") and form.RHTidtramite NEQ '-1'>
							, RHTidtramite = <cfqueryparam value="#Form.RHTidtramite#" cfsqltype="cf_sql_numeric">
						<cfelse>
							, RHTidtramite = null
						</cfif>
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and RHUMid =  <cfqueryparam value="#Form.RHUMid#" cfsqltype="cf_sql_numeric">
					  and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
				</cfquery>
		  	
		<!--- Borrar una Jornada --->
		<cfelseif isdefined("Form.Baja")>
			<cfquery name="ABC_Autorizacion" datasource="#Session.DSN#">
				delete from RHUsuariosMarcas
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and RHUMid =  <cfqueryparam value="#Form.RHUMid#" cfsqltype="cf_sql_numeric">
			</cfquery>
		</cfif>
	
</cfif>	

<cfif isdefined("form.NUEVO") or isdefined('form.Baja')>
	<cflocation url="Autorizacion.cfm">
</cfif>


<cfoutput>
<form action="Autorizacion.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif isdefined('Form.RHUMid') and Form.RHUMid NEQ ''>
		<input name="RHUMid" type="hidden" value="#Form.RHUMid#">
	</cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

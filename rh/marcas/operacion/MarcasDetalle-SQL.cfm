<cfset modo = "ALTA">
<!--- Verificacion de si el usuario actual tiene derechos para generar incidencias --->
<cfquery name="rsPermisoGenIncidencia" datasource="#Session.DSN#">
	select 1
	from DatosEmpleado a, LineaTiempo lt, RHPlazas r, RHProcesamientoMarcas b, RHUsuariosMarcas um
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	and a.Ecodigo = lt.Ecodigo
	and a.DEid = lt.DEid
	and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between lt.LTdesde and lt.LThasta
	and lt.Ecodigo = r.Ecodigo
	and lt.RHPid = r.RHPid
	and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and b.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
	and b.Ecodigo = r.Ecodigo
	and b.CFid = r.CFid
	and b.Ecodigo = um.Ecodigo
	and b.CFid = um.CFid
	and um.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	and um.RHUMgincidencias = 1
</cfquery>

<cfif rsPermisoGenIncidencia.recordCount GT 0>
	<cfif not isdefined("Form.btnNuevo")>
		<!--- Chequear que no se inserten Conceptos Incidentes mas de una vez para una marca --->
		<cfif isdefined("Form.Alta") or isdefined("Form.Cambio")>
			<cfquery name="chkExists" datasource="#Session.DSN#">
				select 1
				from RHDetalleIncidencias
				where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CIid#">
				  and RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
				  and RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
				<cfif isdefined("Form.Cambio")>
				  and RHDMid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHDMid#">
				</cfif>
			</cfquery>
			<cfif chkExists.recordCount GT 0>
				<cfset msg = "No se puede insertar más de un Concepto de Incidencia.">
				<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat(msg)#">
				<cfabort>
			</cfif>
		</cfif>
	
		<cftransaction>
		<cftry>
			<!--- Agregar Control de Marca --->
			<cfif isdefined("Form.Alta")>
				<cfquery name="ABC_ControlMarca" datasource="#Session.DSN#">
					insert RHDetalleIncidencias (RHCMid, RHPMid, CIid, RHDMhorascalc, RHDMhorasautor, RHDMusuario, RHDMfecha, BMUsucodigo, BMfecha, BMfmod)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CIid#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="0.00">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#Form.RHDMhorasautor#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					)
				</cfquery>
			<!--- Actualizar Accion a Seguir --->
			<cfelseif isdefined("Form.Cambio")>
				<cfquery name="ABC_ControlMarca" datasource="#Session.DSN#">
					update RHDetalleIncidencias set 
						RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">,
						RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">,
						CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CIid#">,
						RHDMhorasautor = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.RHDMhorasautor#">,
						RHDMusuario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						RHDMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						BMfmod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					where RHDMid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHDMid#">
					  and RHPMid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
					  and RHCMid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
				</cfquery>
					  
			<!--- Borrar una Jornada --->
			<cfelseif isdefined("Form.Baja")>
				<cfquery name="ABC_ControlMarca" datasource="#Session.DSN#">
					delete from RHDetalleIncidencias
					where RHDMid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHDMid#">
					  and RHPMid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
					  and RHCMid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
				</cfquery>
			</cfif>
	
		<cfcatch type="any">
			<cftransaction action="rollback">
			<cfinclude template="/sif/errorPages/BDerror.cfm">
			<cfabort>
		</cfcatch>
		</cftry>
		</cftransaction>
	</cfif>	
</cfif>

<cfoutput>
<form action="Marcas.cfm" method="post" name="sql">
	<cfif isdefined("Form.RHPMid") and Len(Trim(Form.RHPMid))>
		<input name="RHPMid" type="hidden" value="#Form.RHPMid#">
	</cfif>
	<cfif isdefined("Form.RHCMid") and Len(Trim(Form.RHCMid))>
		<input name="RHCMid" type="hidden" value="#Form.RHCMid#">
	</cfif>
	<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid))>
		<input name="DEid" type="hidden" value="#Form.DEid#">
	</cfif>
	<input type="hidden" name="showDetail" value="1">
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

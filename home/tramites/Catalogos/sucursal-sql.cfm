<cfparam name="modo" default="ALTA">
<cfif isdefined("Form.Regresar")>
	<form action="Tp_Institucion.cfm" method="post" name="sql">
		<input name="modo" type="hidden" value="CAMBIO">
		<input name="id_inst" type="hidden" value="<cfoutput>#Form.id_inst#</cfoutput>">
	</form>
	<HTML>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
	<body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
	</HTML>
</cfif>
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cf_tr_direccion action="readform" name="direccion">
		<cf_tr_direccion action="insert" data="#direccion#" name="direccion">
		<cftransaction>
			<cfquery name="ABC_ins" datasource="#session.tramites.dsn#" >
				insert into TPSucursal (
				codigo_sucursal,
				nombre_sucursal,
				id_direccion, 
				id_inst,  
				horario_sucursal,
				BMUsucodigo,
				BMfechamod)
				values (
					<cfqueryparam cfsqltype="cf_sql_char"    value="#UCase(Form.codigo_sucursal)#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.nombre_sucursal#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#direccion.id_direccion#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.horario_sucursal#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				)
				<cf_dbidentity1 datasource="#session.tramites.dsn#">
				
			</cfquery>
			<cf_dbidentity2 datasource="#session.tramites.dsn#" name="ABC_ins">
		</cftransaction>
		<cfset modo="CAMBIO">
		<cfset Form.id_sucursal = ABC_ins.identity>
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="ABC_ins" datasource="#session.tramites.dsn#">			
			delete TPSucursal 
			where  id_sucursal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_sucursal#">				  
			and   id_inst 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">
		</cfquery>
		<cfset modo="ALTA">
		<cfset p = "?tab=3&id_inst=#form.id_inst#">
		<cflocation url="instituciones.cfm#p#">		
		
	<cfelseif isdefined("Form.Cambio")>
		<cf_tr_direccion action="readform" name="direccion">
		<cf_tr_direccion action="update" data="#direccion#" key="#form.id_direccion#" name="direccion">

		<cf_dbtimestamp datasource="#session.tramites.dsn#"
			table="TPSucursal"
			redirect="instituciones.cfm"
			timestamp="#form.ts_rversion#"
			field1="id_sucursal" 
			type1="numeric" 
			value1="#form.id_sucursal#">
		<cfquery name="ABC_ins" datasource="#session.tramites.dsn#">			
			update TPSucursal set 
			codigo_sucursal  	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Form.codigo_sucursal)#">, 
			nombre_sucursal  	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.nombre_sucursal#">, 
			id_direccion 	    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#">,
			horario_sucursal    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.horario_sucursal#">,
			BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,  
			BMfechamod  	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			where  id_sucursal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_sucursal#">
			and   id_inst 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">
		</cfquery>
		<cfset modo="CAMBIO">
	</cfif>			
</cfif>

<cfset p = "?tab=2&id_inst=#form.id_inst#">
<cfif not isdefined("form.Nuevo") and isdefined("form.id_sucursal") and len(trim(form.id_sucursal))>
	<cfset p = p & "&id_sucursal=#form.id_sucursal#">
</cfif>
<cflocation url="instituciones.cfm#p#">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="rsOficodigo" datasource="#Session.DSN#">
			select Oficodigo 
			from Oficinas
			where Ecodigo = #session.Ecodigo#
				and Oficodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Oficodigo#">
		</cfquery>
		
		<cfif rsOficodigo.RecordCount LTE 0>
			<cfquery name="rsCont" datasource="#Session.DSN#">
				select (coalesce(max(Ocodigo),0)+1) as Cont
				from Oficinas 
				where Ecodigo = #Session.Ecodigo#				
			</cfquery>
			
			<cf_direccion action="readform" name="direccion">
			<cf_direccion action="insert" data="#direccion#" name="direccion">
			 
			<cfquery name="rsAlta" datasource="#Session.DSN#">
				insert into Oficinas (Ecodigo, Ocodigo, LPid, Oficodigo, Odescripcion,id_zona,id_direccion,telefono,responsable,pais
				,Onumpatronal, Oadscrita, Onumpatinactivo, ZEid, SScodigo, SRcodigo)
				values
				(				
					 #session.Ecodigo# , 
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCont.Cont#"> ,
					 <cfif isdefined("form.LPid") and len(trim(form.LPid))>
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.LPid#">,
					 <cfelse>
					 	null,
					 </cfif>
					 <cfqueryparam cfsqltype="cf_sql_char" 	  value="#Form.Oficodigo#">, 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.Odescripcion)#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LZonaVenta#" null="#Len(form.LZonaVenta) Is 0#">,	
					 #direccion.id_direccion#,				
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.telefono#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.responsable#">,
					 <cfqueryparam cfsqltype="cf_sql_char"    value="#form.fpais#">,
					 <cfif isdefined("form.Onumpatronal") and len(trim(form.Onumpatronal))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Onumpatronal#" ><cfelse>null</cfif>,
					 <cfqueryparam cfsqltype="cf_sql_char"    value="#trim(form.Oadscrita)#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Onumpatinactivo#">,
					 <cfif isdefined("form.ZEid") and len(trim(form.ZEid)) and form.ZEid><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ZEid#"><cfelse>null</cfif>,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#form.SRcodigo#">
				 )
			 </cfquery>
			 <cfset modo="ALTA">
		<cfelse>
			<cf_errorCode	code = "50020" msg = "El registro que desea insertar ya existe.">
		</cfif>
		
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="rsBaja" datasource="#Session.DSN#">
			delete from Oficinas
			where Ecodigo = #Session.Ecodigo#
				and Ocodigo  = <cfqueryparam value="#Form.Ocodigo#" cfsqltype="cf_sql_integer">
				and Oficodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Oficodigo#">
		</cfquery>
		<cf_sifcomplementofinanciero action='delete'
			tabla="Oficinas"
			form = "form"
			llave="#form.Ocodigo#" />		
		<cfset modo="ALTA">
	
	<cfelseif isdefined("Form.Cambio")>
		<cfif trim(Form.xOficodigo) NEQ trim(Form.Oficodigo)>
			<cfquery name="rsOficodigoCambio" datasource="#Session.DSN#">
				select 1 
				from Oficinas
				where Ecodigo = #session.Ecodigo#
					and Oficodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Oficodigo#">
			</cfquery>
			
			<cfif isdefined("rsOficodigoCambio") and rsOficodigoCambio.RecordCount GT 0>
				<cf_errorCode	code = "50021" msg = "El Código que desea modificar ya existe.">
			</cfif>
		</cfif>

		<cf_dbtimestamp datasource="#session.dsn#"
				table="Oficinas"
				redirect="Oficinas.cfm"
				timestamp="#form.ts_rversion#"				
				field1="Ecodigo" 
				type1="integer" 
				value1="#session.Ecodigo#"
				field2="Ocodigo" 
				type2="integer" 
				value2="#form.Ocodigo#"
				field3="Oficodigo" 
				type3="char" 
				value3="#form.xOficodigo#"
				>
		
		<cf_direccion action="readform" name="direccion">
		<cf_direccion action="update" data="#direccion#" name="direccion">
		
		
		<cfquery name="rsCambio" datasource="#Session.DSN#">			
			update Oficinas set
				Oficodigo 		= <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Oficodigo#">,
				Odescripcion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.Odescripcion)#">,
				LPid 			= <cfif isdefined("form.LPid") and len(trim(form.LPid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.LPid#"><cfelse>null</cfif>,
				id_zona         = <cfif isdefined("form.LZonaVenta") and len(trim(form.LZonaVenta))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LZonaVenta#"><cfelse>null</cfif>,
				telefono        = <cfif isdefined("form.telefono") and len(trim(form.telefono))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.telefono#"><cfelse>null</cfif>,
				responsable     = <cfif isdefined("form.responsable") and len(trim(form.responsable))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.responsable#"><cfelse>null</cfif>,
				id_direccion    = <cfif isdefined("direccion.id_direccion") and len(trim(direccion.id_direccion))><cfqueryparam cfsqltype="cf_sql_numeric" value="#direccion.id_direccion#"><cfelse>null</cfif>,
				pais            = <cfif isdefined("form.fpais") and len(trim(form.fpais))><cfqueryparam cfsqltype="cf_sql_char" value="#form.fpais#"><cfelse>null</cfif>,
				Onumpatronal    = <cfif isdefined("form.Onumpatronal") and len(trim(form.Onumpatronal))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Onumpatronal#" ><cfelse>null</cfif>,
				Oadscrita       = <cfif isdefined("form.Oadscrita") and len(trim(form.Oadscrita))><cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.Oadscrita)#" ><cfelse>null</cfif>,
				Onumpatinactivo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Onumpatinactivo#">,
				ZEid            = <cfif isdefined("form.ZEid") and len(trim(form.ZEid)) and form.ZEid><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ZEid#"><cfelse>null</cfif>,
				SScodigo       = <cfif isdefined("form.SScodigo") and len(trim(form.SScodigo))><cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.SScodigo)#" ><cfelse>null</cfif>,
				SRcodigo       = <cfif isdefined("form.SRcodigo") and len(trim(form.SRcodigo))><cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.SRcodigo)#" ><cfelse>null</cfif>
			where Ecodigo = #Session.Ecodigo#
				and Ocodigo = <cfqueryparam value="#Form.Ocodigo#" cfsqltype="cf_sql_integer">
				and Oficodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.xOficodigo#">
		</cfquery>
		<cf_sifcomplementofinanciero action='update'
			tabla="Oficinas"
			form = "form"
			llave="#form.Ocodigo#" />		
		<cfset modo="CAMBIO">
		
	</cfif>
</cfif>
<cfif isdefined("LvarSucursal")>
	<cfset LvarAction = '/cfmx/sif/QPass/catalogos/QPassSucursal.cfm'>
<cfelse>
	<cfset LvarAction = 'Oficinas.cfm'>
</cfif>

<form action="<cfoutput>#LvarAction#</cfoutput><cfif isdefined('url.desde') and Trim(url.desde) eq 'rh'>?desde=rh</cfif>" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="Ocodigo" type="hidden" value="<cfif isdefined("Form.Ocodigo")><cfoutput>#Form.Ocodigo#</cfoutput></cfif>">
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">		
	<input type="hidden" name="desde" value="<cfif isdefined("form.desde")><cfoutput>#form.desde#</cfoutput></cfif>">		
</form>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>
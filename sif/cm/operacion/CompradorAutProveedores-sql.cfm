<cfquery name="rsExiste" datasource="#session.DSN#">
	select 1 
	from DSDetalleProveedores
	where DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DSlinea#">
</cfquery>
<cfif rsExiste.RecordCount GT 0><!---Si ya a sido asignada la linea la elimina---->
	<cfquery datasource="#session.DSN#">
		delete 
		from DSDetalleProveedores
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DSlinea#">
	</cfquery>
</cfif>
<cfloop list="#form.SNcodigo#" index="i">
	<cfif isdefined("form.DSDcantidad_#i#") and len(trim(form["DSDcantidad_#i#"])) and form["DSDcantidad_#i#"] NEQ 0><!----Si la cantidad adjudicada no es 0---->		
		<!---Validar que no exista ya el mismo proveedor, mismo articulo y misma unidad de medida--->
		<cfquery name="rsExiste" datasource="#session.DSN#">
			select 1 
			from DSDetalleProveedores a
				inner join DSolicitudCompraCM b
					on a.DSlinea = b.DSlinea
					and a.Ecodigo = b.Ecodigo
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and a.DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DSlinea#">
				and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
		</cfquery>
		<cfif rsExiste.RecordCount NEQ 0>
			<cf_errorCode	code = "50291" msg = "El socio de negocio ya ha sido adjudicado para esa línea de la solicitud">
		<cfelse>
			<cfquery datasource="#session.DSN#">
				insert into DSDetalleProveedores (DSlinea, Ecodigo, SNcodigo, DSDcantidad, BMUsucodigo, fechaalta)
				values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DSlinea#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#Replace(form['DSDcantidad_#i#'],',','','all')#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						)
			</cfquery>	
		</cfif>		
	</cfif>
</cfloop>

<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">window.close()</script></body></HTML>



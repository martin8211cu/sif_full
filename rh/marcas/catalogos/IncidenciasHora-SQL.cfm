<cfif not isdefined("Form.btnNuevo")>
		<!--- Agregar Concepto de Pago por Hora --->
		<cfif isdefined("Form.Alta")>
			<cfset fecha1 = listtoarray(form.RHIHfrige, '/') >
			<cfset fecha2 = listtoarray(form.RHIHfhasta, '/') >

			<cfif Form.RHIHhinicio3 eq 'PM' and form.RHIHhinicio1 neq 12>
				<cfset form.RHIHhinicio1 = form.RHIHhinicio1 + 12 >
			</cfif>
			<cfif Form.RHIHhinicio3 eq 'AM' and form.RHIHhinicio1 eq 12>
				<cfset form.RHIHhinicio1 = 0 >
			</cfif>
			<cfset vHInicio = CreateDateTime(fecha1[3], fecha1[2], fecha1[1], Form.RHIHhinicio1, Form.RHIHhinicio2, 0) >
			
			<cfif Form.RHIHhfinal3 eq 'PM' and form.RHIHhfinal1 neq 12>
				<cfset form.RHIHhfinal1 = form.RHIHhfinal1 + 12 >
			</cfif>
			<cfif Form.RHIHhfinal3 eq 'AM' and form.RHIHhfinal1 eq 12>
				<cfset form.RHIHhfinal1 = 0 >
			</cfif>
			<cfset vHFinal = CreateDateTime(fecha2[3], fecha2[2], fecha2[1], Form.RHIHhfinal1, Form.RHIHhfinal2, 0) >
			
			<cfif datecompare(vHInicio, vHFinal) >
				<cfset vHFinal = dateadd('d', 1, vHFinal ) >
			</cfif>

			<cfquery name="ABC_IncidenciaHora" datasource="#Session.DSN#">
				insert into RHIncidenciasHora (CIid, RHIHfrige, RHIHfhasta, RHIHhinicio, RHIHhfinal)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CIid#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHIHfrige)#">, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHIHfhasta)#">, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vHInicio#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#vHFinal#">
				)
			</cfquery>

		<!--- Actualizar Concepto de Pago por Hora --->
		<cfelseif isdefined("Form.Cambio")>
			<cf_dbtimestamp
				datasource="#Session.DSN#"
				table="RHIncidenciasHora" 
				redirect="IncidenciasHora.cfm"
				timestamp="#form.ts_rversion#"
				field1="RHIHid,numeric,#Form.RHIHid#" >
		
			<cfset fecha1 = listtoarray(form.RHIHfrige, '/') >
			<cfset fecha2 = listtoarray(form.RHIHfhasta, '/') >

			<cfif Form.RHIHhinicio3 eq 'PM' and form.RHIHhinicio1 neq 12>
				<cfset form.RHIHhinicio1 = form.RHIHhinicio1 + 12 >
			</cfif>
			<cfif Form.RHIHhinicio3 eq 'AM' and form.RHIHhinicio1 eq 12>
				<cfset form.RHIHhinicio1 = 0 >
			</cfif>
			<cfset vHInicio = CreateDateTime(fecha1[3], fecha1[2], fecha1[1], Form.RHIHhinicio1, Form.RHIHhinicio2, 0) >
			
			<cfif Form.RHIHhfinal3 eq 'PM' and form.RHIHhfinal1 neq 12>
				<cfset form.RHIHhfinal1 = form.RHIHhfinal1 + 12 >
			</cfif>
			<cfif Form.RHIHhfinal3 eq 'AM' and form.RHIHhfinal1 eq 12>
				<cfset form.RHIHhfinal1 = 0 >
			</cfif>
			<cfset vHFinal = CreateDateTime(fecha2[3], fecha2[2], fecha2[1], Form.RHIHhfinal1, Form.RHIHhfinal2, 0) >
			
			<cfif datecompare(vHInicio, vHFinal) >
				<cfset vHFinal = dateadd('d', 1, vHFinal ) >
			</cfif>

			<cfquery name="ABC_IncidenciaHora" datasource="#Session.DSN#">
				update RHIncidenciasHora set 
					CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CIid#">,
					RHIHfrige = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHIHfrige)#">, 
					RHIHfhasta = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHIHfhasta)#">, 
					RHIHhinicio = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vHInicio#">,
					RHIHhfinal = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vHFinal#">
				where RHIHid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHIHid#">
			</cfquery>
				  
		<!--- Borrar Concepto de Pago por Hora --->
		<cfelseif isdefined("Form.Baja")>
			<cfquery name="ABC_IncidenciaHora" datasource="#Session.DSN#">
				delete from RHIncidenciasHora
				where RHIHid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHIHid#">
			</cfquery>
			
		</cfif>

</cfif>	

<cfoutput>
<form action="IncidenciasHora.cfm" method="post" name="sql">
	<input name="PageNum" type="hidden" value="<cfif isdefined("Form.PageNum")>#Form.PageNum#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

<!--- <cf_dump var="#form#"> --->
<cfset modo = "ALTA">
<cfif not isdefined("Form.NuevoAnotaciones")>
	<cfif isdefined("Form.AltaAnotaciones")>

		<cfquery name="insert" datasource="#Session.DSN#">
			insert into SNAnotaciones(Ecodigo, SNcodigo, SNAtipo, SNAdescripcion, SNAfecha, SNAobs, SNApeso, Usucodigo, fechaalta, SNApuntoVenta, SNAfechaCierre) 
			values ( <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer">,
					 <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">,
					 <cfqueryparam value="#Form.LTipo#" cfsqltype="cf_sql_char">,
					 <cfqueryparam value="#Form.SNAdescripcion#" cfsqltype="cf_sql_varchar">,
					 <cfqueryparam value="#LSParseDateTime(Form.SNAfecha)#" cfsqltype="cf_sql_date">,
					 <cfqueryparam value="#form.SNAobs#" cfsqltype="cf_sql_longvarchar">,
					 <cfqueryparam value="#form.SNApeso#" cfsqltype="cf_sql_float">,
					 <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
					 <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
					 <cfif isdefined("form.SNApuntoVenta")>
 						<cfqueryparam value="#form.SNApuntoVenta#" cfsqltype="cf_sql_bit">,
					 <cfelse>
					 	0,
					 </cfif>
					 <cfqueryparam cfsqltype="cf_sql_date" value="#form.SNAfechaCierre#">					 
			       )
		</cfquery>		   
		<cfset modo="ALTA">
		<cfelseif isdefined("Form.BajaAnotaciones")>
			<cfquery name="delete" datasource="#session.DSN#">
				delete from SNAnotaciones
				where  SNcodigo = <cfqueryparam value="#form.SNcodigo#" cfsqltype="cf_sql_integer"> 
				  and  SNAid = <cfqueryparam value="#form.SNAid#" cfsqltype="cf_sql_numeric">
			</cfquery>
		<cfset modo="BAJA">

	<cfelseif isdefined("Form.CambioAnotaciones")>
		<cf_dbtimestamp datasource="#session.dsn#"
			 			table="SNAnotaciones"
			 			redirect="Anotaciones.cfm"
			 			timestamp="#form.ts_rversion#"
						field1="SNAid" 
						type1="numeric" 
						value1="#form.SNAid#"
						field2="Ecodigo" 
						type2="integer" 
						value2="#session.ecodigo#"
						field3="SNcodigo" 
						type3="integer" 
						value3="#form.SNcodigo#"
						>

		<cfquery name="update" datasource="#Session.DSN#">
			update SNAnotaciones set
				   SNAtipo   = <cfqueryparam value="#Form.LTipo#" cfsqltype="cf_sql_char">,
				   SNAdescripcion   = <cfqueryparam value="#Form.SNAdescripcion#" cfsqltype="cf_sql_varchar">,
				   SNAfecha    = <cfqueryparam value="#LSParseDateTime(Form.SNAfecha)#" cfsqltype="cf_sql_date">,
				   SNAobs  = <cfqueryparam value="#Form.SNAobs#" cfsqltype="cf_sql_longvarchar">,				   
				   SNApeso   = <cfqueryparam value="#Form.SNApeso#" cfsqltype="cf_sql_float">,
		   		   <cfif isdefined("form.SNApuntoVenta")>
					   SNApuntoVenta = <cfqueryparam value="#form.SNApuntoVenta#" cfsqltype="cf_sql_bit">,
				   <cfelse>
					   SNApuntoVenta = 0,
				   </cfif>
				   SNAfechaCierre = <cfqueryparam value="#LSParseDateTime(form.SNAfechaCierre)#" cfsqltype="cf_sql_date">				   
			where  SNcodigo = <cfqueryparam value="#form.SNcodigo#" cfsqltype="cf_sql_integer"> 
				   and  SNAid = <cfqueryparam value="#form.SNAid#" cfsqltype="cf_sql_numeric">
			  	   <!---and ts_rversion = #lcase(Form.ts_rversion)#---->
		</cfquery> 
		<cfset modo="CAMBIO">
	</cfif>
</cfif>
<cfoutput>


<form action="Socios.cfm" method="post" name="sql">
 <!--- <cfif not isdefined("form.btnRegresar")><input name="btnAnotaciones" type="hidden" value="Notas"></cfif>  --->
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif isdefined("Form.SNAid") and isdefined("Form.CambioAnotaciones")>
		<input name="SNAid" type="hidden" value="#Form.SNAid#">
	</cfif>
	<input name="SNcodigo" type="hidden" value="#Form.SNcodigo#">	
	<input name="SNCcodigo" type="hidden" value="<cfif isdefined("Form.SNCcodigo")>#Form.SNCcodigo#</cfif>">
	<input name="tab" type="hidden" value="5">
</form>

</cfoutput>	

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>




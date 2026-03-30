<cfset modo = "ALTA">
	<cfif not isdefined("Form.Nuevo")>
		<cfif isdefined("Form.Alta")>
			<cfquery name="insert" datasource="#Session.DSN#">
				insert into CMSeguros(Ecodigo, CMSdescripcion, Costos, Fletes, Seguros, Gastos, Impuestos, ESporcadic, ESporcmult, Usucodigo, fechaalta) 
				values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CMSdescripcion#">,
						 <cfif isdefined("form.Costos")>1<cfelse>0</cfif>,
						 <cfif isdefined("form.Fletes")>1<cfelse>0</cfif>,
						 <cfif isdefined("form.Seguros")>1<cfelse>0</cfif>,
						 <cfif isdefined("form.Gastos")>1<cfelse>0</cfif>,
						 <cfif isdefined("form.Impuestos")>1<cfelse>0</cfif>,
						 <cfqueryparam cfsqltype="cf_sql_float" value="#Form.ESporcadic#">,
						 <cfqueryparam cfsqltype="cf_sql_float" value="#Form.ESporcmult#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Usucodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
					   )
			</cfquery>		   
			<cfset modo="ALTA">
			<cfelseif isdefined("Form.Baja")>
				<cfquery name="delete" datasource="#session.DSN#">
					delete from CMSeguros
					where  Ecodigo = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer"> 
					  and  CMSid = <cfqueryparam value="#form.CMSid#" cfsqltype="cf_sql_numeric">
				</cfquery>
			<cfset modo="BAJA">
	
		<cfelseif isdefined("Form.Cambio")>
			<cf_dbtimestamp datasource="#session.dsn#"
							table="CMSeguros"
							redirect="Seguros.cfm"
							timestamp="#form.ts_rversion#"
							field1="CMSid" 
							type1="numeric" 
							value1="#form.CMSid#"
							>
	
			<cfquery name="update" datasource="#Session.DSN#">
				update CMSeguros set
					   CMSdescripcion = <cfqueryparam value="#Form.CMSdescripcion#" cfsqltype="cf_sql_varchar">,
					   Costos = <cfif isdefined("form.Costos")>1<cfelse>0</cfif>,
					   Fletes = <cfif isdefined("form.Fletes")>1<cfelse>0</cfif>,
					   Seguros = <cfif isdefined("form.Seguros")>1<cfelse>0</cfif>,
					   Gastos = <cfif isdefined("form.Gastos")>1<cfelse>0</cfif>,
					   Impuestos =  <cfif isdefined("form.Impuestos")>1<cfelse>0</cfif>, 
					   ESporcadic = <cfqueryparam value="#Form.ESporcadic#" cfsqltype="cf_sql_float">,
					   ESporcmult = <cfqueryparam value="#Form.ESporcmult#" cfsqltype="cf_sql_float">
				where  Ecodigo = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer"> 
					   and  CMSid = <cfqueryparam value="#form.CMSid#" cfsqltype="cf_sql_numeric">
			</cfquery> 
			<cfset modo="CAMBIO">
		</cfif>
	</cfif>
<cfoutput>
<form action="Seguros.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif isdefined("Form.CMSid") and isdefined("Form.Cambio") >
		<input name="CMSid" type="hidden" value="#Form.CMSid#">
	</cfif>
</form>
</cfoutput>	

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>




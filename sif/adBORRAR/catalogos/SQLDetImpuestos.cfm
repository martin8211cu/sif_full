<cfset modo = "ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cftransaction>
		<cfquery name="insert" datasource="#Session.DSN#">
			insert into DImpuestos( Ecodigo, Icodigo, DIcodigo, DIporcentaje, DIdescripcion, DIcreditofiscal, Ccuenta, Usucodigo, DIfecha )
			select <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">,
					 <cfqueryparam value="#Form.Icodigo#" cfsqltype="cf_sql_char">,
					 <cfqueryparam value="#Form.DIcodigo#" cfsqltype="cf_sql_char">,
					 <cfqueryparam value="#Form.DIporcentaje#" cfsqltype="cf_sql_float">,
					Idescripcion,
					 					 
					  <cfif isdefined("Form.DIcreditofiscal")>				
						1,
					 <cfelse>
						0,
					 </cfif>
					 
					 <cfqueryparam value="#Form.Ccuenta#" cfsqltype="cf_sql_numeric">,				 
					 <cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">,
					 <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">
			from Impuestos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.DIcodigo#">
		</cfquery>		   
		<cfquery name="update" datasource="#Session.DSN#">
			update Impuestos 
			set	Iporcentaje = (select coalesce(sum(DIporcentaje),0)
								from DImpuestos b
								where b.Icodigo = Impuestos.Icodigo
								and b.Ecodigo = Impuestos.Ecodigo),
				Usucodigo = <cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">,
				Ifecha = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">
			where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and Icodigo = <cfqueryparam value="#Form.Icodigo#" cfsqltype="cf_sql_char">
		</cfquery> 
		</cftransaction>
		<cfset modo="ALTA">	
	
	<cfelseif isdefined("Form.Baja")>
		<cftransaction>
		<cfquery name="delete" datasource="#Session.DSN#">
			delete from DImpuestos
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and Icodigo = <cfqueryparam value="#Form.Icodigo#" cfsqltype="cf_sql_char">
				and DIcodigo = 	<cfqueryparam value="#Form.DIcodigo#" cfsqltype="cf_sql_char">
		</cfquery>
		<cfquery name="update" datasource="#Session.DSN#">
			update Impuestos 
			set	Iporcentaje = (select coalesce(sum(DIporcentaje),0)
								from DImpuestos b
								where b.Icodigo = Impuestos.Icodigo
								and b.Ecodigo = Impuestos.Ecodigo),
				Usucodigo = <cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">,
				Ifecha = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">
			where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and Icodigo = <cfqueryparam value="#Form.Icodigo#" cfsqltype="cf_sql_char">
		</cfquery> 
		</cftransaction>
		<cfset modo="ALTA">
	
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
			 			table="DImpuestos"
			 			redirect="DetImpuestos.cfm"
			 			timestamp="#form.ts_rversion#"				
						field1="Ecodigo" 
						type1="integer" 
						value1="#session.Ecodigo#"
						field2="Icodigo" 
						type2="char" 
						value2="#form.Icodigo#"
						field3="DIcodigo" 
						type3="char" 
						value3="#form.DIcodigo#"
						>

		<cftransaction>
		<cfquery name="update" datasource="#Session.DSN#">
			update DImpuestos 
			set	DIporcentaje = <cfqueryparam value="#Form.DIporcentaje#" cfsqltype="cf_sql_float">,
				<cfif isdefined("Form.DIcreditofiscal")>				
					DIcreditofiscal = 1,
				<cfelse>
					DIcreditofiscal = 0,
				</cfif>
				Ccuenta = <cfqueryparam value="#Form.Ccuenta#" cfsqltype="cf_sql_numeric">,
				Usucodigo = <cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">,
				DIfecha = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">
			where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and Icodigo = <cfqueryparam value="#Form.Icodigo#" cfsqltype="cf_sql_char">
				and DIcodigo = 	<cfqueryparam value="#Form.DIcodigo#" cfsqltype="cf_sql_char">
		</cfquery> 
		<cfquery name="update" datasource="#Session.DSN#">
			update Impuestos 
			set	Iporcentaje = (select coalesce(sum(DIporcentaje),0)
								from DImpuestos b
								where b.Icodigo = Impuestos.Icodigo
								and b.Ecodigo = Impuestos.Ecodigo),
				Usucodigo = <cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">,
				Ifecha = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">
			where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and Icodigo = <cfqueryparam value="#Form.Icodigo#" cfsqltype="cf_sql_char">
		</cfquery> 
		</cftransaction>
		<cfset modo="CAMBIO">
	
	</cfif>
</cfif>

<cfoutput>
<form action="DetImpuestos.cfm" method="post" name="sql">
	<input name="Icodigo" type="hidden" value="#Form.Icodigo#">
	<cfif isdefined("modo") and modo eq "CAMBIO">
		<input name="modo" type="hidden" value="#modo#">
		<input name="DIcodigo" type="hidden" value="#Form.DIcodigo#">
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

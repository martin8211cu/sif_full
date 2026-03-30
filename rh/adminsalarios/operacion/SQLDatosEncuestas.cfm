
<cftransaction>
	<cfif isdefined("Cambio")>
		<cfloop collection="#Form#" item="i">
			<cfif FindNoCase("Obs_", i) NEQ 0>
				<cfset linea = Mid(i, 5, Len(i))>
				<cfquery name="EncDatosInsert" datasource="sifpublica">
					Update EncuestaSalarios
					Set EScantobs = <cfqueryparam cfsqltype="cf_sql_integer" value="#Replace(Evaluate('Form.Obs_'&linea),',','','All')#">,
						ESp25 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(Evaluate('Form.ESp25_'&linea),',','','All')#">,
						ESp50 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(Evaluate('Form.ESp50_'&linea),',','','All')#">,
						ESp75 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(Evaluate('Form.ESp75_'&linea),',','','All')#">,
						ESpromedioanterior = <cfqueryparam cfsqltype="cf_sql_numeric" 
															value="#Replace(Evaluate('Form.ESpromedioanterior_'&linea),',','','All')#">,
						ESpromedio = <cfqueryparam cfsqltype="cf_sql_numeric" 
													value="#Replace(Evaluate('Form.ESpromedio_'&linea),',','','All')#">,
						ESvariacion = <cfqueryparam cfsqltype="cf_sql_float" 
													value="#Replace(Evaluate('Form.ESvariacion_'&linea),',','','All')#">,
						BMfechaalta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
						BMUsucodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					where ESid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.ESid_'&linea)#">
				</cfquery>
			</cfif>
		</cfloop>
		<cfset form.modo = 'CAMBIO'>
	<cfelseif isdefined("Alta") >
		<cfloop collection="#Form#" item="i">
			<cfif FindNoCase("Obs_", i) NEQ 0>
				<cfset linea = Mid(i, 5, Len(i))>
				<cfquery name="EncDatosInsert" datasource="sifpublica">
					insert into EncuestaSalarios
					(EEid,ETid,Eid,EPid,EScantobs,ESp25,ESp50,ESp75,ESpromedio,
					ESpromedioanterior,ESvariacion,Moneda,BMUsucodigo,BMfechaalta)
					values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.EEid_'&linea)#">,
						   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.ETid_'&linea)#">,
						   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.Eid_'&linea)#">,
						   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.EPid_'&linea)#">,
						   <cfqueryparam cfsqltype="cf_sql_integer" value="#Replace(Evaluate('Form.Obs_'&linea),',','','All')#">,
						   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(Evaluate('Form.ESp25_'&linea),',','','All')#">,
						   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(Evaluate('Form.ESp50_'&linea),',','','All')#">,
						   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(Evaluate('Form.ESp75_'&linea),',','','All')#">,
						   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(Evaluate('Form.ESpromedio_'&linea),',','','All')#">,
						   <cfqueryparam cfsqltype="cf_sql_numeric" 
						   		value="#Replace(Evaluate('Form.ESpromedioanterior_'&linea),',','','All')#">,
						   <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(Evaluate('Form.ESvariacion_'&linea),',','','All')#">,
						   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.Mcodigo')#">,
						   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
					  <cf_dbidentity1 datasource="sifpublica">
				</cfquery>
				<cf_dbidentity2 datasource="sifpublica" name="EncDatosInsert">
			</cfif>
		</cfloop>
		<cfset form.modo = 'CAMBIO'>		
	<cfelseif isdefined("Baja") >
		<cfquery name="EncSalDelete" datasource="sifpublica">
			delete from EncuestaSalarios
			where Eid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Eid#">
			  and Moneda = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">
		</cfquery>
		<cfset form.modo = 'CAMBIO'>		
	</cfif> 
</cftransaction>

<form action="DatosEncuestas.cfm" method="post" name="sql">
	<input name="Eid" type="hidden" value="<cfif isdefined("Form.Eid")><cfoutput>#Form.Eid#</cfoutput></cfif>">	
	<input name="EAid" type="hidden" value="<cfif isdefined("Form.EAid")><cfoutput>#Form.EAid#</cfoutput></cfif>">	
	<input name="ETid" type="hidden" value="<cfif isdefined("Form.ETid")><cfoutput>#Form.ETid#</cfoutput></cfif>">	
	<input name="modo" type="hidden" value="<cfif isdefined("Form.modo")><cfoutput>#form.modo#</cfoutput></cfif>">	
	<input name="Mcodigo" type="hidden" value="<cfif isdefined("Form.Mcodigo")><cfoutput>#form.Mcodigo#</cfoutput></cfif>">	
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">	
</form>

<html>
	<head>
	</head>
	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</html>
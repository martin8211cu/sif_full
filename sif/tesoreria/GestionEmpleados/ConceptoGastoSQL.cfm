<!---<cf_dump var="#form#">--->
<cfset modo = 'ALTA'>
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
	
		
		
		<cfquery name="rsAlta" datasource="#Session.DSN#">
			insert into GEconceptoGasto (
				GECconcepto, 
				GECdescripcion,
				GECcomplemento,
				GETid,
				BMUsucodigo,
				montoI,
				Cid,
				montoM,
				GECcomplemento2,
				GECmontoDeducibleDia,
				GECajusteDias
				)
				
			values(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.GECconcepto#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.GECdescripcion#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.GECcomplemento#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GETid#">,
				#session.usucodigo#,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form.montoI,',','','ALL')#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#form.Cid#" null="#len(trim(form.Cid))#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.montoM,',','','ALL')#">,
				<cfif trim(form.GECcomplemento2) EQ "">
					<cfset form.GECmontoDeducibleDia = "">
				<cfelseif trim(form.GECmontoDeducibleDia) EQ "">
					<cfset form.GECmontoDeducibleDia = "0">
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.GECcomplemento2#" null="#trim(form.GECcomplemento2) EQ ""#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.GECmontoDeducibleDia,',','','ALL')#" null="#trim(form.GECmontoDeducibleDia) EQ ""#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GECajusteDias#">
			)
		</cfquery>
		
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="rsBaja" datasource="#Session.DSN#">
			delete from GEconceptoGasto
			where GECid = <cfqueryparam value="#Form.GECid#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfset modo="BAJA">
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp
			datasource	="#session.dsn#"
			table		="GEconceptoGasto" 
			redirect	="ConceptoGasto.cfm"
			timestamp	="#form.ts_rversion#"
			field1		="GECid,integer,#form.GECid#">
			
			<cfquery name="rsCambio" datasource="#Session.DSN#">
				update GEconceptoGasto set
					GECdescripcion = <cfqueryparam  value="#Form.GECdescripcion#" cfsqltype="cf_sql_varchar">,
					GECcomplemento			= <cfqueryparam  value="#Form.GECcomplemento#" cfsqltype="cf_sql_varchar">,
					GETid 		= <cfqueryparam  value="#form.GETid#" 	    cfsqltype="cf_sql_numeric">,
					montoI=<cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form.montoI,',','','ALL')#">,
					<cfif isdefined('form.Cid') and len(trim(#form.Cid#))>
					Cid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid#">,
					</cfif>
					montoM=	<cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form.montoM,',','','ALL')#">,
					<cfif trim(form.GECcomplemento2) EQ "">
						<cfset form.GECmontoDeducibleDia = "">
					<cfelseif trim(form.GECmontoDeducibleDia) EQ "">
						<cfset form.GECmontoDeducibleDia = "0">
					</cfif>
					GECcomplemento2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.GECcomplemento2#" null="#trim(form.GECcomplemento2) EQ ""#">,
					GECmontoDeducibleDia = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.GECmontoDeducibleDia,',','','ALL')#" null="#trim(form.GECmontoDeducibleDia) EQ ""#">,
					GECajusteDias=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GECajusteDias#">
				where GECid = <cfqueryparam value="#Form.GECid#" cfsqltype="cf_sql_numeric">
			</cfquery>	
			
		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<form action="ConceptoGasto.cfm" method="post" name="sql">
	<cfoutput>
		<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<input name="GECid" type="hidden" value="<cfif isdefined("Form.GECid") and modo NEQ 'ALTA'>#Form.GECid#</cfif>">
	</cfoutput>		
</form>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>
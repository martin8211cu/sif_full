<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfif isdefined("Form.Alta")>
			<cfquery name="Valida" datasource="#Session.DSN#">
				select count(1) as Cantidad
				from MIGMonedas
				where Msimbolo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.Msimbolo)#">
				and Ecodigo=#session.Ecodigo#
			</cfquery>
			<cfif Valida.Cantidad GT 0>
				<cfthrow type="toUser" message="La Moneda que esta insertando ya existe en el Sistema.">
			<cfelse>
				<cfquery name="MIGMonedas" datasource="#Session.DSN#">
					insert INTO MIGMonedas (Ecodigo, Mnombre, Msimbolo, Miso4217,CEcodigo,BMusucodigo)
					values(
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.Mnombre)#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.Msimbolo)#">,
						 <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(Form.Miso4217)#">,
						 #session.CEcodigo#,
						 #session.usucodigo#
					)													
				</cfquery>
			</cfif>
				
				<cfset modo="ALTA">
		<cfelseif isdefined("Form.Baja")>
			<cfquery name="Valida" datasource="#Session.DSN#">
				select id_moneda_origen,id_moneda
				from F_Datos
				where id_moneda_origen  = <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">
				and Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfquery name="Valida2" datasource="#Session.DSN#">
				select id_moneda_origen,id_moneda
				from F_Datos
				where id_moneda  = <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">
				and Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfquery name="Valida3" datasource="#Session.DSN#">
				select Mcodigo
				from MIGFactorconversion
				where Mcodigo  = <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">
				and Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfif Valida.recordCount GT 0 or Valida2.recordCount GT 0 or  Valida3.recordCount GT 0>
				<cfthrow type="toUser" message="La Moneda no puede ser eliminada ya que posee relaciones con la el Mantenimiento de Datos Variables">
			<cfelse>
				<cfquery name="MIGMonedas" datasource="#Session.DSN#">
					delete from MIGMonedas
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and Mcodigo  = <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">
				</cfquery>
				<cfset modo="BAJA">
			</cfif>
		<cfelseif isdefined("Form.Cambio")>
			<cftransaction>
				<cf_dbtimestamp
				    datasource="#session.dsn#"
					table="MIGMonedas" 
					redirect="Monedas.cfm"
					timestamp="#form.ts_rversion#"
					field1="Ecodigo,integer,#session.Ecodigo#"					
					field2="Mcodigo,numeric,#form.Mcodigo#">			
					
				<cfquery name="MIGMonedas" datasource="#Session.DSN#">
					update MIGMonedas set 
						Msimbolo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.Msimbolo)#">,
						Miso4217 = <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(Form.Miso4217)#">
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and Mcodigo = <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">
				</cfquery>
			</cftransaction>
				  
			<cfset modo="CAMBIO">
		</cfif>
	<cfcatch type="database">
		<cfinclude template="../../sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>
<form action="Monedas.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="Mcodigo" type="hidden" value="<cfif isdefined("Form.Mcodigo")><cfoutput>#Form.Mcodigo#</cfoutput></cfif>">
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">		
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


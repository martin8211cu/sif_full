<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="Error_El_Regimen_ya_esta_asignado"
Default="Error! El R&eacute;gimen ya est&aacute asignado. Proceso Cancelado"
returnvariable="MG_RegimenAsignado"/>

<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfquery name="RegFiscal" datasource="#Session.DSN#">
			set nocount on
			<cfif isdefined("Form.Alta")>
				Insert 	FARegFiscal(codigo_RegFiscal,nombre_RegFiscal,BMfechamod,Ecodigo,BMUsucodigo,ClaveSAT)
						values	(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.codigo_RegFiscal#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.nombre_RegFiscal#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,						
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CSATcodigo#">
						)
				Select 1
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Cambio")>
				Update 	FARegFiscal
					set  codigo_RegFiscal = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.codigo_RegFiscal#">,
						 nombre_RegFiscal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.nombre_RegFiscal#">,
						 ClaveSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CSATcodigo#">
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				      and id_RegFiscal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_RegFiscal#">
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Baja")>
                <cfquery name="rs" datasource="#session.DSN#">
                    select Pvalor
                    from RHParametros
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                      and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="45">
                </cfquery>
                <cfif rs.RecordCount gt 0 and rs.Pvalor eq Form.id_RegFiscal>
					<cf_throw message="#MG_RegimenAsignado#" errorcode="2075">
                <cfelse>
                    delete FARegFiscal
                    where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                         and id_RegFiscal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_RegFiscal#">
                </cfif>
				<cfset modo="BAJA">
			</cfif>
			set nocount off
		</cfquery>
	<cfcatch type="database">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<form action="RegFiscalFact.cfm" method="post" name="sql">
	<cfif isDefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="<cfoutput>#Form.Nuevo#</cfoutput>">
	</cfif>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="id_RegFiscal" type="hidden" value="<cfif isdefined("Form.id_RegFiscal")><cfoutput>#Form.id_RegFiscal#</cfoutput></cfif>">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
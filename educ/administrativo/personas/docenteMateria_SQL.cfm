<cfset modo = "CAMBIO">
	<cftry>			
		<cfif isdefined("Form.btnAgregarDocMateria") and form.btnAgregarDocMateria EQ 1>
			<cfquery name="A_MatRequisitos" datasource="#Session.DSN#">
				set nocount on
					insert DocenteMateria 
						(DOpersona, Mcodigo, DOMtipo,DOMfecha)
					values (
						<cfqueryparam value="#form.DOpersona#" cfsqltype="cf_sql_numeric">
						, <cfqueryparam value="#form.McodigoDocMateria#" cfsqltype="cf_sql_numeric">
						, <cfqueryparam value="#form.DOMtipo#" cfsqltype="cf_sql_char">
						, getDate())
				set nocount off
			</cfquery>
		<cfelseif isdefined("Form.btnDesactDocMateria") and form.btnDesactDocMateria EQ 1>
			<cfquery name="A_MatRequisitos" datasource="#Session.DSN#">
				set nocount on
					update DocenteMateria set
						DOMactivo=0
						, DOMfecha = getDate()
					where Mcodigo = <cfqueryparam value="#Form.IdDocMateriaDesact#"   cfsqltype="cf_sql_numeric">						
				set nocount off	
			</cfquery>						
		<cfelseif isdefined("Form.btnActDocMateria") and form.btnActDocMateria EQ 1>
			<cfquery name="A_MatRequisitos" datasource="#Session.DSN#">
				set nocount on
					update DocenteMateria set
						DOMactivo=1
						, DOMfecha = getDate()
					where Mcodigo = <cfqueryparam value="#Form.IdDocMateriaAct#"   cfsqltype="cf_sql_numeric">						
				set nocount off	
			</cfquery>						
		</cfif>
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
</cftry>

<form action="docente.cfm" method="post" name="sql">
	<cfoutput>
		<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<input name="DOpersona" type="hidden" value="<cfif isdefined("Form.DOpersona") and form.DOpersona NEQ ''>#Form.DOpersona#</cfif>">
		<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	
		<input name="TP" type="hidden" value="DO">		
	</cfoutput>	
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
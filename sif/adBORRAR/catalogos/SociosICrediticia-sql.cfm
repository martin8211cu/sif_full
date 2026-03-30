<!--- 
	Modificado por: Gustavo Fonseca Hernández.
		Fecha: 9-8-2005.
		Motivo: se quita el campo SNcodigoext de este tab.
 --->

<cftransaction>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="SNegocios"
		redirect="Socios.cfm"
		timestamp="#form.ts_rversion#"				
		field1="Ecodigo" 
		type1="integer"
		value1="#session.Ecodigo#"
		field2="SNcodigo" 
		type2="integer" 
		value2="#form.SNcodigo#">
	
	<cfif Len(Form.SNmontoLimiteCC) EQ 0><cfset Form.SNmontoLimiteCC = 0></cfif>
	<cfif Len(Form.SNdiasVencimientoCC) EQ 0><cfset Form.SNdiasVencimientoCC = 0></cfif>
	<cfif Len(Form.SNdiasMoraCC) EQ 0><cfset Form.SNdiasMoraCC = 0></cfif>
	
	<cfquery name="update" datasource="#Session.DSN#">
		update SNegocios set  
			LPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.LPid#" null="#len(trim(form.LPid)) EQ 0#">,
			SNvencompras   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNvencompras#"   null="#len(trim(Form.SNvencompras))   EQ 0#">,
			SNvenventas    = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNvenventas#"    null="#len(trim(Form.SNvenventas))    EQ 0#">,
			SNplazoentrega = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNplazoentrega#" null="#len(trim(form.SNplazoentrega)) EQ 0#">,
			SNplazocredito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNplazocredito#" null="#len(trim(form.SNplazocredito)) EQ 0#">,
			Mcodigo        = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#"        null="#len(trim(form.Mcodigo))        EQ 0#">,
			SNmontoLimiteCC = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.SNmontoLimiteCC#" null="#len(trim(form.SNmontoLimiteCC))EQ 0#">,
			SNdiasVencimientoCC = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNdiasVencimientoCC#" null="#len(trim(form.SNdiasVencimientoCC)) EQ 0#">,
			SNdiasMoraCC  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNdiasMoraCC#" null="#len(trim(form.SNdiasMoraCC)) EQ 0#">,<!--- , Preguntar a Gudiño donde quiere estos campos: GAFH--->
			DEidEjecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid3#"        null="#len(trim(form.DEid3))        EQ 0#">,
			DEidVendedor  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid2#"        null="#len(trim(form.DEid2))        EQ 0#">,
			DEidCobrador  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid1#"        null="#len(trim(form.DEid1))        EQ 0#">,
			SNnombrePago = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#form.SNnombrePago#" null="#len(trim(form.SNnombrePago)) EQ 0#"> <!--- Campo nuevo Ozkar Tesorería --->
			<!--- ,ZCSNid        = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ZCSNid#"       null="#len(trim(form.ZCSNid))       EQ 0#">  --->
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
	</cfquery>
</cftransaction>

<cfoutput>
<form action="Socios.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif isdefined("Form.SNcodigo") and len(trim(Form.SNcodigo)) GT 0 and not isdefined("form.nuevo")>
		<input name="SNcodigo" type="hidden" value="#Form.SNcodigo#">
		<input type="hidden" name="tab" value="2">
	</cfif>
	
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ "">#Pagenum_lista#<cfelseif isdefined("Form.PageNum")>#PageNum#</cfif>">		
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

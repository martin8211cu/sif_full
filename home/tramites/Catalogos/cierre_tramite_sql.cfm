<!--- 
	Creado por: Gustavo Fonseca Hernández.
		Fecha: 25-8-2005.
		Motivo: Creación del Mantenimiento de la tabla: TPTramiteCierreDoc.
 --->
<!--- <cfdump var="#form#">
<cf_dump var="#url#"> --->
<cfparam name="modo" default="ALTA">
<cfset tab = '1'>
<cfif isdefined("btnGuardar")>
  <cftransaction>
  	<cfparam name="form.id_metodo_generado" default="">
  	<cfquery datasource="#session.tramites.dsn#">
		update TPTramite
		set id_metodo_generado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_metodo_generado#" null="#Len(form.id_metodo_generado) EQ 0#">
		where id_tramite= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">
	</cfquery>
  
    <cfquery datasource="#session.tramites.dsn#">
		delete TPTramiteCierreDoc
		where id_tramite= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">
	</cfquery>
  
    <cfquery datasource="#session.tramites.dsn#">
		delete TPTramiteCierrePers
		where id_tramite= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">
	</cfquery>
    <cfloop collection="#Form#" item="i">
      <cfif FindNoCase("id_campo_req_", i) NEQ 0>
        
		<cfset Lvarid_campo_doc = Mid(i, 14, Len(i))>
        
		<cfset Lvarid_campo_req = form['id_campo_req_'&Lvarid_campo_doc]>
        <cfif Lvarid_campo_req neq '-1'>
          <!--- los que tienen -1 no se graban --->
		  
		  <cfset esDoc = IsNumeric(Lvarid_campo_doc)>
		  
          <cfquery name="rsinsert" datasource="#session.tramites.dsn#">
			insert into <cfif esDoc>TPTramiteCierreDoc<cfelse>TPTramiteCierrePers</cfif>
				(id_tramite, <cfif esDoc>id_campo_doc<cfelse>campo_persona</cfif>, 
				id_campo_req, campo_fijo, modificable,
				BMfechamod, BMUsucodigo)
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">,
				<cfif esDoc>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvarid_campo_doc#">,
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvarid_campo_doc#">,
				</cfif>
				
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#ListRest(Lvarid_campo_req)#" null="#ListFirst(Lvarid_campo_req) NEQ 'C'#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#ListRest(Lvarid_campo_req)#" null="#ListFirst(Lvarid_campo_req) NEQ 'F'#">,
				
				<cfqueryparam cfsqltype="cf_sql_bit" value="#StructKeyExists(form,'modif_' & Lvarid_campo_doc)#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			)
		</cfquery>
        </cfif>
        <!--- <cfdump var="#Lvarid_campo_doc# Lvarid_campo_doc |">
				<cfdump var="#Lvarid_campo_req# form.Lvarid_campo_doc_NUMERO | ">
				<cfdump var="#id_tramite# id_tramite |">
				<cfdump var="#now()# fecha |">
				<cfdump var="#session.Usucodigo# usucodigo |">	<br> --->
      </cfif>
    </cfloop>
  </cftransaction>
  <cfset modo = "CAMBIO">
  <cfset tab = '6'>
</cfif>
<!--- <cf_dump var="#form#"> --->
<form action="tramites.cfm" method="post" name="sql">
  <input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
  <input name="id_tramite" type="hidden" value="<cfif isdefined("Form.id_tramite")><cfoutput>#Form.id_tramite#</cfoutput></cfif>">
  <input type="hidden" name="tab" value="<cfoutput>#tab#</cfoutput>">
</form>
<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

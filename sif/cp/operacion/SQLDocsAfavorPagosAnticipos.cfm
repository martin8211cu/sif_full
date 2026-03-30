<cfset cambioEncab = false>
<cfif not (isDefined("Form.EAfecha") and Trim(Form.EAfecha) EQ Trim(Form._EAfecha))>
	<cfset cambioEncab = true>
</cfif>

<cftransaction>
<cfif isdefined("Form.AgregarE")>

	<cfquery name="InsertAplicaD" datasource="#session.DSN#">
		insert into EAplicacionCP (ID, Ecodigo, CPTcodigo, Ddocumento, SNcodigo, Mcodigo,  EAtipocambio, EAtotal, EAselect,
				EAfecha, EAusuario )
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_char"    value="#Form.CPTcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_char"    value="#Form.Ddocumento#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.McodigoE#">,
			<cfqueryparam cfsqltype="cf_sql_float"   value="#Form.EAtipocambio#">,
			0,
			0,
			#LSParseDateTime(Form.EAfecha)#,
			'#Session.usuario#'
		)
	</cfquery>
	<cfset modo="CAMBIO">
	<cfset modoDet="ALTA">
<cfelseif isdefined("Form.BorrarE")>
	<cfquery name="Delete" datasource="#session.DSN#">
		delete from DAplicacionCP
		where Ecodigo =  #Session.Ecodigo#
		  and ID  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDpago#">
	</cfquery>
	<cfquery name="Delete" datasource="#session.DSN#">
		delete from EAplicacionCP
		where Ecodigo =  #Session.Ecodigo#
		  and ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDpago#">
	</cfquery>
	<cfquery name="Update" datasource="#session.DSN#">
		update EAplicacionCP set
		EAtotal=
		(select coalesce(sum(DAtotal),0.0)
					from DAplicacionCP
					where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDpago#">
			)
		where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDpago#">
	</cfquery>
	<cfset modo="ALTA">
	<cfset modoDet="ALTA">
<cfelseif isdefined("Form.AgregarD")>
	<!--- Calcular el tipo de cambio --->
	<cfif Form.FC EQ "calculado">
		<cfset tipocambio = #Val(Form.DAmontodoc)# / #Val(Form.DAmonto)#>
	<cfelseif Form.FC EQ "iguales">
		<cfset tipocambio = 1.0>
	<cfelseif Form.FC EQ "encabezado">
		<cfset tipocambio = #Val(Form.EAtipocambio)#>
	</cfif>

	<cfif cambioEncab>

				<cf_dbtimestamp
					datasource="#session.dsn#"
					table="EAplicacionCP"
					redirect="listaDocsAfavorPagosAnticipos.cfm"
					timestamp="#Form.timestampE#"
					field1="Ecodigo,integer,#session.Ecodigo#"
					field2="ID,numeric,#Form.IDpago#">

		<cfquery name="Update" datasource="#session.DSN#">
			update EAplicacionCP set EAfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.EAfecha)#">
			where Ecodigo =  #Session.Ecodigo#
			  and ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDpago#">
		</cfquery>
	</cfif>
	<cfquery name="InsertD" datasource="#session.DSN#">
		insert into DAplicacionCP (ID , Ecodigo, SNcodigo, DAidref, DAtransref, DAdocref, DAmonto, DAtotal ,
								   DAmontodoc, DAtipocambio)
		values
		(
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDpago#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DAidref#">,
			<cfqueryparam cfsqltype="cf_sql_char"    value="#Form.DAtransref#">,
			<cfqueryparam cfsqltype="cf_sql_char"    value="#Form.DAdocref#">,
			<cfqueryparam cfsqltype="cf_sql_money"   value="#Replace(Form.DAmonto,",","")#">,
			<cfqueryparam cfsqltype="cf_sql_money"   value="#Replace(Form.DAmonto,",","")#">,
			<cfqueryparam cfsqltype="cf_sql_money"   value="#Replace(Form.DAmontodoc,",","")#">,
			<cfqueryparam cfsqltype="cf_sql_float"   value="#tipocambio#">
		)

	</cfquery>
	<cfquery name="UpdateE" datasource="#session.DSN#">
		update EAplicacionCP set
		EAtotal=
		(select coalesce(sum(DAtotal),0.0)
					from DAplicacionCP
					where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDpago#">
			)
		where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDpago#">
	</cfquery>
	<cfset modo="CAMBIO">
	<cfset modoDet="ALTA">
<cfelseif isdefined("Form.BorrarD")>
	<cfquery name="DeleteD" datasource="#session.DSN#">
		delete from DAplicacionCP
		where Ecodigo =  #Session.Ecodigo#
		  and ID  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDpago#">
		  and DAlinea =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DAlinea#">
	</cfquery>
	<cfquery name="UpdateE" datasource="#session.DSN#">
		update EAplicacionCP set
		EAtotal=
		(select coalesce(sum(DAtotal),0.0)
					from DAplicacionCP
					where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDpago#">
			)
		where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDpago#">
	</cfquery>
	<cfset modo="CAMBIO">
	<cfset modoDet="ALTA">
<cfelseif isdefined("Form.CambiarD")>
	<!--- Calcular el tipo de cambio --->

	<cfif Form.FC EQ "calculado">
		<cfset tipocambio = #Val(Form.DAmontodoc)# / #Val(Form.DAmonto)#>
	<cfelseif Form.FC EQ "iguales">
		<cfset tipocambio = 1.0>
	<cfelseif Form.FC EQ "encabezado">
		<cfset tipocambio = #Val(Form.EAtipocambio)#>
	</cfif>

	<cfif cambioEncab>
			<cf_dbtimestamp
					datasource="#session.dsn#"
					table="EAplicacionCP"
					redirect="listaDocsAfavorPagosAnticipos.cfm"
					timestamp="#Form.timestampE#"
					field1="ID,numeric,#Form.IDpago#">

		<cfquery name="UpdateE" datasource="#session.DSN#">
			update EAplicacionCP set EAfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.EAfecha)#">
			where Ecodigo =  #Session.Ecodigo#
			  and ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDpago#">
		</cfquery>
	</cfif>
		<cfquery name="UpdateLinea" datasource="#session.DSN#">
				update DAplicacionCP set
					DAidref =      <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DAidref#">,
					DAtransref =   <cfqueryparam cfsqltype="cf_sql_char"    value="#Form.DAtransref#">,
					DAdocref =     <cfqueryparam cfsqltype="cf_sql_char"    value="#Form.DAdocref#">,
					DAmonto =      <cfqueryparam cfsqltype="cf_sql_money"   value="#Replace(Form.DAmonto,",","")#">,
					DAtotal =      <cfqueryparam cfsqltype="cf_sql_money"   value="#Replace(Form.DAmonto,",","")#">,
					DAmontodoc =   <cfqueryparam cfsqltype="cf_sql_money"   value="#Replace(Form.DAmontodoc,",","")#">,
					DAtipocambio = <cfqueryparam cfsqltype="cf_sql_float"   value="#tipocambio#">
				where Ecodigo =  #Session.Ecodigo#
				  and ID  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDpago#">
				  and DAlinea =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DAlinea#">
		</cfquery>
		<cfquery name="UpdateEncabezado" datasource="#session.DSN#">
			update EAplicacionCP set
			EAtotal=
			(select coalesce(sum(DAtotal),0.0)
						from DAplicacionCP
						where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDpago#">
				)
			where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDpago#">
		</cfquery>
		<cfset modo="CAMBIO">
		<cfset modoDet="ALTA">

	</cfif>

<cfif isdefined("modo") and modo EQ "ALTA" and isdefined("modoDet") and modoDet EQ "ALTA">
	<cfset Action = "listaDocsAfavorPagosAnticipos.cfm">
<cfelse>
	<cfset Action = "AplicaDocsAfavorPagosAnticipos.cfm">
</cfif>

</cftransaction>
<cfoutput>
<form action="#Action#" method="post" name="sql">	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="modoDet" type="hidden" value="<cfif isdefined("modoDet")>#modoDet#</cfif>">

	<input name="IDpago" type="hidden" value="<cfif isdefined("form.IDdocumento") and LEN(TRIM(form.IDdocumento))>#form.IDdocumento#<cfelseif isdefined("Form.IDpago") and LEN(TRIM(form.IDpago))>#Form.IDpago#</cfif>">

	<cfif isdefined("Form.Aplicar")>
   	<input name="Aplicar" type="hidden" value="<cfif isdefined("Form.Aplicar")>#Form.Aplicar#</cfif>">
	</cfif>

	<cfif isdefined("Form.CPTcodigo")>
   	<input name="CPTcodigo" type="hidden" value="<cfif isdefined("Form.CPTcodigo")>#Form.CPTcodigo#</cfif>">
	</cfif>

	<cfif isdefined("Form.Ddocumento")>
   	<input name="Ddocumento" type="hidden" value="<cfif isdefined("Form.Ddocumento")>#Form.Ddocumento#</cfif>">
	</cfif>

	<cfif isdefined("Form.docrefb")>
   	<input name="docrefb" type="hidden" value="<cfif isdefined("Form.docrefb")>#Form.docrefb#</cfif>">
	</cfif>

	<cfoutput>
	<input type="hidden" name="pageNum_Lista" 	      value="<cfif isdefined('form.PageNum_Lista') and len(trim(form.PageNum_Lista))>#form.PageNum_Lista#<cfelse>1</cfif>" />
	<input type="hidden" name="filtro_CPTdescripcion" value="<cfif isdefined('form.filtro_CPTdescripcion') and len(trim(form.filtro_CPTdescripcion))>#form.filtro_CPTdescripcion#</cfif>" />
	<input type="hidden" name="filtro_Ddocumento"	  value="<cfif isdefined('form.filtro_Ddocumento') and len(trim(form.filtro_Ddocumento)) >#form.filtro_Ddocumento#</cfif>" />
	<input type="hidden" name="filtro_EAfecha" 		  value="<cfif isdefined('form.filtro_EAfecha') and len(trim(form.filtro_EAfecha)) >#form.filtro_EAfecha#</cfif>" />
	<input type="hidden" name="filtro_EAusuario" 	  value="<cfif isdefined('form.filtro_EAusuario') and len(trim(form.filtro_EAusuario)) >#form.filtro_EAusuario#</cfif>" />
	<input type="hidden" name="filtro_Mnombre" 		  value="<cfif isdefined('form.filtro_Mnombre') and len(trim(form.filtro_Mnombre)) and form.filtro_Mnombre neq -1 >#form.filtro_Mnombre#<cfelse>-1</cfif>" />

	<input type="hidden" name="hfiltro_CPTdescripcion"value="<cfif isdefined('form.hfiltro_CPTdescripcion') and len(trim(form.hfiltro_CPTdescripcion)) >#form.hfiltro_CPTdescripcion#</cfif>" />
	<input type="hidden" name="hfiltro_Ddocumento" 	  value="<cfif isdefined('form.hfiltro_Ddocumento') and len(trim(form.hfiltro_Ddocumento)) >#form.hfiltro_Ddocumento#</cfif>" />
	<input type="hidden" name="hfiltro_EAfecha" 	  value="<cfif isdefined('form.hfiltro_EAfecha') and len(trim(form.hfiltro_EAfecha)) >#form.hfiltro_EAfecha#</cfif>" />
	<input type="hidden" name="hfiltro_EAusuario" 	  value="<cfif isdefined('form.hfiltro_EAusuario') and len(trim(form.hfiltro_EAusuario)) >#form.hfiltro_EAusuario#</cfif>" />
	<input type="hidden" name="hfiltro_Mnombre" 	  value="<cfif isdefined('form.hfiltro_Mnombre') and len(trim(form.hfiltro_Mnombre)) and form.hfiltro_Mnombre neq -1 >#form.hfiltro_Mnombre#<cfelse>-1</cfif>" />
	</cfoutput>
</form>
</cfoutput>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>
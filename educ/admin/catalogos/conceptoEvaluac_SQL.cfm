<cfset modo = "ALTA">

<cfif isdefined("Form.btnNuevo")>
	<cfset MODO = "ALTA">
<cfelseif isdefined("Form._ActionTag") and Len(Trim(Form._ActionTag)) NEQ 0>
	<cfset modo = "LISTA">
	<cfif isdefined("Form._Rows") and Len(Trim(Form._Rows)) NEQ 0 
	  and isdefined("Form.CEcodigo") and Len(Trim(Form.CEcodigo)) NEQ 0>

		<!--- Obtener todas las llaves --->
		<cfset listaValores = "">
		<cfloop index="i" from="1" to="#Form._Rows#">
			<cfset listaValores = listaValores & "," & Evaluate('Form.CEcodigo_'&i)>
		</cfloop>
		<cfif Len(Trim(listaValores)) NEQ 0>
			<cfset listaValores = Mid(listaValores, 2, Len(listaValores))>
		</cfif>
		
		<!--- Si la acción es bajar --->
		<cfif Form._ActionTag EQ "pushDown">
			<cfset pos = ListFind(listaValores, Form.CEcodigo, ',')>	<!--- posicion del item a bajar --->
			<cfif pos NEQ 0 and (pos+1) LE Val(Form._Rows)>
				<cfset swap_CEcodigo = ListGetAt(listaValores, (pos+1), ',')>	<!--- codigo del item a cambiar por el que baja --->
			</cfif>
		<!--- Si la acción es subir --->
		<cfelseif Form._ActionTag EQ "pushUp">
			<cfset pos = ListFind(listaValores, Form.CEcodigo, ',')>	<!--- posicion del item a subir --->
			<cfif pos NEQ 0 and (pos-1) GT 0>
				<cfset swap_CEcodigo = ListGetAt(listaValores, (pos-1), ',')>	<!--- codigo del item a cambiar por el que baja --->
			</cfif>
		</cfif>
		<cfif isdefined("swap_CEcodigo")>
			<cfquery name="updOrden" datasource="#Session.DSN#">
				declare @o1 smallint, @o2 smallint
				select @o1 = CEorden
				from ConceptoEvaluacion
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEcodigo#">
			
				select @o2 = CEorden
				from ConceptoEvaluacion
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#swap_CEcodigo#">
			
				update ConceptoEvaluacion set CEorden = @o2
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEcodigo#">
			
				update ConceptoEvaluacion set CEorden = @o1
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#swap_CEcodigo#">
			</cfquery>
		</cfif>
	</cfif>

<cfelse>
	<cfif isdefined('form.CEorden') and form.CEorden NEQ ''>
		<cfset varCEorden = form.CEorden>
	<cfelse>
		<cfquery name="qryCEorden" datasource="#Session.DSN#">
			select (max(CEorden) + 5) as CEorden
			from ConceptoEvaluacion		
			where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfif isdefined('qryCEorden') and qryCEorden.recordCount GT 0 and qryCEorden.CEorden GT 0>
			<cfset varCEorden = qryCEorden.CEorden>
		<cfelse>
			<cfset varCEorden = 1>	
		</cfif>
	</cfif>
	
	<cfif not isdefined("Form.Nuevo")>
		<cftry>
			<cfquery name="ABC_conceptoEvaluac" datasource="#Session.DSN#">
				set nocount on
					<cfif isdefined("Form.Alta")>
						insert ConceptoEvaluacion 
						(Ecodigo, CEnombre, CEdescripcion, CEorden, CEorigen)
						values (
						<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
						, <cfqueryparam value="#form.CEnombre#" cfsqltype="cf_sql_varchar">
						, <cfqueryparam value="#form.CEdescripcion#" cfsqltype="cf_sql_varchar">
						, <cfqueryparam value="#varCEorden#" cfsqltype="cf_sql_smallint">
						, <cfif session.monitoreo.SMcodigo EQ "CAPACITA">1<cfelseif session.monitoreo.SMcodigo EQ "RECLUTA">2<cfelse>0</cfif>
						)			
						
						<cfset modo="ALTA">
					<cfelseif isdefined("Form.Baja")>
						delete ConceptoEvaluacion
						where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
						  and CEcodigo = <cfqueryparam value="#Form.CEcodigo#"   cfsqltype="cf_sql_numeric">
						   and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
						   
						<cfset modo="LISTA">
					<cfelseif isdefined("Form.Cambio")>
						update ConceptoEvaluacion set
							CEnombre = <cfqueryparam value="#Form.CEnombre#" cfsqltype="cf_sql_varchar">,
							CEdescripcion = <cfqueryparam value="#Form.CEdescripcion#" cfsqltype="cf_sql_varchar">
						where Ecodigo   = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
						  and CEcodigo  = <cfqueryparam value="#Form.CEcodigo#" cfsqltype="cf_sql_numeric">
						  and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
						  
						<cfset modo="LISTA">
					</cfif>
				set nocount off
			</cfquery>
		<cfcatch type="any">
			<cfinclude template="/educ/errorPages/BDerror.cfm">
			<cfabort>
		</cfcatch>
		</cftry>
	</cfif>
</cfif>

<form action="conceptoEvaluac.cfm" method="post" name="sql">
<cfoutput>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="CEcodigo" type="hidden" value="<cfif isdefined("Form.CEcodigo") and modo NEQ 'ALTA'>#Form.CEcodigo#</cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	
</cfoutput>	
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
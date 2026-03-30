<cfset modo = "ALTA">
<cfset modoD = "ALTA">
<cfset action = "planEvaluac.cfm">

<cfif isdefined("Form._ActionTag") and Len(Trim(Form._ActionTag)) NEQ 0>
	<cfif isdefined("Form._Rows") and Len(Trim(Form._Rows)) NEQ 0 
	  and isdefined("Form.CEcodigo") and Len(Trim(Form.CEcodigo)) NEQ 0
	  and isdefined("Form.PEVcodigo") and Len(Trim(Form.PEVcodigo)) NEQ 0>

		<!--- Obtener todas las llaves --->
		<cfset listaValores1 = "">
		<cfset listaValores2 = "">
		<cfloop index="i" from="1" to="#Form._Rows#">
			<cfset listaValores1 = listaValores1 & "," & Evaluate('Form.CEcodigo_'&i)>
			<cfset listaValores2 = listaValores2 & "," & Evaluate('Form.PEVcodigo_'&i)>
		</cfloop>
		<cfif Len(Trim(listaValores1)) NEQ 0>
			<cfset listaValores1 = Mid(listaValores1, 2, Len(listaValores1))>
			<cfset listaValores2 = Mid(listaValores2, 2, Len(listaValores2))>
		</cfif>
		
		<!--- Si la acción es bajar --->
		<cfif Form._ActionTag EQ "pushDown">
			<cfset encontrado = false>
			<cfset pos = 1>
			<cfloop condition="not encontrado and pos LE Val(Form._Rows)">
				<cfif Trim(ListGetAt(listaValores1, pos, ',')) EQ Form.CEcodigo>
					<cfset encontrado = true>	<!--- pos contiene la posicion del item a bajar --->
					<cfbreak>
				</cfif>
				<cfset pos = pos + 1>
			</cfloop>
			
			<cfif pos NEQ 0 and (pos+1) LE Val(Form._Rows)>
				<cfset swap_CEcodigo = ListGetAt(listaValores1, (pos+1), ',')>	<!--- codigo del item a cambiar por el que baja --->
				<cfset swap_PEVcodigo = ListGetAt(listaValores2, (pos+1), ',')>	<!--- codigo del item a cambiar por el que baja --->
			</cfif>
		<!--- Si la acción es subir --->
		<cfelseif Form._ActionTag EQ "pushUp">
			<cfset encontrado = false>
			<cfset pos = 1>
			<cfloop condition="not encontrado and pos LE Val(Form._Rows)">
				<cfif Trim(ListGetAt(listaValores1, pos, ',')) EQ Form.CEcodigo>
					<cfset encontrado = true>	<!--- pos contiene la posicion del item a bajar --->
					<cfbreak>
				</cfif>
				<cfset pos = pos + 1>
			</cfloop>
			
			<cfif pos NEQ 0 and (pos-1) GT 0>
				<cfset swap_CEcodigo = ListGetAt(listaValores1, (pos-1), ',')>	<!--- codigo del item a cambiar por el que baja --->
				<cfset swap_PEVcodigo = ListGetAt(listaValores2, (pos-1), ',')>	<!--- codigo del item a cambiar por el que baja --->
			</cfif>
		</cfif>
		<cfif isdefined("swap_CEcodigo") and isdefined("swap_PEVcodigo")>
			<cfquery name="updOrden" datasource="#Session.DSN#">
				declare @o1 smallint, @o2 smallint
				select @o1 = PECorden
				from PlanEvaluacionConcepto
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEcodigo#">
				and PEVcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#swap_PEVcodigo#">
			
				select @o2 = PECorden
				from PlanEvaluacionConcepto
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#swap_CEcodigo#">
				and PEVcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#swap_PEVcodigo#">
			
				update PlanEvaluacionConcepto set PECorden = @o2
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEcodigo#">
				and PEVcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#swap_PEVcodigo#">
			
				update PlanEvaluacionConcepto set PECorden = @o1
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#swap_CEcodigo#">
				and PEVcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#swap_PEVcodigo#">
			</cfquery>
		</cfif>
	</cfif>
	<cfset modo = "CAMBIO">

<cfelse>
	<cfif isdefined('form.AltaD') or isdefined('form.CambioD')>
		<cfif isdefined('form.PECorden') and form.PECorden NEQ ''>
			<cfset varPECorden = form.PECorden>
		<cfelse>
			<cfquery name="qryPECorden" datasource="#Session.DSN#">
				select (max(PECorden) + 1) as PECorden
				from PlanEvaluacionConcepto		
				where PEVcodigo=<cfqueryparam value="#form.PEVcodigo#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cfif isdefined('qryPECorden') and qryPECorden.recordCount GT 0 and qryPECorden.PECorden GT 0>
				<cfset varPECorden = qryPECorden.PECorden>
			<cfelse>
				<cfset varPECorden = 1>	
			</cfif>	
		</cfif>
	</cfif>
	
	<cfif not isdefined("Form.Nuevo") AND not isdefined("Form.NuevoD")>
		<cftry>
			<cfquery name="ABC_planEvaluac" datasource="#Session.DSN#">
				set nocount on
					<cfif isdefined("Form.Alta")>
						insert PlanEvaluacion 
						(PEVnombre, Ecodigo)
						values (
							<cfqueryparam value="#form.PEVnombre#" cfsqltype="cf_sql_varchar">
							,<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
						)
						
						Select @@identity as nuevoPlan
					
						<cfset modo="CAMBIO">
					<cfelseif isdefined("Form.Baja")>
						delete PlanEvaluacionConcepto	
						where PEVcodigo = <cfqueryparam value="#Form.PEVcodigo#"   cfsqltype="cf_sql_numeric">
					
						delete PlanEvaluacion
						where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
						  and PEVcodigo = <cfqueryparam value="#Form.PEVcodigo#"   cfsqltype="cf_sql_numeric">
						   and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
						   
						<cfset modo="ALTA">
					<cfelseif isdefined("Form.Cambio")>
						update PlanEvaluacion set
							PEVnombre = <cfqueryparam value="#Form.PEVnombre#" cfsqltype="cf_sql_varchar">
						where Ecodigo   = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
						  and PEVcodigo  = <cfqueryparam value="#Form.PEVcodigo#" cfsqltype="cf_sql_numeric">
						  and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
						  
						<cfset modo="CAMBIO">
					<cfelseif isdefined("Form.AltaD")>
						insert PlanEvaluacionConcepto 
						(PEVcodigo, CEcodigo, PECporcentaje, PECorden)
						values (
							<cfqueryparam value="#form.PEVcodigo#" cfsqltype="cf_sql_numeric">
							, <cfqueryparam value="#form.CEcodigo#" cfsqltype="cf_sql_numeric">
							, <cfqueryparam value="#form.PECporcentaje#" cfsqltype="cf_sql_smallint">
							, <cfqueryparam value="#varPECorden#" cfsqltype="cf_sql_tinyint">
						)
					
						<cfset modoD="ALTA">
						<cfset modo="CAMBIO">
					<cfelseif isdefined("Form.BajaD")>
						delete PlanEvaluacionConcepto
						where CEcodigo  = <cfqueryparam value="#Form.CEcodigo#" cfsqltype="cf_sql_numeric">
						  and PEVcodigo = <cfqueryparam value="#Form.PEVcodigo#"   cfsqltype="cf_sql_numeric">
						   and ts_rversion = convert(varbinary,#lcase(Form.timestampD)#)
						   
						<cfset modoD="ALTA">
						<cfset modo="CAMBIO">					
					<cfelseif isdefined("Form.CambioD")>
						update PlanEvaluacionConcepto set
							PECporcentaje = <cfqueryparam value="#Form.PECporcentaje#" cfsqltype="cf_sql_smallint">
						where CEcodigo   = <cfqueryparam value="#Form.CEcodigo#" cfsqltype="cf_sql_numeric">
						  and PEVcodigo  = <cfqueryparam value="#Form.PEVcodigo#" cfsqltype="cf_sql_numeric">
						  and ts_rversion = convert(varbinary,#lcase(Form.timestampD)#)
						  
						<cfset modoD="CAMBIO">					
						<cfset modo="CAMBIO">					
					</cfif>
				set nocount off
			</cfquery>
		<cfcatch type="any">
			<cfinclude template="/educ/errorPages/BDerror.cfm">
			<cfabort>
		</cfcatch>
		</cftry>
	<cfelseif isdefined("Form.NuevoD")>
		<cfset modo = "CAMBIO">
		<cfset modoD = "ALTA">	
	</cfif>
</cfif>

<cfif modo EQ 'CAMBIO'>
	<cfif isdefined("Form.Alta") and isdefined('ABC_planEvaluac') and ABC_planEvaluac.recordCount GT 0>
		<cfset varPEVcodigo=ABC_planEvaluac.nuevoPlan>
	<cfelse>
		<cfset varPEVcodigo=form.PEVcodigo>		
	</cfif>
</cfif>

<cfoutput>
	<form action="#action#" method="post" name="sql">
		<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<cfif isdefined("modoD") and modoD EQ 'CAMBIO'>
			<input name="modoD" type="hidden" value="<cfif isdefined("modoD")>#modoD#</cfif>">
			<input name="CEcodigo" type="hidden" value="<cfif isdefined("form.CEcodigo")>#form.CEcodigo#</cfif>">
		</cfif>
		<input name="PEVcodigo" type="hidden" value="<cfif isdefined("varPEVcodigo") and modo NEQ 'ALTA'>#varPEVcodigo#</cfif>">
		<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	
	</form>
</cfoutput>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
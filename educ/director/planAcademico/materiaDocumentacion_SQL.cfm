<!---  
<cfdump var="#form#">

	<!--- Obtener todas las llaves --->
	<cfset listaValores = "">
	<cfloop index="i" from="1" to="#Form._Rows#">
		<cfset listaValores = listaValores & "," & Evaluate('Form.MDOcodigo_'&i)>
	</cfloop>
	<cfif Len(Trim(listaValores)) NEQ 0>
		<cfset listaValores = Mid(listaValores, 2, Len(listaValores))>
	</cfif>

<cfdump var="#listaValores#">


	<!--- Si la acción es bajar --->
	<cfif Form._ActionTag EQ "pushDown">
		<cfset pos = ListFind(listaValores, Form.MDOcodigo, ',')>	<!--- posicion del item a bajar --->
		<cfif pos NEQ 0 and (pos+1) LE Val(Form._Rows)>
			<cfset swap_MDOcodigo = ListGetAt(listaValores, (pos+1), ',')>	<!--- codigo del item a cambiar por el que baja --->
		</cfif>
	</cfif>
<br>
pos -- <cfdump var="#pos#">
<br>
swap_MDOcodigo -- <cfdump var="#swap_MDOcodigo#">
 
<cfabort>
--->
<cfset modoDocumentacion = "ALTA">

<cfif isdefined("Form._ActionTag") and Len(Trim(Form._ActionTag)) NEQ 0 
		and isdefined("Form._Rows") and Len(Trim(Form._Rows)) NEQ 0 
	  	and isdefined("Form.MDOcodigo") and Len(Trim(Form.MDOcodigo)) NEQ 0>
	  
	<cfif Form._ActionTag EQ "borrarDocumentacion">
		<cfquery name="updOrden" datasource="#Session.DSN#">
			delete MateriaDocumentacion
			where MDOcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MDOcodigo#">
		</cfquery>	
	<cfelse>
		<!--- Obtener todas las llaves --->
		<cfset listaValores = "">
		<cfloop index="i" from="1" to="#Form._Rows#">
			<cfset listaValores = listaValores & "," & Evaluate('Form.MDOcodigo_'&i)>
		</cfloop>
		<cfif Len(Trim(listaValores)) NEQ 0>
			<cfset listaValores = Mid(listaValores, 2, Len(listaValores))>
		</cfif>
		
		<!--- Si la acción es bajar --->
		<cfif Form._ActionTag EQ "pushDown">
			<cfset pos = ListFind(listaValores, Form.MDOcodigo, ',')>	<!--- posicion del item a bajar --->
			<cfif pos NEQ 0 and (pos+1) LE Val(Form._Rows)>
				<cfset swap_MDOcodigo = ListGetAt(listaValores, (pos+1), ',')>	<!--- codigo del item a cambiar por el que baja --->
			</cfif>
		<!--- Si la acción es subir --->
		<cfelseif Form._ActionTag EQ "pushUp">
			<cfset pos = ListFind(listaValores, Form.MDOcodigo, ',')>	<!--- posicion del item a subir --->
			<cfif pos NEQ 0 and (pos-1) GT 0>
				<cfset swap_MDOcodigo = ListGetAt(listaValores, (pos-1), ',')>	<!--- codigo del item a cambiar por el que baja --->
			</cfif>		
		</cfif>			
	
		<cfif isdefined("swap_MDOcodigo")>
			<cfquery name="updOrden" datasource="#Session.DSN#">
				declare @o1 smallint, @o2 smallint
				select @o1 = MDOsecuencia
				from MateriaDocumentacion
				where MDOcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MDOcodigo#">
			
				select @o2 = MDOsecuencia
				from MateriaDocumentacion
				where MDOcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#swap_MDOcodigo#">
			
				update MateriaDocumentacion set MDOsecuencia = @o2
				where MDOcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MDOcodigo#">
			
				update MateriaDocumentacion set MDOsecuencia = @o1
				where MDOcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#swap_MDOcodigo#">
			</cfquery>
		</cfif>
	</cfif>	  
	<cfset modoDocumentacion = "LISTA">
<cfelse>
	<cfif isdefined("form.Alta")>
		<cfquery name="rsMatDocumentacion" datasource="#session.DSN#">
			select (max(isnull(MDOsecuencia,0)) +1) as MDOsecuencia
			from MateriaDocumentacion
			where Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">
		</cfquery>
		<cfif isdefined('rsMatDocumentacion') and rsMatDocumentacion.recordCount GT 0 and rsMatDocumentacion.MDOsecuencia NEQ ''>
			<cfset varMDOsecuencia = rsMatDocumentacion.MDOsecuencia>
		<cfelse>
			<cfset varMDOsecuencia = 1>	
		</cfif>	
	</cfif>
		
	<cfif not isdefined("form.Nuevo")>
		<cftry>	
			<cfquery name="abc_planestudio" datasource="#session.DSN#">
				set nocount on
				<cfif isdefined("form.Alta")>				
					insert MateriaDocumentacion 
					(Mcodigo, MDOsecuencia, MDOtitulo, MDOdescripcion)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#varMDOsecuencia#">
						, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.MDOtitulo#">
						, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.MDOdescripcion#">)
					declare @newDocumentacion numeric
					select @newDocumentacion = @@identity
					select @newDocumentacion as newDocumentacion
					
					<cfset modoDocumentacion = "CAMBIO">
				<cfelseif isdefined("form.Cambio")>
					update MateriaDocumentacion	set 
						MDOtitulo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.MDOtitulo#">,
						MDOdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.MDOdescripcion#">
					where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">
						and MDOcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MDOcodigo#">
						and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)			  
	
					<cfset modoDocumentacion = "CAMBIO">
				<cfelseif isdefined("form.Baja")>
					delete MateriaDocumentacion 
					where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">
						and MDOcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MDOcodigo#">
						
					<cfset modoDocumentacion = "LISTA">						
				</cfif>
				set nocount off
			</cfquery>
			<cfcatch type="any">
				<cfinclude template="/educ/errorpages/BDerror.cfm">		
				<cfabort>
			</cfcatch>
		</cftry>	
	</cfif>
</cfif>
<cfif isdefined('form.Alta') and isdefined('abc_planestudio') and abc_planestudio.recordCount GT 0>
	<cfset valMDOcodigo = abc_planestudio.newDocumentacion>
<cfelse>
	<cfset valMDOcodigo = form.MDOcodigo>	
</cfif>

<cfif isdefined('form.PEScodigo') and form.PEScodigo NEQ ''>
	<cfset fAction = "CarrerasPlanes.cfm">
	<cfset modo = "MPcambio">
<cfelse>
	<cfset fAction = "materia.cfm">	
</cfif>	

<cfoutput>
<form action="<cfoutput>#fAction#</cfoutput>" method="post" name="sql">
		<!--- Parametros del mantenimiento de Materia Plan --->
		<cfif isdefined('form.CILcodigo') and form.CILcodigo NEQ ''>
			<input name="CILcodigo" type="hidden" value="#form.CILcodigo#">
		</cfif>
		<cfif isdefined('form.CARcodigo') and form.CARcodigo NEQ ''>
			<input name="CARcodigo" type="hidden" value="#form.CARcodigo#">
		</cfif>
		<cfif isdefined('form.MPcodigo') and form.CARcodigo NEQ ''>
			<input name="MPcodigo" type="hidden" value="#form.MPcodigo#">
		</cfif>			
		<cfif isdefined('form.PEScodigo') and form.PEScodigo NEQ ''>
			<input name="PEScodigo" type="hidden" value="#form.PEScodigo#">
			<input type="hidden" name="modoPES" value="MPcambio">
		</cfif>
		<cfif isdefined('form.EScodigo') and form.EScodigo NEQ ''>
			<input name="EScodigo" type="hidden" value="#form.EScodigo#">
		</cfif>		
		<cfif isdefined('form.PBLsecuencia') and form.PBLsecuencia NEQ ''>
			<input name="PBLsecuencia" type="hidden" value="#form.PBLsecuencia#">
		</cfif>
		<input name="TabsPlan" id="TabsPlan" type="hidden" value="3">
		 <!--- ********************************* --->
	<input type="hidden" name="modoDocumentacion" value="#modoDocumentacion#">
	<input type="hidden" name="modo" value="CAMBIO">	
	<input type="hidden" name="Mcodigo" value="#form.Mcodigo#">	
	<input type="hidden" name="nivel" value="<cfif isdefined("form.nivel") and form.nivel NEQ 'ALTA'>#form.nivel#</cfif>">
	<input type="hidden" name="tabsMateria" value="<cfif isdefined("form.tabsMateria") and form.tabsMateria NEQ 'ALTA'>#form.tabsMateria#</cfif>">
	<cfif isdefined("Form._ActionTag") and Len(Trim(Form._ActionTag)) NEQ 0>
		<cfif isdefined("Form.T_1") and Len(Trim(Form.T_1)) NEQ 0>
			<input type="hidden" name="T" value="#Form.T_1#">			
		</cfif>
	<cfelse>
		<cfif isdefined("Form.T") and Len(Trim(Form.T)) NEQ 0>
			<input type="hidden" name="T" value="#Form.T#">
		</cfif>
	</cfif>
	<input name="MDOcodigo" type="hidden" value="#valMDOcodigo#">	
	<input name="Pagina" type="hidden" value="<cfif isdefined("form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


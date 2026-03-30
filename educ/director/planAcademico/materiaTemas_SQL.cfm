<!---  
<cfdump var="#form#">

	<!--- Obtener todas las llaves --->
	<cfset listaValores = "">
	<cfloop index="i" from="1" to="#Form._Rows#">
		<cfset listaValores = listaValores & "," & Evaluate('Form.MTEcodigo_'&i)>
	</cfloop>
	<cfif Len(Trim(listaValores)) NEQ 0>
		<cfset listaValores = Mid(listaValores, 2, Len(listaValores))>
	</cfif>

<cfdump var="#listaValores#">


	<!--- Si la acción es bajar --->
	<cfif Form._ActionTag EQ "pushDown">
		<cfset pos = ListFind(listaValores, Form.MTEcodigo, ',')>	<!--- posicion del item a bajar --->
		<cfif pos NEQ 0 and (pos+1) LE Val(Form._Rows)>
			<cfset swap_MTEcodigo = ListGetAt(listaValores, (pos+1), ',')>	<!--- codigo del item a cambiar por el que baja --->
		</cfif>
	</cfif>
<br>
pos -- <cfdump var="#pos#">
<br>
swap_MTEcodigo -- <cfdump var="#swap_MTEcodigo#">
 
<cfabort>
--->
<cfset modoTemas = "ALTA">

<cfif isdefined("Form._ActionTag") and Len(Trim(Form._ActionTag)) NEQ 0 
		and isdefined("Form._Rows") and Len(Trim(Form._Rows)) NEQ 0 
	  	and isdefined("Form.MTEcodigo") and Len(Trim(Form.MTEcodigo)) NEQ 0>
	  
	<cfif Form._ActionTag EQ "borrarTema">
		<cfquery name="updOrden" datasource="#Session.DSN#">
			delete MateriaTema
			where MTEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MTEcodigo#">
		</cfquery>	
	<cfelse>
		<!--- Obtener todas las llaves --->
		<cfset listaValores = "">
		<cfloop index="i" from="1" to="#Form._Rows#">
			<cfset listaValores = listaValores & "," & Evaluate('Form.MTEcodigo_'&i)>
		</cfloop>
		<cfif Len(Trim(listaValores)) NEQ 0>
			<cfset listaValores = Mid(listaValores, 2, Len(listaValores))>
		</cfif>
		
		<!--- Si la acción es bajar --->
		<cfif Form._ActionTag EQ "pushDown">
			<cfset pos = ListFind(listaValores, Form.MTEcodigo, ',')>	<!--- posicion del item a bajar --->
			<cfif pos NEQ 0 and (pos+1) LE Val(Form._Rows)>
				<cfset swap_MTEcodigo = ListGetAt(listaValores, (pos+1), ',')>	<!--- codigo del item a cambiar por el que baja --->
			</cfif>
		<!--- Si la acción es subir --->
		<cfelseif Form._ActionTag EQ "pushUp">
			<cfset pos = ListFind(listaValores, Form.MTEcodigo, ',')>	<!--- posicion del item a subir --->
			<cfif pos NEQ 0 and (pos-1) GT 0>
				<cfset swap_MTEcodigo = ListGetAt(listaValores, (pos-1), ',')>	<!--- codigo del item a cambiar por el que baja --->
			</cfif>		
		</cfif>			
	
		<cfif isdefined("swap_MTEcodigo")>
			<cfquery name="updOrden" datasource="#Session.DSN#">
				declare @o1 smallint, @o2 smallint
				select @o1 = MTEsecuencia
				from MateriaTema
				where MTEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MTEcodigo#">
			
				select @o2 = MTEsecuencia
				from MateriaTema
				where MTEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#swap_MTEcodigo#">
			
				update MateriaTema set MTEsecuencia = @o2
				where MTEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MTEcodigo#">
			
				update MateriaTema set MTEsecuencia = @o1
				where MTEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#swap_MTEcodigo#">
			</cfquery>
		</cfif>
	</cfif>	  
	<cfset modoTemas = "LISTA">
<cfelse>
	<cfif isdefined("form.Alta")>
		<cfquery name="rsMatTema" datasource="#session.DSN#">
			select (max(isnull(MTEsecuencia,0)) +1) as MTEsecuencia
			from MateriaTema
			where Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">
		</cfquery>
		<cfif isdefined('rsMatTema') and rsMatTema.recordCount GT 0 and rsMatTema.MTEsecuencia NEQ ''>
			<cfset varMTEsecuencia = rsMatTema.MTEsecuencia>
		<cfelse>
			<cfset varMTEsecuencia = 1>	
		</cfif>	
	</cfif>
		
	<cfif not isdefined("form.Nuevo")>
		<cftry>	
			<cfquery name="abc_planestudio" datasource="#session.DSN#">
				set nocount on
				<cfif isdefined("form.Alta")>				
					insert MateriaTema 
					(Mcodigo, MTEsecuencia, MTEtema, MTEdescripcion)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#varMTEsecuencia#">
						, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.MTEtema#">
						, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.MTEdescripcion#">)
					declare @newTema numeric
					select @newTema = @@identity
					select @newTema as newTema
					
					<cfset modoTemas = "CAMBIO">
				<cfelseif isdefined("form.Cambio")>
					update MateriaTema	set 
						MTEtema = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.MTEtema#">,
						MTEdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.MTEdescripcion#">
					where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">
						and MTEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MTEcodigo#">
						and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)			  
	
					<cfset modoTemas = "CAMBIO">
				<cfelseif isdefined("form.Baja")>
					delete MateriaTema 
					where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">
						and MTEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MTEcodigo#">
						
					<cfset modoTemas = "LISTA">						
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
	<cfset valMTEcodigo = abc_planestudio.newTema>
<cfelse>
	<cfset valMTEcodigo = form.MTEcodigo>	
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
		 <!--- ********************************* --->
	<input type="hidden" name="modoTemas" value="#modoTemas#">
	<input type="hidden" name="modo" value="CAMBIO">	
	<input type="hidden" name="Mcodigo" value="#form.Mcodigo#">	
	<input type="hidden" name="nivel" value="<cfif isdefined("form.nivel") and form.nivel NEQ 'ALTA'>#form.nivel#</cfif>">
	<input type="hidden" name="TabsPlan" id="TabsPlan" value="3">
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
	<input name="MTEcodigo" type="hidden" value="#valMTEcodigo#">	
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


<cfset modo = "ALTA">
<cfif isdefined("Form._ActionTag") and Len(Trim(Form._ActionTag)) NEQ 0>
	<cfif isdefined("Form._Rows") and Len(Trim(Form._Rows)) NEQ 0 
	  and isdefined("Form.Scodigo") and Len(Trim(Form.Scodigo)) NEQ 0>

		<!--- Obtener todas las llaves --->
		<cfset listaValores = "">
		<cfloop index="i" from="1" to="#Form._Rows#">
			<cfset listaValores = listaValores & "," & Evaluate('Form.Scodigo_'&i)>
		</cfloop>
		<cfif Len(Trim(listaValores)) NEQ 0>
			<cfset listaValores = Mid(listaValores, 2, Len(listaValores))>
		</cfif>
		
		<!--- Si la acción es bajar --->
		<cfif Form._ActionTag EQ "pushDown">
			<cfset pos = ListFind(listaValores, Form.Scodigo, ',')>	<!--- posicion del item a bajar --->
			<cfif pos NEQ 0 and (pos+1) LE Val(Form._Rows)>
				<cfset swap_Scodigo = ListGetAt(listaValores, (pos+1), ',')>	<!--- codigo del item a cambiar por el que baja --->
			</cfif>
		<!--- Si la acción es subir --->
		<cfelseif Form._ActionTag EQ "pushUp">
			<cfset pos = ListFind(listaValores, Form.Scodigo, ',')>	<!--- posicion del item a subir --->
			<cfif pos NEQ 0 and (pos-1) GT 0>
				<cfset swap_Scodigo = ListGetAt(listaValores, (pos-1), ',')>	<!--- codigo del item a cambiar por el que baja --->
			</cfif>
		</cfif>
		<cfif isdefined("swap_Scodigo")>
			<cfquery name="updOrden" datasource="#Session.DSN#">
				declare @o1 smallint, @o2 smallint
				select @o1 = Sorden
				from Sede
				where Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Scodigo#">
			
				select @o2 = Sorden
				from Sede
				where Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#swap_Scodigo#">
			
				update Sede set Sorden = @o2
				where Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Scodigo#">
			
				update Sede set Sorden = @o1
				where Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#swap_Scodigo#">
			</cfquery>
			
			<cfset modo="LISTA">
		</cfif>
	</cfif>

<cfelse>
	<cfif isdefined('form.Sorden') and form.Sorden NEQ ''>
		<cfset varSorden = Form.Sorden>
	<cfelse>
		<cfquery name="qrySorden" datasource="#Session.DSN#">
			select (max(Sorden) + 1) as Sorden
			from Sede
			where Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">		
		</cfquery>
		<cfif isdefined('qrySorden') and qrySorden.recordCount GT 0 and qrySorden.Sorden GT 0>
			<cfset varSorden = qrySorden.Sorden>
		<cfelse>
			<cfset varSorden = 1>	
		</cfif>	
	</cfif>
	
	<cfif not isdefined("Form.Nuevo")>
		<cftry>
			<cfquery name="ABC_sede" datasource="#Session.DSN#">
				set nocount on
					<cfif isdefined("Form.Alta")>
						insert Sede 
						(Ecodigo, Snombre, Scodificacion, Sorden, Sprefijo)
						values (
						<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
						, <cfqueryparam value="#form.Snombre#" cfsqltype="cf_sql_varchar">
						, <cfqueryparam value="#form.Scodificacion#" cfsqltype="cf_sql_varchar">
						, <cfqueryparam value="#varSorden#" cfsqltype="cf_sql_smallint">
						, <cfqueryparam value="#form.Sprefijo#" cfsqltype="cf_sql_char">)				
	
						<cfset modo="ALTA">
					<cfelseif isdefined("Form.Baja")>
						delete Sede
						where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
							and Scodigo = <cfqueryparam value="#Form.Scodigo#" cfsqltype="cf_sql_numeric">
							and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
						   
						<cfset modo="ALTA">
					<cfelseif isdefined("Form.Cambio")>
						update Sede set
							Snombre = <cfqueryparam value="#Form.Snombre#" cfsqltype="cf_sql_varchar">,
							Scodificacion= <cfqueryparam value="#form.Scodificacion#" cfsqltype="cf_sql_varchar">,
							Sprefijo =<cfqueryparam value="#form.Sprefijo#" cfsqltype="cf_sql_char">
						where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
							and Scodigo  = <cfqueryparam value="#Form.Scodigo#" cfsqltype="cf_sql_numeric">
						  and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
						  
						<cfset modo="CAMBIO">
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

<form action="sede.cfm" method="post" name="sql">
<cfoutput>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="Scodigo" type="hidden" value="<cfif isdefined("Form.Scodigo") and modo NEQ 'ALTA'>#Form.Scodigo#</cfif>">
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

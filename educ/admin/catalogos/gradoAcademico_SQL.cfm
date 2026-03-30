<cfset modo = "ALTA">

<cfif isdefined("Form._ActionTag") and Len(Trim(Form._ActionTag)) NEQ 0>
	<cfif isdefined("Form._Rows") and Len(Trim(Form._Rows)) NEQ 0 
	  and isdefined("Form.GAcodigo") and Len(Trim(Form.GAcodigo)) NEQ 0>

		<!--- Obtener todas las llaves --->
		<cfset listaValores = "">
		<cfloop index="i" from="1" to="#Form._Rows#">
			<cfset listaValores = listaValores & "," & Evaluate('Form.GAcodigo_'&i)>
		</cfloop>
		<cfif Len(Trim(listaValores)) NEQ 0>
			<cfset listaValores = Mid(listaValores, 2, Len(listaValores))>
		</cfif>
		
		<!--- Si la acción es bajar --->
		<cfif Form._ActionTag EQ "pushDown">
			<cfset pos = ListFind(listaValores, Form.GAcodigo, ',')>	<!--- posicion del item a bajar --->
			<cfif pos NEQ 0 and (pos+1) LE Val(Form._Rows)>
				<cfset swap_GAcodigo = ListGetAt(listaValores, (pos+1), ',')>	<!--- codigo del item a cambiar por el que baja --->
			</cfif>
		<!--- Si la acción es subir --->
		<cfelseif Form._ActionTag EQ "pushUp">
			<cfset pos = ListFind(listaValores, Form.GAcodigo, ',')>	<!--- posicion del item a subir --->
			<cfif pos NEQ 0 and (pos-1) GT 0>
				<cfset swap_GAcodigo = ListGetAt(listaValores, (pos-1), ',')>	<!--- codigo del item a cambiar por el que baja --->
			</cfif>
		</cfif>
		<cfif isdefined("swap_GAcodigo")>
			<cfquery name="updOrden" datasource="#Session.DSN#">
				declare @o1 smallint, @o2 smallint
				select @o1 = GAorden
				from GradoAcademico
				where GAcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.GAcodigo#">
			
				select @o2 = GAorden
				from GradoAcademico
				where GAcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#swap_GAcodigo#">
			
				update GradoAcademico set GAorden = @o2
				where GAcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.GAcodigo#">
			
				update GradoAcademico set GAorden = @o1
				where GAcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#swap_GAcodigo#">
			</cfquery>
		</cfif>
	</cfif>

<cfelse>
	<cfif isdefined('form.GAorden') and form.GAorden NEQ ''>
		<cfset varGAorden = form.GAorden>
	<cfelse>
		<cfquery name="qryGAorden" datasource="#Session.DSN#">
			select (max(GAorden) + 1) as GAorden
			from GradoAcademico		
		</cfquery>
		<cfif isdefined('qryGAorden') and qryGAorden.recordCount GT 0 and qryGAorden.GAorden GT 0>
			<cfset varGAorden = qryGAorden.GAorden>
		<cfelse>
			<cfset varGAorden = 1>	
		</cfif>	
	</cfif>
	
	<cfif not isdefined("Form.Nuevo")>
		<cftry>
			<cfquery name="ABC_gradoAcademico" datasource="#Session.DSN#">
				set nocount on
					<cfif isdefined("Form.modoMove") AND Form.modoMove EQ "up">
						declare @GAorden numeric
						select @GAorden = GAorden
						  from GradoAcademico 
						 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						   and GAcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GAcodigo#">
						declare @GAorden_Move numeric
						select @GAorden_Move = max(GAorden)
						  from GradoAcademico 
						 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						   and GAorden < @GAorden

						if @GAorden_Move is not null
						BEGIN
							update GradoAcademico
							   set GAorden = @GAorden
							 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
							   and GAorden = @GAorden_Move
							update GradoAcademico
							   set GAorden = @GAorden_Move
							 where GAcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GAcodigo#">
						END

						<cfset modo="LISTA">
					<cfelseif isdefined("Form.modoMove") AND Form.modoMove EQ "dw">
						declare @GAorden numeric
						select @GAorden = GAorden
						  from GradoAcademico 
						 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						   and GAcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GAcodigo#">
						declare @GAorden_Move numeric
						select @GAorden_Move = min(GAorden)
						  from GradoAcademico 
						 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						   and GAorden > @GAorden

						if @GAorden_Move is not null
						BEGIN
							update GradoAcademico
							   set GAorden = @GAorden
							 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
							   and GAorden = @GAorden_Move
							update GradoAcademico
							   set GAorden = @GAorden_Move
							 where GAcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GAcodigo#">
						END
						   
						<cfset modo="LISTA">
					<cfelseif isdefined("Form.Alta")>
						insert GradoAcademico (Ecodigo, GAnombre, GAorden)
						values (
							<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
							, <cfqueryparam value="#form.GAnombre#" cfsqltype="cf_sql_varchar">
							, <cfqueryparam value="#varGAorden#" cfsqltype="cf_sql_smallint">)
						
						<cfset modo="ALTA">
					<cfelseif isdefined("Form.Baja")>
						delete GradoAcademico
						where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
							and GAcodigo = <cfqueryparam value="#Form.GAcodigo#" cfsqltype="cf_sql_numeric">
							and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
						   
						<cfset modo="ALTA">
					<cfelseif isdefined("Form.Cambio")>
						update GradoAcademico set
							GAnombre = <cfqueryparam value="#Form.GAnombre#" cfsqltype="cf_sql_varchar">
						where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
							and GAcodigo  = <cfqueryparam value="#Form.GAcodigo#" cfsqltype="cf_sql_numeric">
							and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
						  
						<cfset modo="CAMBIO">
					</cfif>
					update GradoAcademico
					   set GAorden = (
					   			select count(*) from GradoAcademico gaO
					   			 where right('0000'+convert(varchar,gaO.GAorden),4) + convert(varchar,gaO.GAcodigo) <= right('0000'+convert(varchar,ga.GAorden),4) + convert(varchar,ga.GAcodigo)
								 	)
					 from GradoAcademico ga
				set nocount off
			</cfquery>
		<cfcatch type="any">
			<cfinclude template="/educ/errorPages/BDerror.cfm">
			<cfabort>
		</cfcatch>
		</cftry>
	</cfif>
</cfif>

<form action="gradoAcademico.cfm" method="post" name="sql">
<cfoutput>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="GAcodigo" type="hidden" value="<cfif isdefined("Form.GAcodigo") and modo NEQ 'ALTA'>#Form.GAcodigo#</cfif>">
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
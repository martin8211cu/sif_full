
<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfquery name="ABC_Grado" datasource="#Session.DSN#">
			<cfif isdefined("Form.Alta")>
				if not exists ( select 1 from Grado a, Nivel b
					where a.Ncodigo = <cfqueryparam value="#Form.Ncodigo#" cfsqltype="cf_sql_numeric">
					  and b.CEcodigo = <cfqueryparam value="#Session.CEcodigo#" cfsqltype="cf_sql_integer">
					  and rtrim(ltrim(a.Gdescripcion)) = <cfqueryparam value="#Form.Gdescripcion#" cfsqltype="cf_sql_varchar">
					  and a.Ncodigo = b.Ncodigo
				)
				begin
					declare @cont int
					select @cont = isnull(max(a.Gorden),0)+10 
					from Grado a, Nivel b
					where a.Ncodigo = <cfqueryparam value="#Form.Ncodigo#" cfsqltype="cf_sql_numeric">
					  and b.CEcodigo = <cfqueryparam value="#Session.CEcodigo#" cfsqltype="cf_sql_integer">
					  and a.Ncodigo = b.Ncodigo
				
					insert into Grado ( Ncodigo, Gdescripcion, Gorden )
					values
						(
							<cfqueryparam value="#Form.Ncodigo#" cfsqltype="cf_sql_numeric">,
							<cfqueryparam value="#Form.Gdescripcion#" cfsqltype="cf_sql_varchar">,
							<!--- <cfqueryparam value="#Form.Ganual#" cfsqltype="cf_sql_smallint">, --->
							<cfif len(trim(#Form.Gorden#)) NEQ 0 >
								<cfqueryparam value="#Form.Gorden#" cfsqltype="cf_sql_smallint">
							<cfelse>
								@cont	
							</cfif>
						)
				end
				else 
					select 1
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Baja")>
				delete from Grado
				where Gcodigo = <cfqueryparam value="#Form.Gcodigo#" cfsqltype="cf_sql_numeric">
				  and Ncodigo = <cfqueryparam value="#Form.Ncodigo#" cfsqltype="cf_sql_numeric">
				  <cfset modo="BAJA">
			<cfelseif isdefined("Form.Cambio")>
				declare @cont int
				select @cont = isnull(max(a.Gorden),0)+10 
				from Grado a, Nivel b
				where a.Ncodigo = <cfqueryparam value="#Form.Ncodigo#" cfsqltype="cf_sql_numeric">
				  and b.CEcodigo = <cfqueryparam value="#Session.CEcodigo#" cfsqltype="cf_sql_integer">
				  <!--- and a.Gcodigo  = <cfqueryparam value="#Form.Gcodigo#" cfsqltype="cf_sql_numeric"> --->
				  and a.Ncodigo = b.Ncodigo

				if not exists ( select 1 from Grado a, Nivel b, Grupo c
						where a.Ncodigo = <cfqueryparam value="#Form._Ncodigo#" cfsqltype="cf_sql_numeric">
						  and b.CEcodigo =  <cfqueryparam value="#Session.CEcodigo#" cfsqltype="cf_sql_integer">
						  and c.Gcodigo  = <cfqueryparam value="#Form.Gcodigo#" cfsqltype="cf_sql_numeric">
						  and a.Ncodigo = b.Ncodigo
						  and b.Ncodigo = c.Ncodigo
						  and a.Gcodigo = c.Gcodigo
					)
				 begin
					update Grado set
						Gdescripcion = <cfqueryparam value="#Form.Gdescripcion#" cfsqltype="cf_sql_varchar">,
						Ganual = <cfqueryparam value="#Form.Ganual#" cfsqltype="cf_sql_smallint">,
						Ncodigo = <cfqueryparam value="#Form.Ncodigo#" cfsqltype="cf_sql_numeric">,
						<cfif len(trim(#Form.Gorden#)) NEQ 0 >
							Gorden = <cfqueryparam value="#Form.Gorden#" cfsqltype="cf_sql_smallint">
						<cfelse>
							Gorden = @cont	
						</cfif>
					where Gcodigo = <cfqueryparam value="#Form.Gcodigo#" cfsqltype="cf_sql_numeric">
					  and Ncodigo = <cfqueryparam value="#Form._Ncodigo#" cfsqltype="cf_sql_numeric">
				 end
				 else
				 begin
					update Grado set
						Gdescripcion = <cfqueryparam value="#Form.Gdescripcion#" cfsqltype="cf_sql_varchar">,
						Ganual = <cfqueryparam value="#Form.Ganual#" cfsqltype="cf_sql_smallint">,
						<cfif len(trim(#Form.Gorden#)) NEQ 0 >
							Gorden = <cfqueryparam value="#Form.Gorden#" cfsqltype="cf_sql_smallint">
						<cfelse>
							Gorden = @cont	
						</cfif>
					where Gcodigo = <cfqueryparam value="#Form.Gcodigo#" cfsqltype="cf_sql_numeric">
					  and Ncodigo = <cfqueryparam value="#Form.Ncodigo#" cfsqltype="cf_sql_numeric">
				 end
					<cfset modo="CAMBIO">
			</cfif>
		</cfquery>
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>
<form action="Grado_filtro.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="Ncodigo" type="hidden" value="<cfif isdefined("Form.Ncodigo")><cfoutput>#Form.Ncodigo#</cfoutput></cfif>">
	<input name="Gcodigo" type="hidden" value="<cfif isdefined("Form.Gcodigo")><cfoutput>#Form.Gcodigo#</cfoutput></cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


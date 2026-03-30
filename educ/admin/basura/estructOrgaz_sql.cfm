<cfif not isdefined("Form.Nuevo") and not isDefined("Form.Filtrar")>
	<cftry>
		<cfif isdefined("Form.Alta")>
			<cfset existeOrganizacion = false>

			<!--- Averigua si ya existe una organización con el mismo código --->
			<cfquery name="rsExisteOrganizacion" datasource="#Session.DSN#">
				select count(1) as valor from EstructuraOrganizacional
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
				  and ESOcodificacion = <cfqueryparam value="#Trim(Form.ESOcodificacion)#" cfsqltype="cf_sql_varchar">
			</cfquery>
	
			<cfif rsExisteOrganizacion.valor GT 0> 
				<cfset existeOrganizacion = true> 
				<script>alert("Ya existe una organización con ese código");</script> 			
			</cfif>		

			<cfif not existeOrganizacion>
				<cfquery name="ABC_EstructuraOrganizacional" datasource="#Session.DSN#">
					insert EstructuraOrganizacional (Ecodigo, ETcodigo, ESOcodificacion, ESOnombre, EScodigoPadre, ESOultimoNivel, ESOprefijo)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETcodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESOcodificacion#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESOnombre#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EScodigoPadre#">,
					<cfif isdefined("Form.ESOultimoNivel") and Len(Trim(Form.ESOultimoNivel)) GT 0>
						<cfqueryparam cfsqltype="cf_sql_bit" value="1">,
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_bit" value="0">,
					</cfif>
					<cfif isdefined("Form.ESOultimoNivel") and Len(Trim(Form.ESOultimoNivel)) GT 0 and Len(Trim(Form.ESOprefijo)) GT 0>
						<cfqueryparam cfsqltype="cf_sql_char" value="#Form.ESOprefijo#">
					<cfelse>
						null
					</cfif>
					)
				</cfquery>
			</cfif>
			<cfset modo="ALTA">

		<cfelseif isdefined("Form.Baja")>
			<cfset tieneSubordinados = false>
			
			<!--- Verificar si tiene organizaciones dependientes --->
			<cfquery name="rsTieneSubordinados" datasource="#Session.DSN#">
				select count(1) as valor from EstructuraOrganizacional 
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
				  and EScodigoPadre = <cfqueryparam value="#Form.EScodigo#" cfsqltype="cf_sql_numeric">
				  and EScodigo != EScodigoPadre
			</cfquery>
			
			<cfif rsTieneSubordinados.valor GT 0> 
				<cfset tieneSubordinados = true> 
				<script>alert("La organización no se puede eliminar debido a que tiene organizaciones dependientes");</script> 			
			</cfif>
	
			<cfif not tieneSubordinados>
				<cfquery name="ABC_EstructuraOrganizacional" datasource="#Session.DSN#">
					delete from EstructuraOrganizacional
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
					  and EScodigo = <cfqueryparam value="#Form.EScodigo#" cfsqltype="cf_sql_numeric">
				</cfquery>
			</cfif>
			<cfset modo="ALTA">

		<cfelseif isdefined("Form.Cambio")>
			<cfset existeOrganizacion = false>

			<!--- Averigua si ya existe una organización con el mismo código --->
			<cfquery name="rsExisteOrganizacion" datasource="#Session.DSN#">
				select count(1) as valor from EstructuraOrganizacional
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
				  and ESOcodificacion = <cfqueryparam value="#Trim(Form.ESOcodificacion)#" cfsqltype="cf_sql_varchar">
				  and EScodigo != <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EScodigo#">
			</cfquery>
	
			<cfif rsExisteOrganizacion.valor GT 0> 
				<cfset existeOrganizacion = true> 
				<script>alert("Ya existe una organización con ese código");</script> 			
			</cfif>		

			<cfif not existeOrganizacion>
				<!--- Averiguar si es un nodo de Ultimo Nivel --->
				<cfquery name="rsUltimo" datasource="#Session.DSN#">
					select ESOultimoNivel 
					from EstructuraOrganizacional
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
					and EScodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EScodigo#">
				</cfquery>
				
				<cfif rsUltimo.ESOultimoNivel EQ 1 and not isdefined("Form.ESOultimoNivel")>
					<cfset error = "cambio">
					<cfquery name="ABC_EstructuraOrganizacional1" datasource="#Session.DSN#">
						delete from EstructuraOrganizacional
						where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
						  and EScodigo = <cfqueryparam value="#Form.EScodigo#" cfsqltype="cf_sql_numeric">
					</cfquery>
		
					<cfquery name="ABC_EstructuraOrganizacional2" datasource="#Session.DSN#">
						insert EstructuraOrganizacional (Ecodigo, ETcodigo, ESOcodificacion, ESOnombre, EScodigoPadre, ESOultimoNivel, ESOprefijo)
						values (
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETcodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESOcodificacion#">, 
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESOnombre#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EScodigoPadre#">,
						<cfif isdefined("Form.ESOultimoNivel") and Len(Trim(Form.ESOultimoNivel)) GT 0>
							<cfqueryparam cfsqltype="cf_sql_bit" value="1">,
						<cfelse>
							<cfqueryparam cfsqltype="cf_sql_bit" value="0">,
						</cfif>
						<cfif isdefined("Form.ESOultimoNivel") and Len(Trim(Form.ESOultimoNivel)) GT 0 and Len(Trim(Form.ESOprefijo)) GT 0>
							<cfqueryparam cfsqltype="cf_sql_char" value="#Form.ESOprefijo#">
						<cfelse>
							null
						</cfif>
						)
						
						select convert(varchar, @@identity) as EScodigo, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EScodigoPadre#"> as EScodigoPadre
					</cfquery>

				<cfelseif rsUltimo.ESOultimoNivel EQ 0 and isdefined("Form.ESOultimoNivel")>
					<cfset tieneSubordinados = false>
					
					<!--- Verificar si tiene organizaciones dependientes --->
					<cfquery name="rsTieneSubordinados" datasource="#Session.DSN#">
						select count(1) as valor from EstructuraOrganizacional 
						where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
						  and EScodigoPadre = <cfqueryparam value="#Form.EScodigo#" cfsqltype="cf_sql_numeric">
						  and EScodigo != EScodigoPadre
					</cfquery>
					
					<cfif rsTieneSubordinados.valor GT 0> 
						<cfset tieneSubordinados = true> 
						<script>alert("No se puede modificar el estado de Ultimo Nivel de la unidad académica porque ésta ya tiene hijos asociados");</script>
					</cfif>
			
					<cfif not tieneSubordinados>
						<cfquery name="ABC_EstructuraOrganizacional2" datasource="#Session.DSN#">
							update EstructuraOrganizacional 
							   set ESOnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESOnombre#">, 
								   ESOcodificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESOcodificacion#">,
								   EScodigoPadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EScodigoPadre#">,
								   ETcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETcodigo#">,
								   <cfif isdefined("Form.ESOultimoNivel") and Len(Trim(Form.ESOultimoNivel)) GT 0 and Len(Trim(Form.ESOprefijo)) GT 0>
								   ESOprefijo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.ESOprefijo#">,
								   <cfelse>
								   ESOprefijo = null,
								   </cfif>
								   ESOultimoNivel = 1
							where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
							  and EScodigo = <cfqueryparam value="#Form.EScodigo#" cfsqltype="cf_sql_numeric">
							  and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)

							select convert(varchar, <cfqueryparam value="#Form.EScodigo#" cfsqltype="cf_sql_numeric">) as EScodigo, convert(varchar, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EScodigoPadre#">) as EScodigoPadre
						</cfquery>
					</cfif>
				<cfelse>
					<cfquery name="ABC_EstructuraOrganizacional2" datasource="#Session.DSN#">
						update EstructuraOrganizacional 
						   set ESOnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESOnombre#">, 
							   ESOcodificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ESOcodificacion#">,
							   EScodigoPadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EScodigoPadre#">,
							   ETcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETcodigo#">,
							   <cfif isdefined("Form.ESOultimoNivel") and Len(Trim(Form.ESOultimoNivel)) GT 0 and Len(Trim(Form.ESOprefijo)) GT 0>
							   ESOprefijo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.ESOprefijo#">
							   <cfelse>
							   ESOprefijo = null
							   </cfif>
						where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
						  and EScodigo = <cfqueryparam value="#Form.EScodigo#" cfsqltype="cf_sql_numeric">
						  and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)

						select convert(varchar, <cfqueryparam value="#Form.EScodigo#" cfsqltype="cf_sql_numeric">) as EScodigo, convert(varchar, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EScodigoPadre#">) as EScodigoPadre
					</cfquery>
				</cfif>
			</cfif>
			<cfset modo="ALTA">
		</cfif>
	<cfcatch type="database">
		<cfif isdefined("error") and error EQ "cambio">
			<script>alert("No se puede modificar el estado de Ultimo Nivel de la unidad académica porque ésta ya tiene dependencias");</script>
		<cfelse>
			<cfinclude template="/sif/errorPages/BDerror.cfm">
			<cfabort>
		</cfif>
	</cfcatch>
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<cfif isdefined("Form.Cambio") and isdefined("ABC_EstructuraOrganizacional2.EScodigo")>
	<cfset Form.EScodigo = ABC_EstructuraOrganizacional2.EScodigo>
	<cfset Form.EScodigoPadre = ABC_EstructuraOrganizacional2.EScodigoPadre>
</cfif>

<form action="estructOrgaz.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif not isdefined("Form.Baja")>
		<input name="EScodigo" type="hidden" value="<cfif isdefined("Form.EScodigo")><cfoutput>#Form.EScodigo#</cfoutput></cfif>">
		<cfif isDefined("Form.Nuevo")>
			<input name="Nuevo" type="hidden" value="<cfoutput>#Form.Nuevo#</cfoutput>">
		</cfif>
		<cfif isDefined("Form.EScodigoPadre")>
			<input name="EScodigoPadre" type="hidden" value="<cfoutput>#Form.EScodigoPadre#</cfoutput>">
		</cfif>
		<cfif isDefined("Form.root")>
			<input name="root" type="hidden" value="<cfoutput>#Form.root#</cfoutput>">
		</cfif>
		<cfif isDefined("Form.ItemId")>
			<input name="ItemId" type="hidden" value="<cfoutput>#Form.ItemId#</cfoutput>">
		</cfif>
		<cfif isDefined("Form.ETcodigo")>
			<input name="ETcodigo" type="hidden" value="<cfoutput>#Form.ETcodigo#</cfoutput>">
		</cfif>
	<!---
	<cfelse>
		<cfif isDefined("Form.EScodigoPadre")>
			<input name="EScodigo" type="hidden" value="<cfoutput>#Form.EScodigoPadre#</cfoutput>">
		</cfif>
		<input name="Nuevo" type="hidden" value="Nuevo">
		<cfif isDefined("Form.root")>
			<input name="root" type="hidden" value="<cfoutput>#Form.root#</cfoutput>">
		</cfif>
		<cfif isDefined("Form.ItemId")>
			<input name="ItemId" type="hidden" value="<cfoutput>#Form.ItemId#</cfoutput>">
		</cfif>
		<cfif isDefined("Form.ETcodigo")>
			<input name="ETcodigo" type="hidden" value="<cfoutput>#Form.ETcodigo#</cfoutput>">
		</cfif>
	--->
	</cfif>
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">		
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

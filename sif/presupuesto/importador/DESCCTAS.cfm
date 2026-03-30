<!---  validaciones --->
<!---
1. Cuentas que no existen
2. Cuenta duplicadas en la importacion
3. Cuentas que no aceptan movimientos
--->

<cfinclude template="FnScripts.cfm">

<cfquery  name="rsImportador" datasource="#session.dsn#">
	select distinct <cf_dbfunction name="sPart"	args="t.FormatoCuenta,1,4"> as Cmayor, cm.Cmayor as CmayorExiste
	  from #table_name# t
		left outer join CtasMayor cm
			 on cm.Ecodigo = #session.Ecodigo#
			and cm.Cmayor = <cf_dbfunction name="sPart"	args="t.FormatoCuenta,1,4">
</cfquery>

<cfloop query="rsImportador">
	<cfif rsImportador.CmayorExiste EQ "">
		<cfset sbError ("FATAL", "Cuenta Mayor '#rsImportador.Cmayor#' no existe")>
	</cfif>
</cfloop>

<cfquery  name="rsImportador" datasource="#session.dsn#">
	select count(1) as Repetido, t.TipoCuenta, t.FormatoCuenta, min(t.Descripcion)
	from #table_name# t
	group by t.TipoCuenta, t.FormatoCuenta
	having count(1) > 1
	order by t.FormatoCuenta
</cfquery>
<cfloop query="rsImportador">
	<cfif rsImportador.TipoCuenta EQ "F">
		<cfset LvarTipo = "Financiera">
	<cfelseif rsImportador.TipoCuenta EQ "C">
		<cfset LvarTipo = "Contable">
	<cfelseif rsImportador.TipoCuenta EQ "P">
		<cfset LvarTipo = "Presupuesto">
	<cfelse>
		<cfset LvarTipo = "Tipo incorrecto">
	</cfif>
	<cfset sbError ("FATAL", "Cuenta #LvarTipo# '#rsImportador.FormatoCuenta#' duplicado #rsImportador.Repetido# veces en el archivo.")>
</cfloop>

<cfset ERR = fnVerificaErrores()>

<cfif ERR.recordcount GT 0>
	<cfreturn>
</cfif>

<cfquery name="rsImportador" datasource="#session.dsn#">
	select TipoCuenta, FormatoCuenta, Descripcion
	from #table_name#
</cfquery>

<cfloop query="rsImportador">
	<cfset LvarTipoCuenta		= rsImportador.TipoCuenta>
	<cfset LvarFormatoCuenta	= rsImportador.FormatoCuenta>
	<cfset LvarDescripcion		= rsImportador.Descripcion>
	
	<cftransaction>
		<cfif LvarTipoCuenta EQ "F">
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select CFmovimiento
				  from CFinanciera
				where CFformato		= '#LvarFormatoCuenta#'
				  and Ecodigo 		= #session.Ecodigo#
			</cfquery>
		
			<cfset LvarRESULT = "OLD">
			<cfif rsSQL.recordCount EQ 0>
				<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCFformato" returnvariable="LvarRESULT">
					<cfinvokeargument name="Lprm_Ecodigo" 			value="#session.Ecodigo#"/>							
					<cfinvokeargument name="Lprm_CFformato" 		value="#LvarFormatoCuenta#"/>
					<cfinvokeargument name="Lprm_NoVerificarSinOfi" value="true"/>
					<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
				</cfinvoke>		
			<cfelseif rsSQL.CFmovimiento NEQ "S">
				LvarRESULT = "Cuenta Financiera no acepta movimientos">
			</cfif>

			<cfif LvarRESULT EQ "OLD" OR LvarRESULT EQ "NEW">
				<cfquery datasource="#session.dsn#">
					update CFinanciera
					set CFdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarDescripcion#">,
						CFdescripcionF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarDescripcion#">
					where CFformato		= '#LvarFormatoCuenta#'
					  and Ecodigo		= #session.Ecodigo#
					  and CFmovimiento	= 'S'
				</cfquery>
			<cfelse>
				<cfset sbError ("FATAL", "Error en Cuenta Financiera '#LvarFormatoCuenta#'. #LvarRESULT#")>
			</cfif>
			
		</cfif>
				
		<cfif LvarTipoCuenta EQ "C" OR LvarTipoCuenta EQ "F">
			<cfquery datasource="#session.dsn#">
				update CContables
				set Cdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarDescripcion#">,
					CdescripcionF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarDescripcion#">
				where Cformato		= '#LvarFormatoCuenta#'
				  and Ecodigo 		= #session.Ecodigo#
				  and Cmovimiento	= 'S'
			</cfquery>
		</cfif>
				
		<cfif LvarTipoCuenta EQ "P" OR LvarTipoCuenta EQ "F">
			<cfquery datasource="#session.dsn#">
				update CPresupuesto
				set CPdescripcionF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarDescripcion#">
				where CPformato		= '#LvarFormatoCuenta#'
				  and Ecodigo 		= #session.Ecodigo#
				  and CPmovimiento	= 'S'
			</cfquery>
		</cfif>
	</cftransaction>
	<cfset ERR = fnVerificaErrores()>
</cfloop>
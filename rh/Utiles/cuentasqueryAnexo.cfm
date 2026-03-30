	<!--- parametros para uso del Javascript y asignar valores al Contenedor--->
	<cfparam name="url.form" default="form1">
	<cfparam name="url.desc" default="Cdescripcion">
	<cfparam name="url.mayor" default="Cmayor">
	<cfparam name="url.fmt" default="Cformato">
	<cfparam name="url.id" default="Ccuenta">
	<cfparam name="url.Cnx" default="#Session.DSN#">

<cftry>
	<!--- <cfdump var="#url#"> --->
	<cfif (isdefined("url.Cformato") and len(trim(url.Cformato)) NEQ "") and (isdefined("url.Cmayor") and len(trim(url.Cmayor)) NEQ "") 
			and not (listcontains(url.Cformato, '?') or listcontains(url.Cformato, '*') or listcontains(url.Cformato, '!')) >
		<cfset url.Cmayor = right("0000" & trim(url.Cmayor), 4)>
		<!--- Esto es la ejecución del Procedimiento almacenado que genera el Plan de Cuentas --->
		<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
			<cfinvokeargument name="Lprm_Cmayor" value="#url.Cmayor#"/>							
			<cfinvokeargument name="Lprm_Cdetalle" value="#url.Cformato#"/>
			<cfinvokeargument name="Conexion" value="#session.DSN#"/>
			<cfinvokeargument name="ecodigo" value="#session.Ecodigo#"/>
		</cfinvoke>		
		<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
			<cfthrow message="Cuenta #url.Cformato#: #LvarERROR#">
		</cfif>

		<cfquery name="rsSIFCuentas" datasource="#url.Cnx#">
			select 
				a.Ccuenta, 
				a.Ecodigo, 
				a.Cmayor, 
				a.Cformato, 
						(
							select min(coalesce(mm.PCEMformato, cpv.CPVformatoF))
							  from CPVigencia cpv
							  	left join PCEMascaras mm on mm.PCEMid = cpv.PCEMid
							 where cpv.Ecodigo	= b.Ecodigo
							   and cpv.Cmayor	= b.Cmayor
							   and #createODBCdate(Now())# between CPVdesde and CPVhasta
						) as Cmascara,
				a.Mcodigo, 
				a.SCid, 
				a.Cdescripcion, 
				a.Cmovimiento, 
				a.Cpadre, 
				a.Cbalancen,
				a.Cbalancenormal,  
				a.ts_rversion 
			from CContables a, CtasMayor b
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and a.Cformato = '#url.Cmayor#-#url.Cformato#'
			  and a.Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Cmayor#">
			  and a.Ecodigo = b.Ecodigo
			  and a.Cmayor = b.Cmayor
		</cfquery>
		
		<script language="JavaScript">
			<cfoutput>
			<cfif (Trim(rsSIFCuentas.Cmovimiento) EQ "S") and (rsSIFCuentas.RecordCount GT 0)>
				window.parent.document.#url.form#.#url.id#.value='#JSStringFormat(rsSIFCuentas.Ccuenta)#';
			<cfelse>
				window.parent.document.#url.form#.#url.id#.value='';
			</cfif>
			window.parent.document.#url.form#.#url.desc#.value='#JSStringFormat(rsSIFCuentas.Cdescripcion)#';
			</cfoutput>
		</script>
	<cfelseif (isdefined("url.Cmayor") and len(trim(url.Cmayor)) NEQ "") >
		<cfset url.Cmayor = right("0000" & trim(url.Cmayor), 4)>
		<cfquery name="rsMaskCuenta" datasource="#url.Cnx#">
			select 
				a.Ccuenta, 
				a.Ecodigo, 
				a.Cmayor, 
				a.Cformato, 
						(
							select min(coalesce(mm.PCEMformato, cpv.CPVformatoF))
							  from CPVigencia cpv
							  	left join PCEMascaras mm on mm.PCEMid = cpv.PCEMid
							 where cpv.Ecodigo	= b.Ecodigo
							   and cpv.Cmayor	= b.Cmayor
							   and #createODBCdate(Now())# between CPVdesde and CPVhasta
						) as Cmascara,
				a.Mcodigo, 
				a.SCid, 
				a.Cdescripcion, 
				a.Cmovimiento, 
				a.Cpadre, 
				a.Cbalancen,
				a.Cbalancenormal,  
				a.ts_rversion 
			from CContables a, CtasMayor b
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and a.Cformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Cmayor#">
			  and a.Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Cmayor#">
			  and a.Ecodigo = b.Ecodigo
			  and a.Cmayor = b.Cmayor
		</cfquery>
		<cfdump var="#rsMaskCuenta#" label="rsMaskCuenta">

		<script language="JavaScript">
			<cfif rsMaskCuenta.RecordCount GT 0>
				<cfoutput>
				window.parent.document.#url.form#.#url.mayor#_mask.value="#JSStringFormat(rsMaskCuenta.Cmascara)#";
				<cfif (Trim(rsMaskCuenta.Cmovimiento) EQ "S")>
					window.parent.document.#url.form#.#url.mayor#_id.value="#JSStringFormat(rsMaskCuenta.Ccuenta)#";
					window.parent.document.#url.form#.#url.id#.value="#JSStringFormat(rsMaskCuenta.Ccuenta)#";
				</cfif>
				window.parent.document.#url.form#.#url.desc#.value="#JSStringFormat(rsMaskCuenta.Cdescripcion)#";
				</cfoutput>
			</cfif>
		</script>

	</cfif>
<cfcatch type="any">
	<script language="JavaScript">
		<cfoutput>
		alert ("#JSStringFormat(cfcatch.Message)#:#JSStringFormat(cfcatch.Detail)#");
		</cfoutput>
	</script>
</cfcatch>
</cftry>

<cfif isdefined("url.id") and len(trim(url.id))and url.id neq "-1" and isdefined("url.Ecodigo") and Len(Trim(url.Ecodigo)) and isdefined("url.sufijo") and isdefined("url.conexion") and Len(Trim(url.conexion))>--->
	
	<cfquery datasource="#url.conexion#" name="rsDatosAgente">
		select a.AGid, a.AAplazoDocumentacion, a.AAcomisionTipo, a.AAcomisionPctj, a.AAcomisionMnto, a.AAprospecta, a.ts_rversion, 	a.AAfechacontrato
		from ISBagente a
		where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ecodigo#">	
	</cfquery>


	<cfset ts_ag = "">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
		artimestamp="#rsDatosAgente.ts_rversion#" returnvariable="ts_ag">
	</cfinvoke>

	<cfif Len(Trim(rsDatosAgente.AAplazoDocumentacion))>
		<cfset PG_plazoDoc = rsDatosAgente.AAplazoDocumentacion>
	<cfelse>
		<cfinvoke component="saci.comp.ISBparametros" method="Get" returnvariable="PG_plazoDoc">
			<cfinvokeargument name="Pcodigo" value="10">
		</cfinvoke>
	</cfif>
	dateFormat(
	<cfoutput>
		<script language="JavaScript">
			window.parent.document.#url.form_name#.AGid#url.sufijo#.value = "#rsDatosAgente.AGid#";		
		<cfif isdefined('url.tipo') and url.tipo eq 'Externo'>
			window.parent.document.#url.form_name#.AAplazoDocumentacion#url.sufijo#.value = "#PG_plazoDoc#";
			window.parent.document.#url.form_name#.AAcomisionTipo#url.sufijo#.value = "#rsDatosAgente.AAcomisionTipo#";
			window.parent.document.#url.form_name#.AAcomisionPctj#url.sufijo#.value = "#rsDatosAgente.AAcomisionPctj#";
			window.parent.document.#url.form_name#.AAcomisionMnto#url.sufijo#.value = "#rsDatosAgente.AAcomisionMnto#";
			window.parent.document.#url.form_name#.AAfechacontrato#url.sufijo#.value = "#DateFormat(rsDatosAgente.AAfechacontrato,'dd/mm/yyyy')#";
			window.parent.document.#url.form_name#.ts_rversion_agente#url.sufijo#.value = "#ts_ag#";
			<cfif isdefined("url.modo")>
				<cfif url.modo NEQ "ALTA">
				window.parent.document.#url.form_name#.BDAGid#url.sufijo#.value = "#rsDatosAgente.AGid#";
				</cfif>
			</cfif>
			<cfif rsDatosAgente.AAprospecta EQ 1>
				window.parent.document.#url.form_name#.AAprospecta#url.sufijo#.checked = true;
			<cfelse>
				window.parent.document.#url.form_name#.AAprospecta#url.sufijo#.checked = false;
			</cfif>
			window.parent.muestraPorcentaje();
			window.parent.ActualizaValoresExtendidos#url.sufijo#2(3,'#rsDatosAgente.AGid#');
		</cfif>
		</script>
	</cfoutput>
</cfif>	


<cfinvoke component="sif.Componentes.FPRES_ActividadEmpresarial" method="GetActividadxCodigo" returnvariable="rsActEid">
	<cfinvokeargument name="Codigo"			value="#url.codActividad#">
</cfinvoke>
<cfset hayError =false>
<cfset rsActE.FPAECodigo = "">
<cfif isdefined('url.valores')>
	<cfset valor = ListChangeDelims(url.valores, ',',url.separador) >
</cfif>
<cfset arrayDesc = "">
<cfif len(trim(rsActEid.FPAEid)) and rsActEid.FPAEid gt 0 and isdefined('url.valores') and len(trim(url.valores))>
	<cfinvoke component="sif.Componentes.FPRES_ActividadEmpresarial" method="GetActividad" returnvariable="rsActE">
		<cfinvokeargument name="FPAEid"			value="#rsActEid.FPAEid#">
	</cfinvoke>
	<cfif rsActE.recordcount>
		<cfinvoke component="sif.Componentes.FPRES_ActividadEmpresarial" method="GetNivel" returnvariable="rsActNiveles">
			<cfinvokeargument name="FPAEid"			value="#rsActE.FPAEid#">
		</cfinvoke>
		<cfset catidref = "">
		<cfset arrayDesc = "#rsActE.FPAEDescripcion##url.separador#">
		<cfif rsActNiveles.RecordCount eq listlen(valor)>
			<cfloop query="rsActNiveles">
				<cfif FPADDepende eq "C">
					<cfquery datasource="#session.dsn#" name="rsCatE">
						select PCEempresa 
						from PCECatalogo 
						where PCEcatid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PCEcatid#">
						and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CEcodigo#">
					</cfquery>
					<cfquery datasource="#session.dsn#" name="rsConc">
						select PCDcatid,PCEcatid,PCDvalor,PCDdescripcion,PCEcatidref
						from PCDCatalogo 
						where <cfif rsCatE.PCEempresa>
							Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#url.Ecodigo#"> and
							  </cfif>
							PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PCEcatid#">
							and PCDvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(valor, currentRow)#">
					</cfquery>
					<cfif rsConc.recordcount>
						<cfset catidref = rsConc.PCEcatidref>
						<cfset arrayDesc &= "#rsConc.PCDdescripcion##url.separador#">
					<cfelse>
						<cfset fnEstado(3,"##FFFFFF","##FF0000",true)>
						<cfbreak>
					</cfif>
				<cfelseif FPADDepende eq "N">
					<cfif len(trim(catidref))>
						<cfquery datasource="#session.dsn#" name="rsCatE">
							select PCEempresa 
							from PCECatalogo 
							where PCEcatid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#catidref#">
							and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CEcodigo#">
						</cfquery>
						<cfquery datasource="#session.dsn#" name="rsConc">
							select PCDcatid,PCEcatid,PCDvalor,PCDdescripcion,PCEcatidref
							from PCDCatalogo 
							where <cfif rsCatE.PCEempresa>
								Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#url.Ecodigo#"> and
								  </cfif>
								PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#catidref#">
								and PCDvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(valor, currentRow)#">
						</cfquery>
						<cfif not rsConc.recordcount>
							<cfset fnEstado(3,"##FFFFFF","##FF0000",true)>
							<cfbreak>
						</cfif>
						<cfset catidref = rsConc.PCEcatidref>
						<cfset arrayDesc &= "#rsConc.PCDdescripcion##url.separador#">
					<cfelse>
						<cfset fnEstado(3,"##FFFFFF","##FF0000",true)>
						<cfbreak>
					</cfif>
				<cfelse>
					<cfset fnEstado(3,"##FFFFFF","##FF0000",true)>
					<cfbreak>
				</cfif>
			</cfloop>
		<cfelse>
			<cfset fnEstado(3,"##FFFFFF","##FF0000",true)>
		</cfif>
	<cfelse>
		<cfset fnEstado(3,"##FFFFFF","##FF0000",true)>
	</cfif>
	<cfif not hayError>
		<cfoutput>
			<script language="javascript1.2" type="text/javascript">
				window.parent.document.#url.form#.#url.name#_Valores.style.background = "##FFFFFF";
				window.parent.document.#url.form#.#url.name#.value = "#url.valores#";
				window.parent.document.#url.form#.#url.nameId#.style.background = "##FFFFFF";
				window.parent.document.#url.form#.#url.nameId#.value = "#rsActEid.FPAEid#";
				arrayValores = '#rsActE.FPAECodigo##url.separador##url.valores#'.split('#url.separador#');
				arrayDesc = '#arrayDesc#'.split('#url.separador#');
				window.parent.mostrarArbol_#url.name#(arrayValores,arrayDesc);
			</script>
		</cfoutput>
	</cfif>
<cfelseif rsActEid.recordcount eq 0>
	<cfset fnEstado(1,"##FF0000","##FFFFFF",true)>
<cfelseif  rsActEid.recordcount gt 0>
	<cfset fnEstado(2,"##FFFFFF","##FFFFFF",true)>
</cfif>
<cffunction name="fnEstado" access="private" 	output="true">
	<cfargument  name="estado" 			type="string" 	required="yes">
	<cfargument  name="colorPintado1" 	type="string" 	required="yes">
	<cfargument  name="colorPintado2" 	type="string" 	required="yes">
	<cfargument  name="error" 			type="boolean" 	required="yes">
	<script language="javascript1.2" type="text/javascript">
		<cfif estado eq 1>
			window.parent.document.#url.form#.#url.name#_Act.value = "";
			window.parent.document.#url.form#.#url.nameId#.value = "";
		<cfelseif estado eq 2>
			window.parent.document.#url.form#.#url.nameId#.value = "";
		</cfif>
		window.parent.document.#url.form#.#url.name#_Act.style.background = "#Arguments.colorPintado1#";
		window.parent.document.#url.form#.#url.name#_Valores.style.background = "#Arguments.colorPintado2#";
		window.parent.document.#url.form#.#url.name#_Valores.value = "";
		window.parent.document.#url.form#.#url.name#.value = "";
		window.parent.document.getElementById('#url.name#_arbol').innerHTML = "";
	</script>
	<cfset hayError = Arguments.error>
</cffunction>
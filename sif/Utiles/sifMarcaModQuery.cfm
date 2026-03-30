<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.dato") and url.dato NEQ "" and isdefined("url.opc") and url.opc NEQ "">
	<cfoutput>	
		<cfif url.opc EQ "1">	<!--- Marcas --->

			<cfquery name="rs" datasource="#url.conexion#">
				Select AFMid,rtrim(ltrim(AFMcodigo)) as AFMcodigo,AFMdescripcion
				from AFMarcas 
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.ecodigo#">
					and rtrim(ltrim(upper(AFMcodigo)))=<cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.dato))#">
			</cfquery>

			<script language="JavaScript">
				var descAnt = window.parent.document.#url.form#.#url.desc#.value;
				
				window.parent.document.#url.form#.#url.key#.value='';
				window.parent.document.#url.form#.#url.name#.value='';
				window.parent.document.#url.form#.#url.desc#.value='';
				
				window.parent.document.#url.form#.#url.key#.value="#rs.AFMid#";
				window.parent.document.#url.form#.#url.name#.value="#rs.AFMcodigo#";		
				window.parent.document.#url.form#.#url.desc#.value="#rs.AFMdescripcion#";
				if(descAnt != window.parent.document.#url.form#.#url.desc#.value){
					window.parent.document.#url.form#.#url.keyMod#.value='';
					window.parent.document.#url.form#.#url.nameMod#.value='';		
					window.parent.document.#url.form#.#url.descMod#.value='';		
				}
			</script>
		<cfelse>	<!--- Modelos --->
			<cfquery name="rs" datasource="#url.conexion#">
				Select AFMMid,rtrim(ltrim(AFMMcodigo)) as AFMMcodigo,AFMMdescripcion
				from AFMModelos
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.ecodigo#">
					and rtrim(ltrim(upper(AFMMcodigo)))= <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.dato))#">
					and AFMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.datoPadre#">					
			</cfquery>
			
			<script language="JavaScript">
				window.parent.document.#url.form#.#url.keyMod#.value='';
				window.parent.document.#url.form#.#url.nameMod#.value='';		
				window.parent.document.#url.form#.#url.descMod#.value='';
			
				window.parent.document.#url.form#.#url.keyMod#.value="#rs.AFMMid#";
				window.parent.document.#url.form#.#url.nameMod#.value="#rs.AFMMcodigo#";		
				window.parent.document.#url.form#.#url.descMod#.value="#rs.AFMMdescripcion#";
			</script>	
		</cfif>
	</cfoutput>	
</cfif>
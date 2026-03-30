<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.dato") and url.dato NEQ "" and isdefined("url.opc") and url.opc NEQ "">
	<cfoutput>	
		<cfif url.opc EQ "1">	<!--- Categoría --->

			<cfquery name="rs" datasource="#url.conexion#">
				select ACcodigo, rtrim(ltrim(ACcodigodesc)) as ACcodigodesc, ACdescripcion
				from ACategoria
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.ecodigo#">
					and rtrim(ltrim(upper(ACcodigodesc)))=<cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.dato))#">
			</cfquery>

			<script language="JavaScript">
				var descAnt = window.parent.document.#url.form#.#url.desc#.value;
				
				window.parent.document.#url.form#.#url.key#.value='';
				window.parent.document.#url.form#.#url.name#.value='';
				window.parent.document.#url.form#.#url.desc#.value='';
				
				window.parent.document.#url.form#.#url.key#.value="#rs.ACcodigo#";
				window.parent.document.#url.form#.#url.name#.value="#rs.ACcodigodesc#";		
				window.parent.document.#url.form#.#url.desc#.value="#rs.ACdescripcion#";
				if(descAnt != window.parent.document.#url.form#.#url.desc#.value){
					window.parent.document.#url.form#.#url.keyClas#.value='';
					window.parent.document.#url.form#.#url.nameClas#.value='';		
					window.parent.document.#url.form#.#url.descClas#.value='';		
				}
				if (window.parent.func#trim(url.key)#) {window.parent.func#trim(url.key)#(window.parent.document.#url.form#.#url.key#);}
			</script>
		<cfelse>	<!--- Clasificaciones --->
			<cfquery name="rs" datasource="#url.conexion#">
				select ACid, rtrim(ltrim(ACcodigodesc)) as ACcodigodesc, ACdescripcion
				from AClasificacion
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.ecodigo#">
					and rtrim(ltrim(upper(ACcodigodesc)))= <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.dato))#">
					and ACcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.datoPadre#">					
			</cfquery>
			
			<script language="JavaScript">
				window.parent.document.#url.form#.#url.keyClas#.value='';
				window.parent.document.#url.form#.#url.nameClas#.value='';		
				window.parent.document.#url.form#.#url.descClas#.value='';
			
				window.parent.document.#url.form#.#url.keyClas#.value="#rs.ACid#";
				window.parent.document.#url.form#.#url.nameClas#.value="#rs.ACcodigodesc#";		
				window.parent.document.#url.form#.#url.descClas#.value="#rs.ACdescripcion#";
			</script>	
		</cfif>
	</cfoutput>	
</cfif>
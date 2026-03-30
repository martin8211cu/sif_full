<!--- Recibe conexion, form, name, desc, ecodigo y dato --->

<cfif isdefined("url.valor") and len(trim(url.valor))>
	<cfquery name="rs" datasource="#session.DSN#">
		select FAM12COD, FAM12CODD, FAM12DES
		from FAM012
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and FAM12CODD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.valor#">
	</cfquery>
	
	<cfif isdefined("url.campo") and len(trim(url.campo)) and url.campo eq 1>
		<!--- Si el registro existe lo llenamos --->
		<cfif rs.recordcount gt 0>
			<script language="JavaScript" type="text/javascript">
				window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="<cfoutput>#rs.FAM12COD#</cfoutput>";
				window.parent.document.<cfoutput>#url.formulario#.#url.codigo#</cfoutput>.value="<cfoutput>#trim(rs.FAM12CODD)#</cfoutput>";
				window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="<cfoutput>#trim(rs.FAM12DES)#</cfoutput>";
			</script>
		<!--- Si el registro no existe limpiamos los demas campos --->
		<cfelse>
			<script language="JavaScript" type="text/javascript">
				if (window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value != '') {
					window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="";
					window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value = "";
					window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.disabled = false;
				}
			</script>
		</cfif>
    <cfelseif isdefined("url.campo") and len(trim(url.campo)) and url.campo eq 2>
		<!--- Si el registro existe hacemos el update --->
		<cfif rs.recordcount gt 0>
			<script language="JavaScript" type="text/javascript">
				params = "<cfoutput>&id=#url.id#&desc=#url.desc#</cfoutput>";
				location.href="/cfmx/sif/Utiles/sifImpresoraInserta.cfm?valor=<cfoutput>#url.valor#&descripcion=#url.descripcion#&formulario=#url.formulario#&codigo=#url.codigo#</cfoutput>" + params;
			</script>
		<cfelse>
			<script language="JavaScript">
				var params ="";		
				params = "<cfoutput>&id=#url.id#&desc=#url.desc#</cfoutput>";
				<!--- preguntar si deseo agregar la impresora o no--->
				if (window.parent.document.<cfoutput>#url.formulario#.#url.codigo#</cfoutput>.value != '' && window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value != '') {
					if(confirm('¿Desea agregar la impresora?')){
						location.href="/cfmx/sif/Utiles/sifImpresoraInserta.cfm?valor=<cfoutput>#url.valor#&descripcion=#url.descripcion#&formulario=#url.formulario#&codigo=#url.codigo#</cfoutput>" + params;
					}else{ 
						window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="";
						window.parent.document.<cfoutput>#url.formulario#.#url.codigo#</cfoutput>.value="";
						window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="";
					}	
				}
			</script>
		</cfif>
	</cfif>	
</cfif>

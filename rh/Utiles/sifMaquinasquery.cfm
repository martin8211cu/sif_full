<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.valor") and len(trim(url.valor))>
	<cfquery name="rs" datasource="#session.DSN#">
		select FAM09MAQ, FAM09DES
		from FAM009
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and FAM09MAQ = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#url.valor#">
		
		<cfif isdefined("url.excluir") and len(trim(url.excluir))>
			and FAM09MAQ not in (#url.Excluir#)
		</cfif>
	</cfquery>

	<cfif rs.recordcount gt 0>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="<cfoutput>#rs.FAM09MAQ#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="<cfoutput>#trim(rs.FAM09DES)#</cfoutput>";
			<cfoutput>if (window.parent.func#url.id#) {window.parent.func#url.id#()}</cfoutput>
		</script>
	<cfelse>
		<script language="JavaScript">
			var params ="";		
			
			<!--- preguntar si deseo agregar la impresora o no--->
			if(confirm('¿Desea agregar la impresora?')){
				location.href="/rh/Utiles/sifMaquinaInserta.cfm?valor=<cfoutput>#url.valor#&formulario=#url.formulario#</cfoutput>";
				params = "<cfoutput>&id=#url.id#&desc=#url.desc#</cfoutput>";
		
				<cfif isdefined("url.excluir") and len(trim(url.excluir))>
					params = params + "&excluir=<cfoutput>#url.excluir#</cfoutput>";
				</cfif>	

				location.href="/rh/Utiles/sifMaquinasquery.cfm?valor=<cfoutput>#url.valor#&formulario=#url.formulario#</cfoutput>" + params;
			}else{ 
				window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="";
				window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="";
			}	
				
			<cfoutput>if (window.parent.func#url.id#) {window.parent.func#url.id#()}</cfoutput>
		</script>
	</cfif>
</cfif>

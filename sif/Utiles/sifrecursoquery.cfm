<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.dato") and len(trim(url.dato))>
	<cfquery name="rs" datasource="#session.DSN#">
		select r.PRJRid, r.PRJRcodigo, r.PRJRdescripcion,
		coalesce(Acosto, (select max(PRJPIcostoUnitario) 
                  		  from PRJPproductoInsumos i
			              where i.PRJRid  = r.PRJRid
            		        and i.Ecodigo = r.Ecodigo), 0) as costo_unit,
		r.Ucodigo
		from PRJRecurso r
			 left outer join Articulos ar
    		 on ar.Aid = r.Aid
		where r.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and r.PRJRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.dato#">
	</cfquery>

	<cfif rs.recordcount gt 0>
		<script language="JavaScript">			
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="<cfoutput>#rs.PRJRid#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="<cfoutput>#trim(rs.PRJRdescripcion)#</cfoutput>";			
			window.parent.document.<cfoutput>#url.formulario#.#url.cmp_unitario#</cfoutput>.value="<cfoutput>#rs.costo_unit#</cfoutput>";
			window.parent.document.<cfoutput>#url.formulario#.#url.mod_cant#</cfoutput>.value="1";
			window.parent.document.<cfoutput>#url.formulario#.UcodigoProd</cfoutput>.value="<cfoutput>#rs.Ucodigo#</cfoutput>";

			<cfoutput>if (window.parent.func#url.id#) {window.parent.func#url.id#()}</cfoutput>
		</script>
	<cfelse>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.name#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.cmp_unitario#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.#url.mod_cant#</cfoutput>.value="";
			window.parent.document.<cfoutput>#url.formulario#.UcodigoProd</cfoutput>.value="";
			<cfoutput>if (window.parent.func#url.id#) {window.parent.func#url.id#()}</cfoutput>
			alert("El codigo de producto no existe")
		</script>		
	</cfif>
</cfif>

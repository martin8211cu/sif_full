<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.dato") and url.dato NEQ "">
	
	<cfquery name="rs" datasource="#session.Fondos.dsn#">
		Select A.id_banco, B.cuenta_corriente, B.nombre_cuenta, A.nombre_banco
		from arquitectura..EBA01C A, arquitectura..EBA02C B
		where A.id_banco = B.id_banco
		  and B.cuenta_corriente = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.dato#">
	</cfquery>
			
	<script language="JavaScript">
	function AsignarBanco(idbancoarq,nbanco)
	{		
		if (idbancoarq == -1)
		{
			window.parent.document.<cfoutput>#url.form#</cfoutput>.id_bancoarq.value = ""
			window.parent.document.<cfoutput>#url.form#</cfoutput>.nbancoarq.value = ""
		}
		else
		{
			window.parent.document.<cfoutput>#url.form#</cfoutput>.id_bancoarq.value = idbancoarq
			window.parent.document.<cfoutput>#url.form#</cfoutput>.nbancoarq.value = nbanco
		}
	}
	<cfif rs.recordcount gt 0>				
		window.parent.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value="<cfoutput>#rs.id_banco#</cfoutput>";
		window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#trim(rs.cuenta_corriente)#</cfoutput>";
		window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#trim(rs.nombre_cuenta)#</cfoutput>";
		AsignarBanco('<cfoutput>#rs.id_banco#</cfoutput>', '<cfoutput>#rs.nombre_banco#</cfoutput>')
	<cfelse>			
		window.parent.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value="";
		window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="";
		window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="";
		window.parent.document.<cfoutput>#url.form#.#url.name2#</cfoutput>.value="";
		window.parent.document.<cfoutput>#url.form#.#url.desc2#</cfoutput>.value="";
		AsignarBanco(-1,'1')
		alert("La cuenta no existe")
	</cfif>
	</script>
	
</cfif>


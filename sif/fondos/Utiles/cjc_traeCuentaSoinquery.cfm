<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.dato") and url.dato NEQ "">
	
	<cfquery name="rs" datasource="#session.Fondos.dsn#">
		Select A.B01COD, B.BANDES, B.BANCUE, A.B01DES
		from B01ARC A, BANARC B
		where A.B01COD = B.B01COD		
		  and B.BANCUE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.dato#">
	</cfquery>
					
	<script language="JavaScript">
	function AsignarBanco(idbancosoin, nbanco)
	{				
		if (idbancosoin == -1)
		{
			window.parent.document.<cfoutput>#url.form#</cfoutput>.id_bancosoin.value = ""
			window.parent.document.<cfoutput>#url.form#</cfoutput>.nbancosoin.value = ""
		}
		else
		{
			window.parent.document.<cfoutput>#url.form#</cfoutput>.id_bancosoin.value = idbancosoin
			window.parent.document.<cfoutput>#url.form#</cfoutput>.nbancosoin.value = nbanco
		}
	}
	<cfif rs.recordcount gt 0>				
		window.parent.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value="<cfoutput>#rs.B01COD#</cfoutput>";
		window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#trim(rs.BANCUE)#</cfoutput>";
		window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#trim(rs.BANDES)#</cfoutput>";		
		AsignarBanco('<cfoutput>#rs.B01COD#</cfoutput>', '<cfoutput>#rs.B01DES#</cfoutput>');	
	<cfelse>			
		window.parent.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value="";
		window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="";
		window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="";
		window.parent.document.<cfoutput>#url.form#.#url.name2#</cfoutput>.value="";
		window.parent.document.<cfoutput>#url.form#.#url.desc2#</cfoutput>.value="";
		AsignarBanco(-1,'1');
		alert("La cuenta no existe")
	</cfif>
	</script>
	
</cfif>

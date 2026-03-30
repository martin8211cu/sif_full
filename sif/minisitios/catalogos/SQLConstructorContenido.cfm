<html>
	<cfquery name="rsMSContenido" datasource="sdc">
		select MSCtitulo, MSCtexto
		from MSContenido
		where Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Scodigo#">
		  and MSCcontenido = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.MSCcontenido#">
		  and MSCexpira > getdate()
	</cfquery>
   
    <head>
        <title>		
			<cfif rsMSContenido.RecordCount EQ 0 >
				Contenido Expirado.
			<cfelse>
				<cfoutput>#rsMSContenido.MSCtitulo#</cfoutput>
			</cfif>
		</title>
        <meta http-equiv='Expires' content='0' />
    </head>
    <body topmargin='2px' bottommargin='2px' 
        leftmargin='2px' rightmargin='2px' >
        <span style='font-size:10pt'>
			<cfif rsMSContenido.RecordCount EQ 0 >
				<div align="center">Este contenido ya expiró.</div>
			<cfelse>
				<cfoutput>#rsMSContenido.MSCtexto#</cfoutput>
			</cfif>
        </span>
    </body>
</html>

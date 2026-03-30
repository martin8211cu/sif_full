LOG:
<cftry>
	<cfquery datasource="minisif">
		drop table ##miTabla
	</cfquery>

	<cfoutput><br>Tabla borrada</cfoutput>

	<cfcatch type="database">
		<cfoutput><br>Tabla no existe</cfoutput>
	</cfcatch>
</cftry>
		
<cftry>
	<cfquery datasource="minisif">
		create table ##miTabla (
			cedula int,
			nombre varchar(20))
	</cfquery>

	<cfoutput><br>Tabla creada</cfoutput>

	<cfcatch type="database">
		<cfoutput><br>No se pudo crear la tabla</cfoutput>
	</cfcatch>
</cftry>

<cftry>
	<cfquery datasource="minisif">
		<cfloop list="5,10,15,20,25" index="i">
			insert into ##miTabla values (#i#,'Steve_#i#')
		</cfloop>
	</cfquery>

	<cfoutput><br>Registros insertados</cfoutput>

	<cfcatch>
		<cfoutput><br>No se pudo ingresar el registro</cfoutput>
	</cfcatch>
</cftry>

<cftry>
	<cfquery name="rs" datasource="minisif">
		select cedula,nombre from ##miTabla
	</cfquery>

	<br><br>
	<table border="1" width="30%">
		<tr bgcolor="#99CCFF">
			<td><strong>Nombre</strong></td>
			<td><strong>C&eacute;dula</strong></td>
		</tr>
		<cfset i = 1>
		<cfset colorear = "0x99CCFF">
		<cfoutput query="rs">
			<cfif (i mod 2 eq 0)>
				<cfset colorear = "0x99CCFF">
			<cfelse>
				<cfset colorear = "0xCCCCCC">
			</cfif>
			<tr bgcolor="#colorear#">
				<td width="80%"><a href="">#rs.nombre#</a></td>
				<td width="20%"><a href="">#rs.cedula#</a></td>
			</tr>
			<cfset i = i + 1>
		</cfoutput>
	</table>
	<cfcatch>
		<cfoutput><br>No se pueden leer los registros</cfoutput>
	</cfcatch>	
</cftry>

<cftry>
	<cfquery datasource="minisif">
		drop table ##miTabla
	</cfquery>

	<cfoutput><br>Tabla borrada</cfoutput>

	<cfcatch type="database">
		<cfoutput><br>Tabla no existe</cfoutput>
	</cfcatch>
</cftry>

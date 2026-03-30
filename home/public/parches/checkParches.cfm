<cfset pnum='025'>
<cfset psec='532'>

<cfset pnumh='025'>
<cfset psech='532'>

<cfsetting requesttimeout="3600">
<cfquery datasource="asp" name="rs">
	select parche,nombre,creado,modificado,autor,pdir,pnum,psec,entregado,cerrado
	from APParche 
	where convert(int,pnum+psec)  between #pnum##psec# and #pnumh##psech#
	order by convert(int,pnum) ,convert(int,psec)
</cfquery>
 <cfdump vaR="#rs#"/> <cfabort />

<!--------- revisar que no haya hueco en los parches---->
<cfset cont=psec>
<cfset existeHueco=false>
<cfloop query="rs">
	<cfif rs.psec neq cont>
		<cfoutput>No existe parche con secuencia #pnum# - #cont#<br></cfoutput>
		<cfset cont+=1>
		<cfset existeHueco=true>
	</cfif>
	<cfset cont+=1>
</cfloop>
<cfif existeHueco>
	<cf_dump var="faltan parches en la secuencia">
</cfif>
 

<cfset destino='C:\parches\'>

<cfset cont=0>
<table border="1">
<cfoutput query="rs">
	<cfset home='#destino#\#nombre#.jar'>
	<cfset ori='\\172.20.0.53\control_parches\entregados\No Instalados - Abiertos\Parches026\#nombre#.jar'>
	<cfset ori2='\\172.20.0.53\control_parches\entregados\Instalados - Cerrados\Parches026\#nombre#.jar'>
	
	<cfif FileExists(home)><!---- si lo encuentra en home, no hace nada--->

	<cfelseif FileExists(ori)>
		<cffile action = "copy" destination = "#destino#" source = "#ori#">
	<cfelseif FileExists(ori2)>
		<cffile  action = "copy" destination = "#destino#" source = "#ori2#">
	<cfelse>	
		<tr>
			<td>#pnum#</td>
			<td>#psec#</td>
			<td>#nombre#</td>
			<td>#autor#</td>
			<td>#modificado#</td>
			<td>#entregado#</td>
			<td>#cerrado#</td>
		</tr>
		<cfset cont+=1>
	</cfif>
</cfoutput>
</table>
<cfoutput>TOTAL: #cont#<br></cfoutput>
<cfflush interval="1">
<cfif cont gt 0>
	<cf_dump var="Faltan parches en la carpeta de entregados">
</cfif> 
<cfoutput>Deberían de existir #rs.Recordcount#<br></cfoutput>
<cfset cont=0>
<cf_dump vaR="TODO bien"/>
<cfloop query="rs">
	<cfset home='#destino##nombre#.jar'>
	<cftry>
		
	
		<cfif FileExists(home)><!---- si lo encuentra en home, no hace nada--->
			<cfoutput>-> #pnum#-#psec#  / #nombre#<br></cfoutput>
			<cfzip
		    action = "unzip"
		    destination = "#destino#unzip2\"
		    file = "#home#"
		    overwrite = "yes">
		    <cfset cont+=1>
		</cfif>
			<cfcatch type="any">
				<font color="red">revisar = #home# </font>
			</cfcatch>
		</cftry>
</cfloop>
<cfoutput>Descomprimidos #rs.Recordcount#<br></cfoutput>

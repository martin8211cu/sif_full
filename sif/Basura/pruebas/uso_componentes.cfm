
<!---<cfobject component="fecha.cfc" name="session.myfecha">
#session.myfecha#
<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsClienteDetallistaTipo.ts_rversion#"/>
</cfinvoke>--->
<cfinvoke component="sif.Componentes.fecha" method="Fecha" returnvariable="salida">
<cfinvokeargument name="Formato" value="dd/mm/yyyy">
</cfinvoke>
<cfset fecha1 = #salida#>

<cfset fecha2 = lsdateformat (now(), "dddd, dd mmmm, yyyy")>

<cfoutput>

La fecha de hoy es: #fecha1# 
<br>
#fecha2# <br>
</cfoutput>


<cfquery name="empre" datasource="minisif">
select * from Empresas
</cfquery>




<table border="1"  align="center">
	<tr>
		<th align="center"><font style="font-style:oblique"> <h3><strong> Nombre de la empresa </strong></h3></font></th>
		<th align="center"><font style="font-style:oblique"> <h3><strong> C&oacute;digo de la empresa </strong></h3></font></th>
	</tr>
<cfoutput query="empre" >
<cfif currentrow mod 2 is 1>
	<cfset bgcolor1 = "royalblue">
<cfelse>
	<cfset bgcolor1 = "white">
</cfif>
	<tr bgcolor="#bgcolor1#" align="center">
		<td >
			#empre.Edescripcion# <Br>
		</td>
		<td >
			#empre.Ecodigo# <Br>
		</td>

	</tr>
		</cfoutput>
</table>

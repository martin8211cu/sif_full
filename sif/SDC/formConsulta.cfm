<style type="text/css">
	.etiquetas { color: #000000; font-size:12pt; background-color: #CDCDCD; }
	.listaTitulo {  color: #000000; background-color: #DADADA; vertical-align: middle; }
	
	.lNon {  vertical-align: middle; background-color: #FFFFFF;  }
	.lPar {  background-color: #FAFAFA; vertical-align: middle; }
	.letra {  color: #FF0000; }
	
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
}
</style>

<!--- recupera las llaves de la tabla --->
<cfquery name="rsLlaves" datasource="sdc">
	select PBllaves
	from PBitacora
	where PBtabla='#form.PBtabla#'
</cfquery>
<cfset llaves = rsLlaves.PBllaves >
<cfset arrLlaves  = ListToArray(rsLlaves.PBllaves, ',')>
<cfset arrValores = ListToArray(form.llave, '|')>

<!--- crea la parte del where para la comsulta que recupera los datos actuales --->
<cfset where  = "" >
<cfset where2 = "" >
<cfloop index="i" from="1" to="#ArrayLen(arrLlaves)#">
	<cfset where  = where & trim(arrLlaves[i]) & "=" & trim(arrValores[i]) > 
	<cfset where2 = where2 & trim(arrLlaves[i]) > 
	<cfif ArrayLen(arrLlaves) gt 1 >
		<cfif i neq  ArrayLen(arrLlaves) >
			<cfset where  = where & " and ">
			<cfset where2 = where2 & "|">
		</cfif>
	</cfif>
</cfloop>

<!--- recupera las columnas que forman la tabla --->
<cfquery name="rsColumnas" datasource="sdc">
	select a.name as tnombre, b.name as cnombre, c.name as snombre, b.length
	from sysobjects a, syscolumns b, systypes c
	where a.name='#form.PBtabla#'
	  and a.id = b.id
	  and b.type = c.type
	  and c.name not in ('nvarchar','nchar','sysname', 'image', 'datetimn', 'text')
</cfquery>

<!--- campos para mostrar en datos actuales --->
<cfset actCampos = "" >
<cfloop query="rsColumnas">
	<cfif (trim(rsColumnas.snombre) eq "numeric") or (trim(rsColumnas.snombre) eq "numericn") >
		<cfset temp = "convert(varchar, " & rsColumnas.cnombre & ") as " & rsColumnas.cnombre >
	<cfelse>
		<cfset temp = rsColumnas.cnombre >
	</cfif>	
	<cfif rsColumnas.CurrentRow eq 1>
		<cfset actCampos = temp  >
	<cfelse>
		<cfset actCampos = actCampos & ", " & temp >
	</cfif>
</cfloop>
<cfset colspan = rsColumnas.RecordCount + 2>

<!--- Datos Actuales --->
<cfquery name="rsDatosActuales" datasource="sdc">
	select #actCampos# from #form.PBtabla# where #where#
</cfquery>

<!--- Modificaciones hechas a los datos --->
<cfquery name="rsDatos" datasource="sdc">
	select a.DBid, a.EBid, a.DBcolumna, a.DBvalor, a.DBvalorant, b.EBfecha, convert(varchar, EBfecha, 103) as fecha 
	from DBmovimiento a, EBmovimientos b, PBitacora c
	where a.EBid=b.EBid
	and b.PBid=c.PBid
	and c.PBtabla='#form.PBtabla#'
	and ltrim(rtrim(llavereg)) = ltrim(convert(varchar, '#form.llave#'))
	order by b.EBfecha desc
</cfquery>

<cfset columnas = ArrayNew(1) >
<cfset i = 1 >

<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="">

	<tr>
		<td colspan="<cfoutput>#colspan#</cfoutput>" >
			<table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="#DFDFDF">
			  <tr align="left"> 
				<td><a href="/cfmx/sif/sdc/filtro.cfm">Regresar</a></td></tr>
			</table>
		</td>
	</tr>

	<!--- Pinta los nombres de los campos de la tabla y crea un arreglo con los campos --->
		<cfoutput>
		<cfloop query="rsColumnas">
	
			<cfset vcolumna = "rsDatosActuales." & Trim(rsColumnas.cnombre) >

			<!--- Crea un arreglo con las columnas de la tabla, se hizo aqui para aprovechar el ciclo --->
			<cfset dcolumnas = ArrayNew(1)  >
			<cfset dcolumnas[1] = rsColumnas.cnombre>
			<cfset dcolumnas[2] = #Evaluate(vcolumna)# >
			<cfset dcolumnas[3] = 0 >
			<cfset columnas[i]  = dcolumnas >
			<cfset i = i+1>
		</cfloop>
		</cfoutput> <!--- rsColumnas --->
	
	<!--- Nombre de la tabla --->
	<tr><td colspan="<cfoutput>#colspan#</cfoutput>" ><b><font size="2">Tabla:&nbsp;<cfoutput>#form.PBtabla#</cfoutput></font></b></td></tr>

	<!--- datos actuales--->
	<tr><td class="etiquetas" colspan="<cfoutput>#colspan#</cfoutput>"><b>Datos Actuales</b></td></tr>

		<cfoutput>
			<tr class="listaTitulo">
				<cfloop query="rsColumnas">
					<!--- pinta as columnas --->
					<td align="center"><b>#rsColumnas.cnombre#</b></td>
				</cfloop>	
				<td align="center"><b>Fecha</b></td>
				<td align="center"><b>Hora</b></td>
			</tr>
		</cfoutput>
	
	<tr>
		<cfoutput>
		<cfloop query="rsColumnas">
			<cfset columna = "rsDatosActuales." & Trim(rsColumnas.cnombre) >
			<td align="center"><b>#Evaluate(columna)#</b></td>
		</cfloop>
			<td align="center">-</td>
			<td align="center">-</td>
		</cfoutput>
	</tr>
	
	<!--- pinta los datos de la bitacora --->
	<tr><td class="topline" colspan="<cfoutput>#colspan#</cfoutput>">&nbsp;</td></tr>
	<cfoutput>
	<tr><td  class="etiquetas" colspan="<cfoutput>#colspan#</cfoutput>"><b>Modificaciones</b></td></tr>
	<cfoutput>
		<tr class="listaTitulo">
			<cfloop query="rsColumnas">
				<!--- pinta as columnas --->
				<td align="center"><b>#rsColumnas.cnombre#</b></td>
			</cfloop>	
			<td align="center"><b>Fecha</b></td>
			<td align="center"><b>Hora</b></td>
		</tr>
	</cfoutput>
	
	<cfif rsDatos.RecordCount gt 0>
		<cfloop query="rsDatos">
			<tr title="Valor anterior: #rsDatos.DBvalorant#" class=<cfif rsDatos.CurrentRow MOD 2>"lNon"<cfelse>"lPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif rsDatos.CurrentRow MOD 2>##FAFAFA<cfelse>##FFFFFF</cfif>';">
				<!--- actualiza la columna modificada en el arreglo --->
				<cfloop index="i" from="1" to="#ArrayLen(columnas)#">
					<cfif trim(rsDatos.DBcolumna) eq trim(columnas[i][1]) >
						<cfset columnas [i][2] = trim(rsDatos.DBvalorant) >
						<cfset columnas [i][3] = 1 >
					</cfif>
				</cfloop>
	
				<cfloop index="i" from="1" to="#ArrayLen(columnas)#">
					<cfif  columnas[i][3] eq 1 >
						<!---<td align="center"><font color="##FF0000">#columnas[i][2]#</font></td>--->
						<td align="center"><font color="##FF0000" >#rsDatos.DBvalor#</font></td>	
					<cfelse>
						<td align="center">#columnas[i][2]#</td>
					</cfif>
				</cfloop>
				<td align="center">#rsDatos.fecha#</td>
				<td align="center">&nbsp;#TimeFormat(rsDatos.EBfecha,'medium')#</td>
			</tr>
	
			<!--- limpia la posicion 3 del arreglo --->
			<cfloop index="i" from="1" to="#ArrayLen(columnas)#">
				<cfset columnas [i][3] = 0 >
			</cfloop>
	
		</cfloop>
		
		<!--- Datos Iniciales --->
		<tr><td class="topline" colspan="<cfoutput>#colspan#</cfoutput>"><b>&nbsp;Datos Iniciales</b></td></tr>
		<tr>
			<cfloop index="i" from="1" to="#ArrayLen(columnas)#">
				<td align="center">#columnas[i][2]#</td>
			</cfloop>
			<td align="center">-</td>
			<td align="center">-</td>
		</tr>

	<cfelse>
		<tr><td colspan="<cfoutput>#colspan#</cfoutput>"><b>No existen datos</b></td></tr>
	</cfif>	
	</cfoutput>

	<tr><td class="topline" colspan="<cfoutput>#colspan#</cfoutput>">&nbsp;</td></tr>
</table>
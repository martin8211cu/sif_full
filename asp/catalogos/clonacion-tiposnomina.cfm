<cfoutput>
	<table cellpadding="0" cellspacing="0" border="0" width="100%" >
		<tr><td width="10%">&nbsp;</td><td valign="top" align="center">
			<table cellpadding="0" cellspacing="0" border="0" width="100%" >
			<tr>
				<td valign="top">
					<cf_conlis
					campos="Ecodigo,Mcodigo,Tcodigo,Tdescripcion"
					desplegables="N,N,S,S"
					modificables="N,N,S,N"
					size="0,0,10,30"
					title="Tipos de nomina"					
					tabla="TiposNomina a"
					columnas="a.Ecodigo,a.Mcodigo,a.Tcodigo,a.Tdescripcion"
					filtro="a.Ecodigo = #form.EcodigoO#
							order by a.Tcodigo,a.Tdescripcion"
					desplegar="Tcodigo,Tdescripcion"
					filtrar_por="Tcodigo|Tdescripcion"
					filtrar_por_delimiters="|"
					etiquetas="Tcodigo|Tdescripcion"
					formatos="S,S"
					align="left,left"
					asignar="Ecodigo,Tcodigo,Tdescripcion"
					asignarformatos="I,S,S"
					showEmptyListMsg="true"
					EmptyListMsg="-- No hay empleados --"
					tabindex="1"
					form="form1"
					conexion="#form.DSNO#">	
					</td>
					<td><input name="AddTiposNomina" type="submit" value="Agregar" onclick="javascript: if(document.form1.Tcodigo.value == ""){alert('hola'); return false;}else{return true;}"/></td></tr>
				</table>
		</td></tr>
		
		<cfif isdefined('session.listaTiposNomina') and len(trim(session.listaTiposNomina))>
		<tr><td>&nbsp;</td><td align="center">
			<table cellpadding="0" cellspacing="0" border="0" width="100%" >
			<tr><td colspan="2" align="center" style="background-color:##F5F5F5">Lista de Tipos de Nomina</td></tr>
			<cfloop list="#session.listaTiposNomina#" index="item" delimiters=",">
				<cfquery name="rsDat" datasource="minisif">
					select * from TiposNomina
					where Tcodigo = '#trim(item)#'
				</cfquery>
				<tr><td width="75%">
				#rsDat.Tcodigo# #rsDat.Tdescripcion# </td><td><label onclick="javascript: alert('bajo construccion')"><img src="../imagenes/delete.gif"></label>
				</td></tr>
			</cfloop>
			</table>
		</td></tr>
		</cfif>
	</table>
</cfoutput>
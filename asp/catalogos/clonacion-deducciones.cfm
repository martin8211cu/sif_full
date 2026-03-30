<cfoutput>
	<table cellpadding="0" cellspacing="0" border="0" width="100%" >
		<tr><td width="10%">&nbsp;</td><td valign="top" align="center">
			<table cellpadding="0" cellspacing="0" border="0" width="100%" >
			<tr>
				<td valign="top">
					<cf_conlis
					campos="Ecodigo,TDid,TDcodigo,TDdescripcion"
					desplegables="N,N,S,S"
					modificables="N,N,S,N"
					size="0,0,10,30"
					title="Tipos de Deducciones"					
					tabla="TDeduccion a"
					columnas="a.Ecodigo,a.TDcodigo,a.TDid,a.TDdescripcion"
					filtro="a.Ecodigo = #form.EcodigoO#
							order by a.TDcodigo,a.TDdescripcion"
					desplegar="TDcodigo,TDdescripcion"
					filtrar_por="TDcodigo|TDdescripcion"
					filtrar_por_delimiters="|"
					etiquetas="Codigo,Descripcion"
					formatos="S,S"
					align="left,left"
					asignar="Ecodigo,TDcodigo,TDdescripcion"
					asignarformatos="I,S,S"
					showEmptyListMsg="true"
					EmptyListMsg="-- No hay empleados --"
					tabindex="1"
					form="form1"
					conexion="#form.DSNO#">	
					</td>
					<td><input name="AddDeduccion" type="submit" value="Agregar" onclick="javascript: if(document.form1.TDid.value == ""){return false;}else{return true;}"/></td></tr>
				</table>
		</td></tr>
		
		<cfif isdefined('session.listaDeducciones') and len(trim(session.listaDeducciones))>
		<tr><td>&nbsp;</td><td align="center">
			<table cellpadding="0" cellspacing="0" border="0" width="100%" >
			<tr><td colspan="2" align="center" style="background-color:##F5F5F5">Lista de Empleados</td></tr>
			<cfloop list="#session.listaDeducciones#" index="item" delimiters=",">
				<cfquery name="rsDat" datasource="minisif">
					select * from TDeduccion
					where TDid	= #item#
				</cfquery>
				<tr><td width="75%">
				#rsDat.TDcodigo# #rsDat.TDdescripcion# </td><td><label onclick="javascript: alert('bajo construccion')"><img src="../imagenes/delete.gif"></label>
				</td></tr>
			</cfloop>
			</table>
		</td></tr>
		</cfif>
	</table>
</cfoutput>
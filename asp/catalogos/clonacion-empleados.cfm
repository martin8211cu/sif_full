<cfoutput>
	<table cellpadding="0" cellspacing="0" border="0" width="100%" >
		<tr><td width="10%">&nbsp;</td><td valign="top" align="center">
			<table cellpadding="0" cellspacing="0" border="0" width="100%" >
			<tr>
				<td valign="top">
					<cf_conlis
						campos="DEid,DEidentificacion,DEnombre,DEapellido1,DEapellido2"
						desplegables="N,S,S,N,N"
						modificables="N,S,N,N,N"
						size="0,20,20,20,0"
						title="No hay listas"					
						tabla="DatosEmpleado a"
						columnas="a.Ecodigo,a.DEidentificacion,a.DEid,a.DEapellido1+' '+a.DEapellido2 +', '+a.DEnombre as DEnombre"
						filtro="a.Ecodigo = #form.EcodigoO#
								order by a.DEapellido1,a.DEapellido2,a.DEnombre"
						desplegar="DEidentificacion,DEnombre"
						filtrar_por="DEidentificacion|DEnombre"
						filtrar_por_delimiters="|"
						etiquetas="Identificacion|Nombre"
						formatos="S,S"
						align="left,left"
						asignar="DEid,DEidentificacion,DEnombre"
						asignarformatos="I,S,S"
						showEmptyListMsg="true"
						EmptyListMsg="-- No hay empleados --"
						tabindex="1"
						form="form1"
						conexion="#form.DSNO#">	
					</td>
					<!---<td><input name="AddEmpleado" type="submit" value="Agregar" onclick="javascript: if(document.form1.DEid.value == ""){alert('hola'); return false;}else{return true;}"/></td></tr>--->
				</table>
		</td></tr>
		
		<cfif isdefined('session.listaEmpleados') and len(trim(session.listaEmpleados))>
		<tr><td>&nbsp;</td><td align="center">
			<table cellpadding="0" cellspacing="0" border="0" width="100%" >
			<tr><td colspan="2" align="center" style="background-color:##F5F5F5">Lista de Empleados</td></tr>
			<cfloop list="#session.listaEmpleados#" index="item" delimiters=",">
				<cfquery name="rsDat" datasource="minisif">
					select * from DatosEmpleado
					where DEid	= #item#
				</cfquery>
				<tr><td width="75%">
				#rsDat.DEidentificacion# #rsDat.DEnombre# #rsDat.DEapellido1# #rsDat.DEapellido2# </td><td><label onclick="javascript: alert('bajo construccion')"><img src="../imagenes/delete.gif"></label>
				</td></tr>
			</cfloop>
			</table>
		</td></tr>
		</cfif>
	</table>
</cfoutput>
<cfquery datasource="#session.tramites.dsn#" name="persona" maxrows="1">
	select p.identificacion_persona, p.nombre, p.apellido1, p.apellido2
	from TPFuncionario f
			join TPPersona p
				on p.id_persona = f.id_persona
	where f.id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_funcionario#">
</cfquery>

<cfquery datasource="#session.tramites.dsn#" name="ventanilla" maxrows="1">
	select 
		i.codigo_inst, i.nombre_inst,
		s.codigo_sucursal, s.nombre_sucursal,
		v.codigo_ventanilla, v.nombre_ventanilla
	from TPVentanilla v
		join TPSucursal s
			on s.id_sucursal = v.id_sucursal
			join TPInstitucion i
				on i.id_inst = s.id_inst
	where v.id_ventanilla = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_ventanilla#">
</cfquery>

<table width="400" border="0">
  <tr>
    <td colspan="3">Ventanilla de tr&aacute;mites </td>
  </tr>
  <cfoutput query="ventanilla">
  <tr>
    <td width="60">&nbsp;</td>
    <td colspan="2">#HTMLEditFormat(codigo_inst)# - #HTMLEditFormat(nombre_inst)#</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="2">
	#HTMLEditFormat(codigo_sucursal)# - #HTMLEditFormat(nombre_sucursal)#
	|
	#HTMLEditFormat(codigo_ventanilla)# - #HTMLEditFormat(nombre_ventanilla)#
	</td>
  </tr></cfoutput>
  <tr>
    <td>&nbsp;</td>
    <td colspan="2"><cfoutput query="persona">
		#HTMLEditFormat(identificacion_persona)# #HTMLEditFormat(nombre)#
		#HTMLEditFormat(apellido1)#
		#HTMLEditFormat(apellido2)#
	</cfoutput></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td width="195">&nbsp;</td>
    <td width="131">&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
	<form action="" method="get">
	<input type="hidden" name="loc" value="gestion">
	<input type="submit" value="Gestionar tr&aacute;mites  &gt;&gt;" style="width:200px">
	</form></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
	<form action="" method="get">
	<input type="hidden" name="loc" value="hist">
	<input type="submit" value="Tr&aacute;mites realizados &gt;&gt;" style="width:200px">
	</form></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
	<form action="" method="post">
	<input type="hidden" name="loc" value="ventanilla_cerrar"><input type="submit" value="Cerrar Ventanilla &gt;&gt;" style="width:200px">
	</form>
	</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>

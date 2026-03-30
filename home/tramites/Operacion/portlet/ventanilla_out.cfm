<cfquery datasource="#session.tramites.dsn#" name="funcionario" maxrows="1">
	select f.id_funcionario, 
		p.identificacion_persona,
		p.nombre, p.apellido1, p.apellido2
	from TPFuncionario f
		join TPPersona p
			on p.id_persona = f.id_persona
	where p.identificacion_persona = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.datos_personales.id#">
</cfquery>

<cfquery datasource="#session.tramites.dsn#" name="ventanilla">
	select v.id_ventanilla,
		i.codigo_inst, i.nombre_inst,
		s.codigo_sucursal, s.nombre_sucursal,
		v.codigo_ventanilla, v.nombre_ventanilla,
		rel.ventanilla_default
	from TPRFuncionarioVentanilla rel
		join TPVentanilla v
			on v.id_ventanilla = rel.id_ventanilla
		join TPSucursal s
			on s.id_sucursal = v.id_sucursal
		join TPInstitucion i
			on i.id_inst = s.id_inst
	where rel.id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#funcionario.id_funcionario#">
	order by 
		i.codigo_inst, i.nombre_inst,
		s.codigo_sucursal, s.nombre_sucursal,
		v.codigo_ventanilla, v.nombre_ventanilla
</cfquery>

<form name="form1" method="post" action="" >
	<input type="hidden" name="id_ventanilla" value="<cfoutput>#ventanilla.id_ventanilla#</cfoutput>">
<!---
  <table>
    <tr>
      <td>Funcionario</td>
      <td><cfoutput>#HTMLEditFormat(funcionario.identificacion_persona)#
	  	#HTMLEditFormat(funcionario.nombre)#
		#HTMLEditFormat(funcionario.apellido1)#
		#HTMLEditFormat(funcionario.apellido2)#
	  </cfoutput>
	  </td>
    </tr>
    <tr>
      <td>Ventanilla</td>
      <td><select name="id_ventanilla">
	  <cfoutput query="ventanilla" group="codigo_inst">
		  <cfoutput group="codigo_sucursal">
			  <optgroup label="#HTMLEditFormat(codigo_inst)# #HTMLEditFormat(nombre_inst)# - #HTMLEditFormat(codigo_sucursal)# #HTMLEditFormat(nombre_sucursal)#">
			  <cfoutput>
				<option value="#HTMLEditFormat(id_ventanilla)#" <cfif ventanilla_default EQ 1> selected </cfif>>#HTMLEditFormat(codigo_ventanilla)# - #HTMLEditFormat(nombre_ventanilla)#</option>
			  </cfoutput>
			  </optgroup>
		  </cfoutput>
	  </cfoutput>
      </select></td>
    </tr>
    <tr>
      <td>Contrase&ntilde;a</td>
      <td><input type="password" name="password"></td>
    </tr>
    <tr>
      <td></td>
      <td><input type="submit" name="Submit" value="Ingresar"></td>
    </tr>
	<cfparam name="error_message" default="">
	<cfif Len(error_message)>
		<tr>
		  <td></td>
		  <td bgcolor="red" style="background-color:red;color:white;font-weight:bold">
		  <cfoutput>
		  #HTMLEditFormat(error_message)#</cfoutput></td>
		 </tr>
	 </cfif>
  </table>
  --->
</form>
<script type="text/javascript" language="javascript1.2">
	document.form1.submit();
</script>

<cf_template>
<cf_templatearea name="title">
	Afiliaci&oacute;n a programas
</cf_templatearea>
<cf_templatearea name="body">


<cfparam name="url.id_programa">
<cfparam name="url.id_vigencia">
<cfparam name="url.id_persona" default="">


<cfquery datasource="#session.dsn#" name="progs">
	select 
		p.id_programa, p.nombre_programa,
		v.id_vigencia, v.nombre_vigencia, v.costo, v.periodicidad, v.tipo_periodo,
		v.fecha_desde, v.fecha_hasta, v.cantidad_carnes, v.generar_carnes
	from sa_programas p
		join sa_vigencia v
			on p.id_programa = v.id_programa
	where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and p.id_programa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_programa#">
	  and v.id_programa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_programa#">
	  and v.id_vigencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_vigencia#">
</cfquery>


<cfquery datasource="#session.dsn#" name="lista">
	select
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_programa#" > as id_programa,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_vigencia#" > as id_vigencia,
		fam.id_persona, fam.Pnombre, fam.Papellido1, fam.Papellido2, fam.Pid
	from sa_afiliaciones p
		join sa_personas fam
			on fam.id_persona = p.id_persona
	where p.id_programa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_programa#">
	  and p.id_vigencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_vigencia#">
	  and p.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>


<cfquery datasource="#session.dsn#" name="afiliado_edit">
	select fam.id_persona, fam.Pnombre, fam.Papellido1, fam.Papellido2, fam.Pid, fam.Psexo
	from sa_afiliaciones p
		join sa_personas fam
			on fam.id_persona = p.id_persona
	where p.id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_persona#" null="#Len(url.id_persona) Is 0#">
	  and p.id_programa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_programa#">
	  and p.id_vigencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_vigencia#">
	  and p.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>

	<cfset navegacion=ListToArray('index.cfm,Registro de Programas;sa_programas.cfm?id_programa=#URLEncodedFormat(url.id_programa)#,#progs.nombre_programa#;sa_vigencia.cfm?id_programa=#URLEncodedFormat(url.id_programa)#&id_vigencia=#URLEncodedFormat(url.id_vigencia)#,#progs.nombre_vigencia#;javascript:void(0),Afiliación',';')>
	<cfinclude template="../../pNavegacion.cfm">


<cfoutput>
	
	<script type="text/javascript" src="../personas/personas.js"></script>
	<script type="text/javascript">
	<!--
		function funcRegresar(){
			location.href='sa_vigencia.cfm?id_programa=#JSStringFormat(URLEncodedFormat(url.id_programa))#&id_vigencia=#JSStringFormat(URLEncodedFormat(url.id_vigencia))#';
		}
		function validar(obj){
			return true;
		}
	//-->
	</script>
	
			<table width="559" cellpadding="2" cellspacing="2" summary="Tabla de entrada">
			<tr>
			  <td colspan="4" class="subTitulo">
			Afiliar a un Programa </td>
			  </tr>
				<tr>
				  <td width="140" align="left" nowrap>Programa</td>
				  <td width="391" colspan="3" valign="top">#progs.nombre_programa# #progs.nombre_vigencia#</td>
			  </tr>
				<tr>
				  <td align="left" nowrap>Periodo</td>
				  <td colspan="3" valign="top">#DateFormat(progs.fecha_desde,'dd/mm/yyyy')# - #DateFormat(progs.fecha_hasta,'dd/mm/yyyy')#</td>
			  </tr>
				<tr>
				  <td align="left" nowrap>Costo</td>
				  <td colspan="3" valign="top">#NumberFormat(progs.costo,',0.00')#                      <cfif progs.tipo_periodo is 'U'>
    Pago &Uacute;nico
    <cfelseif progs.tipo_periodo is 'S'>
    <cfif progs.periodicidad is 1>
      Cada Semana
        <cfelse>
      Cada #progs.periodicidad# Semanas
    </cfif>
    <cfelseif progs.tipo_periodo is 'S'>
    <cfif progs.periodicidad is 1>
      Cada Mes
        <cfelse>
      Cada #progs.periodicidad# Meses
    </cfif>
</cfif>				  </td>
</tr>
                <tr>
                  <td align="left">Carn&eacute;s / Entradas </td>
                  <td colspan="3" align="left">
				  <cfif progs.generar_carnes>
				  #progs.cantidad_carnes#
				  <cfelse>No se utilizan
				  </cfif></td>
                </tr> 
                  <tr>
                    <td colspan="4" class="subTitulo">Afiliados </td>
                  </tr>
                <tr>
                  <td colspan="4" ><cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#lista#"
			desplegar="Papellido1,Papellido2,Pnombre,Pid"
			etiquetas="Apellido Paterno,Materno,Nombre,C&eacute;dula"
			formatos="S,S,S,S"
			align="left,left,left,left"
			ira="afiliados.cfm"
			form_method="get"
			keys="id_programa,id_vigencia,id_persona"
			mostrar_filtro="yes"
			botones="" />	</td>
                </tr>
                  <tr>
                    <td colspan="4" class="subTitulo">Nuevo Afiliado </td>
                  </tr>
                  <tr>
                    <td colspan="4" >	<form style="margin:0 " action="afiliados_agregar.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
<table cellpadding="2" cellspacing="0" width="100%" summary="Tabla de entrada">
                    <tr class="tituloListas">
                      <td valign="top">C&eacute;dula</td>
                      <td valign="top">Nombre </td>
                      <td colspan="2" valign="top">Apellidos</td>
                      <td valign="top">Sexo</td>
                      <td valign="top">Foto</td>
                    </tr>
                    <tr>
                      <td valign="top">
					  <input name="Pid" id="Pid" type="text" style="width:90px"  
					  value="#HTMLEditFormat(afiliado_edit.Pid)#"
						maxlength="60" onBlur="blur_cedula(this)" onChange="reset_persona_nueva(this.form)" 
						onFocus="this.select()" ></td>
                      <td valign="top"><input name="Pnombre" id="Pnombre" type="text" style="width:75px"  
					  value="#HTMLEditFormat(afiliado_edit.Pnombre)#"
						maxlength="60" onBlur="blur_nombre(this.form)" onChange="reset_persona_nueva(this.form)" 
						onFocus="this.select()"  ></td>
                      <td valign="top"><input name="Papellido1" id="Papellido1" type="text" style="width:75px" 
					  value="#HTMLEditFormat(afiliado_edit.Papellido1)#"
						maxlength="60" onBlur="blur_nombre(this.form)" onChange="reset_persona_nueva(this.form)" 
						onFocus="this.select()"  ></td>
                      <td valign="top"><input name="Papellido2" id="Papellido2" type="text" style="width:75px"  
					  value="#HTMLEditFormat(afiliado_edit.Papellido2)#"
						maxlength="60" onBlur="blur_nombre(this.form)" onChange="reset_persona_nueva(this.form)" 
						onfocus="this.select()"  >
                      </td>
                      <td valign="top"><select name="Psexo" id="Psexo">
					  <option value="">&nbsp;</option>
					  <option value="M" <cfif afiliado_edit.Psexo is 'M'>selected</cfif>>Masculino</option>
					  <option value="F" <cfif afiliado_edit.Psexo is 'F'>selected</cfif>>Femenino</option>
					  </select></td>
                      <td><input type="file" name="foto" style="width:75px" size="5" onChange="(document.all?document.all.new_image_loader:document.getElementById('new_image_loader')).src = this.value">
                      </td>
                    </tr>
                    <tr>
                      <td valign="top" colspan="2"><input type="submit" name="btnAgregar" value="Afiliar">
                  &nbsp;<input type="button" name="btnBuscar" value="Buscar" onClick="location.href='afiliados_buscar.cfm?id_programa=#URLEncodedFormat(url.id_programa)#&id_vigencia=#URLEncodedFormat(url.id_vigencia)#'"></td>
                      <td colspan="3" rowspan="2" valign="top"><input id="buscar_status" style="background-color:inherit;color:inherit;border-style:none" name="buscar_status" value="" type="text" readonly="" size="40" >
					  <iframe src="about:blank" name="frame_buscar_persona" style="display:none" id="frame_buscar_persona" frameborder="0" width="0" height="0"></iframe>
					  </td>
                      <td rowspan="2"><img src="blank.gif" height="100" width="85" border="0" name="new_image_loader" id="new_image_loader"></td>
                    </tr>
                    <tr>
                      <td valign="top" colspan="2"><span class="formButtons">
                        <input type="button" name="btnRegresar" value="&lt;&lt; Regresar" onClick="funcRegresar()">
                      </span></td>
                    </tr>
                  </table>
				  
				  
<input type="hidden" name="id_programa" value="#HTMLEditFormat(progs.id_programa)#">
<input type="hidden" name="id_vigencia" value="#HTMLEditFormat(progs.id_vigencia)#">
<input type="hidden" name="id_persona" value="#HTMLEditFormat(afiliado_edit.id_persona)#">

</form>
				  </td>
                  </tr>

</table>
</cfoutput>	
	<script type="text/javascript">
	<!--
		document.form1.pariente = document.form1.id_persona;
	//-->
	</script>


</cf_templatearea>
</cf_template>



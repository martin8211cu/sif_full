<cf_templateheader title="Consulta de Permisos por Usuario">
    <cf_web_portlet_start border="true" titulo="Consulta de Permisos por Usuario" >
        <form style="margin:0" action="permisosUsuario.cfm" method="post" name="form1" id="form1" onsubmit="return validar();" >
        <table align="center" border="0" cellspacing="0" cellpadding="4" width="90%" >
            <tr>
                <td align="right" valign="middle" width="1" nowrap="nowrap"><strong>Empresa:</strong></td>
                <td>
                    <cfquery name="rsEmpresa" datasource="asp">
                        select Ecodigo as Ecodigo, Enombre as Enombre
                        from Empresa
                        where CEcodigo=#session.CEcodigo#
                        order by Enombre
                    </cfquery>
                    <select name="empresa">
                        <option value="">-Todos-</option>
                        <cfloop query="rsEmpresa">
                            <cfoutput><option value="#rsEmpresa.Ecodigo#">#rsEmpresa.Enombre#</option></cfoutput>
                        </cfloop>
                    </select>
                </td>
            </tr>
            <tr>
            	<td>&nbsp;</td>
                <td colspan="1">
                    <table width="100%" cellpadding="0" cellspacing="0">
                        <tr>
                            <td valign="middle" width="1%"><input type="radio" name="opcion" value="rol" checked onClick="javascript:mostrar(this);"></td>
                            <td valign="middle">Consultar por grupos de permisos</td>
                        </tr>
                        <tr>
                            <td valign="middle"><input type="radio" name="opcion" value="sistema" onClick="javascript:mostrar(this);"></td>
                            <td valign="middle">Consultar por Sistema/M&oacute;dulos/Procesos</td>
                        </tr>
    
                    </table>
                </td>
            </tr>
    
            <tr>
                <td align="right" valign="middle" ><strong>Sistema:</strong></td>
                <td>
                    <cf_conlis
                        campos="SScodigo,SSdescripcion"
                        desplegables="S,S"
                        modificables="S,N"
                        size="10,40"
                        title="Lista de Sistemas"
                        tabla="SSistemas ss"
                        columnas="ss.SScodigo,ss.SSdescripcion"
                        filtro="exists(	select  mce.SScodigo 
                                        from ModulosCuentaE mce
                                        inner join SSistemas s
                                        on s.SScodigo=mce.SScodigo
                                        where CEcodigo=#session.CEcodigo#
                                        and mce.SScodigo= ss.SScodigo)"
                        desplegar="SScodigo,SSdescripcion"
                        filtrar_por="ss.SScodigo,ss.SSdescripcion"
                        etiquetas="C&oacute;digo,Descripci&oacute;n"
                        formatos="S,S"
                        align="left,left"
                        asignar="SScodigo,SSdescripcion"
                        asignarformatos="S, S"
                        showEmptyListMsg="true"
                        EmptyListMsg="-- No se encontraron Sistemas--"
                        tabindex="1"
                        conexion="asp"
                        alt="Sistema,Sistema">
                </td>
            </tr>
    
            <tr >
                <td align="right" valign="middle" id="tr_rol1"><strong>Grupo de Permisos:</strong></td>
                <td id="tr_rol2">
                    <cf_conlis
                        campos="SRcodigo,SRdescripcion"
                        desplegables="S,S"
                        modificables="S,N"
                        size="10,40"
                        title="Lista de Grupos de Permisos"
                        tabla="SRoles"
                        columnas="SRcodigo,SRdescripcion"
                        filtro="SScodigo=$SScodigo,varchar$"
                        desplegar="SRcodigo,SRdescripcion"
                        filtrar_por="SRcodigo,SRdescripcion"
                        etiquetas="C&oacute;digo,Descripci&oacute;n"
                        formatos="S,S"
                        align="left,left"
                        asignar="SRcodigo,SRdescripcion"
                        asignarformatos="S, S"
                        showEmptyListMsg="true"
                        EmptyListMsg="-- No se encontraron Grupos de Permisos--"
                        tabindex="1"
                        conexion="asp">
                </td>
            </tr>
    
            <tr >
                <td align="right" valign="middle" id="tr_modulo1" ><strong>M&oacute;dulo:</strong></td>
                <td id="tr_modulo2">
                    <cf_conlis
                        campos="SMcodigo,SMdescripcion"
                        desplegables="S,S"
                        modificables="S,N"
                        size="10,40"
                        title="Lista de M&oacute;dulos"
                        tabla="SModulos"
                        columnas="SMcodigo,SMdescripcion"
                        filtro="SScodigo=$SScodigo,varchar$"
                        desplegar="SMcodigo,SMdescripcion"
                        filtrar_por="SMcodigo,SMdescripcion"
                        etiquetas="C&oacute;digo,Descripci&oacute;n"
                        formatos="S,S"
                        align="left,left"
                        asignar="SMcodigo,SMdescripcion"
                        asignarformatos="S, S"
                        showEmptyListMsg="true"
                        EmptyListMsg="-- No se encontraron M&oacute;dulos--"
                        tabindex="1"
                        conexion="asp">
                </td>
            </tr>
    
            <tr >
                <td align="right" valign="middle" id="tr_proceso2" ><strong>Proceso:</strong></td>
                <td id="tr_proceso1">
                    <cf_conlis
                        campos="SPcodigo,SPdescripcion"
                        desplegables="S,S"
                        modificables="S,N"
                        size="10,40"
                        title="Lista de Procesos"
                        tabla="SProcesos"
                        columnas="SPcodigo,SPdescripcion"
                        filtro="SScodigo=$SScodigo,varchar$ and SMcodigo=$SMcodigo,varchar$"
                        desplegar="SPcodigo,SPdescripcion"
                        filtrar_por="SPcodigo,SPdescripcion"
                        etiquetas="C&oacute;digo,Descripci&oacute;n"
                        formatos="S,S"
                        align="left,left"
                        asignar="SPcodigo,SPdescripcion"
                        asignarformatos="S, S"
                        showEmptyListMsg="true"
                        EmptyListMsg="-- No se encontraron Procesos--"
                        tabindex="1"
                        conexion="asp">
                </td>
            </tr>                
            <tr>	
                <td align="right" valign="middle" width="40%"><strong>Estado del Usuario:</strong></td>
                <td>
                    <select name="Uestado">
                        <option value="">--Todos--</option>
                        <option value="A">Activo</option>
                        <option value="I">Inactivo</option>
                        <option value="T">Temporal</option>
                    </select>
                </td>
			</tr>
            <tr>
                <td colspan="3" align="center"><input type="submit" name="btnConsultar" value="Consultar" class="btnConsulta" /></td>
            </tr>
        </table>
    </form>
    <cf_web_portlet_end>
<cf_templatefooter>
<script type="text/javascript" language="javascript1.2">
	function validar(){
		if (document.form1.SScodigo.value == ''){
			alert('Se presentaron los siguientes erorres:\n - El campo Sistema es requerido.');
			return false
		}
		return true;
	}
	
	function mostrar(obj){
		if (obj.value == 'rol'){
			document.getElementById('tr_rol1').style.display = '';
			document.getElementById('tr_rol2').style.display = '';
			document.getElementById('tr_modulo1').style.display = 'none';
			document.getElementById('tr_modulo2').style.display = 'none';
			document.getElementById('tr_proceso1').style.display = 'none';
			document.getElementById('tr_proceso2').style.display = 'none';
		}
		else{
			document.getElementById('tr_rol1').style.display = 'none';
			document.getElementById('tr_rol2').style.display = 'none';
			document.getElementById('tr_modulo1').style.display = '';
			document.getElementById('tr_modulo2').style.display = '';
			document.getElementById('tr_proceso1').style.display = '';
			document.getElementById('tr_proceso2').style.display = '';
		}
	}
	mostrar(document.form1.opcion[0])
</script>

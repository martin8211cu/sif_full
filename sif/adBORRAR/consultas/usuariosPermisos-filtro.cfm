<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cf_templateheader title="Consulta de Permisos por Usuario">
    <cf_web_portlet_start border="true" titulo="Consulta de Permisos por Usuario" >
    <form style="margin:0" action="usuariosPermisos.cfm" method="post" name="form1" id="form1" onsubmit="return validar();" >
    <table align="center" border="0" cellspacing="0" cellpadding="4" width="100%" >
        <tr>
            <td align="right" valign="middle" width="40%"><strong>Empresa:</strong></td>
            <td>
                <cfquery name="rsEmpresa" datasource="asp">
                    select Ecodigo as Ecodigo, Enombre
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
            <td align="right" valign="middle" width="40%"><strong>Usuario inicial:</strong></td>
            <td>
            <cf_dbfunction name="concat" args="dp.Pnombre, ' ',dp.Papellido1,' ',dp.Papellido2" returnvariable="Lvarnombre">
                <cf_conlis
                    campos="Usucodigo,Usulogin,nombre"
                    desplegables="N,S,S"
                    modificables="N,S,N"
                    size="0,10,40"
                    title="Lista de Usuarios"
                    tabla="Usuario u
                        inner join DatosPersonales dp
                        on dp.datos_personales=u.datos_personales"
                    columnas="u.Usucodigo,dp.Pid as Usulogin, 
                        #Lvarnombre# as nombre"
                    filtro="u.Utemporal = 0
                        and u.Uestado=1
                        and u.CEcodigo=#session.CEcodigo#
                        order by u.Usulogin"
                    desplegar="Usulogin,nombre"
                    filtrar_por="dp.Pid| dp.Papellido1 #_Cat# ' ' #_Cat# dp.Papellido2 #_Cat# ' ' #_Cat# dp.Pnombre"
                    filtrar_por_delimiters="|"
                    etiquetas="Identificaci&oacute;n,Usuario"
                    formatos="S,S"
                    align="left,left"
                    asignar="Usucodigo,Usulogin,nombre"
                    asignarformatos="S, S, S"
                    showEmptyListMsg="true"
                    EmptyListMsg="-- No se encontraron usuarios--"
                    tabindex="1"
                    conexion="asp">
            </td>
        </tr>

        <tr>
            <td align="right" valign="middle" width="40%"><strong>Usuario final:</strong></td>
            <td>
            <cf_dbfunction name="concat" args="dp.Pnombre,'  ',dp.Papellido1, ' ', dp.Papellido2" returnvariable="Lvarnombre2">
                <cf_conlis
                    campos="Usucodigo2,Usulogin2,nombre2"
                    desplegables="N,S,S"
                    modificables="N,S,N"
                    size="0,10,40"
                    title="Lista de Usuarios"
                    tabla="Usuario u
                        inner join DatosPersonales dp
                        on dp.datos_personales=u.datos_personales"
                    columnas="u.Usucodigo as usucodigo2,dp.Pid as usulogin2, #Lvarnombre2# as nombre2"
                    filtro="u.Utemporal = 0
                        and u.Uestado=1
                        and u.CEcodigo=#session.CEcodigo#
                        order by u.Usulogin	"
                    desplegar="Usulogin2,nombre2"
                    filtrar_por="dp.Pid| dp.Papellido1 #_Cat# ' ' #_Cat# dp.Papellido2 #_Cat#  ' ' #_Cat# dp.Pnombre"
                    filtrar_por_delimiters="|"
                    etiquetas="Identificaci&oacute;n,Usuario"
                    formatos="S,S"
                    align="left,left"
                    asignar="Usucodigo2,Usulogin2,nombre2"
                    asignarformatos="S, S, S"
                    showEmptyListMsg="true"
                    EmptyListMsg="-- No se encontraron usuarios--"
                    tabindex="1"
                    conexion="asp">
            </td>
        </tr>

        <tr>
            <td align="right" valign="middle" width="40%"><strong>Sistema:</strong></td>
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
            <td colspan="4" align="center"><input type="submit" name="btnConsultar" value="Consultar" class="btnConsulta" /></td>
        </tr>
        </table>
    </form>
    <cf_web_portlet_end>
    
    <script type="text/javascript" language="javascript1.2">
        function validar(){
            if ( document.form1.Usulogin.value == '' && document.form1.Usulogin2.value == '' ){
                alert('Se presentaron los siguientes errores:\n - Debe especificar al menos un usuario')
                return false;
            }
            return true;
        }
    </script>
<cf_templatefooter>
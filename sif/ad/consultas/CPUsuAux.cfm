<!--********************************--->
<!--***    Diseño: ANDRES LARA   ***--->
<!--***    FECHA: 6/01/2014      ***--->
<!--*******************************---->

<!---ETIQUETAS--->
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Emp" default="Empresa" returnvariable="LB_Emp" xmlfile="CPUsuAux.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Usu" default="Usuario" returnvariable="LB_Usu" xmlfile="CPUsuAux.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mdl" default="Módulo"  returnvariable="LB_Mdl" xmlfile="CPUsuAux.xml"/>
<!--- ******  --->

<!---HEADER--->
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cf_templateheader title="Consulta Permisos de Usuario por Auxiliar">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Consulta Permisos de Usuario por Auxiliar">

<!---Querys--->
	<cfquery name="rsEmpresa" datasource="asp">
        select Ecodigo as Ecodigo, Enombre,Ereferencia
        from Empresa
        where CEcodigo=#session.CEcodigo#
        order by Enombre
    </cfquery>

<!---  AREA DE PINTADO  --->
<cfoutput>
<form action="CPUsuAuxR.cfm" method="post" name="form1" onsubmit ="return validarCampos();">
	<cfoutput>				  
		<table width="100%" border="0">
			<tr>
				<td align="right" valign="middle" width="30%"><strong>#LB_Emp#:</strong></div></td>
				<td>
	                <select name="empresa">
	                    <!---option value="">-Todos-</option--->
	                    <cfloop query="rsEmpresa">	                     
	                        	<option value="#rsEmpresa.Ereferencia#" <cfif rsEmpresa.Ereferencia eq session.Ecodigo>selected</cfif>>#rsEmpresa.Enombre#</option>	
	                    </cfloop>
	                </select>
				</td>
			</tr>
			
			<tr>	
				<td align="left" nowrap="nowrap"><div align="right"><strong>#LB_Usu#:</strong></div></td>
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
                    columnas="u.Usucodigo,u.Usulogin,
                        #Lvarnombre# as nombre"
                    filtro="u.CEcodigo=#session.CEcodigo#
                        order by u.Usulogin"
                    desplegar="Usulogin,nombre"
                    filtrar_por="dp.Pid| dp.Papellido1 #_Cat# ' ' #_Cat# dp.Papellido2 #_Cat# ' ' #_Cat# dp.Pnombre"
                    filtrar_por_delimiters="|"
                    etiquetas="Login,Usuario"
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
				<td align="left" nowrap="nowrap"><div align="right"><strong>#LB_Mdl#:</strong></div></td>
				<td>
					<!---Pinta La Oficina Inicial--->
					<select name="Modulo" tabindex="1">
						<option value="TODOS">--- Todos ---</option>
						<option value="Activo Fijo">Activo Fijo</option>					
						<option value="Compras">Compras</option>
						<option value="Contratos">Contratos</option>					
						<option value="Inventario">Inventario</option>
						<option value="Presupuesto">Presupuesto</option>
						<option value="Tesoreria">Tesoreria</option>						
					</select>
				</td>				
			</tr>
				
			<tr>
				<td align="center" valign="top" colspan="4">
					<cf_botones values="Consultar,Limpiar"  tabindex="2">
				</td>
			</tr>
		</table>
	</cfoutput>
</form>
</cfoutput>

<script>

function validarCampos(){
	if ( document.form1.Usulogin.value == ''){
            alert('Se presentaron los siguientes errores:\n - Debe especificar un usuario')
              return false;
        }
    return true;    
}

</script>

<cf_web_portlet_end>
<cf_templatefooter>


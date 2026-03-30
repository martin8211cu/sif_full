<!--- VARIABLES DE TRADUCCION --->

<script language="javascript" type="text/javascript">
</script>

<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripción"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Desde"
	Default="Desde"
	returnvariable="LB_Desde"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Hasta"
	Default="Hasta"
	returnvariable="LB_Hasta"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NOSEHAREGISTRADONINGUNAVALORACION"
	Default="NO SE HA REGISTRADO NINGUNA VALORACION"
	returnvariable="MSG_NOSEHAREGISTRADONINGUNAVALORACION"/>

<cfoutput><form name="listaValoraciones" action="#GetFileFromPath(GetTemplatePath())#" method="post"></cfoutput>
<table width="85%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr>
    	<td>
			<cfinvoke 
				 component="rh.Componentes.pListas"
				 method="pListaRH"
				 returnvariable="pListaRHRet">
					<cfinvokeargument name="tabla" value="RHValoracionPuesto a"/>
					<cfinvokeargument name="columnas" value="RHVPid,RHVPdescripcion,RHVPfdesde,RHVPfdesde"/>
					<cfinvokeargument name="desplegar" value="RHVPdescripcion,RHVPfdesde,RHVPfdesde"/>
					<cfinvokeargument name="etiquetas" value="#LB_Descripcion#,#LB_Desde#,#LB_Hasta#"/>
					<cfinvokeargument name="formatos" value="S, D, D"/>
					<cfinvokeargument name="filtro" value="a.Ecodigo = #session.Ecodigo# #filtro#"/>
					<cfinvokeargument name="align" value="left,center,center"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="registro_valoracion.cfm"/>
					<cfinvokeargument name="keys" value="RHVPid">
					<cfinvokeargument name="formName" value="listaValoraciones">
					<cfinvokeargument name="incluyeform" value="false">
					<cfinvokeargument name="showEmptyListMsg" value="true">
					<cfinvokeargument name="EmptyListMsg" value="*** #MSG_NOSEHAREGISTRADONINGUNAVALORACION# ***">
					<cfinvokeargument name="navegacion" value="#navegacion#">
		  </cfinvoke>
		</td>
	</tr>
	<tr>
		<td>
			<cf_botones names="Nuevo" values="Nuevo" nbspbefore="4" nbspafter="4">
		</td>
	</tr>
</table>
</form>

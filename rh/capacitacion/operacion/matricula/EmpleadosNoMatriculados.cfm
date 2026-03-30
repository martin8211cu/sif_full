<cfquery name="rsEmpleados" datasource="#session.DSN#">
	select de.DEidentificacion,{fn concat({fn concat({fn concat({fn concat(de.DEapellido1 , ' ' )}, de.DEapellido2 )}, ' ' )}, de.DEnombre )} as NombreCompleto
	from RHRelacionCap e
		join RHDRelacionCap rc
			on rc.RHRCid = e.RHRCid
		join RHCursos c
			on c.RHCid = e.RHCid
		join DatosEmpleado de
			on de.DEid = rc.DEid
	where rc.RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHRCid#">
	  and e.RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHRCid#">
	  and rc.DEid in (#url.DEidMatr#)
	  order by de.DEapellido1,de.DEapellido2,de.DEnombre
</cfquery>


<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificaci&oacute;n"
	returnvariable="LB_Identificacion"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_NombreCompleto"
	Default="Nombre Completo"
	returnvariable="LB_NombreCompleto"/>

<script>
	function funcCerrar(){
		window.close;
	}
</script>
<title><cf_translate key="LB_EmpleadosNoMatriculados"> Empleados no Matriculados</cf_translate></title>	
<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td  align="center">
			<strong><cf_translate key="LB_ListaDeEmpleadosNoMatriculados">Lista de Empleados no Matriculados</cf_translate></strong>
		</td>
	</tr>
	<tr>
		<td>
			<cfinvoke 
			 component="rh.Componentes.pListas"
			 method="pListaQuery"
			 returnvariable="pListaEduRet">
				<cfinvokeargument name="query" value="#rsEmpleados#"/>
				<cfinvokeargument name="desplegar" value="DEidentificacion, NombreCompleto "/>
				<cfinvokeargument name="etiquetas" value="#LB_Identificacion#, #LB_NombreCompleto# "/>
				<cfinvokeargument name="cortes" value=""/>
				<cfinvokeargument name="formatos" value="S,S"/>
				<cfinvokeargument name="align" value="left, left"/>
				<cfinvokeargument name="ajustar" value=""/>	
				<cfinvokeargument name="incluyeForm" value="true"/>
				<cfinvokeargument name="MaxRows" value="50"/>
				<cfinvokeargument name="formName" value="listaEmpleados"/>
				<cfinvokeargument name="showLink" value="false"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
			</cfinvoke>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>

<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<form name="Buqueda" action="ReporteTramitesform.cfm" id="Buqueda" method="post" >
<cfquery name="rsSQL" datasource="#session.dsn#">
	select llave as DEid
	from UsuarioReferencia
	where Usucodigo= #session.Usucodigo#
	and Ecodigo	= #session.EcodigoSDC#
	and STabla	= 'DatosEmpleado'
</cfquery>
<cfset LvarDEID=#rsSQL.DEid#>
  <table width="100%">
    <tr>
      <td align="center" colspan="4"><strong>Consultas Tramites de Empleados</strong></td>
    </tr>
    <tr>
      <td width="15%"></td>
    </tr>
    <tr>
      <td nowrap="nowrap" align="right"><strong>Empleado: </strong> </td>
      <td width="85%" align="left"> 
		  <cf_conlis title="LISTA DE EMPLEADOS"
					campos = "DEid, DEidentificacion, DEnombre" 
					desplegables = "N,S,S" 
					modificables = "N,S,N" 
					size = "0,15,34"
					asignar="DEid, DEidentificacion, DEnombre"
					asignarformatos="S,S,S"
					tabla="DatosEmpleado"
					columnas="DEid, DEidentificacion, DEnombre #LvarCNCT#' '#LvarCNCT# DEapellido1 #LvarCNCT#' '#LvarCNCT# DEapellido2 as DEnombre"
					filtro="Ecodigo = #Session.Ecodigo#"
					desplegar="DEidentificacion, DEnombre"
					etiquetas="Identificación,Nombre"
					formatos="S,S"
					align="left,left"
					showEmptyListMsg="true"
					EmptyListMsg=""
					form="Buqueda"
					width="800"
					height="500"
					left="70"
					top="20"
					filtrar_por="DEidentificacion,DEnombre"
					index="1"
					traerInicial="#LvarDEID NEQ ''#"
					traerFiltro="DEid=#LvarDEid#"
					readonly="yes"
					fparams="DEid"   />   
	 </td>
    </tr>
    <tr>
    <cfset fecha1=DateFormat(Now(),'DD/MM/YYYY')>
      <td height="10" align="right"><strong>Fecha inicial:</strong></td>
      <td align="left"> <cf_sifcalendario form="Buqueda" value="#fecha1#" name="Inicio" tabindex="1"></td>
    </tr>
    <tr>
      <cfset fecha2=DateFormat(Now(),'DD/MM/YYYY')>
      <td align="right"><strong>Fecha final:</strong></td>
      <td colspan="2" align="left"><cf_sifcalendario form="Buqueda" value="#fecha2#" name="Final" tabindex="1"></td>
        <td align="right"><input type="submit" value="Consulta" name="btnBusq" /></td>
    </tr>
    <tr>
      <td align="center" colspan="4">&nbsp;</td>
    </tr>
  </table>
</form>



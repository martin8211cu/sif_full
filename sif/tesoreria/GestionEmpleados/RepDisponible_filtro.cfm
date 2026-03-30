<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Consultar" default = "Consultar" returnvariable="BTN_Consultar" xmlfile = "RepDisponible_filtro.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_ElUsuario" default = "El Usuario" returnvariable="LB_ElUsuario" xmlfile = "RepDisponible_filtro.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_NoEstaRegistradoComoEmpleado" default = "no está registrado como Empleado" returnvariable="LB_NoEstaRegistradoComoEmpleado" xmlfile = "RepDisponible_filtro.xml">


<cfparam name="rsCustodio.DEid" default="">
<cfif GvarPorResponsable>
    <cfquery name="rsCustodio" datasource="#session.dsn#">
        select llave as DEid
          from UsuarioReferencia
         where Usucodigo= #session.Usucodigo#
           and Ecodigo	= #session.EcodigoSDC#
           and STabla	= 'DatosEmpleado'
    </cfquery>
    <cfif rsCustodio.DEid EQ "">
        <cfthrow message="#LB_ElUsuario# '#session.usulogin#' #LB_NoEstaRegistradoComoEmpleado#">
    </cfif>
</cfif>
<cfoutput>
<form name="form1" action="RepDisponible#LvarCFM#.cfm" method="post">
	<table align="center">
		<tr>
			<td>
				<strong><cf_translate key = LB_Caja xmlfile = "RepDisponible_filtro.xml">Caja</cf_translate>:</strong>
			</td>
			<td>
				<cf_conlisCajas Responsable=#rsCustodio.DEid#>
			</td>
		</tr>
		<tr>
			<td align="center" colspan="2">
				<input type="submit" name="filtrar" value="#BTN_Consultar#">
			</td>
		</tr>
	</table>
</form>
</cfoutput>
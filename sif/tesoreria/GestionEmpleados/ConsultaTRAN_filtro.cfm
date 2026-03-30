<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Consultar" default = "Consultar" returnvariable="BTN_Consultar" xmlfile = "ConsultaTRAN_filtro.xml">

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
        <cfthrow message="El Usuario '#session.usulogin#' no está registrado como Empleado">
    </cfif>
</cfif>
<cfoutput>
<form name="form1" action="ConsultaTRAN#LvarCFM#.cfm" method="post">
	<table align="center">
		<tr>
			<td align="right">
				<strong><cf_translate key = LB_Caja xmlfile = "ConsultaTRAN_filtro.xml">Caja</cf_translate>:</strong>
			</td>
			<td>
				<cf_conlisCajas Responsable=#rsCustodio.DEid#>
			</td>
		</tr>
		<tr>
			<td nowrap align="right"><strong><cf_translate key = LB_Fecha xmlfile = "ConsultaTRAN_filtro.xml">Fecha</cf_translate>:</strong></td>
				<td colspan="2">
					<table cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td nowrap valign="middle">
									<cf_sifcalendario form="form1" value="" name="TESSPfechaPago_I" tabindex="1">
							</td>
							<td nowrap align="right" valign="middle">
								<strong>&nbsp;<cf_translate key = LB_Hasta xmlfile = "ConsultaTRAN_filtro.xml">Hasta</cf_translate>:</strong>
							</td>
							<td nowrap valign="middle">
									<cf_sifcalendario form="form1" value="" name="TESSPfechaPago_F" tabindex="1">
							</td>						
						</tr>

					</table>
				</td>
		</tr>
        <tr>
            <td align="right" valign="top" nowrap="nowrap"><strong><cf_translate key = LB_EstadoAnticipo xmlfile = "ConsultaTRAN_filtro.xml">Estado del anticipo</cf_translate>:</strong></td>
            <td align="left" valign="top" nowrap="nowrap">
                <select name="tipoMovimiento" id="tipoMovimiento">
                    <option value="1"><cf_translate key = LB_AfectaMontoAsignado xmlfile = "ConsultaTRAN_filtro.xml">Afectan Monto Asignado</cf_translate></option>
                    <option value="2"><cf_translate key = LB_EntregaEfectivo xmlfile = "ConsultaTRAN_filtro.xml">Entrega de Efectivo</cf_translate></option>
                    <option value="3"><cf_translate key = LB_Reintegros xmlfile = "ConsultaTRAN_filtro.xml">Reintegros</cf_translate></option>		
                    <option value="ALL"><cf_translate key = LB_Todos xmlfile = "ConsultaTRAN_filtro.xml">TODOS</cf_translate></option>
                </select>				
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

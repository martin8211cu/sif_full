<!--- 
	Creado por Raúl Bravo
		Fecha: 4 de Mayo de 2012
 --->

<cf_templateheader title="SIF - Interfaces P.M.I.">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Movimientos adicionales de Volúmenes de Ventas'>

<cfset minisifdb       = Application.dsinfo[session.dsn].schema>
<cfset sifinterfacesdb = Application.dsinfo.sifinterfaces.schema>

<cfquery name="rsValores" datasource="sifinterfaces">
	select * from ESIFLD_Facturas_Venta E
	inner join DSIFLD_Facturas_Venta D on E.ID_DocumentoV = D.ID_DocumentoV
	inner join int_ICTS_SOIN I on I.CodICTS = convert (varchar(10),E.Ecodigo) 
	where E.Periodo is not null and I.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by E.Periodo desc
</cfquery>

<cfquery name="rsValoresHIST" datasource="sifinterfaces">
	select * from ESIFLD_HFacturas_Venta E
	inner join DSIFLD_HFacturas_Venta D on E.ID_DocumentoV = D.ID_DocumentoV
	inner join int_ICTS_SOIN I on I.CodICTS = convert (varchar(10),E.Ecodigo) 
	where E.Periodo is not null and I.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by E.Periodo desc
</cfquery>

<cfquery name="rsEmp" datasource="#session.dsn#">
	select E.Edescripcion from #sifinterfacesdb#..int_ICTS_SOIN I
	inner join Empresas E on I.Ecodigo = E.Ecodigo where E.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 
	value="#Session.Ecodigo#">
</cfquery>

<cfoutput>
	<form name="form1" method="post" action="ActualizaSaldosVolumen-sql.cfm">
    	<input name="fltPeriodo" type="hidden" value="#Form.fltPeriodo#">	
		<input name="fltMes" type="hidden" value="#Form.fltMes#">	
		<input name="fltTipoVenta" type="hidden" value="#Form.fltTipoVenta#">	
		<input name="fltTipoDoc" type="hidden" value="#Form.fltTipoDoc#">	
		<input name="fltNaturaleza" type="hidden" value="#Form.fltNaturaleza#">	
		<input name="Volumen" type="hidden" value="#Form.Volumen#">	
		<input name="Ccodigo" type="hidden" value="#Form.Ccodigo#">	
		<input name="Poliza" type="hidden" value="#Form.Poliza#">	
		<input name="Grupo1" type="hidden" value="#Form.Grupo1#">	
		<input name="Observaciones" type="hidden" value="#Form.Observaciones#">	
	<fieldset>
	<table width="99%" cellpadding="2" cellspacing="0" border="0" align="center">
			<tr>
            <tr>
            	<td colspan="1"></td>
                <td colspan="2" align="left">#rsValores.recordcount# Registros Pendientes de Archivar</td>
            </tr>
            <tr><td colspan="2">&nbsp;</td></tr>            
            <tr>
            	<td colspan="1"></td>
                <td colspan="2" align="left">#rsValoresHIST.recordcount# Registros a Procesar</td>
            </tr>
				<td colspan="2">&nbsp;&nbsp;</td>
            </tr>
			<tr>
				<td colspan="1"></td>
				<td><strong>&nbsp;&nbsp;Empresa: </strong> </td>
                <td>
					<cfif #form.Grupo1# EQ "Ninguno">
                        #trim(rsEmp.Edescripcion)#
                    <cfelse>
                        #trim(form.Grupo1)#
                    </cfif>
                </td>
			<tr>
			<tr>
				<td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
            </tr>
			<tr>
				<td colspan="1">&nbsp;</td>
				<td>*<strong>&nbsp;Periodo: </strong></td>
            	<td>#form.fltPeriodo#</td>
				<td colspan="1">&nbsp;</td>
				<td>*<strong>&nbsp;Mes: </strong></td>
                <td>#form.fltMes#</td>
			</tr>
			<tr>
			<td colspan="1">&nbsp;</td></tr>
			<tr>
				<td colspan="1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>*<strong>&nbsp;Tipo de Venta: </strong></td>
            	<td>#form.fltTipoVenta#</td>
				<td colspan="1">&nbsp;</td>
				<td>*<strong>&nbsp;Tipo Documento: </strong></td>
            	<td>#form.fltTipoDoc#</td>
			</tr>
			<tr>
			<td colspan="1">&nbsp;</td></tr>
			<tr>
				<td colspan="1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>*<strong>&nbsp;Movimiento: </strong></td>
            	<td>#form.fltNaturaleza#</td>
				<td colspan="1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>*<strong>&nbsp;Producto: </strong></td>
				<td>#form.Ccodigo#</td>
			</tr>
			<tr>
			<td colspan="1">&nbsp;&nbsp;&nbsp;</td></tr>
			<tr>
				<td colspan="1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>*<strong>&nbsp;&nbsp;Poliza(s) Origen: </strong>
					<td> #form.Poliza#</td>
				</td>
				<td colspan="1">&nbsp;</td>
					<td width="160">*<strong>&nbsp;Volumen en Barriles: </strong></td>
					<td>#form.Volumen#</td>
				</td>
			</tr>
		
		<tr>
			<td colspan="1">&nbsp;&nbsp;&nbsp;</td></tr>
			<tr>
				<td colspan="1">&nbsp;</td>
				<td><strong>&nbsp;&nbsp;Observaciones: </strong>
					<td> #form.Observaciones#</td>
				</td>
    	</tr>
		<tr>
			<td colspan="1">&nbsp;&nbsp;&nbsp;</td>
		</tr>
		</tr>
		<td colspan="1">&nbsp;&nbsp;&nbsp;</td></tr>
			<tr>
				<td colspan="1">&nbsp;</td>
				<td>* Campos Obligatorios</td>
    	</tr>
        <tr>
            <td colspan="2">
               <table  cellpadding="" cellspacing="0" border="0" align="center">
                    <tr>
                        <td><cf_botones values="Confirmar" names="Confirmar"></td>
                        <td><cf_botones values="Cancelar" names="Cancela"></td>
                    </tr>
                </table>
            </td> 
        </tr>
	</table>
	</fieldset>
	</form>

    <cf_web_portlet_end>
    <cf_templatefooter>
    <cf_qforms form = 'form1'>

    <script language="javascript" type="text/javascript">
        function funcConfirmar() {
            if (#rsValores.recordcount#>0)
            {
                if (confirm('¿Desea Aplicar, con Registros Pendientes de Archivar?') )
                    {return true;}   <!---+++--->
                else
                    {return false;}
            }
            return true;
        }
        
        function funcCancela() {
            document.form1.action = "ActualizaSaldosVolumen-form.cfm";		
        }
    </script>
	
</cfoutput>




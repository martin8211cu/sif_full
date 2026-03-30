<!--- 
	Creado por Raúl Bravo
		Fecha: 3 Mayo 2012
 --->

<cf_templateheader title="SIF - Interfaces P.M.I.">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Generación de Volúmenes de Venta'>

<cfset minisifdb       = Application.dsinfo[session.dsn].schema>
<cfset sifinterfacesdb = Application.dsinfo.sifinterfaces.schema>

<cfset GvarEcodigo   = Session.Ecodigo>
<cfset GvarUsucodigo = Session.Usucodigo>	

<cfoutput>
<cfset LvarNavegacion = ""> 

<cfif Form.fltPeriodo NEQ "-1">
	<cfset LvarNavegacion = LvarNavegacion & "&fltPeriodo=#Form.fltPeriodo#">
</cfif>

<cfif Form.fltMes NEQ "-1">
	<cfset LvarNavegacion = LvarNavegacion & "&fltMes=#Form.fltMes#">
</cfif>

<cfquery name="rsValoresHIST" datasource="sifinterfaces">
	select  I.Ecodigo, sum(isnull(Vol_Barriles,0)) as Vol_Barriles, E.Periodo, E.Mes,
	Clas_Venta_Lin, Clas_Item, E.Clas_Venta, CCTtipo 
	from ESIFLD_HFacturas_Venta E
	inner join DSIFLD_HFacturas_Venta D on E.ID_DocumentoV = D.ID_DocumentoV
	inner join int_ICTS_SOIN I on I.CodICTS = convert (varchar(10),E.Ecodigo) 
	inner join #minisifdb#..CCTransacciones T on T.CCTcodigo = E.Tipo_Documento and T.Ecodigo = I.Ecodigo
	where E.Periodo is not null and E.Mes is not null and E.Contabilizado = 0 and Estatus = 2 and I.Ecodigo = 
	<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
	and ((Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#"> and 
	Mes <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">)
	or  (Periodo < <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#"> and 
	Mes <= 12))
	group by E.Periodo, E.Mes, Clas_Venta_Lin, D.Clas_Item, I.Ecodigo, E.Clas_Venta, T.CCTtipo
</cfquery>


<cfquery name="rsValores" datasource="sifinterfaces">
	select  I.Ecodigo, sum(isnull(Vol_Barriles,0)) as Vol_Barriles, E.Periodo, E.Mes,
	Clas_Venta_Lin, Clas_Item, E.Clas_Venta, CCTtipo 
	from ESIFLD_Facturas_Venta E
	inner join DSIFLD_Facturas_Venta D on E.ID_DocumentoV = D.ID_DocumentoV
	inner join int_ICTS_SOIN I on I.CodICTS = convert (varchar(10),E.Ecodigo) 
	inner join #minisifdb#..CCTransacciones T on T.CCTcodigo = E.Tipo_Documento and T.Ecodigo = I.Ecodigo
	where E.Periodo is not null and E.Mes is not null and E.Contabilizado = 0 and Estatus = 2 and I.Ecodigo = 
	<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
	and ((Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#"> and 
	Mes <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">)
	or  (Periodo < <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#"> and 
	Mes <= 12))
	group by E.Periodo, E.Mes, Clas_Venta_Lin, D.Clas_Item, I.Ecodigo, E.Clas_Venta, T.CCTtipo
</cfquery>

	<form name="form1" method="post" action="interfazSaldosVolumen-sql.cfm">
    	<input name="fltPeriodo" type="hidden" tabindex="-1" value="#Form.fltPeriodo#">	
		<input name="fltMes" type="hidden" tabindex="-1" value="#Form.fltMes#">	
	<fieldset><legend align="left">Filtros</legend>
        <table cellpadding="" cellspacing="0" border="0" align="center"> 	
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr><td colspan="2">&nbsp;</td></tr>
            <tr>
                <td colspan="2" align="left">#rsValores.recordcount# Registros Pendientes de Archivar</td>
            </tr>
            <tr><td colspan="2">&nbsp;</td></tr>            
            <tr>
                <td colspan="2" align="left">#rsValoresHIST.recordcount# Registros a Procesar</td>
            </tr>
            <tr><td colspan="2">&nbsp;</td></tr>
			<tr>		
				<td align="left"><strong>Periodo:	</strong></td>
                <td align="left">#Form.fltPeriodo#</td>
			</tr>
				<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td align="left"><strong>Mes: </strong></td>
                <td align="left">#Form.fltMes#</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
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
			<tr><td colspan="2">&nbsp;</td></tr>
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
            document.form1.action = "InterfazSaldosVolumen-form.cfm";		
        }
    </script>
</cfoutput>



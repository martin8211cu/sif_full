
<cfquery name="rsPeriodos" datasource="#Session.DSN#">
    select RHAAPeriodo
	from RHAjusteAnual
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    	<!---and RHAAEstatus = 1--->
    order by RHAAPeriodo
</cfquery> 

<cfquery name="rsConcPago" datasource="#session.dsn#">
	select * 
    from CIncidentes
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
    order by CIdescripcion
</cfquery>

<cfoutput>
<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
<form name="form1" method="post" action="repAjusteAnual_SQL.cfm" style="margin: 0">
	<table width="100%"  border="0" cellspacing="0" cellpadding="2" align="center">
    	<tr>
        	<td rowspan="3" width="45%">
            	<cf_web_portlet_start border="true" titulo="Descripci&oacute;n" skin="info1">
					<div align="justify">
						<p>
							<cf_translate  key="LB_Reporte">
								Reporte de Acumulados de Conceptos de Ajuste Anual
							</cf_translate>
						</p>
					</div>
				<cf_web_portlet_end>
            </td>
        	<td width="10%" align="right">
            	<strong>Per&iacute;odo:</strong>
            </td>
            <td width="45%">
            	<select name="periodo">
              		<option value="-1">---Selecciona Periodo---</option>
                		<cfloop query = "rsPeriodos">
              		<option value="#rsPeriodos.RHAAPeriodo#" <!---<cfif #UltimoPeriodo# EQ "#rsPeriodos.RHAAPeriodo#">selected</cfif>--->>#rsPeriodos.RHAAPeriodo# </option>
                		</cfloop>
              	</select>
            </td>
        </tr>
        <tr>
        	<td colspan = "3" align="center">
            	<input type="submit" name="Generar" value="Generar">            
            </td>
        </tr>
       <tr height="25px">
        	<td colspan = "3" align="left"> 
            	
            </td>
        </tr> 
     </table>
</cfoutput>
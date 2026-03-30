<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Periodo" default="Periodo" returnvariable="LB_Periodo" xmlfile="filtroMetodoParticipacion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mes" default="Mes" returnvariable="LB_Mes"
xmlfile="filtroMetodoParticipacion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Estatus" default="Estatus" returnvariable="LB_Estatus" xmlfile="filtroMetodoParticipacion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Todas" default="Todas" returnvariable="LB_Todas" xmlfile="filtroMetodoParticipacion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Pendiente" default="Pendiente" returnvariable="LB_Pendiente" xmlfile="filtroMetodoParticipacion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Estimada" default="Estimada" returnvariable="LB_Estimada" xmlfile="filtroMetodoParticipacion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Filtrar" default="Filtrar" returnvariable="BTN_Filtrar" xmlfile="filtroMetodoParticipacion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Socio" default="Socio" returnvariable="LB_Socio"
xmlfile="filtroMetodoParticipacion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Moneda" default="Moneda" returnvariable="LB_Moneda" xmlfile="filtroMetodoParticipacion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Oficina" default="Oficina" returnvariable="LB_Oficina" xmlfile="filtroMetodoParticipacion.xml"/>

<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js">//</script>

<cfif isdefined("url.Bid") and not isdefined("form.Bid") >
	<cfset form.Bid = url.Bid >
</cfif>


<!--- Query de lista de Socios --->
 <cfquery name="rsListaSoc" datasource="#session.DSN#">
	select sn.SNnombre, snmp.Ecodigo, snmp.SNid,snmp.FormatoCuentaC,snmp.FormatoCuentaD
	from SNMetodoParticipacion snmp
	inner join SNegocios sn on snmp.Ecodigo=sn.Ecodigo and snmp.SNid=sn.SNid
     where sn.Ecodigo=#session.Ecodigo#
</cfquery>

<!--- Query de Periodos --->
<cfquery name="rsPeriodo" datasource="#session.dsn#">
	select Pvalor as Periodo from Parametros
    where  Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
    and Pcodigo =50
</cfquery>



<cfoutput>
<form style="margin: 0" action="MetodoParticipacion.cfm" name="form1" method="post">

<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">

    <tr>
	    <td width="79" align="right"><strong>#LB_Socio#:</strong></td>
		<td width="180" align="left"  colspan="3">
			<select name="SNnombreU">
					<option value="-1" <cfif isdefined('form.SNnombreU') and form.SNnombreU EQ '-1'> selected</cfif>>&nbsp;</option>
					<cfif isdefined('rsListaSoc') and rsListaSoc.recordCount GT 0>
						<cfloop query="rsListaSoc">
							<option value="#SNid#" <cfif isdefined("Form.SNid") AND Form.SNid EQ rsListaSoc.SNnombre> selected</cfif>>#SNnombre#</option>
						</cfloop>
					</cfif>
				</select>
		</td>
        <td width="55" align="left"><strong>#LB_Periodo#:</strong></td>
        <td width="100">
			<select name="Periodo">
					<option value="-1" <cfif isdefined('form.Periodo') and form.Periodo EQ '-1'> selected</cfif>>&nbsp;</option>
					<cfif isdefined('rsPeriodo') and rsPeriodo.recordCount GT 0>
						<cfloop query="rsPeriodo">
							<option value="#Periodo#" <cfif isdefined("Form.SNid") AND Form.SNid EQ rsListaSoc.SNnombre> selected</cfif>>#Periodo#</option>
						</cfloop>
					</cfif>
				</select>
        </td>
        <td align="right"> <strong>#LB_Mes#:</strong> </td>
        <td>
	    	<select name="Mes">
				<option value="-1" <cfif isdefined('form.Mes') and form.Mes EQ '-1'> selected</cfif>>&nbsp;</option>
				<cfif isdefined('rsPeriodo') and rsPeriodo.recordCount GT 0>
							<option value="1" <cfif isdefined("Form.SNid") AND Form.SNid EQ rsListaSoc.SNnombre> selected</cfif>>Enero</option>
					        <option value="2" <cfif isdefined("Form.SNid") AND Form.SNid EQ rsListaSoc.SNnombre> selected</cfif>>Febrero</option>
					        <option value="3" <cfif isdefined("Form.SNid") AND Form.SNid EQ rsListaSoc.SNnombre> selected</cfif>>Marzo</option>
					        <option value="4" <cfif isdefined("Form.SNid") AND Form.SNid EQ rsListaSoc.SNnombre> selected</cfif>>Abril</option>
					        <option value="5" <cfif isdefined("Form.SNid") AND Form.SNid EQ rsListaSoc.SNnombre> selected</cfif>>Mayo</option>
					        <option value="6" <cfif isdefined("Form.SNid") AND Form.SNid EQ rsListaSoc.SNnombre> selected</cfif>>Junio</option>
					        <option value="7" <cfif isdefined("Form.SNid") AND Form.SNid EQ rsListaSoc.SNnombre> selected</cfif>>Julio</option>
					        <option value="8" <cfif isdefined("Form.SNid") AND Form.SNid EQ rsListaSoc.SNnombre> selected</cfif>>Agosto</option>
					        <option value="9" <cfif isdefined("Form.SNid") AND Form.SNid EQ rsListaSoc.SNnombre> selected</cfif>>Septiembre</option>
					        <option value="10" <cfif isdefined("Form.SNid") AND Form.SNid EQ rsListaSoc.SNnombre> selected</cfif>>Octubre</option>
					        <option value="11" <cfif isdefined("Form.SNid") AND Form.SNid EQ rsListaSoc.SNnombre> selected</cfif>>Noviembre</option>
					        <option value="12" <cfif isdefined("Form.SNid") AND Form.SNid EQ rsListaSoc.SNnombre> selected</cfif>>Diciembre</option>
					</cfif>
				</select>
        </td>
        <td width="16"><input type="submit" name="btnFiltro"  value="#BTN_Filtrar#"></td>
    </tr>
    <tr>
    	<td colspan="4"> </td>

    </tr>
 </table>
</form>
</cfoutput>

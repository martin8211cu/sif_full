<cf_templateheader title="SIF - Reportes SAT">

<cfinvoke  key="LB_Socio" default="Socio" component="sif.Componentes.Translate" method="Translate" returnvariable="LB_Socio" xmlfile="/sif/RpteDIOT.xml"/>
<cfinvoke  key="LB_Banco" default="Banco" component="sif.Componentes.Translate" method="Translate" returnvariable="LB_Banco" xmlfile="/sif/RpteDIOT.xml"/>
<cfinvoke  key="LB_Dsd"   default="Desde" component="sif.Componentes.Translate" method="Translate" returnvariable="LB_Dsd" xmlfile="/sif/RpteDIOT.xml"/>
<cfinvoke  key="LB_Hst"   default="Hasta" component="sif.Componentes.Translate" method="Translate" returnvariable="LB_Hst" xmlfile="/sif/RpteDIOT.xml"/>
<cfinvoke  key="LB_Ofc"   default="Oficina" component="sif.Componentes.Translate" method="Translate" returnvariable="LB_Ofc" xmlfile="/sif/RpteDIOT.xml"/>
<cfinvoke  key="LB_Todas" default="Todas" component="sif.Componentes.Translate" method="Translate" returnvariable="LB_Todas" xmlfile="/sif/RpteDIOT.xml"/>
<cfinvoke  key="LB_Tip"   default="Tipo" component="sif.Componentes.Translate" method="Translate" returnvariable="LB_Tip" xmlfile="/sif/RpteDIOT.xml"/>
<cfinvoke key="CMB_Enero" default="Enero" returnvariable="CMB_Enero" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/RpteDIOT.xml"/>
<cfinvoke key="CMB_Febrero" default="Febrero" returnvariable="CMB_Febrero" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/RpteDIOT.xml"/>
<cfinvoke key="CMB_Marzo" default="Marzo" returnvariable="CMB_Marzo" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/RpteDIOT.xml"/>
<cfinvoke key="CMB_Abril" default="Abril" returnvariable="CMB_Abril" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/RpteDIOT.xml"/>
<cfinvoke key="CMB_Mayo"  default="Mayo"  returnvariable="CMB_Mayo"	 component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/RpteDIOT.xml"/>
<cfinvoke key="CMB_Junio" default="Junio" returnvariable="CMB_Junio" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/RpteDIOT.xml"/>
<cfinvoke key="CMB_Julio" default="Julio" returnvariable="CMB_Julio" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/RpteDIOT.xml"/>
<cfinvoke key="CMB_Agosto" default="Agosto" returnvariable="CMB_Agosto" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/RpteDIOT.xml"/>
<cfinvoke key="CMB_Setiembre" default="Septiembre" returnvariable="CMB_Setiembre" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/RpteDIOT.xml"/>
<cfinvoke key="CMB_Octubre" default="Octubre" returnvariable="CMB_Octubre" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/RpteDIOT.xml"/>
<cfinvoke key="CMB_Noviembre" default="Noviembre" returnvariable="CMB_Noviembre" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/RpteDIOT.xml"/>
<cfinvoke key="CMB_Diciembre" default="Diciembre" returnvariable="CMB_Diciembre" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/RpteDIOT.xml"/>


<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='An&aacute;lisis&nbsp;de&nbsp;Cliente'>


<cfquery name="rsPer" datasource="#Session.DSN#">
	select IPeriodo as Eperiodo
	from DIOT_Control
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	GROUP by IPeriodo
	ORDER by IPeriodo
</cfquery>

<cfquery name="rsOficinas" datasource="#Session.DSN#">
	select Ocodigo, Odescripcion 
	from Oficinas 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<!--- 	BANCOS --->
<cfquery datasource="#Session.DSN#" name="rsBancos">
	select Bid, Bdescripcion
	from Bancos
	where Ecodigo	=	<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
	order by 2
</cfquery>

<form name="form1" action=""  method="post" onsubmit="return validar();">

<cfoutput>
<table width="100%" cellspacing="0">
	<tr>
		<td valign="top">
		<fieldset><legend>Datos del Reporte</legend>
			<table>

				<tr>
					<td rowspan="4">&nbsp;&nbsp;&nbsp;&nbsp;</td>
				</tr>	

				<tr>
					<td></td>
					<td nowrap align="right"><strong>#LB_Socio#:</strong>
					<td align="left"><cf_sifsociosnegocios2 tabindex="1"></td>
					<td>&nbsp;</td>
					<td nowrap align="right"><strong>#LB_Banco#:</strong></td>
					<td>
						<select name="bcoIdInfo" tabindex="5" onfocus="-1">
								
						<!---	<option value="-1" selected="-1">
								-- Ninguno --
							</option>--->
							
							<cfloop query="rsBancos">
								<option value="#rsBancos.Bid#" 
									<!---<cfif modo neq "ALTA" and rsForm.EMBancoIdOD eq rsBancos.Bid>--->
										<		selected
											<!---</cfif>--->
									>#rsBancos.Bdescripcion#</option>
							</cfloop>
							<option value="-1" selected="-1">
								-- Ninguno --
							</option>
					
						</select>
					</td>
				</tr>
				
				<tr>
					<td colspan="4">&nbsp;</td>
								
					
					<td>&nbsp;</td>
					<td>&nbsp;&nbsp;</td>
					<td>&nbsp;&nbsp;</td>
				</tr>
		<table>
				<tr>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td nowrap align="left"><strong>#LB_Dsd#:</strong></td>						
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td nowrap align="left"><strong>#LB_Hst#:</strong></td>
					<td>&nbsp;</td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<!---	<td nowrap align="left"><strong>#LB_Ofc#:</strong></td>--->
				<!---	<td>&nbsp;</td>
					<td>&nbsp;&nbsp;</td>
					<td>&nbsp;&nbsp;</td>--->
					<td nowrap align="left"><strong>#LB_Tip#:</strong></td>						
				</tr>

				<tr>
				  <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td align="right">
					<select name="periodoD" tabindex="1">
						<cfloop query = "rsPer">
							<option value="<cfoutput>#rsPer.Eperiodo#</cfoutput>"><cfoutput>#rsPer.Eperiodo#</cfoutput></option>" ></option>
						</cfloop>

					</select>
				  </td>
				  <td> <select name="mesD" size="1" tabindex="1">
					  <option value="1"><cfoutput>#CMB_Enero#</cfoutput></option>
					  <option value="2"><cfoutput>#CMB_Febrero#</cfoutput></option>
					  <option value="3"><cfoutput>#CMB_Marzo#</cfoutput></option>
					  <option value="4"><cfoutput>#CMB_Abril#</cfoutput></option>
					  <option value="5"><cfoutput>#CMB_Mayo#</cfoutput></option>
					  <option value="6"><cfoutput>#CMB_Junio#</cfoutput></option>
					  <option value="7"><cfoutput>#CMB_Julio#</cfoutput></option>
					  <option value="8"><cfoutput>#CMB_Agosto#</cfoutput></option>
					  <option value="9"><cfoutput>#CMB_Setiembre#</cfoutput></option>
					  <option value="10"><cfoutput>#CMB_Octubre#</cfoutput></option>
					  <option value="11"><cfoutput>#CMB_Noviembre#</cfoutput></option>
					  <option value="12"><cfoutput>#CMB_Diciembre#</cfoutput></option>
					</select> </td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>					
					<td align="right">
					<select name="periodoH" tabindex="1">
						<cfloop query = "rsPer">
							<option value="<cfoutput>#rsPer.Eperiodo#</cfoutput>"><cfoutput>#rsPer.Eperiodo#</cfoutput></option>" ></option>
						</cfloop>

					</select>
				  </td>
				  <td> <select name="mesH" size="1" tabindex="1">
					  <option value="1"><cfoutput>#CMB_Enero#</cfoutput></option>
					  <option value="2"><cfoutput>#CMB_Febrero#</cfoutput></option>
					  <option value="3"><cfoutput>#CMB_Marzo#</cfoutput></option>
					  <option value="4"><cfoutput>#CMB_Abril#</cfoutput></option>
					  <option value="5"><cfoutput>#CMB_Mayo#</cfoutput></option>
					  <option value="6"><cfoutput>#CMB_Junio#</cfoutput></option>
					  <option value="7"><cfoutput>#CMB_Julio#</cfoutput></option>
					  <option value="8"><cfoutput>#CMB_Agosto#</cfoutput></option>
					  <option value="9"><cfoutput>#CMB_Setiembre#</cfoutput></option>
					  <option value="10"><cfoutput>#CMB_Octubre#</cfoutput></option>
					  <option value="11"><cfoutput>#CMB_Noviembre#</cfoutput></option>
					  <option value="12"><cfoutput>#CMB_Diciembre#</cfoutput></option>
					</select> </td>	
					<td></td>
					<td align="rigth">
					<!---<td><select name="Oficina" id="Oficina" tabindex="1">
					  <option value="" label="Todas">---#LB_Todas#---</option>
					  	<cfloop query="rsOficinas" > 
							<option value="#Ocodigo#">#Odescripcion#</option>
					  	</cfloop> </select>
					</td>--->
			<!---		<td colspan="3"></td>	--->										
					<td colspan="1">
						<select name="Tip">
							<option value="1" selected>Resumido</option>
							<option value="2">Detallado</option>												
						</select>
					</td>
				</tr>
				<tr>					
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td ></td>
					<td colspan="12" align="center">
					<input type="submit" name="Generar" value="Generar" class="btnNormal" onclick="Generar();">	
					<input type="submit" name="Filtrar" value="Filtrar" class="btnFiltrar" onclick="Filtrar();">					
					</td>
				</tr>
		</table>
	</table>							
			</fieldset>			
		  	<cf_web_portlet_end>
		</td>	
	</tr>
</table>	
</cfoutput>
</form>

<script language="javascript" type="text/javascript">

function Generar(){
	fuente = 'RpteDIOTSAT.cfm';
	document.form1.action = fuente;
}

function Filtrar(){
	fuente = 'DIOTRpt.cfm';
	document.form1.action = fuente;
}

 function validar() {

  var pd = document.form1.periodoD.value;
  var ph = document.form1.periodoH.value;
  var md = document.form1.mesD.value;
  var mh = document.form1.mesH.value;

  if (pd <= ph && md <= mh){
    return true;
  }else{
   alert('"El mes y periodo desde," deben de ser menores o iguales que "mes y periodo hasta"');
    return false;
  }  
 
 }
</script>


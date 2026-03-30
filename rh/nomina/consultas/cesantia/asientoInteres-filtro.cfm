<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

<cfquery name="rs_periodos" datasource="#session.DSN#">
	select distinct cs.RHCSperiodo as periodo
	from RHCesantiaSaldos cs, DatosEmpleado de
	where de.DEid = cs.DEid
	and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfset lista_meses = 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre' >

<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<table width="100%" cellpadding="1" cellspacing="0">
		<tr>
			<td valign="top">	
				<cf_web_portlet_start border="true" titulo="Asiento de Intereses de Cesant&iacute;a" skin="#Session.Preferences.Skin#"> 
					<form name="form1" method="get" action="asientoInteres.cfm" onSubmit="javascript: return validar();">
					<table width="50%" align="center">
						<tr>
				    		<td width="50%" align="right" nowrap> <strong><cf_translate xmlfile="/rh/generales.xml"  key="LB_Periodo">Per&iacute;odo</cf_translate>:</strong></td>							
							<td>
								<select name="periodo">
									<cfoutput query="rs_periodos">
										<option value="#rs_periodos.periodo#" <cfif rs_periodos.periodo eq year(now())>selected</cfif>  >#rs_periodos.periodo#</option>
									</cfoutput>
								</select>
							</td>
						</tr>
						<tr>
							<td align="right"><strong><cf_translate key="LB_Mes">Mes</cf_translate>:</strong></td>
							<td>
								<cfset i = 1 >
								<cfoutput>
								<select name="mes">
									<cfloop list="#lista_meses#" index="mes">
										<option value="#i#" <cfif i eq month(now())>selected</cfif> >#mes#</option>
										<cfset i = i+1 >
									</cfloop>
								</select>
								</cfoutput>
							</td>
						</tr>
						<tr>
							<td align="right" nowrap="nowrap"><strong><cf_translate key="LB_Empleado">Empleado</cf_translate>:</strong></td>
							<td>
								<cf_rhempleado size="80" tabindex="1"> 
							</td>
						</tr>
						<tr>
							<td colspan="2" align="center">
								<input type="submit" name="Reporte" class='btnFiltrar' value="Reporte" >
							</td>
						</tr>
					</table>
					</form>
				<cf_web_portlet_end> 
			</td>	
		</tr>
	</table>	
	
	<script language="javascript1.2" type="text/javascript">
		function validar(){
			var msj = '';
			if( document.form1.periodo.value == '' ){
				msj += '\n - El Período es requerido';
			}
			if( document.form1.mes.value == '' ){
				msj += '\n - El Mes es requerido';
			}
			
			if ( msj != '' ){
				alert('Se presentaron los siguientes errores:' + msj);
				return false;
			}
			
			return true;
		}
	</script> 
	
<cf_templatefooter>
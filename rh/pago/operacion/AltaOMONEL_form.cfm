<!--- OPARRALES 2018-08-29
	- Layut de Alta OMONEL
 --->
<cfinvoke key="LB_Titulo" 		default="Alta OMONEL" 	xmlfile="/rh/generales.xml" returnvariable="LB_Titulo" 		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_FechaIni" 	default="Fecha Inicial" xmlfile="/rh/generales.xml" returnvariable="LB_FechaIni" 	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_FechaFin" 	default="Fecha Final" 	xmlfile="/rh/generales.xml" returnvariable="LB_FechaFin" 	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_BtnGenerar" 	default="Generar" 		xmlfile="/rh/generales.xml" returnvariable="LB_BtnGenerar" 	component="sif.Componentes.Translate" method="Translate"/>

<cf_templateheader title="#LB_Titulo#" template="#session.sitio.template#">
	<cf_web_portlet_start titulo="#LB_Titulo#">
		<cfoutput>
			<cf_dbfunction name="now"	returnvariable="myToday" >
			<form name="form1" method="post" action="AltaOMONEL_sql.cfm" onsubmit="javascript: return validaFechaIni();">
				<table align="center" width="35%" border="0">
					<tr>
						<td align="right">
							<strong>#LB_FechaIni#:&nbsp;</strong>
						</td>
						<td align="left">
							<cf_sifcalendario form="form1" name="FechaIni" value="#now()#">
						</td>
						<td align="right">
							<strong>#LB_FechaFin#:&nbsp;</strong>
						</td>
						<td align="left">
							<cf_sifcalendario form="form1" name="FechaFin" value="#now()#">
						</td>
					</tr>

					<tr>
						<td colspan="4" align="center">
							<input type="submit" name="btnGenerar" value="#LB_BtnGenerar#">
						</td>
					</tr>
				</table>
			</form>

			<script language="javascript" type="text/javascript">
				function validaFechaIni()
				{
					var varFecIni = document.getElementById('FechaIni').value;
					if(varFecIni == '')
					{
						alert('Debe seleccionar por lo menos una fecha inicial.');
						return false;
					}
					return true;
				}
			</script>
		</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>

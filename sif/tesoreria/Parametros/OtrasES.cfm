<cf_templateheader title="Mantenimiento de Tesorería">
	<cfset titulo = "">
	<cfset titulo = 'Otras Entradas y Salidas de Efectivo'>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	
		<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<form name="frmTES" style="margin:0;" method="post">
				<tr>
					<td class="tituloListas">
						<strong>Tesorería:</strong>
						<cf_cboTESid tipo="" onChange="document.frmTES.submit();" tabindex="1">
					</td>
				</tr>
			</form>
		  <tr>
			<td valign="top">
            	<cfinclude template="../../Utiles/sifConcat.cfm">
				<cfquery datasource="#session.dsn#" name="lista">
					select TESOid,    TESOtipo,  TESOdescripcion,
					       TESOmonto, TESOfechaDesde, 
						   case when TESOrecursividad <> 0 then TESOfechaHasta end as TESOfechaHasta, 
						   case when TESOrecursividad = 0 then 'Una sola vez' 	
						   		else 'Cada ' #_Cat# <cf_dbfunction name="to_char" args="TESOrecursividadN"> #_Cat# 
								case
									when TESOrecursividad = 1 then ' días'
									when TESOrecursividad = 2 then ' semanas' 
									when TESOrecursividad = 3 then ' meses'
									else ' años' 
								end
							end as TESOrecursividad, 
							Miso4217
					from TESotrasEntradasSalidas A, Monedas B
					where A.Mcodigo = B.Mcodigo
					  and A.TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Tesoreria.TESid#">
					<!--- falta el where --->
				</cfquery>
				
		
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
					query="#lista#"
					desplegar="TESOtipo,TESOdescripcion, Miso4217, TESOmonto,TESOrecursividad,TESOfechaDesde,TESOfechaHasta"
					etiquetas="Tipo, Descripcion, Moneda, Monto, Frecuencia, Fecha, Hasta" 
					formatos="S,S,S,M,S,D,D"
					align="center,left,center,right,left,left,left"
					ira="OtrasES.cfm"
					form_method="get"
					showEmptyListMsg="true"
					keys="TESOid"
				/>		
			</td>
			<td valign="top">
				<cfinclude template="OtrasES_form.cfm">
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
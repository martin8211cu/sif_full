
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ISI" default="Incluir saldo incial" returnvariable="LB_ISI" xmlfile="DescargaXMLSAT.xml">
<cfquery datasource="sifcontrol" name="tComprobante">
	select IdTipoCompr, rtrim(ltrim(CSATcodigo)) CSATcodigo, CSATdescripcion
	from CSATTipoCompr	
	order by IdTipoCompr
</cfquery>

<cfquery datasource="#Session.DSN#" name="tAsociados">
	SELECT DISTINCT COALESCE(Relacionado,0) as Relacionado 
	FROM DBitacoraDescargaSAT 
	WHERE Ecodigo=#Session.Ecodigo#
</cfquery>
<cfset Asociados = Trim(tAsociados.Relacionado)>

<cfset vsPath_A = "#Left(ExpandPath( GetContextRoot()),2)#">
<cfset rutaDirTmp = '#vsPath_A#\Enviar\#Session.FileCEmpresa#\#Session.Ecodigo#\DescargasXMLZip'>
<cfif directoryExists(rutaDirTmp)>
	<!--- Elimina el archivo DescargasXMLZip (directorio temporal)--->	
    <cfset DirectoryDelete(rutaDirTmp,true)>
</cfif>

<cf_templateheader title="SIF - Cuentas por Pagar">
           <cf_web_portlet_start titulo='Descarga de XML del SAT'>
		  	<cfinclude template="../../portlets/pNavegacion.cfm">
			<cfoutput>
			
			<cfif isdefined("url.q")><cfset form.q=url.q></cfif>
			<form name="form1" method="post" action="" onSubmit="javascript: return setAction();">
				<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" class="AreaFiltro">
				  <tr>
					<td class="FileLabel">Tipo:</td>
		
					<td colspan="1">
						<select name="tipoC" id="select">
							<option value="0">Todos</option>
							<cfloop query="tComprobante">
								<option value="#tComprobante.CSATcodigo#">#tComprobante.CSATdescripcion#</option>
							</cfloop>
							
						</select>
					</td>

					<td class="FileLabel">Asociados a CXP:</td>
					<td>	
						<select name="Asociados" id="select">
							<option value="Todos">Todos</option>
							<option value="1" <cfif Asociados eq 1><cfset Asociados = 1></cfif>>Asociado</option>
							<option value="0" <cfif Asociados eq 0><cfset Asociados = 0></cfif>>No Asociado</option>							
						</select>
					</td>

				  </tr>
				  <tr>
					<td class="FileLabel">Fecha Desde:</td>
					<td>
						<cf_sifcalendario name="fecha1" value="#LSDateFormat(CreateDate(Year(Now()),Month(Now()),01),'dd/mm/yyyy')#">
					</td>
					<td class="FileLabel">Fecha Hasta:</td>
					<td>
						<cf_sifcalendario name="fecha2" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
					</td>
					<td>&nbsp;</td>
				  </tr>	
				  <tr>
					<td></td>
					<td></td>										
					<td><cf_botones values="Generar"></td>
					
				  </tr>			 
				</table>
			</form>
			<cf_qforms>
			<script language="javascript" type="text/javascript">
				function fnFechaMMDDYYYY (LvarFecha)
				{
					return LvarFecha.substr(3,2)+"-"+LvarFecha.substr(0,2)+"-"+LvarFecha.substr(6,4);
				}
				
				function setAction() {
					const date1 = new Date(fnFechaMMDDYYYY(document.form1.fecha1.value));
					const date2 = new Date(fnFechaMMDDYYYY(document.form1.fecha2.value));
					if (date1 > date2)
					{
						alert ("La Fecha Inicial debe ser menor a la Fecha Final");
						return false;					
					}
					
					const diffTime = Math.abs(date2 - date1);
					const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 
					
					if (diffDays > 31)
					{
						alert ("La diferencia entre fechas no puede ser mayor a 31 días. La diferencia es de  " + diffDays);
						return false;
					}
					
					var retorne = 'DescargaXMLSATD.cfm';
					document.form1.action = retorne;					
					return true;
					
				}
				objForm.tipoC.description = 'Tipo';
				objForm.Asociados.description = 'Asociados';
				objForm.fecha1.description = 'Fecha1 Desde';
				objForm.fecha2.description = 'Fecha1 Hasta';
				objForm.required('fecha1,fecha2,tipoC,Asociados');
			</script>
			</cfoutput>
		<cf_web_portlet_end>
	<cf_templatefooter>
<cf_templateheader title="<cfoutput>Mejoras de Activos Aplicadas</cfoutput>">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		
			<cf_web_portlet_start titulo='Mejoras de Activos Aplicadas'>
  				<!---Periodos--->
				<cfquery name="rsPrePeriodo" datasource="#Session.DSN#">
					select Pvalor as periodo
					from Parametros 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
					and Pcodigo = 30
				</cfquery>
				<cfset rsPeriodo = QueryNew("Pvalor")>
				<cfset temp = QueryAddRow(rsPeriodo,3)>
				<cfset temp = QuerySetCell(rsPeriodo,"Pvalor",rsPrePeriodo.periodo,1)>
				<cfset temp = QuerySetCell(rsPeriodo,"Pvalor",rsPrePeriodo.periodo+1,2)>
				<cfset temp = QuerySetCell(rsPeriodo,"Pvalor",rsPrePeriodo.periodo+2,3)>
				<!---Meses--->
				<cfquery name="rsMeses" datasource="sifControl">
					select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as Pvalor, b.VSdesc as Pdescripcion
					from Idiomas a, VSidioma b 
					where a.Icodigo = '#Session.Idioma#'
					and b.VSgrupo = 1
					and a.Iid = b.Iid
					order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
				</cfquery>
				<cfoutput>
				<form style="margin: 0"  action="repMejorasAplicadas-form.cfm"name="form1" method="post" onSubmit="javascript: return funcValidar();">
					<table width="100%" cellpadding="0" cellspacing="0">
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td width="14%" align="right"><strong>Per&iacute;odo:&nbsp;</strong></td>
							<td width="15%">
								<select name="TAperiodo" tabindex="1">
									<!---<option value="">Todos</option>--->
									<option value="">--- Seleccionar ---</option>
										<cfloop query="rsPeriodo">
											<option value="#Pvalor#" <cfif (isdefined("TAperiodo") and len(trim(TAperiodo)) and TAperiodo eq Pvalor)>selected</cfif>>#Pvalor#</option>
										</cfloop>
								</select>
							</td>
							<td width="11%" align="right"><strong>Mes:&nbsp;</strong></td>
							<td width="20%">
								<select name="TAmes" tabindex="1">
									<!----<option value="">Todos</option>---->
									<option value="">--- Seleccionar ---</option>
										<cfloop query="rsMeses">
											<option value="#Pvalor#" <cfif (isdefined("TAmes") and len(trim(TAmes)) and TAmes eq Pvalor)>selected</cfif>>#Pdescripcion#</option>
										</cfloop>
								</select>
							</td>
							<td width="9%" align="right"><strong>Fecha:&nbsp;</strong></td>
							<td width="19%"><cf_sifcalendario name="TAfecha" form="form1" tabindex="1"></td>
							<td width="12%"><input type="submit" name="btnFiltrar" value="Filtrar" tabindex="1"></td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr><td>&nbsp;</td></tr>
					</table>
				</form>
				</cfoutput>	
				<script type="text/javascript" language="javascript1.2">
					function funcValidar(){
						if (document.form1.TAperiodo.value == '' || document.form1.TAmes.value == ''){
							alert("Debe seleccionar el período y el mes");
							return false;
						}
						return true;										
					}
				</script>			
			<cf_web_portlet_end>
	<cf_templatefooter>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Existencias"
	Default="Existencias"
	returnvariable="LB_Existencias"/>

<cfquery datasource="#session.DSN#" name="rsAlmacen">
	select Aid, Almcodigo, Bdescripcion
	from Almacen 
	where Ecodigo = #session.Ecodigo#
	order by Almcodigo
</cfquery> 

<cf_dbfunction name="to_char" args="Kperiodo" returnvariable = "Kperiodo">
<cfquery datasource="#session.DSN#" name="rsPeriodos">
	select distinct #PreserveSingleQuotes(Kperiodo)#
	  from Kardex
	where Ecodigo = #session.Ecodigo#
	union
	select Pvalor as Kperiodo
	 from Parametros
	where Ecodigo = #session.Ecodigo#
	and Pcodigo=50
</cfquery> 
<cf_dbfunction name="to_integer" args="VSvalor" returnvariable = "VSvalor">
<cfquery datasource="#session.DSN#" name="rsMes">
	select 
	#PreserveSingleQuotes(VSvalor)#,
	VSdesc 
	from VSidioma
	where Iid=1 
	   and VSgrupo=1
	order by #PreserveSingleQuotes(VSvalor)#
</cfquery> 

<cf_dbfunction name="to_integer" args="Pvalor" returnvariable = "Pvalor">
<cfquery datasource="#session.DSN#" name="rsMesAux">
	select 
	#PreserveSingleQuotes(Pvalor)#
		from Parametros 
	where Pcodigo=60 and Ecodigo = #session.Ecodigo#			
</cfquery>

<cf_templateheader title="#LB_Existencias#">
	<cfinclude template="../../portlets/pNavegacionIV.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_Existencias#">
			<form action="SQLExistencias.cfm" method="post" name="consulta">
				<table width="86%" border="0" cellpadding="0" cellspacing="0" align="center">
					<!--- Almacen --->
					<tr> 
						<td align="right" valign="baseline" nowrap><div align="right">Almac&eacute;n Desde:&nbsp;&nbsp;&nbsp;</div></td>
						<td valign="baseline">
							<select name="almaceni">
								<cfoutput query="rsAlmacen"> 
									<option value="#rsAlmacen.Aid#">#trim(rsAlmacen.Almcodigo)# - #trim(rsAlmacen.Bdescripcion)#</option>
								</cfoutput>
							</select>
						</td>
						<td width="13%" align="right" valign="baseline" nowrap>&nbsp;</td>
						<td align="right" valign="baseline" nowrap><div align="right">Almac&eacute;n Hasta:&nbsp;&nbsp;&nbsp;</div></td>
						<td valign="baseline">
							<cfset ultimo = rsAlmacen.RecordCount-1>
							<select name="almacenf">
								<cfoutput query="rsAlmacen"> 
										<option value="#rsAlmacen.Aid#">#trim(rsAlmacen.Almcodigo)# - #trim(rsAlmacen.Bdescripcion)#</option>
								</cfoutput>
							</select>
							<script language="JavaScript1.2" type="text/javascript">
								document.consulta.almacenf.selectedIndex = <cfoutput>#ultimo#</cfoutput>;
							</script>
						</td>
					</tr>
					<!--- Articulo --->
					<tr> 
						<td valign="baseline" align="right"><div align="right">Art&iacute;culo Desde:&nbsp;&nbsp;&nbsp;</div></td>
						<td nowrap><cf_sifarticulos form="consulta" frame="fri" id="iAid" name="articuloi" desc="Aidescripcion"></td>
						<td width="13%" align="right" valign="baseline">&nbsp;</td>
						<td valign="baseline" align="right"><div align="right">Art&iacute;culo Hasta:&nbsp;&nbsp;&nbsp;</div></td>
						<td nowrap><cf_sifarticulos form="consulta" frame="frf" id="fAid" name="articulof" desc="Afdescripcion"></td>
					</tr>
					<tr> 
						<td width="25%" align="right" valign="middle" nowrap >Clasificaci&oacute;n Inicial:&nbsp;</td>
						<td valign="baseline" nowrap><cf_sifclasificacion form="consulta" frame="cli" id="clasificacioni" name="Ccodigoclas" desc="Cdescripcion"></td>
						<td width="13%" align="right" valign="baseline">&nbsp;</td>
						<td width="40%" align="right" valign="middle" nowrap>Clasificaci&oacute;n Final:&nbsp;</td>
						<td valign="baseline" nowrap><cf_sifclasificacion form="consulta" frame="clf" id="clasificacionf" name="CcodigoclasF" desc="CdescripcionF"></td>
					</tr>
					<tr>
						<td align="right"><input type="checkbox" name="chkExistcero"></td>
						<td >Mostrar existencias en cero</td>
						<td>&nbsp;</td>
						<td align="right"><input type="checkbox" name="chkExistneg"></td>
						<td >Mostrar existencias negativas</td>
					</tr>
					<tr> 
						<td  align="right" valign="middle" nowrap><input type="checkbox" name="toExcel"/></td>
						<td  colspan="4" valign="baseline" nowrap><cf_translate  key="LB_ExpotarAExcel">Exportar a Excel</cf_translate></td>
					</tr>
					<tr>
						<td colspan="5" align="center"> <input name="btnConsultar" type="submit" value="Consultar"></td>
					</tr>
				</table>
			</form>
		<cf_web_portlet_end>	
<cf_templatefooter>
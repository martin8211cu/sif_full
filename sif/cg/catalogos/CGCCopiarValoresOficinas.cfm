<title>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_CopiaValoresOf"
		Default="Copiar Valores Oficinas"
		returnvariable="LB_CopiaValoresOf"/>
		<cfoutput>#LB_CopiaValoresOf#</cfoutput>
</title>	
<cf_templatecss>
<cf_web_portlet_start titulo="#LB_CopiaValoresOf#">

<!--- Solo muestras los periodos que tienen valores parametrizados --->
<cfquery name="rsPeriodos" datasource="#session.dsn#">
	select distinct CGCperiodo as value , <cf_dbfunction name="to_char" args="CGCperiodo">  as description  
	from CGParamConductores
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"/>
	order by value
</cfquery>

<cfquery name="rsMeses" datasource="#session.dsn#">
	select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">  as value, VSdesc as description
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
	and b.VSgrupo = 1
	and a.Iid = b.Iid
	order by 1
</cfquery>

<cfquery name="rsPeriodoAux" datasource="#session.dsn#"> 
	select Pvalor, Pdescripcion 
	from Parametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"/> 
	  and Pcodigo = 30 
	  and Mcodigo = 'CG'
</cfquery>
<cfquery name="rsMesAux" datasource="#session.dsn#">
	select Pvalor, Pdescripcion 
	from Parametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"/> 
	  and Pcodigo = 40 
	  and Mcodigo = 'CG'
</cfquery>


<cfquery name="rsUENS" datasource="#session.dsn#">
	Select (PCCDvalor + '-' + PCCDdescripcion) as UEN
	from  PCClasificacionD	
	where PCCEclaid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.PCCEclaid#"/> 
	  and PCCDclaid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.PCCDclaid#"/>  
</cfquery>
<cfset Tltuen = rsUENS.UEN>

<cfoutput>
	<form action="CGCCopiarValoresOficina-sql.cfm" method="post" name="form1">
		<table width="100%" border="0"  cellpadding="6">
			<tr>
				<td colspan=2 align="center"><cfoutput><strong>#Tltuen#</strong></cfoutput></td>
			</tr>
			<tr>
				<td width="50%" align="right"><strong><cf_translate  key="LB_Periodo">Periodo</cf_translate></strong>&nbsp;:</td>
				<td width="50%">
					<select name="CGCPeriodo" tabindex="1">
						<cfloop query="rsPeriodos">
							<option value="#rsPeriodos.value#" <cfif isdefined("rsPeriodoAux.Pvalor") and rsPeriodoAux.Pvalor eq rsPeriodos.value>selected</cfif> >#rsPeriodos.description#</option>
						</cfloop>
					</select>
				</td>
			</tr>
			<tr>
				<td align="right"><strong><cf_translate  key="LB_Mes">Mes</cf_translate></strong>&nbsp;:</td>
				<td>
					<select name="CGCmes" tabindex="2">
						<cfloop query="rsMeses">
							<option value="#rsMeses.value#" <cfif isdefined("rsMesAux.Pvalor") and rsMesAux.Pvalor eq rsMeses.value>selected</cfif> >#rsMeses.description#</option>
						</cfloop>
					</select>		
				</td>
			</tr>			
			<tr>
				<td align="right"><strong><cf_translate  key="LB_Sobreescribir">Sobreescribir Valores</cf_translate></strong>&nbsp;:</td>
				<td>
					<input type="checkbox" name="chksobwr" value="1">				
				</td>
			</tr>			
			<tr>
			<td colspan="2" align="center">
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Copiar"
			Default="Copiar"
			returnvariable="BTN_Copiar"/>
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Cerrar"
			Default="Cerrar"
			returnvariable="BTN_Cerrar"/>
			
			<input name="PERAUX" type="hidden" value="#rsPeriodoAux.Pvalor#">
			<input name="MESAUX" type="hidden" value="#rsMesAux.Pvalor#">

			<input name="PCCEclaid" type="hidden" value="#URL.PCCEclaid#">
			<input name="PCCDclaid" type="hidden" value="#URL.PCCDclaid#">
			
			<input name="btnCopiar" type="submit" value="#BTN_Copiar#" tabindex="4">
			<input name="btnCerrarDOWN" type="button" value="#BTN_Cerrar#" onClick="javascript:window.close();window.opener.location.reload();" tabindex="5"></td>
			</tr>
		</table>
	</form>
</cfoutput>
<cf_web_portlet_end>

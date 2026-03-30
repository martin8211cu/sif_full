<!---------
	Modificado por: Ana Villavicencio
	Fecha de modificación: 25 de mayo del 2005
	Motivo:	Se cambio el proceso de construccion del reporte utilizando Report Builder 
			ademas de la correccion de la consulta q no estaba correcta.
	Modificado por Gustavo Fonseca H.
		Fecha 19-9-2005.
		Motivo: el query del cffunction name="auxiliares" estaba utilizando el Ecodigo =1, se cambió para que utilice el de la session
----------->
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Cuenta" default="Cuenta" returnvariable="LB_Cuenta" xmlfile="SaldosPeriodoMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Periodo" default="Periodo" returnvariable="LB_Periodo" xmlfile="SaldosPeriodoMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mes" default="Mes" returnvariable="LB_Mes" xmlfile="SaldosPeriodoMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Formato" default="Visualizar en formato" returnvariable="LB_Formato" xmlfile="SaldosPeriodoMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Todas" default="Todas" returnvariable="LB_Todas" xmlfile="SaldosPeriodoMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Generar" default="Generar" returnvariable="BTN_Generar" xmlfile="SaldosPeriodoMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TituloHeader" default="Bancos" returnvariable="LB_TituloHeader" xmlfile="SaldosPeriodoMes.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TituloReporte" default="Reporte de Movimientos por Período/Mes" returnvariable="LB_TituloReporte" xmlfile="SaldosPeriodoMes.xml"/>


<cfif not isdefined("form.MLmes") and  isdefined("url.MLmes")>
	<cfset form.MLmes = url.MLmes>
</cfif>
<!--- ---><cfif not isdefined("form.MLperiodo") and  isdefined("url.MLperiodo")>
	<cfset form.MLperiodo = url.MLperiodo>
</cfif> 

<cfif not isdefined("form.CBid") and  isdefined("url.CBid")>
	<cfset form.CBid = url.CBid>
</cfif>

<cfquery name="rsPeriodos" datasource="#session.DSN#">
	select distinct MLperiodo
	from MLibros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by MLperiodo
</cfquery>

<cfquery name="rsMes" datasource="sifcontrol">
	select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as VSvalor, VSdesc as VSdesc
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
	  and b.VSgrupo = 1
	  and a.Iid = b.Iid
	order by 1
</cfquery>



<cfquery name="rsCuentasBancos" datasource="#session.DSN#">
	select CBid as CBid, rtrim(CBcodigo) as CBcodigo from CuentasBancos
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    	and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">  
	order by CBcodigo
</cfquery>

<cffunction name="auxiliares" access="public" returntype="string">
	<cfargument name="valor"  type="numeric" required="true" default="<!--- Código de la línea de Título --->">
	<cfquery name="rsget_aux" datasource="#session.DSN#" >

		select Pvalor from Parametros 
		where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo = #valor#

	</cfquery>
	<cfreturn #rsget_aux.Pvalor#>
</cffunction>


<cf_templateheader title="#LB_TituloHeader#">

<form name="form1" method="post">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" 
					titulo='#LB_TituloReporte#'>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr><td><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
			<tr>	
				<td valign="top" align="center">
					<table width="80%" border="0" cellspacing="0" cellpadding="0" align="center">
						<tr><td width="8%">&nbsp;</td></tr>
						<tr>
							<cfset periodo = auxiliares(50) >

							<td align="right"><strong><cfoutput>#LB_Cuenta#</cfoutput>:</strong>&nbsp;</td>
							<td width="25%">
								<select name="CBid">
									<option value="0"><cfoutput>#LB_Todas#</cfoutput></option>
									<cfoutput query="rsCuentasBancos">
										<option value="#CBid#" <cfif isdefined('form.CBid') and #CBid# eq #form.CBid#>selected</cfif>> #CBcodigo#</option>
									</cfoutput>
								</select>
							</td>

							<td align="right"><strong><cfoutput>#LB_Periodo#</cfoutput>:</strong>&nbsp;</td>
							<td width="13%">
								<select name="MLperiodo">
									<cfoutput query="rsPeriodos">
										<option value="#MLperiodo#" <cfif isdefined('form.MLperiodo') and MLperiodo eq form.MLperiodo>selected</cfif>>#MLperiodo#</option>
									</cfoutput>
								</select>
							</td>
							<cfset mes = auxiliares(60) >
							<td width="5%" align="right"><strong><cfoutput>#LB_Mes#</cfoutput>:</strong>&nbsp;</td>					
							<td width="11%">
								<select name="MLmes">
									<cfoutput query="rsMes">
										<option value="#VSvalor#" <cfif isdefined('form.MLmes') and VSvalor eq #form.MLmes#>selected</cfif>>#VSdesc#</option>
									</cfoutput>
								</select>
							</td>
							<td width="19%" align="right" nowrap><strong><cfoutput>#LB_Formato#</cfoutput>:</strong></td>
							<td width="17%">
								<select name="formato">
									<option value="flashpaper" <cfif IsDefined("form.formato") and form.formato EQ "flashpaper">selected </cfif> >FLASHPAPER</option>
									<option value="pdf" <cfif IsDefined("form.formato") and form.formato EQ "pdf">selected </cfif>>PDF</option>
									<option value="excel" <cfif IsDefined("form.formato") and form.formato EQ "excel">selected </cfif>>HTML-EXCEL</option>
								</select>
							</td>
							<td width="27%">&nbsp;</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					</table>
				</td>
			</tr>		
			<tr>
				<td colspan="2">
					<cfif isdefined('form.MLmes') and isdefined('form.MLperiodo')>
						<cfif not isdefined('form.Formato')>
							<cfset form.formato = 'flashpaper'>
						</cfif>
						<cfoutput>
								<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
									<tr><td height="700">
									<iframe id="frReporteMovimientos" frameborder="0" width="100%" height="100%"
											src="formSaldosPeriodosMes.cfm?MLmes=#form.MLmes#&MLperiodo=#form.MLperiodo#&CBid=#form.CBid#
												<cfif isdefined('form.Formato')>
													&formato=#form.formato#
												</cfif>">">
									</iframe>
									</td></tr>	
								</table>
						</cfoutput>
					</cfif>
				</td>
			</tr>	
		</table>
		<input name="visualiza" type="submit" value="<cfoutput>#BTN_Generar#</cfoutput>" />
<cf_web_portlet_end>
</form>
<cf_templatefooter>

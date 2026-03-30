<cfsetting requesttimeout="36000">
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfif isdefined("url.TipoConsulta") and len(url.TipoConsulta) and not isdefined("form.TipoConsulta")><cfset form.TipoConsulta = url.TipoConsulta></cfif>
<cfif isdefined("url.ConMonedas") and len(url.ConMonedas) and not isdefined("form.ConMonedas")><cfset form.ConMonedas = url.ConMonedas></cfif>

<!--- Obtiene el mes de Auxiliares --->
<cfquery name="rsSQL" datasource="#session.dsn#">
select Pvalor
  from Parametros
 where Ecodigo = #session.Ecodigo#
   and Pcodigo = 50
</cfquery>
<cfset LvarAuxAno = rsSQL.Pvalor>
<cfquery name="rsSQL" datasource="#session.dsn#">
	select Pvalor
	  from Parametros
	 where Ecodigo = #session.Ecodigo#
	   and Pcodigo = 60
</cfquery>
<cfset LvarAuxMes = rsSQL.Pvalor>
<cfset LvarAuxAnoMes = LvarAuxAno*100+LvarAuxMes>

<cfif isdefined("form.btnRefrescar")>
	<!--- Obtiene las Cuentas de Presupuesto existentes (correspondientes a las cuentas de Version) --->
	<!--- Actualiza los tipos de Cambio Proyectados por Mes y actualiza el monto a aplicar--->
	<!--- Actualiza los Totales de Formulacion por Cuenta+Año+Mes+Oficina (sin Moneda) --->
	<cfset LobjAjuste = createObject( "component","sif.Componentes.PRES_Formulacion")>
	<cfset LobjAjuste.AjustaFormulacion(form.CVid)>
<cfelseif isdefined("form.btnAjustar")>
	<!--- Borra formulaciones anteriores --->
	<!--- Obtiene las Cuentas de Presupuesto existentes (correspondientes a las cuentas de Version) --->
	<!--- Actualiza los tipos de Cambio Proyectados por Mes y actualiza el monto a aplicar--->
	<!--- Actualiza los Totales de Formulacion por Cuenta+Año+Mes+Oficina (sin Moneda) --->
	<cfquery name="rsSQL" datasource="#session.dsn#">
		delete from CVFormulacionMonedas
		 where Ecodigo	= #session.Ecodigo#
		   and CVid 	= #form.CVid#
		   and CPCano*100+CPCmes < #LvarAuxAnoMes#
	</cfquery>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		delete from CVFormulacionTotales
		 where Ecodigo	= #session.Ecodigo#
		   and CVid 	= #form.CVid#
		   and CPCano*100+CPCmes < #LvarAuxAnoMes#
	</cfquery>
	<cfset LobjAjuste = createObject( "component","sif.Componentes.PRES_Formulacion")>
	<cfset LobjAjuste.AjustaFormulacion(form.CVid)>
</cfif>

<!--- Obtiene la Moneda de la Empresa --->
<cfquery name="qry_monedaEmpresa" datasource="#session.dsn#">
	select e.Mcodigo, m.Mnombre
	from Empresas e, Monedas m
	where e.Ecodigo = #Session.Ecodigo#
	  and m.Ecodigo = e.Ecodigo
	  and m.Mcodigo = e.Mcodigo
</cfquery>
<cfif find(",",qry_monedaEmpresa.Mnombre) GT 0>
	<cfset LvarMnombreEmpresa = trim(mid(qry_monedaEmpresa.Mnombre,find(",",qry_monedaEmpresa.Mnombre)+1,100))>
<cfelse>	
	<cfset LvarMnombreEmpresa = qry_monedaEmpresa.Mnombre>
</cfif>

<cfset LvarTiposConsulta = ArrayNew(1)>
<cfset LvarTiposConsulta[1]  = "Tipo Cuenta">
<cfset LvarTiposConsulta[2]  = "Tipo Cuenta, Mes">
<cfset LvarTiposConsulta[3]  = "Tipo Cuenta, Mayor">
<cfset LvarTiposConsulta[4]  = "Tipo Cuenta, Mes, Mayor">
<cfset LvarTiposConsulta[5]  = "Tipo Cuenta, Mayor, Mes">
<cfset LvarTiposConsulta[6]  = "Tipo Cuenta, Mayor, Cuenta">
<cfset LvarTiposConsulta[7]  = "Tipo Cuenta, Mayor, Cuenta, Mes">
<cfset LvarTiposConsulta[8]  = "Tipo Cuenta, Mayor, Mes, Cuenta">
<cfset LvarTiposConsulta[9]  = "Tipo Cuenta, Mes, Mayor, Cuenta">
<cfset LvarTiposConsulta[10] = "Tipo Cuenta, Mayor, Cuenta, Oficina">
<cfset LvarTiposConsulta[11] = "Tipo Cuenta, Mayor, Cuenta, Oficina, Mes">
<cfset LvarTiposConsulta[12] = "Tipo Cuenta, Mayor, Cuenta, Mes, Oficina">
<cfset LvarTiposConsulta[13] = "Tipo Cuenta, Mayor, Mes, Cuenta, Oficina">
<cfset LvarTiposConsulta[14] = "Tipo Cuenta, Mes, Mayor, Cuenta, Oficina">
<cfset LvarTiposConsulta[15] = "Tipo Cuenta, Mayor, Oficina, Cuenta">
<cfset LvarTiposConsulta[16] = "Tipo Cuenta, Mayor, Oficina, Cuenta, Mes">
<cfset LvarTiposConsulta[17] = "Tipo Cuenta, Mayor, Oficina, Mes, Cuenta">
<cfset LvarTiposConsulta[18] = "Tipo Cuenta, Mayor, Mes, Oficina, Cuenta">
<cfset LvarTiposConsulta[19] = "Tipo Cuenta, Mes, Mayor, Oficina, Cuenta">

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select 	v.CVid, v.CVaprobada, v.CVtipo, 
				p.CPPid, p.CPPfechaDesde, p.CPPtipoPeriodo, p.CPPestado
		  from CVersion v
				INNER JOIN CPresupuestoPeriodo p
					ON p.CPPid = v.CPPid
		 where v.Ecodigo 	= #session.Ecodigo#
		   and CVid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
	</cfquery>
	
	<cfset LvarCVid = rsSQL.CVid>
	<cfset LvarCPPid = rsSQL.CPPid>

	<cfif rsSQL.CPPestado EQ "0">
		<cfset LvarAprobacion = true>
	<cfelse>
		<cfset LvarAprobacion = false>
	</cfif>

<cfif isdefined("form.TipoConsulta")>
	<cfparam name="form.ConMonedas" default="0">
<cfelse>	
	<cfparam name="form.ConMonedas" default="1">
</cfif>
<cfparam name="form.TipoConsulta" default="-1">

<cfif form.TipoConsulta EQ "-1">
	<cfquery name="qry_lista" datasource="#session.dsn#">
		select 	cvfm.CVPcuenta
		  from	CVFormulacionMonedas cvfm
		 where cvfm.Ecodigo = #Session.Ecodigo#
		   and cvfm.CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
		   <cfif isdefined("form.chkConFormulacion")>
		   and cvfm.CVFMmontoAplicar <> 0
		   </cfif>
	</cfquery>
<cfelse>
	<cfset LvarParametrosCampos = ArrayNew(2)>
	<cfset fnParametrosCampos (1, 	"Tipo Cuenta", 
									"case cvm.Ctipo when 'A' then 'Activo' when 'P' then 'Pasivo' when 'C' then 'Capital' when 'I' then 'Ingreso' when 'G' then 'Gasto' when 'O' then 'Orden' end as Tipo_Cuenta",
																				"cvm.Ctipo",		"S", "left")>
	<cfset fnParametrosCampos (2, 	"Mayor", 	"cvm.Cmayor as Mayor", 			"cvm.Cmayor", 				"S", "left")>
	<cfset fnParametrosCampos (3, 	"Cuenta", 	"cvp.CPformato as Cuenta", 		"cvp.CPformato", 			"S", "left")>
	<cfset fnParametrosCampos (4, 	"Oficina", 	"o.Odescripcion as Oficina", 	"o.Odescripcion", 			"S", "left")>
	<cf_dbfunction name="to_char" args="cvfm.CPCano" returnvariable="LvarMes">
	<cfset fnParametrosCampos (5, 	"Mes", 		
									"cvfm.CPCano, cvfm.CPCmes, #LvarMes# #_Cat# '-' #_Cat# case cvfm.CPCmes when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end as Mes", 
																				"cvfm.CPCano, cvfm.CPCmes",	"S", "left")>
	<cfset fnParametrosCampos (6, 	"Moneda", 	"m.Miso4217 as Moneda", 		"m.Miso4217", 				"S", "center")>
	
	
	
	<cfset fnParametrosCampos (7, 	"Formulaciones Aprobadas", 	
									"sum((cvfm.CVFMmontoBase + cvfm.CVFMajusteUsuario + cvfm.CVFMajusteFinal) - cvfm.CVFMmontoAplicar) as Formulaciones_Aprobadas",
																				"",							"M", "right")>
	<cfset fnParametrosCampos (8, 	"Monto Solicitado", 	
									"sum((cvfm.CVFMmontoBase + cvfm.CVFMajusteUsuario + cvfm.CVFMajusteFinal)) as Monto_Solicitado",
																				"",							"M", "right")>
	<cfset fnParametrosCampos (9, 	"Modificacion Solicitada", 	
									"sum(cvfm.CVFMmontoAplicar) as Modificacion_Solicitada",
																				"",							"M", "right")>
	
	<cfset fnParametrosCampos (10, 	"Formulaciones Aprobadas Local", 	
									"sum(((cvfm.CVFMmontoBase + cvfm.CVFMajusteUsuario + cvfm.CVFMajusteFinal) - cvfm.CVFMmontoAplicar)*cvfm.CVFMtipoCambio) as Formulaciones_Aprobadas_Local",
																				"",							"M", "right")>
	<cfset fnParametrosCampos (11, 	"Solicitado Moneda Local", 	
									"sum((cvfm.CVFMmontoBase + cvfm.CVFMajusteUsuario + cvfm.CVFMajusteFinal)*cvfm.CVFMtipoCambio) as Solicitado_Moneda_Local",
																				"",							"M", "right")>
	<cfset fnParametrosCampos (12, 	"Modificacion Moneda Local", 	
									"sum(cvfm.CVFMmontoAplicar*cvfm.CVFMtipoCambio) as Modificacion_Moneda_Local",
																				"",							"M", "right")>
	<cfset fnParametrosCampos (13, 	"T", 	"0 as T", 							"", 						"S", "left")>
	
	<cfset LvarTipoConsulta = form.TipoConsulta>
	<cfif form.ConMonedas EQ 1>
		<cfset LvarTipoConsulta = LvarTipoConsulta & ",Moneda">
		<cfif LvarAprobacion>
			<cfset LvarTipoConsulta = LvarTipoConsulta & ",Monto Solicitado,Solicitado Moneda Local">
		<cfelse>
			<cfset LvarTipoConsulta = LvarTipoConsulta & ",Formulaciones Aprobadas,Monto Solicitado,Modificacion Solicitada,Formulaciones Aprobadas Local,Solicitado Moneda Local,Modificacion Moneda Local">
		</cfif>
	<cfelse>
		<cfif LvarAprobacion>
			<cfset LvarTipoConsulta = LvarTipoConsulta & ",Solicitado Moneda Local">
		<cfelse>
			<cfset LvarTipoConsulta = LvarTipoConsulta & ",Formulaciones Aprobadas Local,Solicitado Moneda Local,Modificacion Moneda Local">
		</cfif>
	</cfif>
	
	<cfset LvarEtiquetas	= replace(LvarTipoConsulta,", ",",","ALL")>
	<cfset LvarDesplegar	= replace(LvarEtiquetas," ","_","ALL")>
	<cfset LvarEtiquetas	= replace(LvarEtiquetas,"Moneda Local","<BR>#LvarMnombreEmpresa#","ALL")>
	<cfset LvarEtiquetas	= replace(LvarEtiquetas,"Local","<BR>#LvarMnombreEmpresa#","ALL")>
	<cfset LvarSelect 		= fnCrearCampos(LvarTipoConsulta, 2)>
	<cfset LvarGroupBy 		= fnCrearCampos(LvarTipoConsulta, 3)>
	<cfset LvarFormatos 	= fnCrearCampos(LvarTipoConsulta, 4)>
	<cfset LvarAlign	 	= fnCrearCampos(LvarTipoConsulta, 5)>
	
	<cfquery name="qry_lista" datasource="#session.dsn#">
		select 	cvfm.CVid, #preserveSingleQuotes(LvarSelect)#, min(coalesce(cvfm.CVFMtipoCambio,0)) as Nulo, 
				case cvm.Ctipo when 'A' then 1 when 'P' then 2 when 'C' then 3 when 'I' then 4 when 'G' then 5 else 6 end as Orden
		  from	CVFormulacionMonedas cvfm
				inner join CVPresupuesto cvp
					inner join CVMayor cvm
						 on cvm.Ecodigo	= cvp.Ecodigo
						and cvm.CVid	= cvp.CVid
						and cvm.Cmayor	= cvp.Cmayor
					 on cvp.Ecodigo		= cvfm.Ecodigo
					and cvp.CVid		= cvfm.CVid
					and cvp.CVPcuenta	= cvfm.CVPcuenta
				inner join Oficinas o
					 on o.Ecodigo		= cvfm.Ecodigo
					and o.Ocodigo		= cvfm.Ocodigo
				inner join Monedas m
					 on m.Mcodigo		= cvfm.Mcodigo
		 where cvfm.Ecodigo = #Session.Ecodigo#
		   and cvfm.CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
		   <cfif isdefined("form.chkConFormulacion")>
		   and cvfm.CVFMmontoAplicar <> 0
		   </cfif>
		 group by cvfm.CVid, #LvarGroupBy#
		 order by case cvm.Ctipo when 'A' then 1 when 'P' then 2 when 'C' then 3 when 'I' then 4 when 'G' then 5 else 6 end
	</cfquery>
</cfif>

<cfquery name="qry_Monedas" datasource="#session.dsn#">
	select 	distinct m.Miso4217 #_Cat# ' - ' #_Cat# m.Mnombre as Moneda, <cf_dbfunction name="to_char" args="cvfm.CPCano"> #_Cat# '-' #_Cat# case cvfm.CPCmes when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end as Mes
	  from	CVFormulacionMonedas cvfm
			inner join Monedas m
				 on m.Mcodigo		= cvfm.Mcodigo
	 where cvfm.Ecodigo = #Session.Ecodigo#
	   and cvfm.CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
	   and cvfm.CVFMmontoAplicar <> 0 and coalesce(cvfm.CVFMtipoCambio,0) = 0
</cfquery>

<cfoutput>
<cfif isdefined("request.CFaprobacion_MesesAnt")>
	<cfset LvarCFM = "aprobacion_MesesAnt.cfm">
<cfelse>
	<cfset LvarCFM = "aprobacion.cfm">
</cfif>
<form action="#LvarCFM#" method="post" name="form1">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<cfinclude template="versiones_header.cfm">
	<tr>
		<td>
			<strong>Tipo Consulta&nbsp;:&nbsp;</strong>
		</td>
		<td>
			<select name="TipoConsulta" onChange="document.form1.submit();">
				<option value="-1" <cfif form.TipoConsulta EQ -1>selected</cfif>>(Sin Consulta)</option>
			<cfloop index="i" from="1" to="#ArrayLen(LvarTiposConsulta)#">
				<option value="#LvarTiposConsulta[i]#" <cfif form.TipoConsulta EQ LvarTiposConsulta[i]>selected</cfif>>#LvarTiposConsulta[i]#</option>
			</cfloop>
			</select>
		</td>
		<td>
			<input type="checkbox" name="ConMonedas" value="1" <cfif form.ConMonedas EQ "1">checked</cfif> onClick="document.form1.submit();">Formulación con Moneda
		</td>
		<td>
			<input type="checkbox" name="chkConFormulacion" <cfif isdefined("form.chkConFormulacion")>checked</cfif> onClick="document.form1.submit();">
			Crear sólo cuentas con Formulación<BR>
		<cfif qry_cvm.CVtipo EQ 2>
			<input type="checkbox" name="chkActualizarControl" <cfif isdefined("form.chkActualizarControl")>checked</cfif>>
			Reemplazar Tipos de Control y de Calculo<BR>
		</cfif>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select count(1) as cantidad
				  from CVFormulacionMonedas
				 where Ecodigo	= #session.Ecodigo#
				   and CVid 	= #LvarCVid#
				   and CPCano*100+CPCmes < #LvarAuxAnoMes#
			</cfquery>
			<cfif rsSQL.cantidad GT 0>
				<strong><font color="##FF0000">Existen Formulaciones en Meses Anteriores</font></strong><BR>
				<cfif isdefined("request.CFaprobacion_MesesAnt")>    
               		<cfif qry_Monedas.recordCount EQ 0 AND qry_Lista.recordCount GT 0>
						<input type="button" name="btnAprobar" value="Aprobar" onClick="fnAprobarFrm();">
					</cfif>
				<cfelse>
					<input type="submit" name="btnAjustar" value="Borrar Meses Anteriores">
                </cfif>
			<cfelse> 
				<cfif qry_Monedas.recordCount EQ 0 AND qry_Lista.recordCount GT 0>
					<input type="button" name="btnAprobar" value="Aprobar" onClick="fnAprobarFrm();">
				</cfif>
				<input type="submit" name="btnRefrescar" value="Refrescar">
			</cfif>
			<input type="submit" name="btnRegresar" value="Regresar" onClick="document.form1.CVid.value = ''">
		</td>
	</tr>
</table>
</form>
<cfset session.CFaprobacion.Paso = -1000>
<cfif isdefined("request.CFaprobacion_MesesAnt")>
	<cfset LvarCFM = "aprobacion_wait.cfm?MesesAnt">
<cfelse>
	<cfset LvarCFM = "aprobacion_wait.cfm">
</cfif>
<script language="javascript">
	function fnAprobarFrm()
	{
		if (confirm("¿Desea aprobar la Version #qry_cvm.Vdescripcion# para el Período #qry_cvm.CPPdescripcion#?"))
		{
			document.form1.action = "/cfmx/sif/presupuesto/versiones/#LvarCFM#";
			document.form1.submit();
		}
		
	}
</script>
</cfoutput>

<cfif form.TipoConsulta neq "-1">
	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="PListaRet">
		<cfinvokeargument name="query" value="#qry_lista#">
		<cfinvokeargument name="desplegar" value="#LvarDesplegar#"/>
		<cfinvokeargument name="etiquetas" value="#LvarEtiquetas#"/>
		<cfinvokeargument name="formatos" value="#LvarFormatos#"/>
		<cfinvokeargument name="align" value="#LvarAlign#"/>
		<cfinvokeargument name="navegacion" value="CVid=#form.CVid#&TipoConsulta=#URLEncodedFormat(form.TipoConsulta)#&ConMonedas=#form.ConMonedas#"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="showlink" value="false"/>
		<cfinvokeargument name="showEmptyListMsg" value="true"/>
		<cfinvokeargument name="maxrows" value="10"/>
		<cfinvokeargument name="LineaRoja" value="Nulo EQ 0"/>
		<cfinvokeargument name="width" value="60%"/>
	</cfinvoke>	

	<br>
	<cfif qry_lista.recordCount EQ 0>
	<div align="center" style="color:#FF0000">
	No se ha solicitado ningun monto para esta Version<BR><BR>
	</div>
	</cfif>
	</div>
</cfif>

<cfif qry_Monedas.recordCount GT 0>
	<div align="center" style="color:#FF0000">
	<strong>(*) Faltan Definir Tipos de Cambio Proyectados por Mes</strong><BR><BR>
	</div>

	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="PListaRet">
		<cfinvokeargument name="query" value="#qry_Monedas#">
		<cfinvokeargument name="desplegar" value="Moneda, Mes"/>
		<cfinvokeargument name="etiquetas" value="Moneda, Mes"/>
		<cfinvokeargument name="formatos" value="S,S"/>
		<cfinvokeargument name="align" value="left, left"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="showlink" value="false"/>
		<cfinvokeargument name="showEmptyListMsg" value="true"/>
		<cfinvokeargument name="maxrows" value="0"/>
		<cfinvokeargument name="LineaRoja" value="true"/>
		<cfinvokeargument name="width" value="30%"/>
	</cfinvoke>	
	
</cfif>
</div>

<cffunction name="fnParametrosCampos">
	<cfargument name="i" type="numeric" required="yes">
	<cfargument name="Nombre" type="string" required="yes">
	<cfargument name="Select" type="string" required="yes">
	<cfargument name="GroupBy" type="string" required="yes">
	<cfargument name="Formato" type="string" required="yes">
	<cfargument name="Align" type="string" required="yes">
	
	<cfset LvarParametrosCampos [Arguments.i][1] = Arguments.Nombre>
	<cfset LvarParametrosCampos [Arguments.i][2] = Arguments.Select>
	<cfset LvarParametrosCampos [Arguments.i][3] = Arguments.GroupBy>
	<cfset LvarParametrosCampos [Arguments.i][4] = Arguments.Formato>
	<cfset LvarParametrosCampos [Arguments.i][5] = Arguments.Align>
</cffunction>

<cffunction name="fnCrearCampos" returntype="string">
	<cfargument name="Nombre" type="string" required="yes">
	<cfargument name="i" type="numeric" required="yes">
	
	<cfset LvarCampos = listToArray(Arguments.Nombre)>
	<cfset LvarLinea = "">
	<cfloop index="c" from="1" to="#ArrayLen(LvarCampos)#">
		<cfloop index="j" from="1" to="#ArrayLen(LvarParametrosCampos)#">
			<cfif trim(LvarCampos[c]) EQ trim(LvarParametrosCampos[j][1])>
				<cfbreak>
			</cfif>
		</cfloop>

		<cfif LvarParametrosCampos [j][Arguments.i] NEQ "">
			<cfif c GT 1>
				<cfset LvarLinea = LvarLinea & ",">
			</cfif>
			<cfif Arguments.i EQ 2 and findNoCase("local",LvarCampos[c]) GT 0>
			<cfset LvarLinea = LvarLinea & " case when min(coalesce(cvfm.CVFMtipoCambio,0))<>0 then " & replace(LvarParametrosCampos [j][Arguments.i]," as "," end as ")>
			<cfelse>
			<cfset LvarLinea = LvarLinea & LvarParametrosCampos [j][Arguments.i]>
			</cfif>
		</cfif>
	</cfloop>
	<cfreturn LvarLinea>
</cffunction>


<!--- 
	Mdulo    : Contabilidad General
	Nombre    : Reporte de Balance de Comprobacin por Cuenta Mayor
	Hecho por : Randall Colomer en SOIN
	Creado    : 28/07/2006
 --->

<cfsetting requesttimeout="3600">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo"	 default="Balanza de Comprobaci&oacute;n por Cuenta de Mayor"		returnvariable="LB_Titulo"		 xmlfile="BalCompPorCtaMayor-sql.xml"/>
<cfinvoke component="sif.Componentes.Translate"  method="Translate" key="LB_Archivo" default="BalanceComprobacionPorCuentaMayor"		returnvariable="LB_Archivo"		 xmlfile="BalCompPorCtaMayor-sql.xml"/>
<cfinvoke component="sif.Componentes.Translate"  method="Translate" key="LB_Periodo" default="Per&iacute;odo"		
returnvariable="LB_Periodo"		 xmlfile="BalCompPorCtaMayor-sql.xml"/>
<cfinvoke component="sif.Componentes.Translate"  method="Translate" key="LB_Mes" default="Mes"		
returnvariable="LB_Mes"		 xmlfile="BalCompPorCtaMayor-sql.xml"/>
<cfinvoke component="sif.Componentes.Translate"  method="Translate" key="LB_Mensual" default="Mensual"		
returnvariable="LB_Mensual"		 xmlfile="BalCompPorCtaMayor-sql.xml"/>
<cfinvoke component="sif.Componentes.Translate"  method="Translate" key="LB_Acumulado" default="Acumulado"		
returnvariable="LB_Acumulado"		 xmlfile="BalCompPorCtaMayor-sql.xml"/>
<cfinvoke component="sif.Componentes.Translate"  method="Translate" key="LB_Empresa" default="Empresa"		
returnvariable="LB_Empresa"		 xmlfile="BalCompPorCtaMayor-sql.xml"/>
<cfinvoke component="sif.Componentes.Translate"  method="Translate" key="LB_Office" default="Office"		
returnvariable="LB_Office"		 xmlfile="BalCompPorCtaMayor-sql.xml"/>
<cfinvoke component="sif.Componentes.Translate"  method="Translate" key="Oficina" default="Oficina"		
returnvariable="LB_Oficina"		 xmlfile="/sif/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate"  method="Translate" key="LB_CuentaMayor" default="Cuenta Mayor"		
returnvariable="LB_CuentaMayor"		 xmlfile="BalCompPorCtaMayor-sql.xml"/>
<cfinvoke component="sif.Componentes.Translate"  method="Translate" key="LB_Descripcion" default="Descripci&oacute;n"		
returnvariable="LB_Descripcion"		 xmlfile="BalCompPorCtaMayor-sql.xml"/>
<cfinvoke component="sif.Componentes.Translate"  method="Translate" key="LB_Debitos" default="D&eacute;bitos"		
returnvariable="LB_Debitos"		 xmlfile="BalCompPorCtaMayor-sql.xml"/>
<cfinvoke component="sif.Componentes.Translate"  method="Translate" key="LB_Creditos" default="Cr&eacute;ditos"		
returnvariable="LB_Creditos"		 xmlfile="BalCompPorCtaMayor-sql.xml"/> 
<cfinvoke component="sif.Componentes.Translate"  method="Translate" key="LB_FinConsulta " default="Fin de la Consulta"		
returnvariable="LB_FinConsulta"		 xmlfile="BalCompPorCtaMayor-sql.xml"/>
<cfinvoke component="sif.Componentes.Translate"  method="Translate" key="LB_SinRegistros " default="No se encontraron registros que cumplan los filtros" returnvariable="LB_SinRegistros"		 xmlfile="BalCompPorCtaMayor-sql.xml"/>
<cfinvoke component="sif.Componentes.Translate"  method="Translate" key="LB_GpoEmpr" default="Grupo de Empresa"		
returnvariable="LB_GpoEmpr"		 xmlfile="BalCompPorCtaMayor-sql.xml"/>
<cfinvoke component="sif.Componentes.Translate"  method="Translate" key="LB_GpoOf" default="Grupo de Oficina"		
returnvariable="LB_GpoOf"		 xmlfile="BalCompPorCtaMayor-sql.xml"/>


<!--- Empresas u Oficinas --->
<cfif isDefined("form.ubicacion")>
	<cfset myEcodigo = IIf(len(trim(form.ubicacion)) EQ 0, session.Ecodigo,-1)>
	<cfset myGEid    = IIf(ListFirst(form.ubicacion) EQ 'ge', ListRest(form.ubicacion), -1)>
	<cfset myGOid    = IIf(ListFirst(form.ubicacion) EQ 'go', ListRest(form.ubicacion), -1)>
	<cfset myOcodigo = IIf(ListFirst(form.ubicacion) EQ 'of', ListRest(form.ubicacion), -1)>
	<cfset mySLinicial = "SLinicialGE">
	<cfset mySOinicial = "SOinicialGE">
<cfelse>
	<cfset myEcodigo = session.Ecodigo>
	<cfset myGEid = "-1">
	<cfset myGOid = "-1">
	<cfset myOcodigo = "-1">
	<cfset mySLinicial = "SLinicial">
	<cfset mySOinicial = "SOinicial">
</cfif>

<!--- Obtiene la Ubicacin --->
<cfset lstOficinas = "">
<cfset lstEmpresas = "">
<cfset ubiDescripcion = "">

<cfquery name="rsMesCierreConta" datasource="#Session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = #Session.Ecodigo#
	and Pcodigo = 45
</cfquery>

<cfparam name="form.CHKMesCierre" default="0">
<cfset LvarCHKMesCierre = form.CHKMesCierre>
<cfif rsMesCierreConta.Pvalor NEQ form.mes and form.CHKMesCierre EQ "1">
	<cfset LvarCHKMesCierre = "0">
</cfif>

<!--- Se obtiene descripcion para encabazados --->
<cfif myOcodigo NEQ -1>
	<!--- Obtiene la descripcin de la Oficina--->
	<cfquery name="rsOficinas" datasource="#Session.DSN#">
		select Odescripcion
		from Oficinas 
		where Ecodigo = #Session.Ecodigo#
			and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#myOcodigo#" > 
	</cfquery>
	<cfif rsOficinas.recordCount EQ 1>
		<cfset ubiDescripcion = "#LB_Oficina#: " & #rsOficinas.Odescripcion#>
	</cfif>
	
	<!--- Define para query lista de oficinas igual a la oficina consultada --->
	<cfset lstOficinas = myOcodigo>
	<cfset lstEmpresas = Session.Ecodigo>
	
<cfelseif myEcodigo NEQ -1>
	<!--- Obtiene la descripcin de la Empresa--->
	<cfset ubiDescripcion = "#LB_Empresa#: " & #HTMLEditFormat(session.Enombre)#>
	
	<!--- Se asigna los valores a la lista de Empresa y Oficina --->
	<cfquery name="rsOficinas" datasource="#Session.DSN#">
		select Ocodigo
		from Oficinas 
		where Ecodigo = #Session.Ecodigo#
	</cfquery>

	<cfif rsOficinas.recordCount gt 0>
		<cfset arrOf = ArrayNew(1)>
		<cfloop query="rsOficinas">
			<cfset temp = ArrayAppend(arrOf,#rsOficinas.Ocodigo#)>
		</cfloop>
		<cfset lstOficinas = ArrayToList(arrOf)>
	</cfif>
	<cfset lstEmpresas = Session.Ecodigo>
	
<cfelseif myGEid NEQ -1>
	<!--- Obtiene la descripcin del grupo de empresas--->
	<cfquery name="rsGE" datasource="#session.DSN#">
		select ge.GEnombre
		from AnexoGEmpresa ge
		where ge.GEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#myGEid#">
			and ge.CEcodigo = #session.CEcodigo#
	</cfquery>
	<cfif rsGE.recordCount EQ 1>
		<cfset ubiDescripcion = "#LB_GpoEmpr#: " & #rsGE.GEnombre#>
	</cfif>
	
	<!--- Se asigna los valores a la lista de Empresa y Oficina --->
	<cfquery name="rsGEmpresas" datasource="#session.DSN#">
		select gd.Ecodigo
		from AnexoGEmpresa ge
			inner join AnexoGEmpresaDet gd
			on ge.GEid = gd.GEid					
		where ge.GEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#myGEid#">									
	</cfquery>
	
	<cfif rsGEmpresas.recordCount gt 0>
		<cfset arrGE = ArrayNew(1)>
		<cfloop query="rsGE">
			<cfset temp = ArrayAppend(arrGE,#rsGEmpresas.Ecodigo#)>
		</cfloop>
		<cfset lstEmpresas = ArrayToList(arrGE)>
	</cfif>
	
<cfelseif myGOid NEQ -1>
	<!--- Obtiene la descripcin del grupo de Oficinas--->
	<cfquery name="rsGO" datasource="#session.DSN#">
		select GOid, GOnombre
		from AnexoGOficina
		where Ecodigo = #session.Ecodigo#
			and GOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#myGOid#">
	</cfquery>
	<cfif rsGO.recordCount EQ 1>
		<cfset ubiDescripcion = "#LB_GpoOf#: " & #rsGO.GOnombre#>
	</cfif>	

	<!--- Se asigna los valores a la lista de Empresa y Oficina --->
	<cfquery name="rsOficinas" datasource="#Session.DSN#">
		select Ocodigo
		from AnexoGOficinaDet
		where GOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#myGOid#">
			and Ecodigo = #session.Ecodigo#
	</cfquery>
	
	<cfif rsOficinas.recordCount gt 0>
		<cfset arrOf = ArrayNew(1)>
		<cfloop query="rsOficinas">
			<cfset temp = ArrayAppend(arrOf,#rsOficinas.Ocodigo#)>
		</cfloop>
		<cfset lstOficinas = ArrayToList(arrOf)>
	<cfelse>
		<cfset lstOficinas = -1>
	</cfif>
	<cfset lstEmpresas = Session.Ecodigo>
	
</cfif>

<cfif not LvarCHKMesCierre>
	<cfif isdefined("form.IncluirOficina")>
		<cfsavecontent variable="queryBalanceCtaMayorOficina">
			<cfoutput>
				select
					o.Oficodigo,
					o.Odescripcion,
					m.Cmayor,
					m.Cdescripcion,
					(coalesce((
								<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) NEQ -2>
									select sum(s.#mySOinicial#)
								<cfelse>
									select sum(s.#mySLinicial#)
								</cfif>
								from SaldosContables s
								where s.Speriodo = #form.periodo#
								  and s.Smes = #form.mes#
								<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) NEQ -2>
								  and s.Mcodigo = #form.Mcodigo#
								</cfif>
								  and s.Ccuenta = c.Ccuenta
								  and s.Ocodigo = o.Ocodigo
					), 0.00)) SInicial,

					(coalesce((
								<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) NEQ -2>
									select sum(s.DOdebitos)
								<cfelse>
									select sum(s.DLdebitos)
								</cfif>
								from SaldosContables s
								where s.Speriodo = #form.periodo#
								  and s.Smes = #form.mes#
								<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) NEQ -2>
								  and s.Mcodigo = #form.Mcodigo#
								</cfif>
								  and s.Ccuenta = c.Ccuenta
								  and s.Ocodigo = o.Ocodigo
					), 0.00)) Debitos,
									
					(coalesce((
								<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) NEQ -2>
									select sum(s.COcreditos)
								<cfelse>
									select sum(s.CLcreditos)
								</cfif>
								from SaldosContables s
								where s.Speriodo = #form.periodo#
								  and s.Smes = #form.mes#
								<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) NEQ -2>
								  and s.Mcodigo = #form.Mcodigo#
								</cfif>
								  and s.Ccuenta = c.Ccuenta
								  and s.Ocodigo = o.Ocodigo
					), 0.00)) Creditos
				from CtasMayor m
					inner join CContables c
						 on c.Ecodigo  = m.Ecodigo
						and c.Cmayor   = m.Cmayor
						and c.Cformato = c.Cmayor
					inner join Oficinas o 
						on o.Ecodigo = m.Ecodigo
				where m.Ecodigo in (#lstEmpresas#)
					<cfif myGEid EQ -1>
						and o.Ocodigo in (#lstOficinas#)
					</cfif>
				order by o.Oficodigo, o.Odescripcion, m.Cmayor, m.Cdescripcion
			</cfoutput>
		</cfsavecontent>
	
	<cfelse>
		<cfsavecontent variable="queryBalanceCtaMayor">
			<cfoutput>
				select
					m.Cmayor,
					m.Cdescripcion,
					(coalesce((
								<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) NEQ -2>
									select sum(s.#mySOinicial#)
								<cfelse>
									select sum(s.#mySLinicial#)
								</cfif>
								from SaldosContables s
								where s.Speriodo = #form.periodo#
									and s.Smes = #form.mes#
									<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) NEQ -2>
										and s.Mcodigo = #form.Mcodigo#
									</cfif>
									and s.Ccuenta = c.Ccuenta
									<cfif myGEid EQ -1>
										and s.Ocodigo in (#lstOficinas#)
									</cfif>
					), 0.00)) SInicial,
									
					(coalesce((
								<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) NEQ -2>
									select sum(s.DOdebitos)
								<cfelse>
									select sum(s.DLdebitos)
								</cfif>
								from SaldosContables s
								where s.Speriodo = #form.periodo#
									and s.Smes = #form.mes#
									<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) NEQ -2>
										and s.Mcodigo = #form.Mcodigo#
									</cfif>
									and s.Ccuenta = c.Ccuenta
									<cfif myGEid EQ -1>
										and s.Ocodigo in (#lstOficinas#)
									</cfif>
					), 0.00)) Debitos,
					(coalesce((
								<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) NEQ -2>
									select sum(s.COcreditos)
								<cfelse>
									select sum(s.CLcreditos)
								</cfif>
								from SaldosContables s
								where s.Speriodo = #form.periodo#
									and s.Smes = #form.mes#
									<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) NEQ -2>
										and s.Mcodigo = #form.Mcodigo#
									</cfif>
									and s.Ccuenta = c.Ccuenta
									<cfif myGEid EQ -1>
										and s.Ocodigo in (#lstOficinas#)
									</cfif>
					), 0.00)) Creditos
				from CtasMayor m
					inner join CContables c
						 on c.Ecodigo  = m.Ecodigo
						and c.Cmayor   = m.Cmayor
						and c.Cformato = c.Cmayor
				where m.Ecodigo in (#lstEmpresas#)
				order by m.Cmayor, m.Cdescripcion
			</cfoutput>
		</cfsavecontent>
	
	</cfif>

<cfelse>

	<cf_dbtemp name="saldoscuenta" returnvariable="saldoscuenta" datasource="#session.dsn#">
			<cf_dbtempcol name="Ccuenta"  		type="numeric"    mandatory="yes">
			<cf_dbtempcol name="Ocodigo"  		type="integer"    mandatory="yes">
			<cf_dbtempcol name="Debitos"  		type="money"    mandatory="yes">
			<cf_dbtempcol name="Creditos"  		type="money"    mandatory="yes">
			<cf_dbtempkey cols="Ccuenta, Ocodigo">
	</cf_dbtemp>

	<cfquery datasource="#session.dsn#">
		insert into #saldoscuenta# (Ccuenta, Ocodigo, Debitos, Creditos)
		select 
			cu.Ccuentaniv, 
			d.Ocodigo, 
			<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) NEQ -2>
				sum(Doriginal * case when Dmovimiento = 'D' then 1.00 else 0.00 end) as Debitos,
				sum(Doriginal * case when Dmovimiento = 'C' then 1.00 else 0.00 end) as Creditos
			<cfelse>
				sum(Dlocal * case when Dmovimiento = 'D' then 1.00 else 0.00 end) as Debitos,
				sum(Dlocal * case when Dmovimiento = 'C' then 1.00 else 0.00 end) as Creditos
			</cfif>
		from HEContables e
				inner join HDContables d
						inner join PCDCatalogoCuenta cu
						on cu.Ccuenta = d.Ccuenta
						and cu.PCDCniv = 0
				on d.IDcontable = e.IDcontable
				<cfif myGEid EQ -1>
					and d.Ocodigo in (#lstOficinas#)
				</cfif>
				<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) NEQ -2>
					and d.Mcodigo = #form.Mcodigo#
				</cfif>
		where e.Eperiodo = #form.periodo#
		  and e.Emes     = #form.mes#
		  and e.ECtipo   = 1
		  and e.Ecodigo in (#lstEmpresas#)
		group by cu.Ccuentaniv, d.Ocodigo
	</cfquery>

	<cfif isdefined("form.IncluirOficina")>
		<cfsavecontent variable="queryBalanceCtaMayorOficina">
			<cfoutput>
				select
					o.Oficodigo,
					o.Odescripcion,
					m.Cmayor,
					m.Cdescripcion,
					(coalesce((
								<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) NEQ -2>
									select sum(s.#mySOinicial# + s.DOdebitos - s.COcreditos)
								<cfelse>
									select sum(s.#mySLinicial# + s.DLdebitos - s.CLcreditos)
								</cfif>
								from SaldosContables s
								where s.Speriodo = #form.periodo#
									and s.Smes   = #form.mes#
									<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) NEQ -2>
										and s.Mcodigo = #form.Mcodigo#
									</cfif>
									and s.Ccuenta = c.Ccuenta
									and s.Ocodigo = o.Ocodigo
					), 0.00)) SInicial,
									
					(coalesce((
								select sum(Debitos)
								from #saldoscuenta# st
								where st.Ccuenta = c.Ccuenta
								 and  st.Ocodigo = o.Ocodigo
					), 0.00)) Debitos,
									
					(coalesce((
								select sum(Creditos)
								from #saldoscuenta# st
								where st.Ccuenta = c.Ccuenta
								 and  st.Ocodigo = o.Ocodigo
					), 0.00)) Creditos

				from CtasMayor m
					inner join CContables c
						 on c.Ecodigo  = m.Ecodigo
						and c.Cmayor   = m.Cmayor
						and c.Cformato = c.Cmayor
					inner join Oficinas o 
						on o.Ecodigo = m.Ecodigo
				where m.Ecodigo in (#lstEmpresas#)
					<cfif myGEid EQ -1>
						and o.Ocodigo in (#lstOficinas#)
					</cfif>
				order by o.Oficodigo, o.Odescripcion, m.Cmayor, m.Cdescripcion
			</cfoutput>
		</cfsavecontent>
	
	<cfelse>
	
		<cfsavecontent variable="queryBalanceCtaMayor">
			<cfoutput>
				select
					m.Cmayor,
					m.Cdescripcion,
					(coalesce((
								<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) NEQ -2>
									select sum(s.#mySOinicial# + s.DOdebitos - s.COcreditos)
								<cfelse>
									select sum(s.#mySLinicial# + s.DLdebitos - s.CLcreditos)
								</cfif>
								from SaldosContables s
								where s.Speriodo = #form.periodo#
									and s.Smes = #form.mes#
									<cfif isdefined("form.mcodigoopt") and trim(form.mcodigoopt) NEQ -2>
										and s.Mcodigo = #form.Mcodigo#
									</cfif>
									and s.Ccuenta = c.Ccuenta
									<cfif myGEid EQ -1>
										and s.Ocodigo in (#lstOficinas#)
									</cfif>
					), 0.00)) SInicial,

					(coalesce((
								select sum(Debitos)
								from #saldoscuenta# st
								where st.Ccuenta = c.Ccuenta
					), 0.00)) Debitos,
									
					(coalesce((
								select sum(Creditos)
								from #saldoscuenta# st
								where st.Ccuenta = c.Ccuenta
					), 0.00)) Creditos

				from CtasMayor m
					inner join CContables c
						 on c.Ecodigo  = m.Ecodigo
						and c.Cmayor   = m.Cmayor
						and c.Cformato = c.Cmayor
				where m.Ecodigo in (#lstEmpresas#)
				order by m.Cmayor, m.Cdescripcion 
			</cfoutput>
		</cfsavecontent>
	</cfif>

</cfif>

<!--- Obtiene la descripcin del Mes Final --->
<cfif isdefined("form.mes") and len(trim(form.mes))>
	<cfquery name="rsMes" datasource="sifcontrol">
		select <cf_dbfunction name="to_number" args="b.VSvalor"> as v, VSdesc as descMes
		from Idiomas a
			inner join VSidioma b
			on b.Iid = a.Iid
			and b.VSgrupo = 1
		where Icodigo = '#session.idioma#'
			and b.VSvalor = '#form.mes#'
		order by <cf_dbfunction name="to_number" args="b.VSvalor">
	</cfquery>
	<cfif isdefined("rsMes") and rsMes.recordcount GT 0>
		<cfset mesOrigen = rsMes.descMes>
	<cfelse>
		<cfset mesOrigen = form.mes>
	</cfif>
</cfif>

<cfset Title = "#LB_Titulo#">
<cfset FileName = "#LB_Archivo#">
<cfset FileName = FileName & Session.Usucodigo & "-" & DateFormat(Now(),'yyyymmdd') & "-" & TimeFormat(Now(),'hhmmss') & ".xls">
<cfset FileNameTab = "#LB_Archivo#">
<cfset FileNameTab = FileNameTab & Session.Usucodigo & "-" & DateFormat(Now(),'yyyymmdd') & "-" & TimeFormat(Now(),'hhmmss')>

<!--- Pinta los botones de regresar, impresin y exportar a excel. --->
<cf_htmlreportsheaders
	title="#Title#" 
	filename="#FileName#" 
	ira="BalCompPorCtaMayor.cfm">

<!--- Empieza a pintar el reporte en el usuario cada 512 bytes. --->
<cfif not isdefined("form.toExcel")>
	<cfflush interval="512">
</cfif>

<cf_templatecss>

<cfoutput>
<style type="text/css">
	.encabReporteLine {
		background-color: ##006699;
		color: ##FFFFFF;
		padding-top: 2px;
		padding-bottom: 2px;
		font-size: 11px; 
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: ##CCCCCC;
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: ##CCCCCC;
	}
	.imprimeDatos {
		font-size: 10px;	
		padding-left: 5px; 
	}
	.imprimeDatosLinea {
		color: ##FF0000;
		font-size: 10px;
		font-weight: bold;
		padding-left: 5px; 
	}
	.imprimeMonto {
		font-size: 10px;
		text-align: right;
	}
	.imprimeMontoBold {
		font-size: 10px;
		text-align: right;
		font-weight: bold;
	}
	.imprimeMontoLinea {
		color: ##FF0000;
		font-size: 10px;
		text-align: right;
		font-weight: bold;
	}
</style>
</cfoutput>
	
<cfset Lvar_nrecordcount = 0>
<cfoutput>
<table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
	<tr><td align="center" colspan="6"><cfinclude template="RetUsuario.cfm"></td></tr>
	<tr><td align="center" colspan="6"><font size="3"><strong>#session.Enombre#</strong></font></td></tr>
	<tr><td align="center" colspan="6"><font size="2"><strong>#Title#</strong></font></td></tr>
	<tr><td align="center" colspan="6"><font size="2"><strong>#LB_Periodo#:</strong>&nbsp;&nbsp;#periodo#&nbsp;&nbsp;-&nbsp;&nbsp;<strong>#LB_Mes#:</strong>&nbsp;&nbsp;#mesOrigen#</font></td></tr>
	<tr><td align="center" colspan="6"><font size="2"><strong> #ubiDescripcion# </strong></font></td></tr>
	<tr><td align="center" colspan="6"><hr></td></tr>
	</cfoutput>
	
	<!--- Variables para sumar los montos --->	
	<cfset TotalDebitoMensual = 0>	
	<cfset TotalCreditoMensual = 0>	
	<cfset TotalDebitoAcumulado = 0>	
	<cfset TotalCreditoAcumulado = 0>

	<!--- Pinta el Reporte de Balance de Cuenta Mayor --->	
	<cfif isdefined("queryBalanceCtaMayor") and len(trim(queryBalanceCtaMayor)) gt 0>

			<cfquery datasource="#session.dsn#" name="rsBalanceCtaMayor">
				<cfoutput>#PreserveSingleQuotes(queryBalanceCtaMayor)#</cfoutput>
			</cfquery>

			<cfif isdefined("form.toExcel")>
				<cf_exportQueryToFile query="#rsBalanceCtaMayor#" filename="#FileNameTab#.xls" jdbc="false">
			</cfif>
			
			<cfset Lvar_bx = false>
			<cfoutput query="rsBalanceCtaMayor" >
				<cfif not Lvar_bx>
					<cfset Lvar_bx = true>	
					<tr>
						<td nowrap class="encabReporteLine" colspan="2"><strong>#ubiDescripcion#</strong></td>
						<td nowrap class="encabReporteLine" colspan="2" align="center">#LB_Mensual#</td>
						<td nowrap class="encabReporteLine" colspan="2" align="center">#LB_Acumulado#</td>
					</tr>
					<tr>
						<td nowrap class="encabReporteLine">#LB_CuentaMayor#</td>
						<td nowrap class="encabReporteLine">#LB_Descripcion#</td>
						<td align="right" nowrap class="encabReporteLine">#LB_Debitos#</td>
						<td align="right" nowrap class="encabReporteLine">#LB_Creditos#</td>
						<td align="right" nowrap class="encabReporteLine">#LB_Debitos#</td>
						<td align="right" nowrap class="encabReporteLine">#LB_Creditos#</td>
					</tr>
				</cfif>
				
				<cfif (Debitos-Creditos) GT 0><cfset debitoMensual = (Debitos-Creditos)><cfelse><cfset debitoMensual = 0></cfif>
				<cfif (Debitos-Creditos) LT 0><cfset creditoMensual = (Debitos-Creditos)><cfelse><cfset creditoMensual = 0></cfif>
				<cfif ((SInicial+Debitos)-Creditos) GT 0><cfset debitoAcumulado = ((SInicial+Debitos)-Creditos)><cfelse><cfset debitoAcumulado = 0></cfif>
				<cfif ((SInicial+Debitos)-Creditos) LT 0><cfset creditoAcumulado = ((SInicial+Debitos)-Creditos)><cfelse><cfset creditoAcumulado = 0></cfif>

				<cfset debitoMensual = abs(debitoMensual)>
				<cfset creditoMensual = abs(creditoMensual)>
				<cfset debitoAcumulado = abs(debitoAcumulado)>
				<cfset creditoAcumulado = abs(creditoAcumulado)>

				<!--- Totaliza los montos de las columnas --->
				<cfset TotalDebitoMensual = TotalDebitoMensual + debitoMensual>
				<cfset TotalCreditoMensual = TotalCreditoMensual + creditoMensual>
				<cfset TotalDebitoAcumulado = TotalDebitoAcumulado + debitoAcumulado>
				<cfset TotalCreditoAcumulado = TotalCreditoAcumulado + creditoAcumulado>
				
				<cfset Lvar_nrecordcount = Lvar_nrecordcount + 1>
				<cfif isdefined("form.chkCeros")>
					<cfif abs(debitoMensual) + abs(creditoMensual) + abs(debitoAcumulado) +  abs(creditoAcumulado)  neq 0 >
						<tr>
							<td nowrap class="imprimeDatos">#Cmayor#</td>
							<td nowrap class="imprimeDatos">#Cdescripcion#</td>
							<td nowrap class="imprimeMonto">#LSCUrrencyFormat(debitoMensual,'none')#</td>
							<td nowrap class="imprimeMonto">#LSCUrrencyFormat(creditoMensual,'none')#</td>
							<td nowrap class="imprimeMonto">#LSCUrrencyFormat(debitoAcumulado,'none')#</td>
							<td nowrap class="imprimeMonto">#LSCUrrencyFormat(creditoAcumulado,'none')#</td>
						</tr>
					</cfif>
				<cfelse>
					<tr>
						<td nowrap class="imprimeDatos">#Cmayor#</td>
						<td nowrap class="imprimeDatos">#Cdescripcion#</td>
						<td nowrap class="imprimeMonto">#LSCUrrencyFormat(debitoMensual,'none')#</td>
						<td nowrap class="imprimeMonto">#LSCUrrencyFormat(creditoMensual,'none')#</td>
						<td nowrap class="imprimeMonto">#LSCUrrencyFormat(debitoAcumulado,'none')#</td>
						<td nowrap class="imprimeMonto">#LSCUrrencyFormat(creditoAcumulado,'none')#</td>
					</tr>
				</cfif>
			</cfoutput>
			<!--- Imprime al final de la lnea los totales de los montos --->
			<cfoutput>
				<tr>
					<td nowrap class="imprimeDatos">&nbsp;</td>
					<td nowrap class="imprimeDatos">&nbsp;</td>
					<td nowrap class="imprimeMontoBold">#LSCUrrencyFormat(TotalDebitoMensual,'none')#</td>
					<td nowrap class="imprimeMontoBold">#LSCUrrencyFormat(TotalCreditoMensual,'none')#</td>
					<td nowrap class="imprimeMontoBold">#LSCUrrencyFormat(TotalDebitoAcumulado,'none')#</td>
					<td nowrap class="imprimeMontoBold">#LSCUrrencyFormat(TotalCreditoAcumulado,'none')#</td>
				</tr>
			</cfoutput>
			
	</cfif>

	<!--- Pinta el Reporte de Balance de Cuenta Mayor con Oficinas --->
	<cfif isdefined("queryBalanceCtaMayorOficina") and len(trim(queryBalanceCtaMayorOficina)) gt 0>
			<cfquery datasource="#session.dsn#" name="rsBalanceCtaMayorOficina">
				<cfoutput>#PreserveSingleQuotes(queryBalanceCtaMayorOficina)#</cfoutput>
			</cfquery>

			<cfif isdefined("form.toExcel")>
				<cf_exportQueryToFile query="#rsBalanceCtaMayorOficina#" filename="#FileNameTab#.xls" jdbc="false">
			</cfif>

			<cfset Lvar_bx = false>
			<cfoutput query="rsBalanceCtaMayorOficina" group="Oficodigo">
				<tr>
					<td nowrap class="encabReporteLine" colspan="2"><strong>#LB_Oficina#: #Odescripcion#</strong></td>
					<td nowrap class="encabReporteLine" colspan="2" align="center">#LB_Mensual#</td>
					<td nowrap class="encabReporteLine" colspan="2" align="center">#LB_Acumulado#</td>
				</tr>
				<tr>
                    <td nowrap class="encabReporteLine">#LB_CuentaMayor#</td>
                    <td nowrap class="encabReporteLine">#LB_Descripcion#</td>
                    <td align="right" nowrap class="encabReporteLine">#LB_Debitos#</td>
                    <td align="right" nowrap class="encabReporteLine">#LB_Creditos#</td>
                    <td align="right" nowrap class="encabReporteLine">#LB_Debitos#</td>
                    <td align="right" nowrap class="encabReporteLine">#LB_Creditos#</td>
				</tr>
				<cfoutput>
					<cfif (Debitos-Creditos) GT 0><cfset debitoMensual = (Debitos-Creditos)><cfelse><cfset debitoMensual = 0></cfif>
					<cfif (Debitos-Creditos) LT 0><cfset creditoMensual = (Debitos-Creditos)><cfelse><cfset creditoMensual = 0></cfif>
					<cfif ((SInicial+Debitos)-Creditos) GT 0><cfset debitoAcumulado = ((SInicial+Debitos)-Creditos)><cfelse><cfset debitoAcumulado = 0></cfif>
					<cfif ((SInicial+Debitos)-Creditos) LT 0><cfset creditoAcumulado = ((SInicial+Debitos)-Creditos)><cfelse><cfset creditoAcumulado = 0></cfif>

					<cfset debitoMensual = abs(debitoMensual)>
					<cfset creditoMensual = abs(creditoMensual)>
					<cfset debitoAcumulado = abs(debitoAcumulado)>
					<cfset creditoAcumulado = abs(creditoAcumulado)>
					
					<!--- Totaliza los montos de las columnas --->
					<cfset TotalDebitoMensual = TotalDebitoMensual + debitoMensual>
					<cfset TotalCreditoMensual = TotalCreditoMensual + creditoMensual>
					<cfset TotalDebitoAcumulado = TotalDebitoAcumulado + debitoAcumulado>
					<cfset TotalCreditoAcumulado = TotalCreditoAcumulado + creditoAcumulado>
					
					<cfset Lvar_nrecordcount = Lvar_nrecordcount + 1>
					<cfif isdefined("form.chkCeros")>
						<cfif abs(debitoMensual) + abs(creditoMensual) + abs(debitoAcumulado) +  abs(creditoAcumulado) neq 0 >
							<tr>
								<td nowrap class="imprimeDatos">#Cmayor#</td>
								<td nowrap class="imprimeDatos">#Cdescripcion#</td>
								<td nowrap class="imprimeMonto">#LSCUrrencyFormat(debitoMensual,'none')#</td>
								<td nowrap class="imprimeMonto">#LSCUrrencyFormat(creditoMensual,'none')#</td>
								<td nowrap class="imprimeMonto">#LSCUrrencyFormat(debitoAcumulado,'none')#</td>
								<td nowrap class="imprimeMonto">#LSCUrrencyFormat(creditoAcumulado,'none')#</td>
							</tr>
						</cfif>
					<cfelse>
						<tr>
							<td nowrap class="imprimeDatos">#Cmayor#</td>
							<td nowrap class="imprimeDatos">#Cdescripcion#</td>
							<td nowrap class="imprimeMonto">#LSCUrrencyFormat(debitoMensual,'none')#</td>
							<td nowrap class="imprimeMonto">#LSCUrrencyFormat(creditoMensual,'none')#</td>
							<td nowrap class="imprimeMonto">#LSCUrrencyFormat(debitoAcumulado,'none')#</td>
							<td nowrap class="imprimeMonto">#LSCUrrencyFormat(creditoAcumulado,'none')#</td>
						</tr>
					</cfif>
				</cfoutput>
				<!--- Imprime al final de la lnea los totales de los montos --->
				<tr>
					<td nowrap class="imprimeDatos">&nbsp;</td>
					<td nowrap class="imprimeDatos">&nbsp;</td>
					<td nowrap class="imprimeMontoBold">#LSCUrrencyFormat(TotalDebitoMensual,'none')#</td>
					<td nowrap class="imprimeMontoBold">#LSCUrrencyFormat(TotalCreditoMensual,'none')#</td>
					<td nowrap class="imprimeMontoBold">#LSCUrrencyFormat(TotalDebitoAcumulado,'none')#</td>
					<td nowrap class="imprimeMontoBold">#LSCUrrencyFormat(TotalCreditoAcumulado,'none')#</td>
				</tr>
				<tr><td align="center" colspan="6">&nbsp;</td></tr>
				
				<!--- Se reinician las variables para sumar los montos --->	
				<cfset TotalDebitoMensual = 0>	
				<cfset TotalCreditoMensual = 0>	
				<cfset TotalDebitoAcumulado = 0>	
				<cfset TotalCreditoAcumulado = 0>

			</cfoutput>

	</cfif>

	<cfif Lvar_nrecordcount gt 0>
		<cfset Lvar_smsg = "#LB_FinConsulta#">
	<cfelse>
		<cfset Lvar_smsg = "#LB_SinRegistros#">
	</cfif>
	
	<cfoutput>
	<tr><td align="center" colspan="6">&nbsp;</td></tr>		
	<tr><td align="center" colspan="6"><strong> --- #Lvar_smsg# ---  </strong></td></tr>
</table>
</cfoutput>

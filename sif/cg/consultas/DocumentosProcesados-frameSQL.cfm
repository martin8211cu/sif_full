<!---
	Modificado por: Ana Villavicencio
	Fecha: 23 de setiembre del 2005
	Motivo: Cambia la consulta de los documentos. Se elimina de la consulta el filtro por fechas.
			Se envia un nuevo parámetro al reporte, firmaAutorizada.
			Se eliminaron parámetros q no se utilizan.

	Modificado por : Ana Villavicencio
	Fecha: 29 de setiembre del 2005
	Motivo: Agregar a la consulta del reporte los campos CFdescripcion (descripcion de la cuenta)
			y Miso4217 de las monedas

 --->

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Titulo" Default="P&oacute;lizas Aplicada Contabilizadas"
returnvariable="LB_Titulo" xmlfile = "DocumentosProcesados-frameSQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TituloR" Default="Reporte de Documentos  Aplicados en Contabilidad General" returnvariable="LB_TituloR" xmlfile = "DocumentosProcesados-frameSQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Archivo" Default="PolizasAplicadas"
returnvariable="LB_Archivo" xmlfile = "DocumentosProcesados-frameSQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Poliza" Default="P&oacute;liza"
returnvariable="LB_Poliza" xmlfile = "DocumentosProcesados-frameSQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Concepto" Default="Concepto"
returnvariable="LB_Concepto" xmlfile = "DocumentosProcesados-frameSQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default="Descripción"
returnvariable="LB_Descripcion" xmlfile = "DocumentosProcesados-frameSQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Documento" Default="Documento"
returnvariable="LB_Documento" xmlfile = "DocumentosProcesados-frameSQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Doc" Default="Doc"
returnvariable="LB_Doc" xmlfile = "DocumentosProcesados-frameSQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_anio" Default="Año"
returnvariable="LB_anio" xmlfile = "DocumentosProcesados-frameSQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Referencia" Default="Referencia"
returnvariable="LB_Referencia" xmlfile = "DocumentosProcesados-frameSQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Ref" Default="Ref"
returnvariable="LB_Ref" xmlfile = "DocumentosProcesados-frameSQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha" Default="Fecha Doc."
returnvariable="LB_Fecha" xmlfile = "DocumentosProcesados-frameSQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Periodo" Default="Periodo"
returnvariable="LB_Periodo" xmlfile = "DocumentosProcesados-frameSQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Mes" Default="Mes"
returnvariable="LB_Mes" xmlfile = "DocumentosProcesados-frameSQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Linea" Default="Linea"
returnvariable="LB_Linea" xmlfile = "DocumentosProcesados-frameSQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Oficina" Default="Oficina"
returnvariable="LB_Oficina" xmlfile = "DocumentosProcesados-frameSQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Cuenta" Default="Cuenta"
returnvariable="LB_Cuenta" xmlfile = "DocumentosProcesados-frameSQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Moneda" Default="Moneda"
returnvariable="LB_Moneda" xmlfile = "DocumentosProcesados-frameSQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MontoOrigen" Default="Monto Original"
returnvariable="LB_MontoOrigen" xmlfile = "DocumentosProcesados-frameSQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Debitos" Default="D&eacute;bitos"
returnvariable="LB_Debitos" xmlfile = "DocumentosProcesados-frameSQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Creditos" Default="Cr&eacute;ditos"
returnvariable="LB_Creditos" xmlfile = "DocumentosProcesados-frameSQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Usuario" Default="Usuario"
returnvariable="LB_Usuario" xmlfile = "DocumentosProcesados-frameSQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ElaboradoPor" Default="Elaborado por"
returnvariable="LB_ElaboradoPor" xmlfile = "DocumentosProcesados-frameSQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_AplicadoPor" Default="Aplicado por"
returnvariable="LB_AplicadoPor" xmlfile = "DocumentosProcesados-frameSQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TotalPoliza" Default="Total P&oacute;liza"
returnvariable="LB_TotalPoliza" xmlfile = "DocumentosProcesados-frameSQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TotalDocumento" Default="Total Documento"
returnvariable="LB_TotalDocumento" xmlfile = "DocumentosProcesados-frameSQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TotalConcepto" Default="Total Concepto"
returnvariable="LB_TotalConcepto" xmlfile = "DocumentosProcesados-frameSQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DescCta" Default="Desc. Cuenta"
returnvariable="LB_DescCta" xmlfile = "DocumentosProcesados-frameSQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Empresa" Default="Empresa"
returnvariable="LB_Empresa" xmlfile = "DocumentosProcesados-frameSQL.xml"/>

 <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Todos" Default="Todos"
returnvariable="LB_Todos" xmlfile = "DocumentosProcesados.xml"/>

<cfset intercomp=0>
<cfif IsDefined("url.intercompany") and url.intercompany EQ 1>
	<cfset intercomp=1>
</cfif>
<cfset quitarAnulado=0>
<cfif IsDefined("url.excluirAnulados")>
	<cfset quitarAnulado=1>
</cfif>

<cfquery name="rsParametro" datasource="#session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = #session.Ecodigo#
	and Pcodigo = 981
</cfquery>
<cfset LvarParametro = 0>
<cfif isdefined("rsParametro") and rsParametro.recordcount eq 1>
		<cfset LvarParametro= rsParametro.Pvalor>
</cfif>
<cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato  eq 'tab'>
	<cfset LvarControl = fnExportaDocumentos()>
<cfelse>
	<cfset LvarControl = fnVerificaCantidadDocumentos()>
	<cfif LvarControl GT 5000 and isdefined("url.formato") and url.formato neq 'HTML'>
		<cfset LvarControl = fnReportaDocumentosError(LvarControl, 5000)>
		<cfabort>
	</cfif>
	<cfif isdefined('url.actulizarp')>
		<cfif url.hayAutoP EQ "1">
			<cfquery name="rsUpdate" datasource="#session.DSN#">
				update Parametros
				   set Pvalor  = '#url.firmaautorizada#'
				 where Ecodigo = #Session.Ecodigo#
				   and Pcodigo = 752
			</cfquery>
		<cfelseif url.hayAutoP EQ "0" and Len(Trim(url.firmaautorizada)) GT 0>
			<cfquery name="rsInsert" datasource="#session.DSN#">
				insert into Parametros (Ecodigo, Pcodigo,Mcodigo,Pdescripcion,Pvalor,BMUsucodigo)
				values(	#Session.Ecodigo#,	752,  'CG', 'Firma autorizada para Pólizas', '#url.firmaAutorizada#',#session.Usucodigo#)
			</cfquery>
		</cfif>
	</cfif>

	<cfif isdefined("url.formato") and url.formato neq 'HTML'>
		<cfset LvarReporte = fnReportaDocumentosCFR()>
	<cfelseif intercomp EQ 1>
    	<cfset LvarReporte = fnReportaDocumentosHTMLInter()>
	<cfelse>
		<cfset LvarReporte = fnReportaDocumentosHTML()>
	</cfif>
</cfif>

<cffunction name="fnVerificaCantidadDocumentos" access="private" output="no" returntype="numeric">
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select DISTINCT
			count (*) as cantidad
		from HEContables e
		<cfif intercomp EQ 1>
				inner join HDContablesInt d
				  on d.IDcontable = e.IDcontable
				 inner join EControlDocInt ei
				  on ei.idcontableori=d.IDcontable
				  and ei.idcontableori=e.IDcontable
			<cfelse>
			   inner join HDContables d
				  on d.IDcontable = e.IDcontable
			</cfif>
		where e.Ecodigo = #session.Ecodigo#
		 <cfif isdefined ("url.periodoIni") and isdefined ("url.PeriodoFin")>
			and e.Eperiodo >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.PeriodoIni#">
			and e.Eperiodo <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.PeriodoFin#">
		 </cfif>
		 <cfif isdefined ("url.periodoini") and isdefined ("url.mesini")>
		   and ((e.Eperiodo * 100 + e.Emes)  between (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.PeriodoIni#"> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#url.MesIni#">) and (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.PeriodoFin#"> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#url.MesFin#">))
		 </cfif>
		 <cfif isdefined ("url.Usuario") and len(trim(url.Usuario))>
			and (upper(ltrim(rtrim(e.ECusuario))) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Trim(url.Usuario))#"> or '#Trim(url.Usuario)#' = '#LB_Todos#')
		 </cfif>

		  <!--- FILTROS DE Conceptos --->
		 <cfif isdefined("url.loteini") and len(trim(url.loteini)) and isdefined("url.lotefin") and len(trim(url.lotefin))>
			and e.Cconcepto >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.loteini#">
			and e.Cconcepto <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.lotefin#">
		 <cfelseif isdefined("url.loteini") and len(trim(url.loteini))>
			and e.Cconcepto >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.loteini#">
		 <cfelseif isdefined("url.lotefin") and len(trim(url.lotefin))>
			and e.Cconcepto <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.lotefin#">
		 </cfif>

		<!--- FILTROS DE ASIENTOS --->
		<cfif isdefined("url.EdocumentoI") and len(trim(url.EdocumentoI)) and isdefined("url.EdocumentoF") and len(trim(url.EdocumentoF))>
			and e.Edocumento >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.EdocumentoI#">
			and e.Edocumento <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.EdocumentoF#">
		<cfelseif isdefined("url.EdocumentoI") and len(trim(url.EdocumentoI))>
			and e.Edocumento >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.EdocumentoI#">
		<cfelseif isdefined("url.EdocumentoF") and len(trim(url.EdocumentoF))>
			and e.Edocumento <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.EdocumentoF#">
		</cfif>
		  <!--- FILTROS DE FECHAS --->
		 <cfif isdefined("url.fechaIni") and len(trim(url.fechaIni)) and isdefined("url.fechaFin") and len(trim(url.fechaFin))>
			and <cf_dbfunction name="to_date00" args="e.Efecha"> between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fechaIni)#"> and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fechaFin)#">
		 <cfelseif isdefined("url.fechaIni") and len(trim(url.fechaIni)) and not isdefined("url.fechaFin")>
			and <cf_dbfunction name="to_date00" args="e.Efecha"> >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fechaIni)#">
		 <cfelseif isdefined("url.fechaFin") and len(trim(url.fechaFin)) and not isdefined("url.fechaIni")>
			and <cf_dbfunction name="to_date00" args="e.Efecha"> <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fechaFin)#">
		 </cfif>
         <!--- FILTROS DE REFERENCIA Y DOCUMENTO --->
         <cfif isdefined("url.txtref") and len(trim(url.txtref))>
			and e.Ereferencia like '%#url.txtref#%'
		 </cfif>
         <cfif isdefined("url.txtdoc") and len(trim(url.txtdoc))>
			and e.Edocbase like '%#url.txtdoc#%'
		 </cfif>
		 <cfif intercomp EQ 1>
				and e.ECtipo=20
		</cfif>
	</cfquery>
	<cfreturn rsReporte.cantidad>
</cffunction>

<cffunction name="fnReportaDocumentosError" access="private" output="yes" returntype="any">
	<cfargument name="ArgCantidad" type="numeric" required="yes">
	<cfargument name="ArgMaximo" type="numeric" required="yes">
	<br>
	<br>
	<br>
	<p align="center">Precauci&oacute;n:  Se genero un reporte de más de <strong><cfoutput>#numberformat(Arguments.ArgMaximo, ",0")#</cfoutput></strong> Registros.</p>
	<p align="center">Registros Generados: <strong><cfoutput>#numberformat(Arguments.ArgCantidad, '_,')#</cfoutput></strong>.</p>
	<p align="center">Debe ser más específico con los filtros del reporte, generarlo en formato tabular o con formato de salida HTML.</p>
	<p align="center">Presione <a href="javascript:parent.document.location.href='DocumentosProcesados.cfm';">Regresar</a> para volver a la pantalla de configuraci&oacute;n del reporte</p>
	<cfabort>
</cffunction>

<cffunction name="fnExportaDocumentos" access="private" output="no" returntype="any">
	<cfsetting requesttimeout="1800">
	<cfquery name="data" datasource="#session.DSN#">
		select DISTINCT
			e.Eperiodo as #LB_Periodo#,
			e.Emes as #LB_Mes#,
			e.Cconcepto as #LB_Concepto#,
			c.Cdescripcion as #LB_Descripcion#,
			e.Edocumento as Documento,
			e.Efecha as Fecha,
			e.Ereferencia ,
			d.Ddescripcion as Descripcion,
			d.Dlinea as Linea,
			o.Oficodigo as Oficina,
			d.Ddocumento as DDocumento,
			e.Edescripcion,
			d.Dreferencia as Referencia,
			cf.CFformato as Cuenta,
			(select e.Edescripcion from Empresas e where Ecodigo=cf.Ecodigo) as Empresa,
			m.Msimbolo as Moneda,
			coalesce(d.Doriginal, 1) as  Monto,
			case when Dmovimiento = 'D' then d.Dlocal else 0.00 end as Debitos,
			case when Dmovimiento = 'C' then d.Dlocal else 0.00 end as Creditos,
			e.ECusuario as Usuario ,
			e.ECfechacreacion,
			e.ECfechaaplica,
			u.Usulogin as UsuarioAplica
		from HEContables e
			<cfif intercomp EQ 1>
				inner join HDContablesInt d
				on d.IDcontable = e.IDcontable
				inner join EControlDocInt ei
				on ei.idcontableori=d.IDcontable
				and ei.idcontableori=e.IDcontable
			<cfelse>
				inner join HDContables d
				on d.IDcontable = e.IDcontable
			</cfif>
		   left join Oficinas o
			  on o.Ecodigo = e.Ecodigo
			 and o.Ocodigo = d.Ocodigo
		   inner join ConceptoContableE c
			  on c.Ecodigo 	 = e.Ecodigo
			 and c.Cconcepto = e.Cconcepto
		   inner join CFinanciera cf
			  on cf.CFcuenta = d.CFcuenta
		   inner join Monedas m
			  on m.Mcodigo = d.Mcodigo
		   inner join Usuario u
			 on u.Usucodigo = e.ECusucodigoaplica

		where e.Ecodigo = #session.Ecodigo#
		<cfif isdefined ("url.periodoIni") and isdefined ("url.PeriodoFin")>
			and e.Eperiodo >= #url.PeriodoIni#
			and e.Eperiodo <= #url.PeriodoFin#
		</cfif>
		<cfif isdefined ("url.periodoini") and isdefined ("url.mesini")>
		   and ((e.Eperiodo * 100 + e.Emes)  between (#url.PeriodoIni#* 100 + #url.MesIni#) and (#url.PeriodoFin# * 100 + #url.MesFin#))
		</cfif>
		<cfif isdefined ("url.Usuario") and len(trim(url.Usuario))>
			and (upper(ltrim(rtrim(e.ECusuario))) = '#UCase(Trim(url.Usuario))#' or '#Trim(url.Usuario)#' = '#LB_Todos#')
		</cfif>

		 <!--- FILTROS DE Conceptos --->
		<cfif isdefined("url.loteini") and len(trim(url.loteini)) and isdefined("url.lotefin") and len(trim(url.lotefin))>
			and e.Cconcepto >= #url.loteini#
			and e.Cconcepto <= #url.lotefin#
		<cfelseif isdefined("url.loteini") and len(trim(url.loteini))>
			and e.Cconcepto >= #url.loteini#
		<cfelseif isdefined("url.lotefin") and len(trim(url.lotefin))>
			and e.Cconcepto <= #url.lotefin#
		</cfif>
		<!--- FILTROS DE ASIENTOS --->
		<cfif isdefined("url.EdocumentoI") and len(trim(url.EdocumentoI)) and isdefined("url.EdocumentoF") and len(trim(url.EdocumentoF))>
			and e.Edocumento >= #url.EdocumentoI#
			and e.Edocumento <= #url.EdocumentoF#
		<cfelseif isdefined("url.EdocumentoI") and len(trim(url.EdocumentoI))>
			and e.Edocumento >= #url.EdocumentoI#
		<cfelseif isdefined("url.EdocumentoF") and len(trim(url.EdocumentoF))>
			and e.Edocumento <= #url.EdocumentoF#
		</cfif>
		  <!--- FILTROS DE FECHAS --->
		 <cfif isdefined("url.fechaIni") and len(trim(url.fechaIni)) and isdefined("url.fechaFin") and len(trim(url.fechaFin))>
			and e.Efecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fechaIni)#"> and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fechaFin)#">
		 <cfelseif isdefined("url.fechaIni") and len(trim(url.fechaIni)) and not isdefined("url.fechaFin")>
			and e.Efecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fechaIni)#">
		 <cfelseif isdefined("url.fechaFin") and len(trim(url.fechaFin)) and not isdefined("url.fechaIni")>
			and e.Efecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fechaFin)#">
		 </cfif>
         <!---FILTROS DE DOCUMENTO Y REFERENCIA--->
         <cfif isdefined("url.txtref") and len(trim(url.txtref))>
			and e.Ereferencia like '%#url.txtref#%'
		 </cfif>
         <cfif isdefined("url.txtdoc") and len(trim(url.txtdoc))>
			and e.Edocbase like '%#url.txtdoc#%'
		 </cfif>
		 <cfif intercomp EQ 1>
				and e.ECtipo=20
			</cfif>
		<!--- FILTROS DE ORDENAMIENTO--->
		<cfif not isdefined ("url.ordenamiento") or len(trim(url.ordenamiento)) EQ 0>
			order by e.Cconcepto, e.Edocumento, d.Dlinea, d.Ddocumento
		</cfif>
		<cfif isdefined ("url.ordenamiento") and len(trim(url.ordenamiento)) and url.ordenamiento EQ 0>
			order by e.Cconcepto, e.Edocumento, d.Dlinea, d.Ddocumento
		<cfelseif isdefined ("url.ordenamiento") and len(trim(url.ordenamiento)) and url.ordenamiento EQ 1>
			order by e.Cconcepto, e.Edocumento,  d.Ddocumento, d.Dlinea
		</cfif>
	</cfquery>
	<cfflush interval="64">
	<cf_exportQueryToFile query="#data#" separador="#chr(9)#" filename="#LB_Archivo##session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.txt" jdbc="false">
</cffunction>

<cffunction name="fnReportaDocumentosCFR" access="private" output="no" returntype="any">
	<!--- cfquery sin corte --->
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select DISTINCT
			e.Cconcepto as Concepto,
			c.Cdescripcion as DescripcionConcepto,
			e.Edocumento as Documento,
			e.Efecha as Fecha,
			e.Eperiodo as Periodo,
			e.Emes as Mes,
			e.ECauxiliar as Auxiliar,
			e.ECusuario as Usuario,
			e.ECfechacreacion,
			e.ECfechaaplica,
			u.Usulogin as UsuarioAplica,
			d.Dlinea as Linea,
			e.Oorigen,
			d.Ddocumento as DDocumento,
			d.Ddescripcion as Descripcion,
			d.Dreferencia as Referencia,
			cf.CFformato as Cuenta,
			cf.CFdescripcion as DescCuenta,
			o.Oficodigo as Oficina,
			coalesce(d.Doriginal, 1) as  Monto,
			m.Msimbolo as Moneda,
			coalesce(d.Dtipocambio, 1) as	 TipoCambio,
			case when Dmovimiento = 'D' then d.Dlocal else 0.00 end as Debitos,
			case when Dmovimiento = 'C' then d.Dlocal else 0.00 end as Creditos,
			e.Edescripcion,
			m.Miso4217,
			e.Ereferencia as ref,
			e.Edocbase as doc,
			(select e.Edescripcion from Empresas e where Ecodigo=cf.Ecodigo) as empresa
		from HEContables e
			<cfif intercomp EQ 1>
				inner join HDContablesInt d
				  on d.IDcontable = e.IDcontable
				 inner join EControlDocInt ei
				  on ei.idcontableori=d.IDcontable
				  and ei.idcontableori=e.IDcontable
			<cfelse>
			   inner join HDContables d
				  on d.IDcontable = e.IDcontable
			</cfif>
		   left join Oficinas o
			  on o.Ecodigo = e.Ecodigo
			 and o.Ocodigo = d.Ocodigo
		   inner join ConceptoContableE c
			  on c.Ecodigo 	 = e.Ecodigo
			 and c.Cconcepto = e.Cconcepto
		   inner join CFinanciera cf
			  on cf.CFcuenta = d.CFcuenta
		   inner join Monedas m
			  on m.Mcodigo = d.Mcodigo
		   inner join Usuario u
			 on u.Usucodigo = e.ECusucodigoaplica
		where e.Ecodigo = #session.Ecodigo#
		<cfif isdefined ("url.periodoIni") and isdefined ("url.PeriodoFin")>
			and e.Eperiodo >= #url.PeriodoIni#
			and e.Eperiodo <= #url.PeriodoFin#
		</cfif>
		<cfif isdefined ("url.periodoini") and isdefined ("url.mesini")>
		   and ((e.Eperiodo * 100 + e.Emes)  between (#url.PeriodoIni# * 100 + #url.MesIni#) and (#url.PeriodoFin# * 100 + #url.MesFin#))
		</cfif>
		<cfif isdefined ("url.Usuario") and len(trim(url.Usuario))>
			and (upper(ltrim(rtrim(e.ECusuario))) = '#UCase(Trim(url.Usuario))#' or '#Trim(url.Usuario)#' = '#LB_Todos#')
		</cfif>

		<!--- FILTROS DE Conceptos --->
		<cfif isdefined("url.loteini") and len(trim(url.loteini)) and isdefined("url.lotefin") and len(trim(url.lotefin))>
			and e.Cconcepto >= #url.loteini#
			and e.Cconcepto <= #url.lotefin#
		<cfelseif isdefined("url.loteini") and len(trim(url.loteini))>
			and e.Cconcepto >= #url.loteini#
		<cfelseif isdefined("url.lotefin") and len(trim(url.lotefin))>
			and e.Cconcepto <= #url.lotefin#
		</cfif>
		<!--- FILTROS DE ASIENTOS --->
		<cfif isdefined("url.EdocumentoI") and len(trim(url.EdocumentoI)) and isdefined("url.EdocumentoF") and len(trim(url.EdocumentoF))>
			and e.Edocumento >= #url.EdocumentoI#
			and e.Edocumento <= #url.EdocumentoF#
		<cfelseif isdefined("url.EdocumentoI") and len(trim(url.EdocumentoI))>
			and e.Edocumento >= #url.EdocumentoI#
		<cfelseif isdefined("url.EdocumentoF") and len(trim(url.EdocumentoF))>
			and e.Edocumento <= #url.EdocumentoF#
		</cfif>
		 <!--- FILTROS DE FECHAS --->
		 <cfif isdefined("url.fechaIni") and len(trim(url.fechaIni)) and isdefined("url.fechaFin") and len(trim(url.fechaFin))>
			and e.Efecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fechaIni)#"> and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fechaFin)#">
		 <cfelseif isdefined("url.fechaIni") and len(trim(url.fechaIni)) and not isdefined("url.fechaFin")>
			and e.Efecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fechaIni)#">
		 <cfelseif isdefined("url.fechaFin") and len(trim(url.fechaFin)) and not isdefined("url.fechaIni")>
			and e.Efecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fechaFin)#">
		 </cfif>

		 <!---FILTROS DE DOCUMENTO Y REFERENCIA--->
         <cfif isdefined("url.txtref") and len(trim(url.txtref))>
			and e.Ereferencia like '%#url.txtref#%'
		 </cfif>
         <cfif isdefined("url.txtdoc") and len(trim(url.txtdoc))>
			and e.Edocbase like '%#url.txtdoc#%'
		 </cfif>

		 <cfif intercomp EQ 1>
				and e.ECtipo=20
			</cfif>

		<!--- FILTROS DE ORDENAMIENTO--->
		<cfif not isdefined ("url.ordenamiento") or len(trim(url.ordenamiento)) EQ 0>
			order by e.Cconcepto, e.Edocumento, d.Dlinea, d.Ddocumento
		</cfif>
		<cfif isdefined ("url.ordenamiento") and len(trim(url.ordenamiento)) and url.ordenamiento EQ 0>
			order by e.Cconcepto, e.Edocumento, d.Dlinea, d.Ddocumento
		<cfelseif isdefined ("url.ordenamiento") and len(trim(url.ordenamiento)) and url.ordenamiento EQ 1>
			order by e.Cconcepto, e.Edocumento,  d.Ddocumento, d.Dlinea
		</cfif>
	</cfquery>
	<!--- Define cual reporte va a llamar --->
	<cfset NombreReporteJR = "">
	<cfif LvarParametro>
		<cfset archivo = "DocumentosProcesadosDescCuenta.cfr">
		<cfset NombreReporteJR = "DocumentosProcesadosDescCuenta">
	<cfelse>
		<cfif isdefined("url.chkCorteDocumento")>
			<cfset archivo = "DocumentosProcesadosCorteDoc.cfr">
			<cfset NombreReporteJR = "DocumentosProcesadosCorteDoc">
		<cfelse>
			<cfset archivo = "DocumentosProcesados.cfr">
			<cfset NombreReporteJR = "DocumentosProcesados">
		</cfif>
	</cfif>
	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select Edescripcion
		from Empresas
		where Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset LvarFechaHora = dateformat(now(), "DD/MM/YYYY") & ' ' & timeformat(now(), "hh:mm:ss")>
	<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
	<cfset LvarNombreReporte = t.Translate('NombreRep','Reporte de Asientos Aplicados')>
	<!--- INVOCA EL REPORTE --->
	<!--- Meter el translate y pasar el título del reporte por parámetro. --->
	<cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
	<cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
	  <cfset typeRep = 1>
		<cfif url.formato EQ "pdf">
		  <cfset typeRep = 2>
		</cfif>
		<cf_js_reports_service_tag queryReport = "#rsReporte#" 
				isLink = False 
				typeReport = #typeRep#
				fileName = "cg.consultas.#NombreReporteJR#"
				headers = "title:#LvarNombreReporte#"/>
	<cfelse>
		<cfreport format="#url.formato#" template="#archivo#" query="rsReporte">
			<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
			<cfreportparam name="Edesc" value="#rsEmpresa.Edescripcion#">
			<cfif isdefined("url.firmaAutorizada") and len(trim(url.firmaAutorizada)) and isdefined("url.chkCorteDocumento")>
				<cfreportparam name="firmaAutorizada" value="#url.firmaAutorizada#">
			<cfelse>
				<cfreportparam name="firmaAutorizada" value="">
			</cfif>
			<cfreportparam name="NombreReporte" value="#LvarNombreReporte#">
			<cfreportparam name="FechaHora" value="#LvarFechaHora#">
		</cfreport>
	</cfif>
</cffunction>

<cffunction name="fnReportaDocumentosHTML" access="private" output="yes" returntype="any">
	<cfset LvarFechaHora = dateformat(now(), "DD/MM/YYYY") & ' ' & timeformat(now(), "hh:mm:ss")>
	<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
	<cfset LvarNombreReporte = t.Translate('NombreRep','Reporte de Asientos Aplicados')>
	<!--- cfquery de encabezados para el HTML --->
	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select Edescripcion
		from Empresas
		where Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfquery name="rsEncabezados" datasource="#session.DSN#">
		select DISTINCT
			e.IDcontable,
			e.Cconcepto as Concepto,
			e.Edocumento as Documento,
			e.Efecha as Fecha,
			e.Eperiodo as Periodo,
			e.Emes as Mes,
			e.ECauxiliar as Auxiliar,
			e.ECusuario as Usuario,
			e.ECfechacreacion,
			e.ECfechaaplica,
			e.Edescripcion,
			e.Ereferencia as ref,
            e.Edocbase,
			e.Oorigen,
			u.Usulogin as UsuarioAplica,
			c.Cdescripcion as DescripcionConcepto
		from HEContables e
		   inner join ConceptoContableE c
			  on c.Ecodigo 	 = e.Ecodigo
			 and c.Cconcepto = e.Cconcepto
		   inner join Usuario u
			 on u.Usucodigo = e.ECusucodigoaplica
		<cfif  quitarAnulado EQ 1>
			inner join HDContables hd on hd.IDcontable=e.IDcontable
         </cfif>
		where e.Ecodigo = #session.Ecodigo#
		<cfif isdefined ("url.periodoIni") and isdefined ("url.PeriodoFin")>
			and e.Eperiodo >= #url.PeriodoIni#
			and e.Eperiodo <= #url.PeriodoFin#
		</cfif>
		<cfif isdefined ("url.periodoini") and isdefined ("url.mesini")>
		   and ((e.Eperiodo * 100 + e.Emes)  between (#url.PeriodoIni# * 100 + #url.MesIni#) and (#url.PeriodoFin# * 100 + #url.MesFin#))
		</cfif>
		<cfif isdefined ("url.Usuario") and len(trim(url.Usuario))>
			and (upper(ltrim(rtrim(e.ECusuario))) = '#UCase(Trim(url.Usuario))#' or '#Trim(url.Usuario)#' = '#LB_Todos#')
		</cfif>
		<!--- FILTROS DE Conceptos --->
		<cfif isdefined("url.loteini") and len(trim(url.loteini)) and isdefined("url.lotefin") and len(trim(url.lotefin))>
			and e.Cconcepto >= #url.loteini#
			and e.Cconcepto <= #url.lotefin#
		<cfelseif isdefined("url.loteini") and len(trim(url.loteini))>
			and e.Cconcepto >= #url.loteini#
		<cfelseif isdefined("url.lotefin") and len(trim(url.lotefin))>
			and e.Cconcepto <= #url.lotefin#
		</cfif>
		<!--- FILTROS DE ASIENTOS --->
		<cfif isdefined("url.EdocumentoI") and len(trim(url.EdocumentoI)) and isdefined("url.EdocumentoF") and len(trim(url.EdocumentoF))>
			and e.Edocumento >= #url.EdocumentoI#
			and e.Edocumento <= #url.EdocumentoF#
		<cfelseif isdefined("url.EdocumentoI") and len(trim(url.EdocumentoI))>
			and e.Edocumento >= #url.EdocumentoI#
		<cfelseif isdefined("url.EdocumentoF") and len(trim(url.EdocumentoF))>
			and e.Edocumento <= #url.EdocumentoF#
		</cfif>
		 <!--- FILTROS DE FECHAS --->
		 <cfif isdefined("url.fechaIni") and len(trim(url.fechaIni)) and isdefined("url.fechaFin") and len(trim(url.fechaFin))>
			and e.Efecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fechaIni)#"> and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fechaFin)#">
		 <cfelseif isdefined("url.fechaIni") and len(trim(url.fechaIni)) and not isdefined("url.fechaFin")>
			and e.Efecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fechaIni)#">
		 <cfelseif isdefined("url.fechaFin") and len(trim(url.fechaFin)) and not isdefined("url.fechaIni")>
			and e.Efecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fechaFin)#">
		 </cfif>
         <!---FILTROS DE DOCUMENTO Y REFERENCIA--->
         <cfif isdefined("url.txtref") and len(trim(url.txtref))>
			and e.Ereferencia like '%#url.txtref#%'
		 </cfif>
         <cfif isdefined("url.txtdoc") and len(trim(url.txtdoc))>
			and e.Edocbase like '%#url.txtdoc#%'
		 </cfif>

		<!--- FILTROS DE ORDENAMIENTO--->
		order by e.Cconcepto, e.Edocumento
	</cfquery>

    <cf_htmlReportsHeaders
        title="#LB_Titulo#"
        filename="#LB_Archivo#.xls"
        irA="DocumentosProcesados.cfm"
        download="yes"
        preview="no"
        method="get">
    <cfflush interval="32">
   	<table border="0" cellpadding="0" cellspacing="0" style="width:100%; font-size:12px">
    	 <tr>
            <td colspan="9" align="center" bgcolor="##E3EDEF" style="color:##6188A5; font-size:24px"><strong>#session.enombre#</strong></td>
            <td bgcolor="##E3EDEF">&nbsp;</td>
        </tr>
        <tr>
        	<td colspan="9" align="center" bgcolor="##E3EDEF" style="width:96%;"><strong>#LB_TituloR#</strong></td>
            <td bgcolor="##E3EDEF" style="width:4%;">#dateformat(now(),'dd/mm/yyyy')#</td>
        </tr>
		<cfset LvarCorteConcepto = ''>
        <cfset LvarCortePoliza = ''>

        <cfset LvarTotalDebitos = 0>
        <cfset LvarTotalCreditos = 0>
        <cfset LvarTotalDebitosCon = 0>
	    <cfset LvarTotalCreditosCon = 0>
        <cfloop query="rsEncabezados">
            <cfif LvarCorteConcepto neq rsEncabezados.Concepto>
	            <cfset LvarCorteConcepto = rsEncabezados.Concepto>
				<tr>
                    <td colspan="10" bgcolor="##A7A7A7">
                        #LB_Concepto#: #rsEncabezados.Concepto#&nbsp;#DescripcionConcepto#
                    </td>
                </tr>
                <cfset LvarTotalDebitosCon = 0>
		        <cfset LvarTotalCreditosCon = 0>
			</cfif>
            <cfif LvarCortePoliza neq rsEncabezados.Documento>
            	<cfif len(trim(LvarCortePoliza))>
	            	<tr><td colspan="11">&nbsp;</td></tr>
                </cfif>
                <tr bgcolor="##D3D3D3">
                    <td nowrap="nowrap" colspan="2">#LB_Poliza#&nbsp;#Documento#</td>
                    <td nowrap="nowrap">#LB_Fecha#:&nbsp;#dateformat(Fecha,'dd/mm/yyyy')#</td>
                    <td nowrap="nowrap" colspan="3">#LB_Descripcion#:&nbsp;#Edescripcion#</td>
                    <td nowrap="nowrap">#LB_Referencia#:&nbsp;#ref#</td>
                    <td nowrap="nowrap">#LB_Documento#:&nbsp;#Edocbase#</td>
                    <td nowrap="nowrap">#LB_Periodo#:&nbsp;#Periodo#</td>
                    <td nowrap="nowrap">#LB_Mes#:&nbsp;#Mes#</td>
                </tr>
                <cfset LvarCortePoliza = rsEncabezados.Documento>
                <cfset LvarTotalDebitos = 0>
		        <cfset LvarTotalCreditos = 0>
            </cfif>
            <tr bgcolor="##D3D3D3">
                <td>#LB_Linea#</td>
                <td>#LB_Oficina#</td>
                <td>#LB_Documento#</td>
                <td>#LB_Descripcion#</td>
                <td>#LB_Referencia#</td>
                <td>#LB_Cuenta#</td>
                <td nowrap="nowrap">#LB_Descripcion#</td>
                <td nowrap="nowrap" align="right">#LB_MontoOrigen#</td>
                <td align="right">#LB_Debitos#</td>
                <td align="right">#LB_Creditos#</td>
            </tr>

            <!--- Pintar el encabezado del asiento --->
            <cfset LvarIDcontable = rsEncabezados.IDcontable>
            <cfquery name="rsReporte" datasource="#session.DSN#">
                select
                    d.Dlinea as Linea,
                    d.Ddocumento as Documento,
                    d.Ddescripcion as Descripcion,
                    d.Dreferencia as Referencia,
                    cf.CFformato as Cuenta,
                    cf.CFdescripcion as DescCuenta,
                    o.Oficodigo as Oficina,
                    coalesce(d.Doriginal, 1) as  Monto,
                    m.Msimbolo as Moneda,
                    coalesce(d.Dtipocambio, 1) as	 TipoCambio,
                    case when Dmovimiento = 'D' then d.Dlocal else 0.00 end as Debitos,
                    case when Dmovimiento = 'C' then d.Dlocal else 0.00 end as Creditos,
                    m.Miso4217
                from HDContables d
                   left join Oficinas o
                      on o.Ecodigo = d.Ecodigo
                     and o.Ocodigo = d.Ocodigo
                   inner join CFinanciera cf
                      on cf.CFcuenta = d.CFcuenta
                   inner join Monedas m
                      on m.Mcodigo = d.Mcodigo
                where d.IDcontable = #LvarIDcontable#

                <cfif not isdefined ("url.ordenamiento") or len(trim(url.ordenamiento)) EQ 0>
                    order by d.Dlinea, d.Ddocumento
                </cfif>
                <cfif isdefined ("url.ordenamiento") and len(trim(url.ordenamiento)) and url.ordenamiento EQ 0>
                    order by d.Dlinea, d.Ddocumento
                <cfelseif isdefined ("url.ordenamiento") and len(trim(url.ordenamiento)) and url.ordenamiento EQ 1>
                    order by d.Ddocumento, d.Dlinea
                </cfif>
            </cfquery>
           <!--- Pintar el Detalle de la tabla --->


                <cfloop query="rsReporte">
                    <tr>
                        <td>#Linea#</td>
                        <td>#Oficina#</td>
                        <td>#Documento#</td>
                        <td>#Descripcion#</td>
                        <td>#Referencia#</td>
                        <td>#Cuenta#</td>
                        <td nowrap="nowrap">#DescCuenta#</td>
                        <td nowrap="nowrap" align="right">#numberformat(Monto,',_.__')#</td>
                        <td align="right">#numberformat(Debitos,',_.__')#</td>
                        <td align="right">#numberformat(Creditos,',_.__')#</td>
                    </tr>
                    <cfset LvarTotalDebitos = LvarTotalDebitos + Debitos>
			        <cfset LvarTotalCreditos = LvarTotalCreditos + Creditos>
                </cfloop>
            <tr>
            	<td colspan="2" nowrap="nowrap"><strong>#LB_TotalPoliza#: #Documento#</strong></td>
                <td colspan="6">&nbsp;</td>
                <td align="right" nowrap="nowrap" style="border-top:solid; border-top-width:thin">#numberformat(LvarTotalDebitos,',_.__')#</td>
                <td align="right" nowrap="nowrap" style="border-top:solid; border-top-width:thin">&nbsp;#numberformat(LvarTotalCreditos,',_.__')#</td>
            </tr>
            <cfset LvarTotalDebitosCon = LvarTotalDebitosCon + LvarTotalDebitos>
	        <cfset LvarTotalCreditosCon = LvarTotalCreditosCon + LvarTotalCreditos>
            <tr>
            	<td colspan="9">#LB_ElaboradoPor# #Usuario# #LB_Fecha# #dateformat(ECfechacreacion,'dd/mm/yyyy')#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#LB_AplicadoPor#: #UsuarioAplica# #LB_Fecha# #dateformat(ECfechaaplica,'dd/mm/yyyy')#</td>
            </tr>
        </cfloop>
        <tr>
        	<td colspan="2" nowrap="nowrap"><strong>#LB_TotalConcepto#: #rsEncabezados.Concepto#&nbsp;#rsEncabezados.DescripcionConcepto#</strong></td>
            <td colspan="6">&nbsp;</td>
            <td align="right" nowrap="nowrap" style="border-top:solid; border-top-width:thin">#numberformat(LvarTotalDebitosCon,',_.__')#</td>
            <td align="right" nowrap="nowrap" style="border-top:solid; border-top-width:thin">&nbsp;#numberformat(LvarTotalCreditosCon,',_.__')#</td>
        </tr>
    </table>
</cffunction>



   <!--- AGREGADO POR JCRUZ --->
<!--- reporte de intercompany --->
<cffunction name="fnReportaDocumentosHTMLInter" access="private" output="yes" returntype="any">
	<cfset LvarFechaHora = dateformat(now(), "DD/MM/YYYY") & ' ' & timeformat(now(), "hh:mm:ss")>
	<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
	<cfset LvarNombreReporte = t.Translate('NombreRep','Reporte de Pólizas Contabilizadas')>


	<!--- cfquery de encabezados para el HTML --->
	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select Edescripcion
		from Empresas
		where Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfquery name="rsEncabezados" datasource="#session.DSN#">
		select  DISTINCT
			<cfif intercomp EQ 1>
			g.idcontableori as IDcontable,
			<cfelse>
			e.IDcontable,
			</cfif>
			e.Cconcepto as Concepto,
			e.Edocumento as Documento,
			e.Efecha as Fecha,
			e.Eperiodo as Periodo,
			e.Emes as Mes,
			e.ECauxiliar as Auxiliar,
			e.ECusuario as Usuario,
			e.ECfechacreacion,
			e.ECfechaaplica,
			e.Edescripcion,
			e.Ereferencia as ref,
            e.Edocbase,
			e.Oorigen,
			u.Usulogin as UsuarioAplica,
			c.Cdescripcion as DescripcionConcepto
		from HEContables e
			<cfif intercomp EQ 1>
				INNER JOIN EControlDocInt g ON g.idcontableori=e.IDcontable
				INNER JOIN HDContablesInt hdi ON g.idcontableori=hdi.IDcontable
			</cfif>
		   inner join ConceptoContableE c
			  on c.Ecodigo 	 = e.Ecodigo
			 and c.Cconcepto = e.Cconcepto
		   inner join Usuario u
			 on u.Usucodigo = e.ECusucodigoaplica
		<cfif  quitarAnulado EQ 1>
			inner join HDContables hd on hd.IDcontable=e.IDcontable
         </cfif>
		where e.Ecodigo = #session.Ecodigo#
		<cfif isdefined ("url.periodoIni") and isdefined ("url.PeriodoFin")>
			and e.Eperiodo >= #url.PeriodoIni#
			and e.Eperiodo <= #url.PeriodoFin#
		</cfif>
		<cfif isdefined ("url.periodoini") and isdefined ("url.mesini")>
		   and ((e.Eperiodo * 100 + e.Emes)  between (#url.PeriodoIni# * 100 + #url.MesIni#) and (#url.PeriodoFin# * 100 + #url.MesFin#))
		</cfif>
		<cfif isdefined ("url.Usuario") and len(trim(url.Usuario))>
			and (upper(ltrim(rtrim(e.ECusuario))) = '#UCase(Trim(url.Usuario))#' or '#Trim(url.Usuario)#' = '#LB_Todos#')
		</cfif>
		<!--- FILTROS DE Conceptos --->
		<cfif isdefined("url.loteini") and len(trim(url.loteini)) and isdefined("url.lotefin") and len(trim(url.lotefin))>
			and e.Cconcepto >= #url.loteini#
			and e.Cconcepto <= #url.lotefin#
		<cfelseif isdefined("url.loteini") and len(trim(url.loteini))>
			and e.Cconcepto >= #url.loteini#
		<cfelseif isdefined("url.lotefin") and len(trim(url.lotefin))>
			and e.Cconcepto <= #url.lotefin#
		</cfif>
		<!--- FILTROS DE ASIENTOS --->
		<cfif isdefined("url.EdocumentoI") and len(trim(url.EdocumentoI)) and isdefined("url.EdocumentoF") and len(trim(url.EdocumentoF))>
			and e.Edocumento >= #url.EdocumentoI#
			and e.Edocumento <= #url.EdocumentoF#
		<cfelseif isdefined("url.EdocumentoI") and len(trim(url.EdocumentoI))>
			and e.Edocumento >= #url.EdocumentoI#
		<cfelseif isdefined("url.EdocumentoF") and len(trim(url.EdocumentoF))>
			and e.Edocumento <= #url.EdocumentoF#
		</cfif>
		 <!--- FILTROS DE FECHAS --->
		 <cfif isdefined("url.fechaIni") and len(trim(url.fechaIni)) and isdefined("url.fechaFin") and len(trim(url.fechaFin))>
			and e.Efecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fechaIni)#"> and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fechaFin)#">
		 <cfelseif isdefined("url.fechaIni") and len(trim(url.fechaIni)) and not isdefined("url.fechaFin")>
			and e.Efecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fechaIni)#">
		 <cfelseif isdefined("url.fechaFin") and len(trim(url.fechaFin)) and not isdefined("url.fechaIni")>
			and e.Efecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fechaFin)#">
		 </cfif>
         <!---FILTROS DE DOCUMENTO Y REFERENCIA--->
         <cfif isdefined("url.txtref") and len(trim(url.txtref))>
			and e.Ereferencia like '%#url.txtref#%'
		 </cfif>
         <cfif isdefined("url.txtdoc") and len(trim(url.txtdoc))>
			and e.Edocbase like '%#url.txtdoc#%'
		 </cfif>

		<cfif intercomp EQ 1>
			and e.ECtipo=20
		</cfif>
		<!--- FILTROS DE ORDENAMIENTO--->
		order by e.Cconcepto, e.Edocumento
	</cfquery>

    <cf_htmlReportsHeaders
        title="#LB_Archivo#"
        filename="CGPolizasAplicadas.xls"
        irA="DocumentosProcesados.cfm"
        download="yes"
        preview="no"
        method="get">
    <cfflush interval="32">


   	<table border="0" cellpadding="0" cellspacing="0" style="width:100%; font-size:12px">
    	 <tr>
            <td colspan="10" align="center" bgcolor="##E3EDEF" style="color:##6188A5; font-size:24px"><strong>#session.enombre#</strong></td>
            <td bgcolor="##E3EDEF">&nbsp;</td>
        </tr>
        <tr>
        	<td colspan="10" align="center" bgcolor="##E3EDEF" style="width:96%;"><strong>#LvarNombreReporte#</strong></td>
            <td bgcolor="##E3EDEF" style="width:4%;">#dateformat(now(),'dd/mm/yyyy')#</td>
        </tr>
		<cfset LvarCorteConcepto = ''>
        <cfset LvarCortePoliza = ''>

        <cfset LvarTotalDebitos = 0>
        <cfset LvarTotalCreditos = 0>
        <cfset LvarTotalDebitosCon = 0>
	    <cfset LvarTotalCreditosCon = 0>
        <cfloop query="rsEncabezados">
            <cfif LvarCorteConcepto neq rsEncabezados.Concepto>
	            <cfset LvarCorteConcepto = rsEncabezados.Concepto>
				<tr>
                    <td colspan="11" bgcolor="##A7A7A7">
                        Concepto: #rsEncabezados.Concepto#&nbsp;#DescripcionConcepto#
                    </td>
                </tr>
                <cfset LvarTotalDebitosCon = 0>
		        <cfset LvarTotalCreditosCon = 0>
			</cfif>
            <cfif LvarCortePoliza neq rsEncabezados.Documento>
            	<cfif len(trim(LvarCortePoliza))>
	            	<tr><td colspan="11">&nbsp;</td></tr>
                </cfif>
                <tr bgcolor="##D3D3D3">
                    <td nowrap="nowrap" colspan="2">#LB_Poliza#&nbsp;#Documento#</td>
                    <td nowrap="nowrap">#LB_Fecha#:&nbsp;#dateformat(Fecha,'dd/mm/yyyy')#</td>
                    <td nowrap="nowrap" colspan="3">#LB_Descripcion#:&nbsp;#Edescripcion#</td>
                    <td nowrap="nowrap">#LB_Ref#:&nbsp;#ref#</td>
                    <td nowrap="nowrap">#LB_Doc#:&nbsp;#Edocbase#</td>
                    <td nowrap="nowrap">#LB_anio#:&nbsp;#Periodo#</td>
                    <td nowrap="nowrap">#LB_Mes#:&nbsp;#Mes#</td>
					<td nowrap="nowrap">&nbsp;</td>
                </tr>
                <cfset LvarCortePoliza = rsEncabezados.Documento>
                <cfset LvarTotalDebitos = 0>
		        <cfset LvarTotalCreditos = 0>
            </cfif>
            <tr bgcolor="##D3D3D3">
                <td>#LB_Linea#</td>
                <td>#LB_Oficina#</td>
                <td>#LB_Documento#</td>
                <td>#LB_Descripcion#</td>
                <td>#LB_Ref#</td>
                <td>#LB_Cuenta#</td>
                <td nowrap="nowrap">#LB_DescCta#</td>
				<td nowrap="nowrap">#LB_Empresa#</td>
                <td nowrap="nowrap" align="right">#LB_MontoOrigen#</td>
                <td align="right">#LB_Debitos#</td>
                <td align="right">#LB_Creditos#</td>
            </tr>

            <!--- Pintar el encabezado del asiento --->
            <cfset LvarIDcontable = rsEncabezados.IDcontable>
            <cfquery name="rsReporte" datasource="#session.DSN#">
                select DISTINCT
                    d.Dlinea as Linea,
                    d.Ddocumento as Documento,
                    d.Ddescripcion as Descripcion,
                    d.Dreferencia as Referencia,
                    cf.CFformato as Cuenta,
                    cf.CFdescripcion as DescCuenta,
                    o.Oficodigo as Oficina,
                    coalesce(d.Doriginal, 1) as  Monto,
                    m.Msimbolo as Moneda,
                    coalesce(d.Dtipocambio, 1) as	 TipoCambio,
                    case when Dmovimiento = 'D' then d.Dlocal else 0.00 end as Debitos,
                    case when Dmovimiento = 'C' then d.Dlocal else 0.00 end as Creditos,
                    m.Miso4217,
					(select e.Edescripcion from Empresas e where Ecodigo=cf.Ecodigo) as empresa
                from
					<cfif intercomp EQ 1>
						HDContablesInt d
					<cfelse>
						HDContables d
					</cfif>
                   LEFT join Oficinas o
                      on o.Ecodigo = d.Ecodigo
                     and o.Ocodigo = d.Ocodigo
                   inner join CFinanciera cf
                      on cf.CFcuenta = d.CFcuenta
                   inner join Monedas m
                      on m.Mcodigo = d.Mcodigo
                where d.IDcontable = #LvarIDcontable#

                <cfif not isdefined ("url.ordenamiento") or len(trim(url.ordenamiento)) EQ 0>
                    order by d.Dlinea, d.Ddocumento
                </cfif>
                <cfif isdefined ("url.ordenamiento") and len(trim(url.ordenamiento)) and url.ordenamiento EQ 0>
                    order by d.Dlinea, d.Ddocumento
                <cfelseif isdefined ("url.ordenamiento") and len(trim(url.ordenamiento)) and url.ordenamiento EQ 1>
                    order by d.Ddocumento, d.Dlinea
                </cfif>
            </cfquery>
           <!--- Pintar el Detalle de la tabla --->


                <cfloop query="rsReporte">
                    <tr>
                        <td>#Linea#</td>
                        <td>#Oficina#</td>
                        <td>#Documento#</td>
                        <td>#Descripcion#</td>
                        <td>#Referencia#</td>
                        <td>#Cuenta#</td>
                        <td nowrap="nowrap">#DescCuenta#</td>
						<td nowrap="nowrap" alt="#empresa#" title="#empresa#">#Left(empresa,15)#</td>
                        <td nowrap="nowrap" align="right">#numberformat(Monto,',_.__')#</td>
                        <td align="right">#numberformat(Debitos,',_.__')#</td>
                        <td align="right">#numberformat(Creditos,',_.__')#</td>
                    </tr>
                    <cfset LvarTotalDebitos = LvarTotalDebitos + Debitos>
			        <cfset LvarTotalCreditos = LvarTotalCreditos + Creditos>
                </cfloop>
            <tr>
            	<td colspan="3" nowrap="nowrap"><strong>#LB_TotalPoliza#: #Documento#</strong></td>
                <td colspan="6">&nbsp;</td>
                <td align="right" nowrap="nowrap" style="border-top:solid; border-top-width:thin">#numberformat(LvarTotalDebitos,',_.__')#</td>
                <td align="right" nowrap="nowrap" style="border-top:solid; border-top-width:thin">&nbsp;#numberformat(LvarTotalCreditos,',_.__')#</td>
            </tr>
            <cfset LvarTotalDebitosCon = LvarTotalDebitosCon + LvarTotalDebitos>
	        <cfset LvarTotalCreditosCon = LvarTotalCreditosCon + LvarTotalCreditos>
            <tr>
            	<td colspan="9">Elaborado por el usuario #Usuario# el d&iacute;a #dateformat(ECfechacreacion,'dd/mm/yyyy')#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Aplicado por el usuario: #UsuarioAplica# el d&iacute;a #dateformat(ECfechaaplica,'dd/mm/yyyy')#</td>
            </tr>
        </cfloop>
        <tr>
        	<td colspan="3" nowrap="nowrap"><strong>#LB_TotalConcepto#: #rsEncabezados.Concepto#&nbsp;#rsEncabezados.DescripcionConcepto#</strong></td>
            <td colspan="6">&nbsp;</td>
            <td align="right" nowrap="nowrap" style="border-top:solid; border-top-width:thin">#numberformat(LvarTotalDebitosCon,',_.__')#</td>
            <td align="right" nowrap="nowrap" style="border-top:solid; border-top-width:thin">&nbsp;#numberformat(LvarTotalCreditosCon,',_.__')#</td>
        </tr>
    </table>
</cffunction>

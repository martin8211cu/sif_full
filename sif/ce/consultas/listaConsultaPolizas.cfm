<cfinvoke  key="BTN_Regresar" default="Regresar" component="sif.Componentes.Translate" method="Translate"
returnvariable="BTN_Regresar" xmlfile="/sif/generales.xml"/>
<cfinvoke  key="BTN_Filtrar" default="Filtrar" component="sif.Componentes.Translate" method="Translate"
returnvariable="BTN_Filtrar" xmlfile="/sif/generales.xml"/>
<cfinvoke  key="BTN_Limpiar" default="Limpiar" component="sif.Componentes.Translate" method="Translate"
returnvariable="BTN_Limpiar" xmlfile="/sif/generales.xml"/>
<cfinvoke  key="LB_Titulo" default="Lista de Documentos Contables" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Titulo" xmlfile="listaConsultaPolizas.xml"/>
<cfinvoke  key="LB_Descripcion" default="Descripci&oacute;n" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Descripcion" xmlfile="listaConsultaPolizas.xml"/>
<cfinvoke  key="LB_Fecha" default="Fecha" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Fecha" xmlfile="listaConsultaPolizas.xml"/>
<cfinvoke  key="LB_Periodo" default="Periodo" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Periodo" xmlfile="listaConsultaPolizas.xml"/>
<cfinvoke  key="LB_Moneda" default="Moneda" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Moneda" xmlfile="listaConsultaPolizas.xml"/>
<cfinvoke  key="LB_Mes" default="Mes" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Mes" xmlfile="listaConsultaPolizas.xml"/>
<cfinvoke  key="LB_Origen" default="Origen" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Origen" xmlfile="listaConsultaPolizas.xml"/>
<cfinvoke  key="LB_Usuario" default="Usuario" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Usuario" xmlfile="listaConsultaPolizas.xml"/>
<cfinvoke  key="LB_Lote" default="Lote" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Lote" xmlfile="listaConsultaPolizas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_EstaSeguro" Default="¿Está seguro de que desea aplicar los documentos seleccionadas?"	 returnvariable="LB_EstaSeguro"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_NoEstaMes1" Default="No se encuentra en el primer mes contable para utilizar este proceso"	 returnvariable="MSG_NoEstaMes1"/>

<!--- <cfdump var = "#url#"> --->
<cfset varFiltrar  = ''>
<cfset LvarXML  = 'SQLGenerarXMLPolizas.cfm'>
<cfparam name="sufix" default="">
<cfif not isdefined("url.inter")  and not isdefined("form.inter")>
 	<cfset inter = 'N'>
</cfif>
<cfif isdefined("url.inter") and not isdefined("form.inter")>
 	<cfset inter = url.inter>
</cfif>
<cfif isdefined("url.usaAJAX") and #url.usaAJAX# EQ "NO">
 	<cfset varUsaAJAX = url.usaAJAX>
</cfif>
<cfif not isdefined("url.inter") and  isdefined("form.inter")>
 	<cfset inter = form.inter>
</cfif>

<cfif isdefined("url.paramretro") and not isdefined("form.paramretro")>
 	<cfset paramretro = url.paramretro>
</cfif>
<cfif not isdefined("url.paramretro") and  isdefined("form.paramretro")>
 	<cfset paramretro = form.paramretro>
</cfif>
<cfif not isdefined("url.varFiltrar") and  isdefined("form.varFiltrar")>
 	<cfset varFiltrar = url.varFiltrar>
</cfif>
<cfset params = "">

<!--- pasa URL a FORM --->
<cfif isdefined("url.lote") and len(trim(url.lote)) and not isdefined("form.lote")>
	<cfset form.lote = url.lote >
</cfif>
<cfif isdefined("url.poliza") and len(trim(url.poliza)) and not isdefined("form.poliza")>
	<cfset form.poliza = url.poliza >
</cfif>
<cfif isdefined("url.Referencia") and len(trim(url.Referencia)) and not isdefined("form.Referencia")>
	<cfset form.Referencia = url.Referencia >
</cfif>
<cfif isdefined("url.periodo") and len(trim(url.periodo)) and not isdefined("form.periodo")>
	<cfset form.periodo = url.periodo >
</cfif>
<cfif isdefined("url.mes") and len(trim(url.mes)) and not isdefined("form.mes")>
	<cfset form.mes = url.mes >
</cfif>
<cfif isdefined("url.fechaIni") and len(trim(url.fechaIni)) and not isdefined("form.fechaIni")>
	<cfset form.fechaIni = url.fechaIni >
</cfif>
<cfif isdefined("url.fechaFin") and len(trim(url.fechaFin)) and not isdefined("form.fechaFin")>
	<cfset form.fechaFin = url.fechaFin >
</cfif>
<cfif isdefined("url.ver") and len(trim(url.ver)) and not isdefined("form.ver")>
	<cfset form.ver = url.ver >
</cfif>
<cfif isdefined("url.ECusuario") and len(trim(url.ECusuario)) and not isdefined("form.ECusuario")>
	<cfset form.ECusuario = url.ECusuario >
</cfif>
<cfif isdefined("url.cierreAnual") and len(trim(url.cierreAnual)) and not isdefined("form.cierreAnual")>
	<cfset form.cierreAnual = url.cierreAnual >
</cfif>
<cfif isdefined("url.fechaIni") and len(trim(url.fechaIni)) and not isdefined("form.fechaIni")>
	<cfset form.fechaIni = url.fechaIni >
</cfif>
<cfif isdefined("url.fechaFin") and len(trim(url.fechaFin)) and not isdefined("form.fechaFin")>
	<cfset form.fechaFin = url.fechaFin >
</cfif>
<cfif isdefined("url.pageNum_lista") and len(trim(url.pageNum_lista)) and not isdefined("form.pageNum_lista")>
	<cfset form.pageNum_lista = url.pageNum_lista >
</cfif>
<cfif isdefined("url.ver") and len(trim(url.ver)) and not isdefined("form.ver")>
	<cfset form.ver = url.ver >
</cfif>
<cfif isdefined("url.hdFiltrar") and len(trim(url.hdFiltrar)) and not isdefined("form.hdFiltrar")>
	<cfset form.hdFiltrar = url.hdFiltrar >
</cfif>
<cfif isdefined("url.LvarConceptos") and len(trim(url.LvarConceptos)) and not isdefined("LvarConceptos")>
	<cfset LvarConceptos = url.LvarConceptos >
</cfif>
<cfif isdefined("url.tipo") and len(trim(url.tipo)) and not isdefined("form.tipo")>
	<cfset form.tipo = url.tipo >
</cfif>
<cfif isdefined("url.Documento") and len(trim(url.Documento)) and not isdefined("form.Documento")>
	<cfset form.Documento = url.Documento >
</cfif>
<cfif isdefined("url.Moneda") and len(trim(url.Moneda)) and not isdefined("form.Moneda")>
	<cfset form.Moneda = url.Moneda >
</cfif>

<cfparam name="session.Conta.operacion.lote" type="string" default="">
<cfparam name="session.Conta.operacion.poliza" type="string" default="">
<cfparam name="session.Conta.operacion.periodo" type="string" default="">
<cfparam name="session.Conta.operacion.mes" type="string" default="">
<cfparam name="session.Conta.operacion.ECusuario" type="string" default="">
<cfparam name="session.Conta.operacion.origen" type="string" default="">
<cfparam name="session.Conta.operacion.descripcion" type="string" default="">
<cfparam name="session.Conta.operacion.PageNum_lista" type="string" default="">
<cfparam name="session.Conta.operacion.Aplicar" type="string" default="">
<cfparam name="session.Conta.operacion.ver" type="string" default="">
<cfset session.Conta.operacion.lote = "">
<cfset session.Conta.operacion.poliza = "">
<cfset session.Conta.operacion.periodo = "">
<cfset session.Conta.operacion.mes = "">
<cfset session.Conta.operacion.ECusuario = "">
<cfset session.Conta.operacion.origen = "">
<cfset session.Conta.operacion.descripcion = "">
<cfset session.Conta.operacion.PageNum_lista = "">
<cfset session.Conta.operacion.Aplicar = "">
<cfset session.Conta.operacion.ver = "">

<cfparam name="form.ver" default="15">

<cfif isdefined("paramretro")>
	<cfset LvarTituloLista = "Lista de Documentos Contables Retroactivos">
<cfelse>
	<cfset LvarTituloLista = "#LB_Titulo#">
</cfif>

<cfset LvarCHKMesCierre = false>

<cfif isdefined("form.cierreAnual")>
	<cfset LvarCHKMesCierre = true>
</cfif>

<cfquery name="rsMesCierreConta" datasource="#session.DSN#" cachedwithin="#createtimespan(1,0,0,0)#">
	select
		Pvalor as Pvalor
	from Parametros
	where Ecodigo = #session.Ecodigo#
	and Pcodigo = 45
</cfquery>

<cfset LvarMesCierreAnual = rsMesCierreConta.Pvalor>
<cfset LvarPrimerMes = LvarMesCierreAnual + 1>
<cfif LvarPrimerMes GT 12>
	<cfset LvarPrimerMes = 1>
</cfif>

<cfif inter eq "S">
	<cfset TituloP = 'Lista de Documentos Contables Intercompa&ntilde;&iacute;as'>
<cfelse>
	<cfif isdefined("paramretro")>
		<cfset TituloP = 'Lista de Documentos Contables Retroactivos'>
	<cfelse>
		<cfset TituloP = '#LB_Titulo#'>
	</cfif>
</cfif>

<cfif sufix eq 'CierreAnual'>
	<cfset LvarTituloLista = "Lista de Documentos Contables de Cierre Anual">
	<cfset TituloP = 'Lista de Documentos Contables (Asiento de Cierre)'>

	<cfset LvarCHKMesCierre = true>

	<cfquery name="rsMesCierreConta" datasource="#session.DSN#" cachedwithin="#createtimespan(1,0,0,0)#">
		select
			Pvalor as Pvalor
		from Parametros
		where Ecodigo = #session.Ecodigo#
		and Pcodigo = 45
	</cfquery>

	<cfset LvarMesCierreAnual = rsMesCierreConta.Pvalor>
	<cfset LvarPrimerMes = LvarMesCierreAnual + 1>
	<cfif LvarPrimerMes GT 12>
		<cfset LvarPrimerMes = 1>
	</cfif>

	<cfquery name="rsMesConta" datasource="#session.DSN#" cachedwithin="#createtimespan(0,0,5,0)#">
		select
			<cf_dbfunction name="to_number" args="Pvalor"> as Pvalor
		from Parametros
		where Ecodigo = #session.Ecodigo#
		and Pcodigo = 40
	</cfquery>

	<cfset LvarMes = rsMesConta.Pvalor>

	<cfif LvarMes Neq LvarPrimerMes>
		<cf_templateheader title="#LB_Titulo#">
		<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo=#LB_Titulo#>
			<cfinclude template="../../portlets/pNavegacion.cfm">

			<form name="form1" action="../MenuCG.cfm" method="post">
				<table cellpadding="0" cellspacing="0" border="0" width="100%">
					<tr>
						<td align="center" nowrap="nowrap"><strong><cfoutput>#MSG_NoEstaMes1#</cfoutput></strong></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<cfoutput><td align="center"><input name="btnRegresar" value="#BTN_Regresar#" type="submit" ></td></cfoutput>
					</tr>
				</table>
			</form>
			<cf_web_portlet_end>
		<cf_templatefooter>
		<cfabort>
	</cfif>
</cfif>

<!--- navegacion -params  --->
<cfset navegacion = "">
<cfif isdefined("form.lote") and len(trim(form.lote)) >
	<cfset navegacion = navegacion & "&lote=#form.lote#">
	<cfset params = params & "&lote=#form.lote#">
</cfif>
<cfif isdefined("form.poliza") and len(trim(form.poliza)) >
	<cfset navegacion = navegacion & "&poliza=#form.poliza#">
	<cfset params = params & "&poliza=#form.poliza#">
</cfif>
<cfif isdefined("form.Referencia") >
	<cfset navegacion = navegacion & "&descripcion=#JSStringFormat(form.Referencia)#">
	<cfset params = params & "&descripcion=#form.Referencia#">
</cfif>
<cfif isdefined("form.Referencia") >
	<cfset navegacion = navegacion & "&Referencia=#JSStringFormat(form.Referencia)#">
	<cfset params = params & "&Referencia=#form.Referencia#">
</cfif>
<cfif isdefined("form.fechaIni") >
	<cfset navegacion = navegacion & "&fechaIni=#form.fechaIni#">
	<cfset params = params & "&fechaIni=#form.fechaIni#">
</cfif>
<cfif isdefined("form.fechaFin") >
	<cfset navegacion = navegacion & "&fechaFin=#form.fechaFin#">
	<cfset params = params & "&fechaFin=#form.fechaFin#">
</cfif>
<cfif isdefined("form.periodo") >
	<cfset navegacion = navegacion & "&periodo=#form.periodo#">
	<cfset params = params & "&periodo=#form.periodo#">
</cfif>
<cfif isdefined("form.mes")>
	<cfset navegacion = navegacion & "&mes=#form.mes#">
	<cfset params = params & "&mes=#form.mes#">
</cfif>
<cfif isdefined("form.ECusuario")>
	<cfset navegacion = navegacion & "&ECusuario=#form.ECusuario#">
	<cfset params = params & "&ECusuario=#form.ECusuario#">
</cfif>
<cfif isdefined("form.fechaGenIni") >
	<cfset navegacion = navegacion & "&fechaGenIni=#form.fechaGenIni#">
	<cfset params = params & "&fechaGen=#form.fechaGenIni#">
</cfif>
<cfif isdefined("form.fechaGenFin") >
	<cfset navegacion = navegacion & "&fechaGenFin=#form.fechaGenFin#">
	<cfset params = params & "&fechaGenFin=#form.fechaGenFin#">
</cfif>
<cfif isdefined("form.ver")>
	<cfset navegacion = navegacion & "&ver=#form.ver#">
	<cfset params = params & "&ver=#form.ver#">
</cfif>
<cfif isdefined("form.origen")>
	<cfset navegacion = navegacion & "&origen=#form.origen#">
	<cfset params = params & "&origen=#form.origen#">
</cfif>

<cfif LvarCHKMesCierre>
	<cfset navegacion = navegacion & "&ECtipo=1">
	<cfset params = params & "&ECtipo=1">
</cfif>
<cfif isDefined("form.hdFiltrar") and #form.hdFiltrar# NEQ "">
	<cfset navegacion = navegacion & "&hdFiltrar=#form.hdFiltrar#">
</cfif>
<cfif isDefined("form.tipo")>
	<cfset navegacion = navegacion & "&tipo=#form.tipo#">
</cfif>

<cfif isDefined("form.Referencia")>
	<!--- <cfset navegacion = navegacion & "&Referencia=#form.Referencia#"> --->
</cfif>
<cfif isDefined("form.Documento")>
	<cfset navegacion = navegacion & "&Documento=#form.Documento#">
</cfif>
<cfif isDefined("form.Moneda")>
	<cfset navegacion = navegacion & "&Moneda=#form.Moneda#">
</cfif>
<cfif isdefined("form.PageNum_lista") and len(trim(form.PageNum_lista))>
	<cfset params = params & "&PageNum_lista=#form.PageNum_lista#">
</cfif>

<cfif LvarCHKMesCierre>
	<cfquery name="rsPerCierre" datasource="#Session.DSN#">
		select
			<cfif LvarPrimerMes eq 1>
				<cf_dbfunction args="Pvalor" name="to_number"> - 1
			<cfelse>
				<cf_dbfunction args="Pvalor" name="to_number">
			</cfif>
				as Eperiodo
		from Parametros
		where Ecodigo = #session.Ecodigo#
		  and Pcodigo = 30
	</cfquery>

	<cfquery name="rsMesesCierre" datasource="sifControl">
		select <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl"> as VSvalor, b.VSdesc
		from Idiomas a, VSidioma b
		where a.Icodigo = '#Session.Idioma#'
		  and b.Iid = a.Iid
		  and b.VSgrupo = 1
		  and b.VSvalor = '#LvarMesCierreAnual#'
	</cfquery>
</cfif>
	<cfquery name="rsPer" datasource="#Session.DSN#" cachedwithin="#createtimespan(0,0,5,0)#">
		select distinct Speriodo as Eperiodo
		from CGPeriodosProcesados
		where Ecodigo = #session.Ecodigo#
		order by Eperiodo desc
	</cfquery>

	<cfquery name="rsMeses" datasource="sifControl" cachedwithin="#createtimespan(0,1,0,0)#">
		select <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl"> as VSvalor, b.VSdesc
		from Idiomas a, VSidioma b
		where a.Icodigo = '#Session.Idioma#'
			and a.Iid = b.Iid
			and b.VSgrupo = 1
		order by <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl">
	</cfquery>


<!---
	FILTRO DE DOCUMENTOS CONTABLES
--->

<cfquery name="rsLotes" datasource="#Session.DSN#" cachedwithin="#createtimespan(0,0,5,0)#">
	select uc.Cconcepto, e.Cdescripcion,e.TipoSAT
	from UsuarioConceptoContableE uc
		inner join ConceptoContableE e
		 on e.Ecodigo = uc.Ecodigo
		and e.Cconcepto = uc.Cconcepto
	where uc.Ecodigo = #session.Ecodigo#
	  and uc.Usucodigo = #Session.Usucodigo#
      <cfif isdefined('form.tipo') and form.tipo NEQ -1>
      and e.TipoSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.tipo)#">
      <cfelse>
      and e.TipoSAT is not null
      </cfif>
	union

	select e.Cconcepto, e.Cdescripcion,e.TipoSAT
	from ConceptoContableE e
	where e.Ecodigo = #session.Ecodigo#
	  and
		(
			select count(1)
			from UsuarioConceptoContableE uc
			where uc.Ecodigo = e.Ecodigo
			  and uc.Cconcepto = e.Cconcepto
		) = 0
      <cfif isdefined('form.tipo') and form.tipo NEQ -1>
      and e.TipoSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.tipo)#">
      <cfelse>
      and e.TipoSAT is not null
      </cfif>
</cfquery>

<cfif rsLotes.recordcount GT 0>
	<cfset LvarConceptos = valuelist(rsLotes.Cconcepto, ",")>
<cfelse>
	<cfset LvarConceptos = "-100">
</cfif>

<cfif isDefined("LvarConceptos")>
	<cfset navegacion = navegacion & "&LvarConceptos=#LvarConceptos#">
</cfif>

<cfquery name="rsMoneda" datasource="#Session.DSN#" cachedwithin="#createtimespan(0,0,1,0)#">
	select Mcodigo,Mnombre from Monedas
	where Ecodigo = #session.Ecodigo#
	order by Mcodigo
</cfquery>

<!---
	LISTA DE DOCUMENTOS CONTABLES
--->
<cfif isdefined('form.hdFiltrar') AND #form.hdFiltrar# EQ "filtrar">
    <cfquery name="rsLista" datasource="#session.DSN#">
        select	t.IDcontable,Cdescripcion,Eperiodo,Emes,PeriodoMes,Edocumento,Edocbase,
                Efecha,Ereferencia,Cconcepto,Oorigen,ECfechacreacion,Edescripcion,
                CASE WHEN cei.IDcontable IS NOT NULL or cer.IdContable IS NOT NULL
                THEN balanceada
                END as balanceada,
                IDcontableinactivar,sum(Dlocal) Monto,Usuario
        from (
            select
                a.IDcontable,
                ((
                    select min(e.Cdescripcion)
                    from ConceptoContableE e
                    where e.Ecodigo = a.Ecodigo
                    and e.Cconcepto = a.Cconcepto
                )) as Cdescripcion,
                a.Eperiodo,
                a.Edocbase,
                a.Emes,
                cast(a.Eperiodo as varchar) + '/' + cast(a.Emes as varchar) as PeriodoMes,
                a.Ereferencia,
                a.Edocumento,
                a.Efecha,
                a.Cconcepto,
                a.Oorigen,
                b.Dlocal,
                a.ECfechacreacion,
                a.Edescripcion
                , '<img border=''0'' src=''/cfmx/sif/imagenes/iindex.gif'' alt=''Mostrar CFDI''>' as balanceada
                ,
                (
                    select
                        case
                            when sum(case when c.Dmovimiento = 'D' then c.Dlocal else 0 end) != sum(case when c.Dmovimiento = 'C' then c.Dlocal else 0 end)
                            then a.IDcontable
                            else -1
                        end
                     from DContables c
                     where c.IDcontable = a.IDcontable
                 ) as IDcontableinactivar,
                 a.ECusuario as Usuario

            from HEContables a
            inner join HDContables b
                on a.IDcontable = b.IDcontable
                and a.Ecodigo = b.Ecodigo
            where a.Ecodigo   = #session.Ecodigo#
              and a.Cconcepto in (#LvarConceptos#)
              and a.Eperiodo  > -1
              and a.Emes      > -1
            <cfif LvarCHKMesCierre>
                and a.ECtipo = 1 <!--- Asientos de Cierre Anual --->
                and a.Eperiodo = #rsPerCierre.Eperiodo#
                and a.Emes     = #rsMesesCierre.VSvalor#
            <cfelse>
                <cfif inter eq "S">
                    and a.ECtipo = 20
                <cfelse>
                    <cfif isdefined("paramretro") and paramretro eq 2>
                        <!--- Para listar solamente asientos retroactivos --->
                        and a.ECtipo = 2
                    <cfelse>
                        and a.ECtipo = 0
                    </cfif>
                </cfif>
                <cfif isdefined("form.periodo") and len(trim(form.periodo)) and listgetat(form.periodo, 1) NEQ -1>
                    and a.Eperiodo = #listgetat(form.periodo, 1)#
                </cfif>
                <cfif isdefined("form.mes") and len(trim(form.mes)) and listgetat(form.mes,1) neq -1>
                    and a.Emes = #listgetat(form.mes,1)#
                </cfif>
            </cfif>
            <cfif isdefined("form.lote")  and len(trim(form.lote)) and listgetat(form.lote,1) NEQ -1>
                and a.Cconcepto = #listgetat(form.lote,1)#
            </cfif>
            <cfif isdefined("form.poliza") and Len(Trim(form.poliza))>
                and a.Edocumento = #form.poliza#
            </cfif>
            <cfif isdefined("form.Documento") and Len(Trim(form.Documento))>
                and upper(a.Edocbase) like upper('%#Trim(form.Documento)#%')
            </cfif>
            <!---<cfif isdefined("form.Documento") and Len(Trim(form.Documento)) GT 0 and isnumeric(form.Documento)>
                and a.Edocumento = #form.Documento#
            </cfif>--->
            <cfif isdefined("form.Referencia") and len(trim(form.Referencia)) GT 0>
                and upper(a.Ereferencia) like '%#Ucase(listgetat(form.Referencia,1))#%'
            </cfif>
            <cfif isdefined("form.Moneda") and len(trim(form.Moneda)) gt 0>
                and b.Mcodigo = #form.Moneda#
            </cfif>
            <!--- <cfif isdefined("form.fechaIni") and len(trim(form.fechaIni)) GT 0 and LSisdate(listgetat(form.fechaIni, 1))>
                and <cf_dbfunction name="to_date00" args="a.Efecha"> >= #LSParseDateTime(listgetat(form.fechaIni, 1))#
            </cfif>
            <cfif isdefined("form.fechaFin") and len(trim(form.fechaFin)) GT 0 and LSisdate(listgetat(form.fechaFin, 1))>
                and <cf_dbfunction name="to_date00" args="a.Efecha"> <= #LSParseDateTime(listgetat(form.fechaFin, 1))#
            </cfif> --->

            <!--- <cfif isdefined("form.ECusuario") and len(trim(form.ECusuario)) and listgetat(form.ECusuario, 1) NEQ 'Todos'>
                and a.ECusuario = '#listgetat(form.ECusuario, 1)#'
            </cfif> --->
            <cfif isdefined("form.fechaIni") and len(trim(form.fechaIni)) GT 0 and LSisdate(listgetat(form.fechaIni, 1))>
                and <cf_dbfunction name="to_date00" args="a.ECfechacreacion"> >= #LSParseDateTime(listgetat(form.fechaIni, 1))#
            </cfif>
            <cfif isdefined("form.fechaFin") and len(trim(form.fechaFin)) GT 0 and LSisdate(listgetat(form.fechaFin, 1))>
                and <cf_dbfunction name="to_date00" args="a.ECfechacreacion"> <= #LSParseDateTime(listgetat(form.fechaFin, 1))#
            </cfif>
            <cfif isdefined("form.origen") and len(trim(form.origen)) GT 0 >
                and upper(a.Oorigen)  like '%#Ucase(listgetat(form.origen,1))#%'
            </cfif>
        ) t
        LEFT JOIN CEInfoBancariaSAT cei ON cei.IDcontable = t.IDcontable
        LEFT JOIN CERepositorio cer ON cer.IdContable = t.IDcontable
        group by t.IDcontable,Cdescripcion,Eperiodo,Emes,PeriodoMes,Edocumento,Edocbase,
                Efecha,Ereferencia,Cconcepto,Oorigen,ECfechacreacion,Edescripcion,balanceada,
                IDcontableinactivar,Usuario,cei.IDcontable,cer.IdContable
        order by Efecha desc, Cconcepto, Edocumento, Eperiodo, Emes
    </cfquery>
	
</cfif>


<!---
	PINTADO DEL FORM
--->
<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset PolizaE = t.Translate('PolizaE','P&oacute;liza')>
<cfset PolizaNum = t.Translate('PolizaNum','La p&oacute;liza debe ser num&eacute;rica.')>


<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
<cf_templateheader title="#LB_Titulo#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo=#LB_Titulo#>
		<cfinclude template="../../portlets/pNavegacion.cfm">
		<cfform action="" method="post" name="formPrepara" style="margin:0;" onSubmit="return sinbotones()">
		</cfform>

		<cfoutput>
		<cfform action="listaConsultaPolizas#sufix#.cfm" method="post" name="formfiltro" style="margin:0;" enctype="multipart/form-data" onSubmit="return sinbotones()">
			<table width="100%"  border="0" cellspacing="1" cellpadding="1" class="AreaFiltro" style="margin:0;">
				<tr>
                	<td align="right"><b>Tipo de Poliza</b></td>
					<td><b>#LB_Lote#</b></td>
					<td><b>#PolizaE#</b></td>
					<td><b>#LB_Moneda#</b></td>
					<td><b>#LB_Periodo#</b></td>
					<td><b>#LB_Mes#</b></td>
                    <td></td>
                    <td></td>
				</tr>
				<tr>
                	<td align="right">
                    	<select name="tipo" id="tipo" onChange = "return cmboPolizas();">
                            <option value="-1"><cf_translate key=LB_Todos>Todos</cf_translate></option>
                            <option value="I" <cfif isdefined("form.tipo") and form.tipo eq 'I'>selected</cfif> >Ingreso</option>
                            <option value="E" <cfif isdefined("form.tipo") and form.tipo eq 'E'>selected</cfif>>Egreso</option>
                            <option value="D" <cfif isdefined("form.tipo") and form.tipo eq 'D'>selected</cfif>>Diario</option>
						</select>
                        <cfset tipoPoliza = "return cmboPolizas();">
                    </td>
					<td>
						<select style="width:385px" name="lote" id= "lote">
						<option value="-1"><cf_translate key=LB_Todos>Todos</cf_translate></option>
							<cfloop query="rsLotes">
								<option value="#Cconcepto#"<cfif isdefined("form.lote") and form.lote eq Cconcepto>selected</cfif>>#Cconcepto# - #Cdescripcion#</option>
							</cfloop>
						</select>
					</td>
					<td>
						<input type="text" name="poliza" id="poliza" maxlength="5" size="5" value="<cfif isdefined('form.poliza')>#form.poliza#</cfif>">
					</td>
					<td>
						<select name="Moneda" id="Moneda">
							<option value=""><cf_translate key=LB_Todas>Todas</cf_translate></option>
							<cfloop query="rsMoneda">
								<option value="#rsMoneda.Mcodigo#"  <cfif isdefined("form.Moneda")  and len(trim(form.Moneda)) and trim(ucase(rsMoneda.Mcodigo))eq trim(Ucase(listgetat(form.Moneda,1)))>selected</cfif> >#rsMoneda.Mnombre#</option>
							</cfloop>
						</select>
				    </td>
					<td>
						<select name="periodo" id="periodo">
							<option value="-1"><cf_translate key=LB_Todos>Todos</cf_translate></option>
							<cfloop query="rsPer">
								<option value="#Eperiodo#"
									<cfif LvarCHKMesCierre>
										<cfif isdefined("rsPerCierre.Eperiodo") and rsPerCierre.Eperiodo eq Eperiodo>selected</cfif>
									<cfelse>
										<cfif isdefined("form.periodo") and form.periodo eq Eperiodo>selected</cfif>
									</cfif>
								>
									#Eperiodo#
								</option>
							</cfloop>
						</select>
					</td>
					<td>
						<select name="mes" id= "mes">
							<option value="-1"><cf_translate key=LB_Todos>Todos</cf_translate></option>
							<cfloop query="rsMeses">
								<option value="#VSvalor#"
									<cfif LvarCHKMesCierre>
										<cfif isdefined("rsMesesCierre.VSvalor") and rsMesesCierre.VSvalor eq VSvalor>selected</cfif>
									<cfelse>
										<cfif isdefined("form.mes") and form.mes eq VSvalor>selected</cfif>
									</cfif>
								>
									#VSdesc#
								</option>
							</cfloop>
						</select>
					</td>
					<td>
                    <input type="hidden" name="hdFiltrar" id="hdFiltrar" value="#varFiltrar#" />
                    <input type="button" name="bFiltrar" id="bFiltrar" value="#BTN_Filtrar#" onClick="filtrar()" class="btnFiltrar"></td>
					<td><input name="btnLimpiar"  type="button" id="btnLimpiar"  value="#BTN_Limpiar#" onClick="javascript:Limpiar(this.form);"  class="btnLimpiar"></td>
		       </tr>
			   <tr>
					  <td width="3%"><b><cf_translate key=LB_Documento>Documento</cf_translate></b></td>
					  <td width="5%"><b><cf_translate key=LB_Referencia>Referencia</cf_translate> </b></td>
					  <td><b>#LB_Fecha# Inicial</b></td>
					  <td><b>#LB_Fecha# Final</b></td>
					  <td colspan="3" nowrap ="true" align="center"><cfif isdefined('rsLista') and #rsLista.recordcount# GT 0><strong>Tipo XML</strong></cfif></td>
                      <td></td>
                      <td></td>
			 </tr>
			 <tr>
			    <td>
				  <input type="text" name="Documento" id = "Documento" size="23" maxlength="100" value="<cfif isdefined('form.Documento')>#form.Documento#</cfif>">
                </td>
		        <td>
					<input name="Referencia" id="Referencia" type="text" size="35" maxlength="100" value="<cfif isdefined('form.Referencia')>#form.Referencia#</cfif>">
				    <input type="checkbox" name="cierreAnual" id="cierreAnual" <cfif LvarCHKMesCierre> checked<cfelse> unchecked</cfif>><b><i><cf_translate key = LB_CierreAnual>Cierre Anual</cf_translate></i></b>
				</td>
				<td>
					<cfset fechaIni = ''>
					<cfif isdefined("form.fechaIni") and len(trim(form.fechaIni))>
						<cfset fechaIni = form.fechaIni>
					</cfif>
					<cf_sifcalendario name="fechaIni" value="#fechaIni#" form="formfiltro">
				</td>
				<td>
					<cfset fechaFin = ''>
					<cfif isdefined("form.fechaFin") and len(trim(form.fechaFin))>
						<cfset fechaFin = form.fechaFin>
					</cfif>
					<cf_sifcalendario name="fechaFin" value="#fechaFin#" form="formfiltro">
				</td>
			    <td colspan="3" align="center" nowrap="true">
			    	<cfif isdefined('rsLista') and #rsLista.recordcount# GT 0>
			    		<input type="radio" name="tipoXML" id="tipoXML" value="poliza" checked>Pólizas
				    	<input type="radio" name="tipoXML" id="tipoXMLAux" value="aux">Auxiliar de folios
			    	</cfif>
				</td>
                <td colspan="2" align="center">
					<cfif isdefined('rsLista') and #rsLista.recordcount# GT 0>
                    	<input type="button" class="btnAplicar" value="Preparar" onClick="Preparar()" />
                    </cfif>
				</td>
			</tr>
			<tr>
					<td colspan="4">
						<!---<input name="chkTodos" type="checkbox" value="" border="0" onClick="javascript:Marcar(this);" style="background:background-color ">
						<label for="chkTodos"><cf_translate key = LB_SeleccionaTodos>Seleccionar Todos</cf_translate></label>--->
				  	</td>
				   <td colspan="8">
						<input name="PageNum_lista" type="hidden" value="<cfif isdefined("form.PageNum_lista")>#form.PageNum_lista#</cfif>">
						<cfif isdefined("paramretro") and paramretro eq 2>
							<input type="hidden" name="paramretro" value="#paramretro#">
						</cfif>
					</td>
			</tr>
			<tr>
				<td colspan="6">
					<cfif isdefined('rsLista') and #rsLista.recordcount# GT 0>
						<cf_sifIncluirSelloDigital mostrar="h" nombre="selloDig">
					</cfif>
				</td>
			</tr>
	</table>
		</cfform>
		</cfoutput>

		<cfset V_irA = "ConsultaPolizas.cfm?inter=#inter#">

		<cfoutput>
		<form name="form1" method="post" action="#V_irA#" style="margin:0;">
			<input name="PageNum_lista" type="hidden" value="<cfif isdefined("form.PageNum_lista") and len(trim(form.PageNum_lista))>#form.PageNum_lista#</cfif>" tabindex="-1">
            <input name="tipo" 			type="hidden" value="<cfif isdefined("form.tipo") 		   and len(trim(form.tipo))>#form.tipo#</cfif>" tabindex="-1">
			<input name="lote" 			type="hidden" value="<cfif isdefined("form.lote") 		   and len(trim(form.lote))>#form.lote#</cfif>" tabindex="-1">
			<input name="poliza" 		type="hidden" value="<cfif isdefined("form.poliza") 	   and len(trim(form.poliza))>#form.poliza#</cfif>" tabindex="-1">
			<input name="descripcion" 	type="hidden" value="<cfif isdefined("form.Referencia")   and len(trim(form.Referencia))>#form.Referencia#</cfif>" tabindex="-1">
			<input name="periodo" 		type="hidden" value="<cfif isdefined("form.periodo")       and len(trim(form.periodo))>#form.periodo#</cfif>" tabindex="-1">
			<input name="mes" 			type="hidden" value="<cfif isdefined("form.mes") 		   and len(trim(form.mes))>#form.mes#</cfif>" tabindex="-1">
			<input name="Documento" 			type="hidden" value="<cfif isdefined("form.Documento") 		   and len(trim(form.Documento)) >#form.Documento#</cfif>" tabindex="-1">
			<input name="Moneda" 	type="hidden" value="<cfif isdefined("form.Moneda")     and len(trim(form.Moneda))>#form.Moneda#</cfif>" tabindex="-1">
			<input name="origen" 		type="hidden" value="<cfif isdefined("form.origen")        and len(trim(form.origen)) >#form.origen#</cfif>" tabindex="-1">
			<input name="fechaIni" 	type="hidden" value="<cfif isdefined("form.fechaIni")   and len(trim(form.fechaIni))>#form.fechaIni#</cfif>" tabindex="-1">
			<input name="fechaFin" 	type="hidden" value="<cfif isdefined("form.fechaFin")   and len(trim(form.fechaFin))>#form.fechaFin#</cfif>" tabindex="-1">
			<input name="cierreAnual" 	type="hidden" value="<cfif isdefined("form.cierreAnual")   and len(trim(form.cierreAnual))>1</cfif>" tabindex="-1">
			<input name="asientosAnulados" 	type="hidden" value="<cfif isdefined("form.asientosAnulados")   and len(trim(form.asientosAnulados))>1</cfif>" tabindex="-1">
			<input name="ListaConsultaAsientos" type="hidden" value="a" />
			<INPUT type="hidden" id="tipoSol">
			<INPUT type="hidden" id="NumSol">
			<INPUT type="hidden" id="NumTram">
			<input name="ReporteResumido" 	type="hidden" value="" tabindex="-1">
			<input name="inter" type="hidden" value="b" />
		<cfif isdefined("form.ver") and len(trim(form.ver)) eq 0>
			<cfset form.ver = 15 >
		</cfif>
		<cfset LvarBotones = 'Consultar'>
		<cfset LvarDesplegar = 'Cdescripcion,Edocumento,Edescripcion,Ereferencia,Edocbase,PeriodoMes, ECfechacreacion, Monto, balanceada'>
		<cfset LvarEtiquetas = '#LB_Lote#, #PolizaE#, #LB_Descripcion#,Referencia, Doc. Base, #LB_Periodo#/#LB_Mes#,  #LB_Fecha#, Monto, Documento'>
		<cfset LvaFormato = 'V,V,V,V,V,V,V,M,V'>
		<cfset LvarAlign = 'left, left, left, left, left, center, left, right, center'>

		<cfif isdefined('rsLista')>
            <cfinvoke
             component="sif.Componentes.pListas"
             method="pListaQuery"
             returnvariable="pListaRet">
                <cfinvokeargument name="query" 				value="#rsLista#"/>
                <cfinvokeargument name="desplegar" 			value="#LvarDesplegar#"/>
                <cfinvokeargument name="etiquetas" 			value="#LvarEtiquetas#"/>
                <cfinvokeargument name="formatos" 			value="#LvaFormato#"/>
                <cfinvokeargument name="align" 				value="#LvarAlign#"/>
                <cfinvokeargument name="ajustar" 			value="S"/>
                <cfinvokeargument name="irA" 				value="#V_irA#"/>
                <cfinvokeargument name="checkboxes" 		value="S"/>
                <cfinvokeargument name="keys" 				value="IDcontable"/>
                <cfinvokeargument name="incluyeform"		value="false"/>
                <cfinvokeargument name="formname" 			value="form1"/>
                <!--- <cfinvokeargument name="botones" 			value="#LvarBotones#"/> --->
                <cfinvokeargument name="maxrows" 			value="#form.ver#"/>
				<cfinvokeargument name="MaxRowsQuery" 		value="100"/>
                <cfinvokeargument name="navegacion" 		value="#navegacion#"/>
                <cfinvokeargument name="showEmptyListMsg" 	value="true"/>
                <cfinvokeargument name="showLink" 			value="false"/>
                <cfinvokeargument name="inactivecol"	 	value="IDcontableinactivar"/>
            </cfinvoke>
        </cfif>
		</form>
		</cfoutput>
	<table border="0" width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td align="center">
				<cfif isdefined('rsLista') and #rsLista.recordcount# GT 0>
					<input type="button" class="btnNormal" onClick="consultarPoliza()" value="Consultar">
					<cfelse>
						&nbsp;
				</cfif>
			</td>
		</tr>
	</table>
	<cf_web_portlet_end>
<cf_templatefooter>
<cfoutput>
<script language="javascript" type="text/javascript">
<cfif isDefined("varUsaAJAX")>
	filtrar();
</cfif>
	function consultarPoliza(){
		var rdio1 = document.getElementById('tipoXML');
		var rdioAux = document.getElementById('tipoXMLAux');
		var varChek = "";
		var varUrl = <cfoutput>"#V_irA#"</cfoutput>
		<cfif isdefined("rsLista") and rsLista.recordcount gt 1>
			for (counter = 0; counter < document.form1.chk.length; counter++)
			{
				if(document.form1.chk[counter].checked){
					if(varChek == ""){
						varChek = "chk=" + document.form1.chk[counter].value
					} else{
						varChek = varChek + "," + document.form1.chk[counter].value
					}
				}
			}
		<cfelse>
			if(document.form1.chk.checked){
				if(varChek == ""){
					varChek = "chk=" + document.form1.chk.value
				} else{
					varChek = varChek + "," + document.form1.chk.value
				}
			}
		</cfif>
		if (!rdio1.checked && !rdioAux.checked) {
			alert('Favor de seleccionar un tipo de XML.');
			return false;
		}
		if(varChek == ""){
			alert('Favor de seleccionar al menos un registro.');
			return false;
		} else {
			if(rdio1.checked){
				varChek = varChek + "&tr=1";
			} else if(rdioAux.checked){
				varChek = varChek + "&tr=2";
			}
			document.formfiltro.action = varUrl + "&" + varChek;
   			document.formfiltro.submit();
   		}
	}
	function filtrar(){
		document.getElementById('hdFiltrar').value = "filtrar";
	  document.formfiltro.action = 'listaConsultaPolizas.cfm';
	  document.formfiltro.submit();
	}
	function Marcar(c) {
		if (c.checked) {
			for (counter = 0; counter < document.form1.chk.length; counter++)
			{
				if ((!document.form1.chk[counter].checked) && (!document.form1.chk[counter].disabled))
					{  document.form1.chk[counter].checked = true;}
			}
			if ((counter==0)  && (!document.form1.chk.disabled)) {
				document.form1.chk.checked = true;
			}
		}
		else {
			for (var counter = 0; counter < document.form1.chk.length; counter++)
			{
				if ((document.form1.chk[counter].checked) && (!document.form1.chk[counter].disabled))
					{  document.form1.chk[counter].checked = false;}
			};
			if ((counter==0) && (!document.form1.chk.disabled)) {
				document.form1.chk.checked = false;
			}
		};
	}

	function Limpiar(f) {
		f.lote.value = "-1";
		f.poliza.value = "";
		f.periodo.value = "-1";
		f.mes.value = "-1";
		//f.origen.value = "";
		//f.descripcion.value = "";
		f.fechaIni.value = "";
		f.fechaFin.value = "";
		f.Moneda.value = "";
		f.cierrenual.checked = false;

	}

	function Preparar(){
		var actionForm = '';
		var stop = false;
		var rdio1 = document.getElementById('tipoXML');
		var rdioAux = document.getElementById('tipoXMLAux');
		var periodo = document.getElementById('periodo');
		var mes = document.getElementById('mes');
		var varsellodig = document.getElementById("chk_selloDig");
		var sellodig = false;
		if(varsellodig){
			sellodig = varsellodig.checked;
		}
		if (!rdio1.checked && !rdioAux.checked) {
			stop = true;
			alert('Favor de seleccionar un tipo de XML')
		}else if(periodo.value == "-1"){
			stop = true;
			alert('Favor de seleccionar un periodo y Filtrar')
		}else if(mes.value == "-1"){
			stop = true;
			alert('Favor de seleccionar un mes y Filtrar')
		} else if(sellodig){
			var key_incSelloDigital = document.getElementById("key_selloDig").value;
			var cer_incSelloDigital = document.getElementById("cer_selloDig").value;
			var psw_incSelloDigital = document.getElementById("psw_selloDig");


			if(key_incSelloDigital == ""){
				stop = true;
				alert("Favor de seleccionar el archivo llave.");
			} else if((key_incSelloDigital.substring(key_incSelloDigital.lastIndexOf("."))).toLowerCase() != ".key"){
				stop = true;
				alert("Favor de seleccionar un archivo llave valido.");
			} else if(cer_incSelloDigital == ""){
				stop = true;
				alert("Favor de seleccionar el certificado.");
			} else if((cer_incSelloDigital.substring(cer_incSelloDigital.lastIndexOf("."))).toLowerCase() != ".cer"){
				stop = true;
				alert("Favor de seleccionar un certificado valido.");
			} else if(psw_incSelloDigital.value == ""){
				stop = true;
				alert("Favor de ingresar la clave.");
				psw_incSelloDigital.focus();
			} else{
				stop = false;
			}

		}
		if(stop == false){
			if (rdioAux.checked) {
				// AUXILIAR DE FOLIOS
				var url = "<cfoutput>#navegacion#</cfoutput>";
				var pagina = "popupAuxFolios.cfm";
				var navegacion = "";
				var moneda = document.formfiltro.Moneda.value;
				if(moneda != '') {
					navegacion = navegacion + "&moneda=" + moneda;
				}
				// var documento = document.formfiltro.Documento.value
				var documento = document.formfiltro.Documento.value
				if(documento != '') {
					navegacion = navegacion + "&documento=" + documento;
				}

				var fechaGenIni = document.formfiltro.fechaIni.value
				if(fechaGenIni != '') {
					navegacion = navegacion + "&fechaGenIni=" + fechaGenIni ;
				}

				var fechaGenFin = document.formfiltro.fechaFin.value
				if(fechaGenFin != '') {
					navegacion = navegacion + "&fechaGenFin=" + fechaGenFin;
				}
				url = "SQLGenerarXMLPolizasAuxiliar.cfm?"+url+navegacion;
				 abrirDatosAdicionales(url, "popupAuxFolios.cfm");
			}else if (rdio1.checked) {
			var pagina = "popupAuxFolios.cfm";
			var LvarXML = "SQLGenerarXMLPolizas.cfm";
			var navegacion = "";
			var periodo = document.getElementById("periodo").value;
			if(periodo != '') {
				navegacion = navegacion + "&periodo=" + periodo ;
			}

			var mes = document.getElementById("mes").value;
			if(mes != '') {
				navegacion = navegacion + "&mes=" + mes;
			}

			var lote = document.getElementById("lote").value;
			if(lote != '') {
				navegacion = navegacion + "&lote=" + lote;
			}

			var poliza = document.getElementById("poliza").value;
			if(poliza != '') {
				navegacion = navegacion + "&poliza=" + poliza;
			}

			var moneda = document.getElementById("Moneda").value;
			if(moneda != '') {
				navegacion = navegacion + "&moneda=" + moneda;
			}

			var documento = document.getElementById("Documento").value;
			if(documento != '') {
				navegacion = navegacion + "&documento=" + documento;
			}

			var Referencia = document.getElementById("Referencia").value;
			if(Referencia != '') {
				navegacion = navegacion + "&Referencia=" + Referencia;
			}

			var fechaGenIni = document.getElementsByName("fechaIni")[0].value;
			if(fechaGenIni != '') {
				navegacion = navegacion + "&fechaGenIni=" + fechaGenIni ;
			}

			var fechaGenFin = document.getElementsByName("fechaFin")[0].value;
			if(fechaGenFin != '') {
				navegacion = navegacion + "&fechaGenFin=" + fechaGenFin;
			}
			 // window.open(pagina + "?LvarXML=" + LvarXML + navegacion,"WinPolizas","Left=430,top=250,width=400,height=270,scrollbars=yes,Resizable=NO")
			 abrirDatosAdicionales(LvarXML + "?" + navegacion, pagina);
			}
		}
	}

	function cmboPolizas(){
		document.getElementById('hdFiltrar').value = "filtrar";
		document.formfiltro.action = 'listaConsultaPolizas.cfm';
   		document.formfiltro.submit();
	}
	function abrirDatosAdicionales(varUrl, varPagina){
	//creamos una variable de tipo array para pasar y recuperar los datos
	var datos=new Array();
		var tipoSolicitud = "";
		var numOrden = "";
		var numTramite = "";
		var url = "";
		var datos=new Array();
		datos[0]=document.getElementById("tipoSol").value;
		datos[1]=document.getElementById("NumSol").value;
		datos[2]=document.getElementById("NumTram").value;
		//aqui paso los datos a la ventana hija
		datos=window.open(varPagina,datos,'status:no;resizable:yes;dialogTop:250px;dialogLeft:430px;dialogWidth:400px;dialogHeight:270px;scroll:yes');
		//aqui recuepero datos de la ventana hija
		document.getElementById("tipoSol").value=datos[0];
		document.getElementById("NumSol").value=datos[1];
		document.getElementById("NumTram").value=datos[2];
		tipoSolicitud = document.getElementById("tipoSol").value;
		numOrden = document.getElementById("NumSol").value;
		numTramite = document.getElementById("NumTram").value;
		// Validacion de datos recuperados
		if(tipoSolicitud == "-1"){
			return;
		}else if(tipoSolicitud == "AF" || tipoSolicitud == "FC"){
			if(numOrden.value == ""){
				return;
			}
		}
		if(tipoSolicitud == "DE" || tipoSolicitud == "CO"){
			if(numTramite.value == ""){
				return;
			}
		}

		url = varUrl+"&tipoSolicitud="+tipoSolicitud+"&numOrden="+numOrden+"&numTramite="+numTramite;
		prepararXML(url);
	}
	function prepararXML(varUrl){
		// formfiltro 	formPrepara
		document.formfiltro.action = varUrl
		document.formfiltro.submit();
		// document.form1.action = "ConsultaPolizas.cfm"
	}
</script>
</cfoutput>
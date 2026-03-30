<!---
	Modificado por: Ana Villavicencio
	Fecha: 30 de setiembre del 2005
	Motivo: el filtro para el usuario q generó no matenía los datos cuando hacia submit.
			Tenía select en lugar de selected.
	Línea: 321

	Modificado por Gustavo Fonseca H.
		Fecha: 21-12-2005.
		Motivo: Se limita la lista para que solo se pueda escoger 150 registros como máximo.
		Esto para evitar páginas grandes que le peguen a la memoria del servidor. Cambio pedido por Mauricio Esquivel.

	Modificado por Gustavo Fonseca H.
		Fecha: 2-3-2006.
		Motivo: Se utiliza la tabla CGPeriodosProcesados para sacar el combo de los periodos y así mejorar el
		rendimiento de la pantalla.
	Modificado por Gustavo Fonseca H.
		Fecha: 27-3-2006.
		Motivo: se hace que se conserven los valores del filtro y el número de página de la lista al aplicar
		tanto desde la lista como dentro del documento.
	Modificado por Victor Mora S.
		Fecha: 16-12-2011
		Motivo: se agrega el campo del usuario a la tabla de asientos contables y filtro al devolverse a la pantalla
		principal de los asientos contables.
 --->
<cfinvoke  key="BTN_Regresar" default="Regresar" component="sif.Componentes.Translate" method="Translate"
returnvariable="BTN_Regresar" xmlfile="/sif/generales.xml"/>
<cfinvoke  key="BTN_Filtrar" default="Filtrar" component="sif.Componentes.Translate" method="Translate"
returnvariable="BTN_Filtrar" xmlfile="/sif/generales.xml"/>
<cfinvoke  key="BTN_Limpiar" default="Limpiar" component="sif.Componentes.Translate" method="Translate"
returnvariable="BTN_Limpiar" xmlfile="/sif/generales.xml"/>
<cfinvoke  key="LB_Titulo" default="Lista de Documentos Contables" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Titulo" xmlfile="listaDocumentosContables.xml"/>
<cfinvoke  key="LB_Descripcion" default="Descripci&oacute;n" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Descripcion" xmlfile="listaDocumentosContables.xml"/>
<cfinvoke  key="LB_Fecha" default="Fecha" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Fecha" xmlfile="listaDocumentosContables.xml"/>
<cfinvoke  key="LB_Periodo" default="Periodo" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Periodo" xmlfile="listaDocumentosContables.xml"/>
<cfinvoke  key="LB_Mes" default="Mes" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Mes" xmlfile="listaDocumentosContables.xml"/>
<cfinvoke  key="LB_Origen" default="Origen" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Origen" xmlfile="listaDocumentosContables.xml"/>
<cfinvoke  key="LB_Usuario" default="Usuario" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Usuario" xmlfile="listaDocumentosContables.xml"/>
<cfinvoke  key="LB_Lote" default="Lote" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Lote" xmlfile="listaDocumentosContables.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_EstaSeguro" Default="¿Está seguro de que desea aplicar los documentos seleccionadas?"	 returnvariable="LB_EstaSeguro"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_NoEstaMes1" Default="No se encuentra en el primer mes contable para utilizar este proceso"	 returnvariable="MSG_NoEstaMes1"/>


<cfparam name="sufix" default="">
<cfif not isdefined("url.inter")  and not isdefined("form.inter")>
 	<cfset inter = 'N'>
</cfif>
<cfif isdefined("url.inter") and not isdefined("form.inter")>
 	<cfset inter = url.inter>
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

<cfset params = "">

<!--- pasa URL a FORM --->
<cfif isdefined("url.lote") and len(trim(url.lote)) and not isdefined("form.lote")>
	<cfset form.lote = url.lote >
</cfif>
<cfif isdefined("url.poliza") and len(trim(url.poliza)) and not isdefined("form.poliza")>
	<cfset form.poliza = url.poliza >
</cfif>
<cfif isdefined("url.descripcion") and len(trim(url.descripcion)) and not isdefined("form.descripcion")>
	<cfset form.descripcion = url.descripcion >
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
<cfif isdefined("url.origen") and len(trim(url.origen)) and not isdefined("form.origen")>
	<cfset form.origen = url.origen >
</cfif>
<cfif isdefined("url.fechaGenIni") and len(trim(url.fechaGenIni)) and not isdefined("form.fechaGenIni")>
	<cfset form.fechaGenIni = url.fechaGenIni >
</cfif>
<cfif isdefined("url.fechaGenFin") and len(trim(url.fechaGenFin)) and not isdefined("form.fechaGenFin")>
	<cfset form.fechaGenFin = url.fechaGenFin >
</cfif>
<cfif isdefined("url.pageNum_lista") and len(trim(url.pageNum_lista)) and not isdefined("form.pageNum_lista")>
	<cfset form.pageNum_lista = url.pageNum_lista >
</cfif>
<cfif isdefined("url.ver") and len(trim(url.ver)) and not isdefined("form.ver")>
	<cfset form.ver = url.ver >
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
<cfif isdefined("form.descripcion") >
	<cfset navegacion = navegacion & "&descripcion=#JSStringFormat(form.descripcion)#">
	<cfset params = params & "&descripcion=#form.descripcion#">
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

<cfif isdefined("form.PageNum_lista") and len(trim(form.PageNum_lista))>
	<cfset params = params & "&PageNum_lista=#form.PageNum_lista#">
</cfif>

<cfif LvarCHKMesCierre>
	<cfquery name="rsPer" datasource="#Session.DSN#">
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

	<cfquery name="rsMeses" datasource="sifControl">
		select <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl"> as VSvalor, b.VSdesc
		from Idiomas a, VSidioma b
		where a.Icodigo = '#Session.Idioma#'
		  and b.Iid = a.Iid
		  and b.VSgrupo = 1
		  and b.VSvalor = '#LvarMesCierreAnual#'
	</cfquery>

<cfelse>
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
</cfif>

<!---
	FILTRO DE DOCUMENTOS CONTABLES
--->
<cfquery name="rsLotes" datasource="#Session.DSN#" cachedwithin="#createtimespan(0,0,5,0)#">
	select uc.Cconcepto, e.Cdescripcion
	from UsuarioConceptoContableE uc
		inner join ConceptoContableE e
		 on e.Ecodigo = uc.Ecodigo
		and e.Cconcepto = uc.Cconcepto
	where uc.Ecodigo = #session.Ecodigo#
	  and uc.Usucodigo = #Session.Usucodigo#

	union

	select e.Cconcepto, e.Cdescripcion
	from ConceptoContableE e
	where e.Ecodigo = #session.Ecodigo#
	  and
		(
			select count(1)
			from UsuarioConceptoContableE uc
			where uc.Ecodigo = e.Ecodigo
			  and uc.Cconcepto = e.Cconcepto
		) = 0
</cfquery>

<cfif rsLotes.recordcount GT 0>
	<cfset LvarConceptos = valuelist(rsLotes.Cconcepto, ",")>
<cfelse>
	<cfset LvarConceptos = "-100">
</cfif>

<cfquery name="rsUsuarios" datasource="#Session.DSN#" cachedwithin="#createtimespan(0,0,1,0)#">
	select ECusuario, count(1) as Cantidad
	from EContables
	where Ecodigo = #Session.Ecodigo#
	  and Cconcepto in (#LvarConceptos#)
	group by ECusuario
	order by ECusuario
</cfquery>

<!---
	LISTA DE DOCUMENTOS CONTABLES
--->
<cfquery name="rsLista" datasource="#session.DSN#">
	select
		a.IDcontable,
		((
			select min(e.Cdescripcion)
			from ConceptoContableE e
			where e.Ecodigo = a.Ecodigo
			and e.Cconcepto = a.Cconcepto
		)) as Cdescripcion,
		a.Eperiodo,
		a.Emes,
		a.Edocumento,
		a.Efecha,
		a.Oorigen,
		a.ECfechacreacion,
		a.Edescripcion
		, ' ' as balanceada
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
	from EContables a
	where a.Ecodigo   = #session.Ecodigo#
	  and a.Cconcepto in (#LvarConceptos#)
	  and a.Eperiodo  > -1
	  and a.Emes      > -1
	<cfif LvarCHKMesCierre>
		and a.ECtipo = 1 <!--- Asientos de Cierre Anual --->
		and a.Eperiodo = #rsPer.Eperiodo#
		and a.Emes     = #rsMeses.VSvalor#
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
	<cfif isdefined("form.poliza") and Len(Trim(form.poliza)) GT 0 and isnumeric(form.poliza)>
		and a.Edocumento = #form.poliza#
	</cfif>
	<cfif isdefined("form.descripcion") and len(trim(form.descripcion)) GT 0>
		and upper(a.Edescripcion) like '%#Ucase(listgetat(form.descripcion,1))#%'
	</cfif>
	<cfif isdefined("form.fechaIni") and len(trim(form.fechaIni)) GT 0 and LSisdate(listgetat(form.fechaIni, 1))>
		and <cf_dbfunction name="to_date00" args="a.Efecha"> >= #LSParseDateTime(listgetat(form.fechaIni, 1))#
	</cfif>
	<cfif isdefined("form.fechaFin") and len(trim(form.fechaFin)) GT 0 and LSisdate(listgetat(form.fechaFin, 1))>
		and <cf_dbfunction name="to_date00" args="a.Efecha"> <= #LSParseDateTime(listgetat(form.fechaFin, 1))#
	</cfif>

	<cfif isdefined("form.ECusuario") and len(trim(form.ECusuario)) and listgetat(form.ECusuario, 1) NEQ 'Todos'>
		and a.ECusuario = '#listgetat(form.ECusuario, 1)#'
	</cfif>
	<cfif isdefined("form.fechaGenIni") and len(trim(form.fechaGenIni)) GT 0 and LSisdate(listgetat(form.fechaGenIni, 1))>
		and <cf_dbfunction name="to_date00" args="a.ECfechacreacion"> >= #LSParseDateTime(listgetat(form.fechaGenIni, 1))#
	</cfif>
	<cfif isdefined("form.fechaGenFin") and len(trim(form.fechaGenFin)) GT 0 and LSisdate(listgetat(form.fechaGenFin, 1))>
		and <cf_dbfunction name="to_date00" args="a.ECfechacreacion"> <= #LSParseDateTime(listgetat(form.fechaGenFin, 1))#
	</cfif>
	<cfif isdefined("form.origen") and len(trim(form.origen)) GT 0 >
		and upper(a.Oorigen)  like '%#Ucase(listgetat(form.origen,1))#%'
	</cfif>
	order by Efecha desc, a.Cconcepto, a.Edocumento, a.Eperiodo, a.Emes
</cfquery>

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

		<cfoutput>
		<cfform action="listaDocumentosContables#sufix#.cfm" method="post" name="formfiltro" style="margin:0;" onSubmit="return sinbotones()">
			<table width="100%"  border="0" cellspacing="1" cellpadding="1" class="AreaFiltro" style="margin:0;">
				<tr>
					<td colspan="2"><b>#LB_Lote#</b></td>
					<td width="11%"><b>#PolizaE#</b></td>
					<td width="9%"><b>#LB_Periodo#</b></td>
					<td width="18%"><b>#LB_Mes#</b></td>
					<td width="14%"><b>#LB_Fecha# Doc.Ini</b></td>
					<td width="26%"><b>#LB_Fecha# Gen.Ini</b></td>
				</tr>
				<tr>
					<td colspan="2">
						<select name="lote">
						<option value="-1"><cf_translate key=LB_Todos>Todos</cf_translate></option>
							<cfloop query="rsLotes">
								<option value="#Cconcepto#"<cfif isdefined("form.lote") and form.lote eq Cconcepto>selected</cfif>>#Cdescripcion#</option>
							</cfloop>
						</select>
					</td>
					<td>
						<input type="text" name="poliza" maxlength="5" size="5" value="<cfif isdefined('form.poliza')>#form.poliza#</cfif>">
					</td>
					<td>
						<select name="periodo">
							<cfif not LvarCHKMesCierre>
								<option value="-1"><cf_translate key=LB_Todos>Todos</cf_translate></option>
							</cfif>
							<cfloop query="rsPer">
								<option value="#Eperiodo#" <cfif isdefined("form.periodo") and form.periodo eq Eperiodo>selected</cfif>>#Eperiodo#</option>
							</cfloop>
						</select>
					</td>
					<td>
						<select name="mes">
							<cfif not LvarCHKMesCierre>
								<option value="-1"><cf_translate key=LB_Todos>Todos</cf_translate></option>
							</cfif>
							<cfloop query="rsMeses">
								<option value="#VSvalor#"<cfif isdefined("form.mes") and form.mes eq VSvalor>selected</cfif>>#VSdesc#</option>
							</cfloop>
						</select>
					</td>
					<td>
							<cfset fechaIni = ''>
						<cfif isdefined("form.fechaIni") and len(trim(form.fechaIni))>
							<cfset fechaIni = form.fechaIni>
						</cfif>
							<cf_sifcalendario name="fechaIni" value="#fechaIni#" form="formfiltro">
					</td>
					<td>
							<cfset fechaGenIni = ''>
						<cfif isdefined("form.fechaGenIni") and len(trim(form.fechaGenIni))>
							<cfset fechaGenIni = form.fechaGenIni>
						</cfif>
							<cf_sifcalendario name="fechaGenIni" value="#fechaGenIni#" form="formfiltro">
					</td>
					<td><input type="submit" name="bFiltrar" value="#BTN_Filtrar#" class="btnFiltrar"></td>
					<td><input name="btnLimpiar"  type="button" id="btnLimpiar"  value="#BTN_Limpiar#" onClick="javascript:Limpiar(this.form);"  class="btnLimpiar"></td>
		       </tr>
			   <tr>
					  <td width="3%"><b><cf_translate key=LB_Ver>Ver</cf_translate></b></td>
					  <td width="19%"><b><cf_translate key=LB_Usuario>Usuario que Gener&oacute;</cf_translate> </b></td>
					  <td><b>#LB_Origen#</b></td>
					  <td colspan="2"><b>#LB_Descripcion#</b></td>
					  <td><b>#LB_Fecha# Doc.Fin</b></td>
					  <td><b>#LB_Fecha# Gen.Fin</b></td>
			 </tr>
			 <tr>
					  <td>
						<input type="text" name="ver" size="4" maxlength="4" value="<cfif isdefined('form.ver')>#form.ver#</cfif>" onBlur="javascript:fm(this,0); FuncLimite();" onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
					  </td>
				      <td>
						<select name="ECusuario">
							<option value="Todos"><cf_translate key=LB_Todos>Todos</cf_translate></option>
							<cfloop query="rsUsuarios">
								<option value="#rsUsuarios.ECusuario#"  <cfif isdefined("form.ECusuario")  and len(trim(form.ECusuario)) and trim(ucase(rsUsuarios.ECusuario))eq trim(Ucase(listgetat(form.ECusuario,1)))>selected</cfif> >#rsUsuarios.ECusuario#</option>
							</cfloop>
						</select>
				  	</td>
				  	<td>
						<input name="origen" type="text" size="5" maxlength="4" value="<cfif isdefined("form.origen")>#form.origen#</cfif>">
					</td>
				  	<td colspan="2">
						<input name="descripcion" type="text" size="40" maxlength="100" value="<cfif isdefined('form.descripcion')>#form.descripcion#</cfif>">
					</td>
					 <td>
						<cfset fechaFin = ''>
						<cfif isdefined("form.fechaFin") and len(trim(form.fechaFin))>
							<cfset fechaFin = form.fechaFin>
						</cfif>
						<cf_sifcalendario name="fechaFin" value="#fechaFin#" form="formfiltro">
					</td>
					<td>
							<cfset fechaGenFin = ''>
						<cfif isdefined("form.fechaGenFin") and len(trim(form.fechaGenFin))>
							<cfset fechaGenFin = form.fechaGenFin>
						</cfif>
						<cf_sifcalendario name="fechaGenFin" value="#fechaGenFin#" form="formfiltro">
					</td>
			</tr>
			<tr>
					<td colspan="4">
						<input name="chkTodos" type="checkbox" value="" border="0" onClick="javascript:Marcar(this);" style="background:background-color ">
						<label for="chkTodos"><cf_translate key = LB_SeleccionaTodos>Seleccionar Todos</cf_translate></label>
				  	</td>
				   <td colspan="8">
						<input name="PageNum_lista" type="hidden" value="<cfif isdefined("form.PageNum_lista")>#form.PageNum_lista#</cfif>">
						<cfif isdefined("paramretro") and paramretro eq 2>
							<input type="hidden" name="paramretro" value="#paramretro#">
						</cfif>
					</td>
			</tr>
	</table>
		</cfform>
		</cfoutput>

		<cfset V_irA = "DocumentosContables#sufix#.cfm?inter=#inter#">

		<cfoutput>
		<form name="form1" method="post" action="#V_irA#" style="margin:0;">
			<input name="PageNum_lista" type="hidden" value="<cfif isdefined("form.PageNum_lista") and len(trim(form.PageNum_lista))>#form.PageNum_lista#</cfif>" tabindex="-1">
			<input name="lote" 			type="hidden" value="<cfif isdefined("form.lote") 		   and len(trim(form.lote))>#form.lote#</cfif>" tabindex="-1">
			<input name="poliza" 		type="hidden" value="<cfif isdefined("form.poliza") 	   and len(trim(form.poliza))>#form.poliza#</cfif>" tabindex="-1">
			<input name="descripcion" 	type="hidden" value="<cfif isdefined("form.descripcion")   and len(trim(form.descripcion))>#form.descripcion#</cfif>" tabindex="-1">
			<input name="periodo" 		type="hidden" value="<cfif isdefined("form.periodo")       and len(trim(form.periodo))>#form.periodo#</cfif>" tabindex="-1">
			<input name="mes" 			type="hidden" value="<cfif isdefined("form.mes") 		   and len(trim(form.mes))>#form.mes#</cfif>" tabindex="-1">
			<input name="fechaIni" 		type="hidden" value="<cfif isdefined("form.fechaIni") 	   and len(trim(form.fechaIni))>#form.fechaIni#</cfif>" tabindex="-1">
			<input name="fechaFin" 		type="hidden" value="<cfif isdefined("form.fechaFin") 	   and len(trim(form.fechaFin))>#form.fechaFin#</cfif>" tabindex="-1">
			<input name="ver" 			type="hidden" value="<cfif isdefined("form.ver") 		   and len(trim(form.ver)) >#form.ver#</cfif>" tabindex="-1">
			<input name="ECusuario" 	type="hidden" value="<cfif isdefined("form.ECusuario")     and len(trim(form.ECusuario))>#form.ECusuario#</cfif>" tabindex="-1">
			<input name="origen" 		type="hidden" value="<cfif isdefined("form.origen")        and len(trim(form.origen)) >#form.origen#</cfif>" tabindex="-1">
			<input name="fechaGenIni" 	type="hidden" value="<cfif isdefined("form.fechaGenIni")   and len(trim(form.fechaGenIni))>#form.fechaGenIni#</cfif>" tabindex="-1">
			<input name="fechaGenFin" 	type="hidden" value="<cfif isdefined("form.fechaGenFin")   and len(trim(form.fechaGenFin))>#form.fechaGenFin#</cfif>" tabindex="-1">
			<input name="ListaConsultaAsientos" type="hidden" value="a" />
			<input name="ReporteResumido" 	type="hidden" value="" tabindex="-1">
			<input name="inter" type="hidden" value="b" />
		<cfif isdefined("form.ver") and len(trim(form.ver)) eq 0>
			<cfset form.ver = 15 >
		</cfif>
		<cfset LvarBotones = 'Nuevo, Aplicar, Consultar'>
		<cfif isdefined("LvarCC")>
			<cfset LvarBotones = 'Aplicar'>
		</cfif>
		<cfinvoke
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" 				value="#rsLista#"/>
			<cfinvokeargument name="desplegar" 			value="Cdescripcion,Edocumento,Edescripcion,Efecha,Eperiodo,Emes, Oorigen, ECfechacreacion, Usuario, balanceada"/>
			<cfinvokeargument name="etiquetas" 			value="#LB_Lote#, #PolizaE#, #LB_Descripcion#, #LB_Fecha# Doc., #LB_Periodo#, #LB_Mes#, #LB_Origen#, #LB_Fecha# Gen., #LB_Usuario#, &nbsp;"/>
			<cfinvokeargument name="formatos" 			value="V,V,V,D,V,V,V,D,V,V"/>
			<cfinvokeargument name="align" 				value="left, left, left, center, center, center, center, center, left, center"/>
			<cfinvokeargument name="ajustar" 			value="S"/>
			<cfinvokeargument name="irA" 				value="#V_irA#"/>
			<cfinvokeargument name="checkboxes" 		value="S"/>
			<cfinvokeargument name="keys" 				value="IDcontable"/>
			<cfinvokeargument name="incluyeform"		value="false"/>
			<cfinvokeargument name="formname" 			value="form1"/>
			<cfinvokeargument name="botones" 			value="#LvarBotones#"/>
			<cfinvokeargument name="maxrows" 			value="#form.ver#"/>
			<cfinvokeargument name="navegacion" 		value="#navegacion#"/>
			<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
			<cfinvokeargument name="inactivecol"	 	value="IDcontableinactivar"/>
		</cfinvoke>
		</form>
		</cfoutput>
	<table border="0" cellpadding="0" cellspacing="0">
		<tr><td>&nbsp;</td></tr>
	</table>
	<cf_web_portlet_end>
<cf_templatefooter>
<cfoutput>
<script language="javascript" type="text/javascript">
	function FuncLimite(){
		if (parseFloat(document.formfiltro.ver.value) >= 151) {
			document.formfiltro.ver.value = 150;
		}
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
	function funcNuevo(){
	 //PASA DIRECTO
	}

	function funcAplicar(){
		var aplica = false;
		if (document.form1.chk) {
			if (document.form1.chk.value) {
				aplica = document.form1.chk.checked;
			} else {
				for (var i=0; i<document.form1.chk.length; i++) {
					if (document.form1.chk[i].checked) {
						aplica = true;
						break;
					}
				}
			}
		}
		if (aplica) {
			return (confirm('#LB_EstaSeguro#'));
		} else {
			alert('Debe seleccionar al menos un documento antes de Aplicar');
			return false;
		}

	}

	function funcConsultar()
	{
	var aplica = false;
		if (document.form1.chk) {
			if (document.form1.chk.value) {
				aplica = document.form1.chk.checked;
			} else {
				for (var i=0; i<document.form1.chk.length; i++) {
					if (document.form1.chk[i].checked) {
						aplica = true;
						break;
					}
				}
			}
		}

	if (aplica){
			document.form1.inter.value = "<cfoutput>#inter#</cfoutput>";
			VerResumido=confirm("¿Desea ver el reporte resumido?");
			if(VerResumido)
			{
			document.form1.action='CDContablesResumido<cfoutput>#sufix#</cfoutput>.cfm';

			document.form1.submit();
			}
			else
			{
			document.form1.action='CDContables<cfoutput>#sufix#</cfoutput>.cfm';

				document.form1.submit();
			}}

	else {
			alert('Debe seleccionar al menos un documento antes de Aplicar');
			return false;
		}
	}


	function funcAplicar_como_Asiento_de_Cierre(){
		var aplica = false;
		if (document.form1.chk) {
			if (document.form1.chk.value) {
				aplica = document.form1.chk.checked;
			} else {
				for (var i=0; i<document.form1.chk.length; i++) {
					if (document.form1.chk[i].checked) {
						aplica = true;
						break;
					}
				}
			}
		}
		if (aplica) {
			return (confirm("¿Está seguro de que desea aplicar los documentos seleccionadas?"));
		} else {
			alert('Debe seleccionar al menos un documento antes de Aplicar');
			return false;
		}
	}

	function Limpiar(f) {
		f.lote.value = "-1";
		f.poliza.value = "";
		f.periodo.value = "-1";
		f.mes.value = "-1";
		f.ECusuario.value = "Todos";
		f.origen.value = "";
		f.descripcion.value = "";
		f.fechaIni.value = "";
		f.fechaGenIni.value = "";
		f.fechaFin.value = "";
		f.fechaGenFin.value = "";
		f.ver.value = "";
	}
</script>
</cfoutput>
<!--- 
	Modificado por: Ana Villavicencio 
	Fecha: 17 de Agosto del 2005
	Motivo: Correccion de error.  No se permite el registro de documentos retroactivos para el periodo actual.
			Y permite el registro de documentos de meses mayores al mes actual. 
			Se modificó la forma de llenar el combo de meses para el documento, 
			se asigna un valor de mes fiscal al mes calendario, asi muestra los meses de acuerdo al año fiscal
			(inicio octubre, fin setiembre).
			
	Modificado por: Josue Gamboa
	Fecha: 5 setiembre del 2005
	Motivo: Se quito lo del mes fiscal, la contabilidad debe trabajar con meses normales.
			El funcionamiento es como sigue: 
				i.  para asientos normales, los meses deben ser mayores o igual al mes actual de la conta
				ii. para asientos retroactivos, los meses deben ser menores al mes actual.

	Modificado por Gustavo Fonseca H.
		Fecha: 25-2-2006.
		Motivo: Se corrige el manejo de tabs (navegación del form). Se mantiene la referencia escrita en el encabezado para las líneas como sugerencia en ALTA.
		
	Modificado por Gustavo Fonseca H.
		Fecha: 1-3-2006.
		Motivo: Se modifica el la condición del pintado del "btnAbrir" para que solo se pinte en modo cambio.
	Modificado por Gustavo Fonseca H.
		Fecha: 2-3-2006.
		Motivo: Se utiliza la tabla CGPeriodosProcesados para sacar el combo de los periodos y así mejorar el 
		rendimiento de la pantalla.
	Modificado por Gustavo Fonseca H.
		Fecha: 27-3-2006.
		Motivo: se hace que se conserven los valores del filtro y el número de página de la lista al aplicar 
		tanto desde la lista como dentro del documento.
--->
<!--- MODOS Y Llaves para Encabezado y Detalle --->

<cfparam name="params" default="">
<cfset LvarCHKMesCierre = false>
<cfif sufix eq 'CierreAnual'>
	<cfset LvarCHKMesCierre = true>
</cfif>

<cfparam name="form.pageNum_lista" default="1">
<!--- 
	Variables de la navegación 
	VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION --->
<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista)) and not isdefined("form.PageNum_lista")>
	<cfset form.PageNum_Lista = url.PageNum_Lista>
</cfif>

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
<cfif isdefined("url.fecha") and len(trim(url.fecha)) and not isdefined("form.fecha")> 
	<cfset form.fecha = url.fecha >
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
<cfif isdefined("url.fechaGen") and len(trim(url.fechaGen)) and not isdefined("form.fechaGen")>
	<cfset form.fechaGen = url.fechaGen >
</cfif>

<!--- navegacion -params  --->
<cfif not isdefined("navegacion")>
	<cfset navegacion = "">
</cfif>

<cfif not isdefined("navegacion")>
	<cfset params = "">
</cfif>

<cfif isdefined("form.lote") and len(trim(form.lote)) >
	<cfset navegacion = navegacion & "&lote=#form.lote#">
	<cfset params = params & "&lote=#form.lote#">
</cfif>
<cfif isdefined("poliza") and len(trim(form.poliza)) >
	<cfset navegacion = navegacion & "&poliza=#form.poliza#">
	<cfset params = params & "&poliza=#form.poliza#">	
</cfif>
<cfif isdefined("form.descripcion") >
	<cfset navegacion = navegacion & "&descripcion=#JSStringFormat(form.descripcion)#">
	<cfset params = params & "&descripcion=#form.descripcion#">
</cfif>
<cfif isdefined("form.fecha") >
	<cfset navegacion = navegacion & "&fecha=#form.fecha#">
	<cfset params = params & "&fecha=#form.fecha#">
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
<cfif isdefined("form.fechaGen") >
	<cfset navegacion = navegacion & "&fechaGen=#form.fechaGen#">
	<cfset params = params & "&fechaGen=#form.fechaGen#">
</cfif>
<cfif isdefined("form.ver")>
	<cfset navegacion = navegacion & "&ver=#form.ver#">
	<cfset params = params & "&ver=#form.ver#">
</cfif>
<cfif isdefined("form.origen")>
	<cfset navegacion = navegacion & "&origen=#form.origen#">
	<cfset params = params & "&origen=#form.origen#">
</cfif>

<cfif isdefined("form.PageNum_lista") and len(trim(form.PageNum_lista))>
	<cfset params = params & "&PageNum_lista=#form.PageNum_lista#">
</cfif>

<cfif isdefined("form.Aplicar") and len(trim(form.Aplicar))>
	<cfset params = params & "&Aplica=#form.Aplicar#">
</cfif>
<cfif LvarCHKMesCierre>
	<cfset navegacion = navegacion & "&ECtipo=1">
	<cfset params = params & "&ECtipo=1">
</cfif>

<cfset mododet = "ALTA">
<cfif isdefined("url.IDcontable") and len(trim(url.IDcontable)) gt 0>
	<cfset IDcontable = url.IDcontable>
	<cfset IDcontable_detalle = url.IDcontable>
</cfif>

<cfif isdefined("IDcontable") and len(trim(IDcontable)) and form.IDcontable NEQ 0 and not isdefined("form.btnNuevo")>
	<cfset modo = "CAMBIO">
</cfif>
<cfif isdefined("Form.Dlinea") and len(trim(Form.Dlinea))>
	<cfset Dlinea = form.Dlinea>
	<cfset mododet = "CAMBIO">
<cfelse>
	<cfset Dlinea = -1>
</cfif>

<cfset LbanderaMonedas = false>
<cfif modo eq "CAMBIO">
	<cfquery name="rsMcodigo" datasource="#session.DSN#">
		select 
			Mcodigo, 
			Ecodigo 
		from Empresas 
		where Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfquery name="rsCheck1" datasource="#session.DSN#">
		select sum(1)as CantidadMoneda
		from DContables d
		where d.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcontable#">
			and d.Mcodigo <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMcodigo.Mcodigo#">
	</cfquery>
	<cfset LbanderaMonedas = rsCheck1.CantidadMoneda GT 0>
</cfif>

<cfquery name="rsOficinas" datasource="#Session.DSN#">
	select Ecodigo,Ocodigo,Odescripcion 
	from Oficinas 
	<cfif inter eq "S">
		where
		Ecodigo in ( select  Ecodigo
			  from Empresas
			 where cliente_empresarial = #Session.CEcodigo#)
	<cfelse>
		where
		Ecodigo = #Session.Ecodigo#
	</cfif>
	order by Ecodigo,Ocodigo 
</cfquery>
<!--- Variables para etiquetas de Traduccion --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t"/>
<cfset PolizaE = t.Translate('PolizaE','P&oacute;liza')>
<cfset PolizaBalOri = t.Translate('PolizaBalOri','Balance de P&oacute;liza en Moneda Origen')>
<cfset PolizaBalLoc = t.Translate('PolizaBalLoc','Balance de P&oacute;liza en Moneda Local')>
<cfset msgAplicar = t.Translate('PolizaAplicar','No tiene permisos para aplicar la p&oacute;liza')>

<!--- Codigo para Aplicacin de Asientos --->
<cfset ListaAplicar = "">
<cfif isDefined("Form.Aplicar") and Len(Trim(IDcontable)) NEQ 0>
	<cfset ListaAplicar = IDcontable>
</cfif>
<cfif isDefined("Form.btnAplicar") and isdefined("Form.chk") and Len(trim(Form.chk))>
	<cfset ListaAplicar = Form.chk>	
</cfif>

<cfset request.error.backs = 2>

<!--- rs con el codigo de la cuenta contable de balance de asientos --->
<cfquery name="rsParamCuentaBalance" datasource="#Session.DSN#">
	Select Pvalor as CFcuenta, '' as Ccuenta
	from Parametros
	where Ecodigo=#Session.Ecodigo#
		and Pcodigo=25
</cfquery>
<cfif Len(Trim(rsParamCuentaBalance.CFcuenta)) EQ 0>
	<cf_errorCode	code = "50241" msg = "No se ha definido la cuenta de Balance de Asientos en parametros">
</cfif>
<cfif Len(Trim(rsParamCuentaBalance.CFcuenta))>
	<cfquery name="rsParamCuentaBalance" datasource="#Session.DSN#">
		Select '#rsParamCuentaBalance.CFcuenta#' as CFcuenta, Ccuenta
		from CFinanciera c
		where Ecodigo=#Session.Ecodigo#
			and CFcuenta=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsParamCuentaBalance.CFcuenta#">
	</cfquery>
</cfif>

<cfset poneBtnBalancear = false>
<cfif modo neq "ALTA">
	<!--- Si es intercompany solo se valida por Moneda y no por oficina --->
	<cfif inter EQ 'S'>
		<cfquery name="rsBalanceO" datasource="#Session.DSN#">
			select 
				b.Mnombre,
				b.Msimbolo, 
				sum(case when a.Dmovimiento = 'D' then a.Doriginal else 0.00 end) as Debitos,
				sum(case when a.Dmovimiento = 'C' then a.Doriginal else 0.00 end) as Creditos,
				sum(case when a.Dmovimiento = 'D' then a.Dlocal else 0.00 end) as DebitosL,
				sum(case when a.Dmovimiento = 'C' then a.Dlocal else 0.00 end) as CreditosL
			from DContables a
				inner join Monedas b 
					on b.Mcodigo = a.Mcodigo 
			where a.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcontable#">
			group by b.Mnombre, b.Msimbolo
		</cfquery>
	<cfelse>
		<cfquery name="rsBalanceO" datasource="#Session.DSN#">
			select 
				a.Ecodigo,
				a.Mcodigo,
				a.Ocodigo,
				((select min(b.Mnombre) from Monedas b where b.Mcodigo = a.Mcodigo)) as Mnombre,
				((select min(b.Msimbolo) from Monedas b where b.Mcodigo = a.Mcodigo)) as Msimbolo,
				((select min(c.Oficodigo) from Oficinas c where c.Ecodigo = a.Ecodigo and c.Ocodigo = a.Ocodigo)) as Odescripcion,				 
				sum(case when a.Dmovimiento = 'D' then a.Doriginal else 0.00 end) as Debitos,
				sum(case when a.Dmovimiento = 'C' then a.Doriginal else 0.00 end) as Creditos,
				sum(case when a.Dmovimiento = 'D' then a.Dlocal else 0.00 end) as DebitosL,
				sum(case when a.Dmovimiento = 'C' then a.Dlocal else 0.00 end) as CreditosL
			from DContables a
			where a.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcontable#">
			group by a.Ecodigo, a.Mcodigo, a.Ocodigo
		</cfquery>
	</cfif>
	<!--- Ciclo para averiguar si se coloca o no el boton de Balancear Asiento --->	
	<!--- No se pone el botón de balanceo cuando se están registrando documentos intercompañía --->
	<cfif inter EQ 'N' and isdefined('rsBalanceO') and rsBalanceO.recordCount GT 0>
		<cfquery name="rsBalanceT"  dbtype="query">
			select sum(Debitos) as Debitos, sum(Creditos) as Creditos, sum(DebitosL) as DebitosL, sum(CreditosL) as CreditosL
			from  rsBalanceO
		</cfquery>

		<cfif rsBalanceT.Debitos EQ rsBalanceT.Creditos and rsBalanceT.DebitosL NEQ rsBalanceT.CreditosL>
				<cfset poneBtnBalancear = true>
		</cfif>
	</cfif>
</cfif>

<cfquery name="rsConceptos" datasource="#Session.DSN#">
		select  a.Cconcepto, Cdescripcion
		from ConceptoContableE a
		where a.Ecodigo = #Session.Ecodigo#
		and   not exists ( select 1 from UsuarioConceptoContableE b 
		where a.Ecodigo = #Session.Ecodigo#
		and   a.Cconcepto = b.Cconcepto
		and   a.Ecodigo = b.Ecodigo
		)  
		UNION
		select a.Cconcepto, Cdescripcion 
		from ConceptoContableE a,UsuarioConceptoContableE   b
		where a.Ecodigo = #Session.Ecodigo#
		and   a.Cconcepto = b.Cconcepto
		and   a.Ecodigo = b.Ecodigo
		and  Usucodigo  = #Session.Usucodigo#	
</cfquery>
<cfquery name="rsPrePeriodo" datasource="#Session.DSN#">
	select Pvalor as periodo
	from Parametros 
	where Ecodigo = #Session.Ecodigo# 
	and Pcodigo = 30
	and Mcodigo = 'CG'	  
</cfquery>

<cfquery name="rsMesCierreConta" datasource="#session.DSN#">
	select 
		<cf_dbfunction name="to_number" args="Pvalor"> as Pvalor
	from Parametros
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
	and Pcodigo = 45
</cfquery>

<cfset LvarMesCierreAnual = rsMesCierreConta.Pvalor>
<cfset LvarPrimerMes = LvarMesCierreAnual + 1>
<cfif LvarPrimerMes GT 12>
	<cfset LvarPrimerMes = 1>
</cfif>

<cfquery name="rsMesConta" datasource="#session.DSN#">
	select 
		<cf_dbfunction name="to_number" args="Pvalor"> as Pvalor
	from Parametros
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
	and Pcodigo = 40
</cfquery>

<cfset LvarMes = rsMesConta.Pvalor>
	
<cfif LvarCHKMesCierre>
	<cfquery name="rsPeriodo" datasource="#Session.DSN#">
		select 
			<cfif LvarPrimerMes eq 1>
				<cf_dbfunction args="Pvalor" name="to_number"> - 1
			<cfelse>
				<cf_dbfunction args="Pvalor" name="to_number">
			</cfif>
				as Pvalor
		from Parametros
		where Ecodigo = #Session.Ecodigo#
		  and Pcodigo = 30
	</cfquery>
	
	<cfquery name="rsMesesA" datasource="sifControl">
		select <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl"> as VSvalor, b.VSdesc 
		from Idiomas a, VSidioma b 
		where a.Icodigo = '#Session.Idioma#'
		  and b.Iid = a.Iid
		  and b.VSgrupo = 1
		  and b.VSvalor = '#LvarMesCierreAnual#'
	</cfquery>
<cfelse>
	<cfif isdefined("paramretro") and paramretro eq 2>
		<cfset rsPeriodo = QueryNew("Pvalor")>
		<cfset temp = QueryAddRow(rsPeriodo,3)>
		<cfset temp = QuerySetCell(rsPeriodo,"Pvalor",rsPrePeriodo.periodo,1)>
		<cfset temp = QuerySetCell(rsPeriodo,"Pvalor",rsPrePeriodo.periodo-1,2)>
		<cfset temp = QuerySetCell(rsPeriodo,"Pvalor",rsPrePeriodo.periodo-2,3)>
	<cfelse>
		<cfset rsPeriodo = QueryNew("Pvalor")>
		<cfset temp = QueryAddRow(rsPeriodo,3)>
		<cfset temp = QuerySetCell(rsPeriodo,"Pvalor",rsPrePeriodo.periodo,1)>
		<cfset temp = QuerySetCell(rsPeriodo,"Pvalor",rsPrePeriodo.periodo+1,2)>
		<cfset temp = QuerySetCell(rsPeriodo,"Pvalor",rsPrePeriodo.periodo+2,3)>
	</cfif>
</cfif>

<cfquery name="rsPeriodoActual" datasource="#Session.DSN#">
	select Pvalor from Parametros 
	where Ecodigo = #Session.Ecodigo# 
	and Pcodigo = 30
	and Mcodigo = 'CG'	  
</cfquery>
<cfset periodoActual = rsPeriodoActual.Pvalor>
<cfquery name="rsMes" datasource="#Session.DSN#">
	select Pvalor from Parametros 
	where Ecodigo = #Session.Ecodigo# 
	and Pcodigo = 40
	and Mcodigo = 'CG'
</cfquery>
<cfset mesActual = rsMes.Pvalor>
<cfquery name="rsMeses" datasource="sifControl">
	select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as mes, b.VSdesc as descripcion,
		case when VSvalor = '1' then 4
			when VSvalor = '2' then 5 
			when VSvalor = '3' then 6
			when VSvalor = '4' then 7
			when VSvalor = '5' then 8
			when VSvalor = '6' then 9
			when VSvalor = '7' then 10
			when VSvalor = '8' then 11
			when VSvalor = '9' then 12
			when VSvalor = '10' then 1
			when VSvalor = '11' then 2 else 3 end as mesFiscal
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
	and b.VSgrupo = 1
	and a.Iid = b.Iid
	order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">, descripcion
</cfquery>

<cfset meses = ValueList(rsMeses.descripcion,',')>
<cfset rsDebCred = QueryNew("tipo,descripcion")>
<cfset QueryAddRow(rsDebCred,2)>
<cfset QuerySetCell(rsDebCred,"tipo","D",1)>
<cfset QuerySetCell(rsDebCred,"descripcion","Débito",1)>
<cfset QuerySetCell(rsDebCred,"tipo","C",2)>
<cfset QuerySetCell(rsDebCred,"descripcion","Crédito",2)>
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select Mcodigo 
	from Empresas 
	where Ecodigo = #Session.Ecodigo# 
</cfquery>

<cfif modo NEQ "ALTA">
	<cfquery name="rsDocumento" datasource="#Session.DSN#">
		select IDcontable, Ecodigo, Cconcepto, Eperiodo, Emes, Edocumento, Efecha, Edescripcion, 
		Edocbase, Ereferencia, 'N' as ECauxiliar, ECusuario, ECselect, ECreversible, ECestado, ECtipo, ts_rversion, ECrecursivo
		from EContables
		where Ecodigo = #Session.Ecodigo#
		and IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcontable#">
	</cfquery>
	<cfquery name="rsTieneLineas" datasource="#Session.DSN#">
		select count(1) as Cantidad 
		from DContables a
		where a.Ecodigo = #Session.Ecodigo#
		and a.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcontable#">
	</cfquery>
	<cfquery name="TCsug" datasource="#Session.DSN#">
		select tc.Mcodigo, tc.TCcompra, tc.TCventa
		from Htipocambio tc
		where tc.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and tc.Hfecha  <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsDocumento.Efecha#">
			and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#rsDocumento.Efecha#">
	</cfquery>
	<cfif mododet NEQ "ALTA">
		<cfquery name="rsLinea" datasource="#Session.DSN#">
			select b.CFformato, b.CFdescripcion, c.Cformato, c.Cdescripcion,
			IDcontable, Dlinea, a.Ecodigo, a.Cconcepto, a.Eperiodo, a.Emes, a.Edocumento, a.Ocodigo, a.Ddescripcion, 
			a.Ddocumento, a.Dreferencia, a.Dmovimiento, a.Ccuenta, a.CFcuenta, a.Doriginal, a.Dlocal, a.Mcodigo, a.Dtipocambio, a.ts_rversion, a.CFid
			from DContables a
				inner JOIN CFinanciera b
					inner JOIN CContables c 
						ON c.Ccuenta = b.Ccuenta
					ON a.CFcuenta = b.CFcuenta
			where a.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcontable#">
			  and a.Dlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Dlinea#">
		</cfquery>
	</cfif>
</cfif>

<!--- Averiguar si se tiene permisos para ver, modificar o aplicar el asiento contable --->
<!--- 
	El campo UCCpermiso funciona de la siguiente manera tomando los bits de derecha a izquierda
	bit 1: Visualizacin / Impresin
	bit 2: Modificacin
	bit 3: Aplicacin
--->
<cfset PermisoVisualizar = true>
<cfset PermisoModificar = true>
<cfset PermisoAplicar = true>
<cfif modo EQ "CAMBIO">
	<cfquery name="chkPermiso" datasource="#Session.DSN#">
		select 1
		from EContables a
		where a.Ecodigo = #Session.Ecodigo#
		and a.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcontable#">
		and ( not exists ( 
				select 1 from UsuarioConceptoContableE b 
				where a.Cconcepto = b.Cconcepto
				and a.Ecodigo = b.Ecodigo
			) or exists (
				select 1
				from ConceptoContableE b, UsuarioConceptoContableE c
				where a.Cconcepto = b.Cconcepto
				and a.Ecodigo = b.Ecodigo
				and b.Cconcepto = c.Cconcepto
				and b.Ecodigo = c.Ecodigo
				and c.Usucodigo = #Session.Usucodigo#
				and c.UCCpermiso in (1,3,5,7)
			)
		)
	</cfquery>
	<cfif chkPermiso.recordCount EQ 0>
		<cfset PermisoVisualizar = false>
	</cfif>

	<cfquery name="chkPermiso" datasource="#Session.DSN#">
		select 1
		from EContables a
		where a.Ecodigo = #Session.Ecodigo#
		and a.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcontable#">
		and ( not exists ( 
				select 1 from UsuarioConceptoContableE b 
				where a.Cconcepto = b.Cconcepto
				and a.Ecodigo = b.Ecodigo
			) or exists (
				select 1
				from ConceptoContableE b, UsuarioConceptoContableE c
				where a.Cconcepto = b.Cconcepto
				and a.Ecodigo = b.Ecodigo
				and b.Cconcepto = c.Cconcepto
				and b.Ecodigo = c.Ecodigo
				and c.Usucodigo = #Session.Usucodigo#
				and c.UCCpermiso in (2,3,6,7)
			)
		)
	</cfquery>
	<cfif chkPermiso.recordCount EQ 0>
		<cfset PermisoModificar = false>
	</cfif>

	<cfquery name="chkPermiso" datasource="#Session.DSN#">
		select 1
		from EContables a
		where a.Ecodigo = #Session.Ecodigo#
		and a.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcontable#">
		and ( not exists ( 
				select 1 from UsuarioConceptoContableE b 
				where a.Cconcepto = b.Cconcepto
				and a.Ecodigo = b.Ecodigo
			) or exists (
				select 1
				from ConceptoContableE b, UsuarioConceptoContableE c
				where a.Cconcepto = b.Cconcepto
				and a.Ecodigo = b.Ecodigo
				and b.Cconcepto = c.Cconcepto
				and b.Ecodigo = c.Ecodigo
				and c.Usucodigo = #Session.Usucodigo#
				and c.UCCpermiso in (4,5,6,7)
			)
		)
	</cfquery>
	<cfif chkPermiso.recordCount EQ 0>
		<cfset PermisoAplicar = false>
	</cfif>
</cfif>

<script type="text/javascript" src="/cfmx/sif/js/Macromedia/wddx.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>

<script language="JavaScript" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//funciones
	function GetmesFiscal(mes){
		if (mes == 1) return 4;
		if (mes == 2) return 5;
		if (mes == 3) return 6;
		if (mes == 4) return 7;
		if (mes == 5) return 8;
		if (mes == 6) return 9;
		if (mes == 7) return 10;
		if (mes == 8) return 11;
		if (mes == 9) return 12;
		if (mes == 10) return 1;
		if (mes == 11) return 2;
		if (mes == 12) return 3;
	}

	function AgregarCombo(combo,codigo) {
		var cont = 0;
		var periodo = <cfoutput>#periodoActual#</cfoutput>;

		<cfif isdefined("url.paramretro") and  url.paramretro eq 2 >
			var mes = 13;
			if ( parseInt(document.form1.Eperiodo.value) == parseInt(periodo) ){
				mes = codigo;
			}
	
			combo.length=0;
			<cfoutput query="rsMeses">
				if ( parseInt(#Trim(rsMeses.mes)#) < parseInt(mes) ) {
					combo.length=cont+1;
					combo.options[cont].value='#rsMeses.mes#';
					combo.options[cont].text='#rsMeses.descripcion#';
				<cfif modo NEQ "ALTA" and #rsMeses.mes# EQ #rsDocumento.Emes#>
					combo.options[cont].selected=true;
				</cfif>
					cont++;
				};
			</cfoutput>
		<cfelse>
			var mes = 1;
			if ( parseInt(document.form1.Eperiodo.value) == parseInt(periodo) ){
				mes = codigo;
			}
	
			combo.length=0;
			<cfoutput query="rsMeses">
				if ( parseInt(#Trim(rsMeses.mes)#) >= parseInt(mes) ) {
					combo.length=cont+1;
					combo.options[cont].value='#rsMeses.mes#';
					combo.options[cont].text='#rsMeses.descripcion#';
				<cfif modo NEQ "ALTA" and #rsMeses.mes# EQ #rsDocumento.Emes#>
					combo.options[cont].selected=true;
				</cfif>
					cont++;
				};
			</cfoutput>
		</cfif>
	}	
	
	function AsignarHiddensEncab() {		
		document.form1._Cconcepto.value = document.form1.Cconcepto.value;		
		document.form1._Eperiodo.value = document.form1.Eperiodo.value;
		document.form1._Emes.value = document.form1.Emes.value;
		document.form1.Edocumento.disabled = false;		
		document.form1._Edocumento.value = document.form1.Edocumento.value;
		document.form1.Edocumento.disabled = true;		
		document.form1._Edescripcion.value = document.form1.Edescripcion.value;
		document.form1._Efecha.value = document.form1.Efecha.value;
		document.form1._Ereferencia.value = document.form1.Ereferencia.value;
		document.form1._Edocbase.value = document.form1.Edocbase.value;
		
			<cfif modo EQ "ALTA" or (modo EQ "CAMBIO" and rsDocumento.ECauxiliar EQ 'N')>
				<cfif isdefined("form.ECreversible")>
				document.form1._ECreversible.value = '1';
				<cfelse>
				document.form1._ECreversible.value = '0';
				</cfif>
			</cfif>
 	
			<cfif modo EQ "ALTA" or (modo EQ "CAMBIO" and rsDocumento.ECauxiliar EQ 'N')>
				<cfif isdefined("form.ECrecursivo")>
				document.form1._ECrecursivo.value = '1';
				<cfelse>
				document.form1._ECrecursivo.value = '0';
				</cfif>
			</cfif>
	}

	function AsignarHiddensDet() {
		document.form1._Ccuenta.value = document.form1.Ccuenta.value;
		document.form1._CFcuenta.value = document.form1.CFcuenta.value;
		document.form1._Dmovimiento.value = document.form1.Dmovimiento.value;
		document.form1._Ocodigo.value = document.form1.Ocodigo.value;
		document.form1._Ddescripcion.value = document.form1.Ddescripcion.value;
		document.form1._Mcodigo.value = document.form1.Mcodigo.value;
		document.form1.Dtipocambio.disabled = false;
		document.form1._Dtipocambio.value = document.form1.Dtipocambio.value;
		document.form1._Doriginal.value = document.form1.Doriginal.value;
		document.form1._Dlocal.value = document.form1.Dlocal.value;		
	}	

	function Lista() {
		<cfoutput>
			location.href="CGV3conta.cfm?Nivel=3&IDcontable=#form.IDcontable#";
		</cfoutput>
	}

	<!---
		Esta funcion se invoca para deshabilitar los campos modificables cuando el asiento proviene de un auxiliar
		o cuando el usuario no tiene permiso de modificacin de ese tipo de asiento
	--->
	function Deshabilitar() {
		<cfif modo EQ "CAMBIO" and ((isdefined("rsDocumento.ECauxiliar") and rsDocumento.ECauxiliar EQ "S" and not isdefined("LvarCC")) or not PermisoModificar)>
			// campos visibles del encabezado
			document.form1.Cconcepto.disabled = true;		
			//document.form1.Eperiodo.disabled = true;
			//document.form1.Emes.disabled = true;
			document.form1.Edocumento.disabled = true;
			document.form1.Edocumento.disabled = true;		
			document.form1.Edescripcion.disabled = true;
			document.form1.Efecha.disabled = true;
			document.form1.CalendarEfecha.disabled = true;
			document.form1.Ereferencia.disabled = true;
			document.form1.Edocbase.disabled = true;
			// campos visibles del detalle
			document.form1.Cdescripcion.disabled = true;
			document.form1.imagen.disabled = true;			
			document.form1.Dmovimiento.disabled = true;
			document.form1.Ocodigo.disabled = true;
			document.form1.Ddescripcion.disabled = true;
			document.form1.Mcodigo.disabled = true;
			document.form1.Dtipocambio.disabled = true;
			document.form1.Doriginal.disabled = true;
			document.form1.Dlocal.disabled = true;
			document.form1.Cformato.disabled = true;
			document.form1.Cmayor.disabled = true;
			document.form1.Ddocumento.disabled = true;
		</cfif>
	}
	
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	function funcArchivo(pOpcion){
		var param = document.form1.IDcontable.value;
		
		if (pOpcion == 1){//La opcion 1 es para MODIFICAR documentos
			document.form1.action = 'ObjetosDocumentos<cfoutput>#sufix#</cfoutput>.cfm'/*?IDcontable='+param;*/
			document.form1.submit();
		}
		else{ //La opcion 2 es para VER documentos
			popUpWindow('../consultas/ObjetosDocumentosCons.cfm?IDcontable='+param,200,100,700,500);
			//document.form1.action = '../consultas/ObjetosDocumentosCons.cfm'
			//document.form1.submit();
		}
	}
	//-->
</script>

<style type="text/css" >
	.tituloBalance{ 
		color:#006699; 
		background-color:#F4F4F4;
		font-weight:bold;
	}
	.detalleBalance{
		color:#FFFFFF; 
		background-color:#006699;
	}
	.auxiliar{ 
		font-size:smaller;
		color:#FF0033;
		font-weight:bold;
	}

</style>
<cfflush interval="32">
<form action="CGV3conta_sql.cfm" method="post" name="form1" onSubmit="javascript: _finalizar();">
	<input type="hidden" name="Nivel" value="5">
	<input type="hidden" name="LvarDlinea" value="<cfif isdefined("form.LvarDlinea")><cfoutput>#form.LvarDlinea#</cfoutput></cfif>" tabindex="-1">
	<cfoutput>
		<input name="PageNum_lista" type="hidden" value="<cfif isdefined("form.PageNum_lista") and len(trim(form.PageNum_lista))>#form.PageNum_lista#</cfif>" tabindex="-1">
		<input name="lote" type="hidden" value="<cfif isdefined("form.lote") and len(trim(form.lote))>#form.lote#</cfif>" tabindex="-1">
		<input name="poliza" type="hidden" value="<cfif isdefined("form.poliza") and len(trim(form.poliza))>#form.poliza#</cfif>" tabindex="-1">
		<input name="descripcion" type="hidden" value="<cfif isdefined("form.descripcion") and len(trim(form.descripcion))>#form.descripcion#</cfif>" tabindex="-1">
		<input name="periodo" type="hidden" value="<cfif isdefined("form.periodo")and len(trim(form.periodo))>#form.periodo#</cfif>" tabindex="-1">
		<input name="mes" type="hidden" value="<cfif isdefined("form.mes") and len(trim(form.mes))>#form.mes#</cfif>" tabindex="-1">
		<input name="fecha" type="hidden" value="<cfif isdefined("form.fecha") and len(trim(form.fecha))>#form.fecha#</cfif>" tabindex="-1">
		<input name="ver" type="hidden" value="<cfif isdefined("form.ver") and len(trim(form.ver)) >#form.ver#</cfif>" tabindex="-1">
		<input name="ECusuario" type="hidden" value="<cfif isdefined("form.ECusuario") and len(trim(form.ECusuario))>#form.ECusuario#</cfif>" tabindex="-1">
		<input name="origen" type="hidden" value="<cfif isdefined("form.origen") and len(trim(form.origen)) >#form.origen#</cfif>" tabindex="-1">
		<input name="fechaGen" type="hidden" value="<cfif isdefined("form.fechaGen") and len(trim(form.fechaGen))>#form.fechaGen#</cfif>" tabindex="-1">
		<input name="chk" type="hidden" value="" />
	</cfoutput>
	<table width="100%" border="0">
		<tr> 
			<td width="100%">
				<table width="100%" border="0">
					<!--- Lista de Balance por Monedas --->
					<tr> 
						<cfif inter eq "N">
							<td width="1%" rowspan="5" valign="top">
								<cfif LbanderaMonedas>
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr > 
											<td colspan="5" class="tituloBalance" align="center" nowrap>
											
												<cfoutput>#PolizaBalOri#</cfoutput>
												
											</td>
										</tr>
										<tr> 
											<td class="detalleBalance" nowrap><cf_translate key="monto">Mon</cf_translate>.&nbsp;</td>
											<td class="detalleBalance" nowrap><cf_translate key="oficina">Oficina</cf_translate>&nbsp;</td>
											<td class="detalleBalance" nowrap><cf_translate key="debito">D&eacute;bitos</cf_translate></td>
											<td class="detalleBalance" nowrap>&nbsp;</td>
											<td class="detalleBalance" nowrap><cf_translate key="credito">Cr&eacute;ditos</cf_translate></td>
										</tr>
										<cfif isdefined("rsBalanceO")>
											<cfoutput query="rsBalanceO"> 
												<tr> 
													<td><font color="##0033CC">#rsBalanceO.Msimbolo#</font></td>
													<td>#rsBalanceO.Odescripcion#</td>
													<td align="right">#lscurrencyformat(rsBalanceO.Debitos,'none')#</td>
													<td>&nbsp;</td>
													<td align="right">#LSCurrencyFormat(rsBalanceO.Creditos,'none')#</td>
												</tr>
											</cfoutput> 
										</cfif>
									</table>
									<br>
								</cfif>
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr> 
										<td colspan="5" class="tituloBalance" nowrap align="center" >
										<cfoutput>#PolizaBalLoc#</cfoutput>
										</td>
									</tr>
									<tr> 
										<td class="detalleBalance" nowrap><cf_translate key="monto">Mon</cf_translate>.&nbsp;</td>
										<td class="detalleBalance" nowrap><cf_translate key="oficina">Oficina</cf_translate>&nbsp;</td>
										<td class="detalleBalance" nowrap><cf_translate key="debito">D&eacute;bitos</cf_translate></td>
										<td class="detalleBalance" nowrap>&nbsp;</td>
										<td class="detalleBalance" nowrap><cf_translate key="credito">Cr&eacute;ditos</cf_translate></td>
									</tr>
									<cfif isdefined("rsBalanceO")>
										<cfoutput query="rsBalanceO"> 
											<tr> 
												<td><font color="##0033CC">#rsBalanceO.Msimbolo#</font></td>
												<td>#rsBalanceO.Odescripcion#</td>
												<td align="right">#lscurrencyformat(rsBalanceO.DebitosL,'none')#</td>
												<td>&nbsp;</td>
												<td align="right">#LSCurrencyFormat(rsBalanceO.CreditosL,'none')#</td>
											</tr>
										</cfoutput> 
									</cfif>
								</table>
							</td>
						</cfif>
						<td colspan="8" class="tituloAlterno" align="center"><cf_translate key="titulodoc">Documento Contable</cf_translate></td>
					</tr>
					<!--- Mantenimiento del Encabezado --->
					<tr> 
						<td nowrap align="right"><cf_translate key="concepto">Concepto</cf_translate>:&nbsp;</td>
						<td>
							<select  name="Cconcepto" <cfif modo NEQ "ALTA">disabled</cfif>  tabindex="1">
								<cfoutput query="rsConceptos"> 
									<option  value="#rsConceptos.Cconcepto#" <cfif modo NEQ "ALTA" and rsConceptos.Cconcepto EQ rsDocumento.Cconcepto>selected</cfif>>#rsConceptos.Cdescripcion#</option>
								</cfoutput>
							</select>
						</td>
						<td nowrap align="right"><cf_translate key="periodo">Per&iacute;odo</cf_translate>:&nbsp;</td>
						<td>
							<cfif modo EQ "ALTA">
								<select name="Eperiodo"  tabindex="1"
									onChange="javascript:if (document.form1.Eperiodo.value == '<cfoutput>#periodoActual#</cfoutput>') AgregarCombo(document.form1.Emes,'<cfoutput>#mesActual#</cfoutput>'); else AgregarCombo(document.form1.Emes,'9');"<cfif modo EQ "CAMBIO" and ((isdefined("rsDocumento.ECauxiliar") and rsDocumento.ECauxiliar EQ "S") or not PermisoModificar)> disabled</cfif>  >
									<cfoutput query="rsPeriodo"> 
										<option value="#rsPeriodo.Pvalor#" <cfif modo NEQ "ALTA" and rsPeriodo.Pvalor EQ rsDocumento.Eperiodo>selected</cfif>>#rsPeriodo.Pvalor#</option>
									</cfoutput>
								</select>
							<cfelse>
								<cfoutput>
									#rsDocumento.Eperiodo#
									<input type="hidden" name="Eperiodo" value="#rsDocumento.Eperiodo#" tabindex="-1">
								</cfoutput>
							</cfif>
							
						</td>
						<td nowrap align="right"><cf_translate key="mes">Mes</cf_translate>:&nbsp;</td>
						<td>
							<!---<select name="Emes" <cfif modo NEQ "ALTA">disabled</cfif>>--->
							<cfif modo EQ "ALTA">
								<cfif LvarCHKMesCierre>
									<select tabindex="1" name="Emes">
										<cfloop query="rsMesesA">
											<option value="<cfoutput>#VSvalor#</cfoutput>"<cfif isdefined("form.mes") and form.mes eq VSvalor>selected</cfif>><cfoutput>#VSdesc#</cfoutput></option>
										</cfloop>	
									</select>
								<cfelse>

									<select tabindex="1" name="Emes" 
									<cfif modo EQ "CAMBIO" and ((isdefined("rsDocumento.ECauxiliar") and rsDocumento.ECauxiliar EQ "S") or not PermisoModificar)> disabled</cfif> ></select>
										<script language="JavaScript">
											if (document.form1.Eperiodo.value == '<cfoutput>#periodoActual#</cfoutput>') 
												AgregarCombo(document.form1.Emes,'<cfoutput>#mesActual#</cfoutput>'); 
											else 
												AgregarCombo(document.form1.Emes,'1');
										</script>
								</cfif>
							<cfelse>
								<cfoutput>
									<cfif ListLen(meses, ',') NEQ 0>
										#Trim(ListGetAt(meses,rsDocumento.Emes, ','))#
									</cfif>
									<input type="hidden" name="Emes" value="#rsDocumento.Emes#" tabindex="-1">
								</cfoutput>
							</cfif><!--- --->
						</td>
						
						<cfif isdefined("paramretro")>
							<td align="right">
								<cfif modo EQ "ALTA" or (modo EQ "CAMBIO" and rsDocumento.ECauxiliar EQ 'N')>
									<input name="paramretro" type="checkbox" id="paramretro" disabled value="2" checked>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td>
								<cfif modo EQ "ALTA" or (modo EQ "CAMBIO" and rsDocumento.ECauxiliar EQ 'N')>
									Retroactivo
								<cfelse>
									&nbsp;
								</cfif>
							</td>
						</cfif>	
						<td align="right">
							<cfif sufix eq 'CierreAnual'>
								&nbsp;
							<cfelse>
								&nbsp;
							</cfif>
						</td>
						<td>
							<cfif sufix eq 'CierreAnual'>
								&nbsp;
							<cfelse>
								&nbsp;
							</cfif>
						</td>
					</tr>
					<tr> 
						<td nowrap align="right">
							<cfoutput>#PolizaE#</cfoutput>:&nbsp;
						</td>
						<td>
							<input name="Edocumento" type="text"  tabindex="1" value="<cfif modo NEQ "ALTA"><cfoutput>#rsDocumento.Edocumento#</cfoutput></cfif>" size="15" maxlength="15" disabled>
						</td>
						<td nowrap align="right"><cf_translate key="descripcion">Descripci&oacute;n</cf_translate>:&nbsp;</td>
						<td colspan="5">
							<input name="Edescripcion" type="text"  tabindex="1" value="<cfif modo NEQ "ALTA"><cfoutput>#rsDocumento.Edescripcion#</cfoutput></cfif>" size="43" maxlength="100" onFocus="javascript:this.select();"> 
							<script language="JavaScript">document.form1.Edescripcion.focus();</script> 
						</td>
					</tr>
					<tr> 
						<td nowrap align="right"><cf_translate key="fecha">Fecha</cf_translate>:&nbsp;</td>
						<td>
							<cfif modo NEQ 'ALTA'> 
								<cf_sifcalendario name="Efecha" value="#LSDateFormat(rsDocumento.Efecha,'dd/mm/yyyy')#"  tabindex="1">
							<cfelse>
								<cf_sifcalendario name="Efecha" value="#LSDateFormat(Now(),'dd/mm/yyyy')#"  tabindex="1">			  			  
							</cfif>
						</td>
						<td nowrap align="right"><cf_translate key="referencia">Referencia</cf_translate>:&nbsp;</td>
						<td colspan="3">
							<input name="Ereferencia" type="text"  tabindex="1" value="<cfif modo NEQ "ALTA"><cfoutput>#rsDocumento.Ereferencia#</cfoutput></cfif>" size="25" maxlength="25" onFocus="javascript:this.select();">
						</td>
						
					</tr>
					<tr>
						<td nowrap align="right"><cf_translate key="documento">Documento</cf_translate>:&nbsp;</td>
						<td colspan="2">
							<input name="Edocbase" type="text" tabindex="1" value="<cfif modo NEQ "ALTA"><cfoutput>#rsDocumento.Edocbase#</cfoutput></cfif>" size="20" maxlength="20" onFocus="javascript:this.select();">
						</td>
                        <td nowrap="nowrap">
                        	<input name="ECrecursivo" type="checkbox" value="1" id="ECrecursivo" tabindex="1" disabled>&nbsp;<label for="ECrecursivo">Recurrente</label>
                        </td>
					</tr>
					<tr> 
						<td colspan="8">
							<input type="hidden" name="_Cconcepto"> <input type="hidden" name="_Eperiodo" tabindex="-1"> 
							<input type="hidden" name="_Emes"> <input type="hidden" name="_Edocumento" tabindex="-1"> 
							<input type="hidden" name="_Edescripcion"> <input type="hidden" name="_Efecha" tabindex="-1"> 
							<input type="hidden" name="_Ereferencia"> <input type="hidden" name="_Edocbase" tabindex="-1">
							<cfif modo EQ "ALTA" or (modo EQ "CAMBIO" and rsDocumento.ECauxiliar EQ 'N')>
								<input type="hidden" name="_ECreversible" tabindex="-1">  
							</cfif>
                            
                            <cfif modo EQ "ALTA" or (modo EQ "CAMBIO" and rsDocumento.ECauxiliar EQ 'N')>
								<input type="hidden" name="_ECrecursivo" tabindex="-1">  
							</cfif>
							<cfset tsE = "">
							<cfif modo NEQ "ALTA">
								<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsDocumento.ts_rversion#" returnvariable="tsE"/>
							</cfif>
							<input type="hidden" name="IDcontable" value="<cfif modo NEQ "ALTA"><cfoutput>#rsDocumento.IDcontable#</cfoutput></cfif>" tabindex="-1"> 
							<input type="hidden" name="ECauxiliar" value="<cfif modo NEQ "ALTA"><cfoutput>#rsDocumento.ECauxiliar#</cfoutput><cfelse>N</cfif>" tabindex="-1"> 
							<input type="hidden" name="ECselect" value="0"> <input type="hidden" name="timestampE" value="<cfif modo NEQ "ALTA"><cfoutput>#tsE#</cfoutput></cfif>" tabindex="-1"> 
						</td>
					</tr>
				</table>
				<script language="JavaScript">AsignarHiddensEncab();</script>
			</td>
		</tr>
		<cfif isdefined("rsDocumento.ECauxiliar") and rsDocumento.ECauxiliar EQ "S" and modo NEQ "ALTA" and not isdefined("LvarCC")>
		<tr>
			<td colspan="7" align="center" class="auxiliar">
				<cf_translate key="documento_auxiliar">Documento Generado desde un Sistema Auxiliar. No se puede modificar.</cf_translate>
			</td>
		</tr>
		<tr>
			<td>&nbsp;
				
			</td>
		</tr>
		</cfif>
		<!--- Detalle del Documento--->
		<cfif not isDefined("Form.NuevoE") and modo NEQ "ALTA">
			<tr> 
				<td>
					<table width="100%" border="0"
						<cfif modo EQ "CAMBIO" and ((isdefined("rsDocumento.ECauxiliar") and rsDocumento.ECauxiliar EQ "S") or not PermisoModificar)>
						style="display:none"
						</cfif>
					>
						<tr>
							<td style="border-top:1px solid #666666; font-size:12px; color:#666666;" colspan="9" align="center"><strong>L&iacute;nea de Detalle</strong></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td nowrap align="right"><cf_translate key="oficina">Oficina</cf_translate>:&nbsp;</td>
							<td colspan="2"> 
								<select name="Ocodigo" tabindex="2">
									<cfoutput query="rsOficinas"> 
										<option value="#rsOficinas.Ocodigo#" <cfif modoDet NEQ "ALTA" and rsOficinas.Ocodigo EQ rsLinea.Ocodigo>selected</cfif>>#rsOficinas.Odescripcion#</option>
									</cfoutput>
								</select>
							</td>
							<td>&nbsp;&nbsp;</td>
							<td nowrap align="right"><cf_translate key="movimiento">Movimiento</cf_translate>:&nbsp;</td>
							<td colspan="3">
								<select name="Dmovimiento" tabindex="2">
									<cfoutput query="rsDebCred"> 
										<option value="#rsDebCred.tipo#" <cfif modoDet NEQ "ALTA" and "#rsDebCred.tipo#" EQ "#rsLinea.Dmovimiento#">selected</cfif>>#rsDebCred.descripcion#</option>
									</cfoutput>
								</select>
							</td>
						</tr>
                        <tr>
                        	<td>&nbsp;</td>
                            <td align="right" nowrap="nowrap">
								<cf_translate key="CFuncional">C. Funcional</cf_translate>:&nbsp;
                            </td>
                            <td colspan="7">
								<cfif modoDet neq 'ALTA' and isdefined('rsLinea') and len(trim(rsLinea.CFid))>
                                    <cfquery name="rsCFuncional" datasource="#session.DSN#">
                                        select CFid, CFcodigo, CFdescripcion
                                        from CFuncional
                                        where Ecodigo = #session.Ecodigo#
                                          and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLinea.CFid#">
                                    </cfquery>
                                    <cf_rhcfuncional size="22" query="#rsCFuncional#" tabindex="2">
                                <cfelse>
                                    <cf_rhcfuncional size="22"   tabindex="2">
                                </cfif>
                            </td>
                        </tr>
						<tr > 
							<td width="1%">&nbsp;</td>
							<td nowrap align="right"><cf_translate key="cuenta_contable">Cuenta Financiera</cf_translate>:</td>
							<td colspan="7">
								<cfif inter eq "S">
									<cfif modoDet NEQ "ALTA">
										<cf_cuentas Ocodigo="Ocodigo" Intercompany='yes'  conexion="#Session.DSN#" conlis="S" query="#rsLinea#" auxiliares="C" movimiento="S" frame="frame1" descwidth="23" onchange="document.getElementById('trCcuenta').style.display='none';" onchangeIntercompany="CambiarOficina(this);" tabindex="2" fecha="#LSDateFormat(rsDocumento.Efecha,'dd/mm/yyyy')#">
									<cfelse>
										<cf_cuentas Ocodigo="Ocodigo" Intercompany='yes'  conexion="#Session.DSN#" conlis="S" auxiliares="C" movimiento="S" frame="frame1" descwidth="23" onchange=""  onchangeIntercompany="CambiarOficina(this);" tabindex="2" fecha="#LSDateFormat(rsDocumento.Efecha,'dd/mm/yyyy')#">
									</cfif>
								<cfelse>
									<cfif modoDet NEQ "ALTA">
										<cf_cuentas Ocodigo="Ocodigo" conexion="#Session.DSN#" conlis="S" query="#rsLinea#" auxiliares="C" movimiento="S" frame="frame1" descwidth="60" onchange="document.getElementById('trCcuenta').style.display='none';" tabindex="2" fecha="#LSDateFormat(rsDocumento.Efecha,'dd/mm/yyyy')#">
									<cfelse>
										<cf_cuentas Ocodigo="Ocodigo" conexion="#Session.DSN#" conlis="S" auxiliares="C" movimiento="S" frame="frame1" descwidth="60" onchange="" tabindex="2" fecha="#LSDateFormat(rsDocumento.Efecha,'dd/mm/yyyy')#">
									</cfif>
								</cfif>	
							</td>
						</tr>
						<tr id="trCcuenta">
						<cfif modoDet NEQ "ALTA" AND rsLinea.Cformato NEQ rsLinea.CFformato>
							<td width="1%">&nbsp;</td>
							<td nowrap align="right"><cf_translate key="cuenta_contable">Cuenta Contable</cf_translate>:</td>
							<td colspan="7">
							<cfoutput>
								<table border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td nowrap>
											<input maxlength="4" size="4"  type="text" 
												tabindex="-1"
												disabled
												style="border:solid 1px ##CCCCCC; background:inherit;"
												value="#mid(rsLinea.Cformato,1,4)#">
										</td>
										<td nowrap> 
											<input maxlength="27" size="32" type="text"
												tabindex="-1"
												disabled
												style="border:solid 1px ##CCCCCC; background:inherit;"
											value="#mid(rsLinea.Cformato,6,100)#">
										</td>
										<td nowrap>
											<input type="text" maxlength="80" size="60"
												tabindex="-1"
												disabled
												style="border:solid 1px ##CCCCCC; background:inherit;"
											value="#rsLinea.Cdescripcion#">
										</td>
									</tr>
								</table>
							</cfoutput>
							</td>
						<cfelse>
							<td></td>
						</cfif>
						</tr>
						<tr> 
							<td>&nbsp;</td>
							<td nowrap align="right"><cf_translate key="descripcion">Descripci&oacute;n</cf_translate>:</td>
							<td colspan="7">
								<input name="Ddescripcion" type="text"  value="<cfif modoDet NEQ "ALTA"><cfoutput>#rsLinea.Ddescripcion#</cfoutput><cfelse><cfoutput>#rsDocumento.Edescripcion#</cfoutput></cfif>" size="90" maxlength="100" onFocus="javascript:this.select();" tabindex="2"> 
							<cfif modo EQ "CAMBIO" and Not ((isdefined("rsDocumento.ECauxiliar") and rsDocumento.ECauxiliar EQ "S") or not PermisoModificar)>
								<script language="JavaScript">document.form1.Ocodigo.focus();</script> 
							</cfif>
							</td>
						</tr>
						<tr> 
							<td>&nbsp;</td>
							<td nowrap align="right"><cf_translate key='documento'> Documento</cf_translate>:&nbsp;</td>
							<td nowrap colspan="2"> 
								<input type="text" name="Ddocumento" size="25" maxlength="20"  tabindex="2" value="<cfoutput><cfif modoDet NEQ "ALTA">#rsLinea.Ddocumento#<cfelse>#rsDocumento.Edocbase#</cfif></cfoutput>" onFocus="this.select();">
							</td>	
							<td>&nbsp;&nbsp;</td>
							<td nowrap align="right"><cf_translate key='referencia'> Referencia</cf_translate>:&nbsp;</td>
							<td nowrap colspan="3"> 
								<input name="Dreferencia"   align="right" type="text" id="Dreferencia" value="<cfoutput><cfif modoDet NEQ "ALTA">#rsLinea.Dreferencia#<cfelse>#rsDocumento.Ereferencia#</cfif></cfoutput>" size="25" maxlength="25" onFocus="javascript:this.select();" tabindex="2">
							</td>
						</tr>
						<tr> 
							<td>&nbsp;</td>
							<td nowrap align="right">Monto Origen:&nbsp;</td>
							<td>
								<cfif modoDet NEQ "ALTA">
									<cf_sifmonedas query="#rsLinea#" valuetc="#rsLinea.Dtipocambio#" onchange="sugerirTC();get_montoLocal();"  tabindex="2">
								<cfelse>
									<cf_sifmonedas onchange="sugerirTC();get_montoLocal();"  tabindex="2">
								</cfif>
							</td>	
							<td>
								<input name="Doriginal" type="text"  tabindex="2"
								onChange="javascript:get_montoLocal();" 
								onBlur="javascript: if(validaNumero(this,2)){get_montoLocal();formatCurrency(this,2);}"
								onFocus="javascript:this.select();"
								onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}};"					
								value="<cfif modoDet NEQ "ALTA"><cfoutput>#lscurrencyformat(rsLinea.Doriginal,'none')#</cfoutput><cfelse>0.00</cfif>" size="20" maxlength="20"> 
							</td>
							<td>&nbsp;&nbsp;</td>
							<td nowrap align="right">Tipo Cambio:&nbsp;</td>
							<td nowrap>
								<input name="Dtipocambio" type="text"  tabindex="2"
								onChange="javascript:get_montoLocal();" 
								onBlur='javascript:this.disabled=false; validaNumero(this,4);'
								onKeyUp="javascript:if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"					
								value="<cfif modoDet NEQ "ALTA"><cfoutput>#rsLinea.Dtipocambio#</cfoutput><cfelse>0.00</cfif>" size="20" maxlength="20"> 
							</td>
							<td nowrap align="right">Monto Local:&nbsp;</td>
							<td>
								<input name="Dlocal" type="text"  tabindex="2" value="<cfif modoDet NEQ "ALTA"><cfoutput>#lscurrencyformat(rsLinea.Dlocal,'none')#</cfoutput></cfif>" size="20" maxlength="20" disabled >
							</td>
						</tr>
						<tr> 
							<td>
								&nbsp;
								<input type="hidden" name="_Ccuenta" tabindex="-1"> <input type="hidden" name="_CFcuenta" tabindex="-1">
								<input type="hidden" name="_Dmovimiento" tabindex="-1"> 
								<input type="hidden" name="_Ocodigo" tabindex="-1"> <input type="hidden" name="_Ddescripcion" tabindex="-1"> 
								<input type="hidden" name="_Mcodigo" tabindex="-1"> <input type="hidden" name="_Dtipocambio" tabindex="-1"> 
								<input type="hidden" name="_Doriginal" tabindex="-1"> <input type="hidden" name="_Dlocal" tabindex="-1"> 
								<cfset tsD = "">
								<cfif modoDet NEQ "ALTA">
									<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsLinea.ts_rversion#" returnvariable="tsD"/>
								</cfif>
								<input type="hidden" name="Dlinea" value="<cfif modoDet NEQ "ALTA"><cfoutput>#rsLinea.Dlinea#</cfoutput></cfif>" tabindex="-1"> 
								<!--- <input type="hidden" name="Dreferencia" value="<cfif modoDet NEQ "ALTA"><cfoutput>#rsLinea.Dreferencia#</cfoutput></cfif>">  --->
								<input type="hidden" name="timestampD" value="<cfif modoDet NEQ "ALTA"><cfoutput>#tsD#</cfoutput></cfif>" tabindex="-1"> 
								<input type="hidden" name="bandBalancear" value="N" tabindex="-1">
								<input type="hidden" name="borrarLista" value="N" tabindex="-1">
								<input type="hidden" name="CcuentaBalancear" value="<cfif isdefined('rsParamCuentaBalance') and rsParamCuentaBalance.recordCount GT 0><cfoutput>#rsParamCuentaBalance.Ccuenta#</cfoutput></cfif>" tabindex="-1">
								<input type="hidden" name="CFcuentaBalancear" value="<cfif isdefined('rsParamCuentaBalance') and rsParamCuentaBalance.recordCount GT 0><cfoutput>#rsParamCuentaBalance.CFcuenta#</cfoutput></cfif>" tabindex="-1">
							</td>
						</tr>
						<script language="JavaScript">AsignarHiddensDet();</script>
					</table>
				</td>
			</tr>
		</cfif>
		<tr> 
			<td colspan="10" align="center">
				<cfif not isDefined("Form.NuevoE") and modo NEQ "ALTA">
					<cfif rsDocumento.ECauxiliar NEQ "S" and PermisoModificar>
						<cfif modoDet EQ "ALTA">
							<input name="AgregarD" type="submit" value="Agregar Lin." class="btnGuardar" onClick="javascript: return valida('AgregarD');"  tabindex="3">
						<cfelse>
							<cfif not isdefined("rsLinea.Ddescripcion") OR rsLinea.Ddescripcion NEQ 'Ajuste para balancear diferencias en tipos de cambio'>
							<input name="CambiarD" type="submit" value="Cambiar Lin." class="btnGuardar" onClick="javascript:return valida('CambiarD');" tabindex="3">
							</cfif>
							<!--- <input name="BorrarD" type="submit" value="Borrar Linea" onClick="javascript:if (confirm('Desea borrar esta lnea del documento?')) return true; else return false;"> --->
							<input name="NuevoD" type="submit" value="Nueva Lin." class="btnNuevo" tabindex="3">
						</cfif>
						&nbsp;
					</cfif>
				</cfif>
				<cfif modo EQ "ALTA"> 
					<input type="submit" name="AgregarE" value="Agregar Doc." class="btnGuardar" tabindex="3">
					<cfif sufix eq 'CierreAnual'>
						<input type="submit" name="btnAsientoLiquida" value="Asiento Liquidación" onClick="javascript: return valida('btnAsientoLiquida');" tabindex="3">
						<input type="submit" name="btnAsientoLimpia"  value="Asiento Limpieza"    onClick="javascript: return valida('btnAsientoLimpia');" tabindex="3">
					</cfif>					
				<cfelse>
					<cfif rsTieneLineas.Cantidad GT 0>
						<!--- Validar si se puede aplicar --->
						<cfif PermisoAplicar>
							<input type="submit" name="btnContabilizar" value="Contabilizar" class="btnAplicar" onClick="javascript:return Postear();" tabindex="3">
						</cfif>
						<cfoutput>
						<input type="hidden" name="regresar" 	 value="#URLEncodedFormat('DocumentosContables#sufix#.cfm?Id=#IDContable#&inter=#inter#&sufix=#sufix#&IDcontable=#IDcontable#')#"  />
						<input type="hidden" name="id" 			 value="#IDContable#"/>
						</cfoutput> 
					</cfif>
					<cfif sufix NEQ 'CC'>
                        <cfif poneBtnBalancear and (isdefined("modoDet") and modoDet EQ "ALTA")>
                            <input type="button" name="btnBalancear"class="btnNormal" value="Balancear Doc." onClick="javascript:validaParametro();" tabindex="3">																		
                        </cfif>
					</cfif>
							<input type="submit" name="CambiarE" 	class="btnGuardar"  tabindex="3" value="Cambiar Doc." onClick="javascript:return valida('CambiarE');">
				</cfif>
                <cfif sufix NEQ 'CC'>	
					<cfif isdefined("rsBalanceOfic") and isdefined("rsTotalLineas") and rsTotalLineas.Debitos NEQ rsTotalLineas.Creditos and rsBalanceOfic.Recordcount NEQ 0 and (isdefined("modoDet") and modoDet EQ "ALTA")>
                        <input type="submit" name="btnBalanceaOfic" class="btnNormal" value="Balancear" title="Balancea por Oficina" onClick="javascript: deshabilitarValidacion();" tabindex="3">
                    </cfif>
                </cfif>
				&nbsp;&nbsp;<input type="button" name="ListaE" class="btnAnterior" value="Ir a Asiento" onClick="javascript:Lista();" tabindex="3">					
			</td>			
		</tr>
	</table>

	<input type="hidden" name="inter" value="<cfoutput>#inter#</cfoutput>" tabindex="-1">
	<cfif inter neq "S">
			<input type="hidden" name="Ecodigo_Ccuenta" value="<cfoutput>#Session.Ecodigo#</cfoutput>" tabindex="-1"> 
	</cfif>
</form>
<script language="JavaScript" type="text/javascript">		
	<cfif not isDefined("Form.NuevoE") and modo NEQ "ALTA">
		if(document.form1.Ecodigo_Ccuenta){
			function CambiarOficina(){
				var oCombo   = document.form1.Ocodigo;
				var EcodigoI = document.form1.Ecodigo_Ccuenta.value;
				var cont = 0;
				oCombo.length=0;
				<cfoutput query="rsOficinas">
				if ('#Trim(rsOficinas.Ecodigo)#' == EcodigoI ){
					oCombo.length=cont+1;
					oCombo.options[cont].value='#Trim(rsOficinas.Ocodigo)#';
					oCombo.options[cont].text='#Trim(rsOficinas.Odescripcion)#';
					<cfif  isdefined("rsLinea") and rsLinea.Ocodigo eq rsOficinas.Ocodigo >
						oCombo.options[cont].selected = true;
					</cfif>
				cont++;
				};
				</cfoutput>
			}
			CambiarOficina();
		}	
	</cfif>
		function validaParametro() {
			if(confirm("Desea generar las lneas de asiento necesarias para balancear esta póliza?")){
				<cfif isdefined('rsParamCuentaBalance') and (rsParamCuentaBalance.Ccuenta EQ '' OR rsParamCuentaBalance.CFcuenta EQ '')>
					alert('No se ha parametrizado la cuenta de balance en los parmetros del sistema');	
					document.form1.bandBalancear.value='N';
				<cfelse>
					document.form1.bandBalancear.value='S';
				document.form1.Edocumento.disabled = false;
				document.form1.Cconcepto.disabled = false;					
					document.form1.submit();
				</cfif>
			}
		}
		
		/* aqui asigna el hidden creado por el tag de monedas al objeto que realmente se va a usar como el tipo de cambio */
		<cfif modo NEQ "ALTA">
			if (document.form1.Mcodigo.value == "<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>") {
				formatCurrency(document.form1.TC,2);
				document.form1.Dtipocambio.disabled = true;			
			}		
			document.form1.Dtipocambio.value = document.form1.TC.value;
		</cfif>
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		sugerirTClocal();
		get_montoLocal();
		Deshabilitar();
	
		function valida(boton) {
			if (boton == "btnAsientoLiquida") {
				objForm.Edescripcion.required=false;
				objForm.Edocbase.required = false;
				return;
			}

			if (boton == "btnAsientoLimpia") {
				objForm.Edescripcion.required=false;
				objForm.Edocbase.required = false;
				return;
			}
		
			if (boton == "CambiarE") {
				objForm.Ccuenta.required = false;
				objForm.CFcuenta.required = false;
				objForm.Ddescripcion.required= false;
				objForm.Ocodigo.required= false;
				return;
			}
			
			if (boton == "AgregarD") {
				var estado_Dtipocambio = document.form1.Dtipocambio.disabled;
				var estado_Doriginal = document.form1.Doriginal.disabled;
				var estado_Dlocal = document.form1.Dlocal.disabled;
				var estado_Cconcepto = document.form1.Cconcepto.disabled;
				<cfif modo EQ "ALTA">
				var estado_Eperiodo = document.form1.Eperiodo.disabled;
				var estado_Emes = document.form1.Emes.disabled;
				</cfif>
	
				document.form1.Dtipocambio.disabled = false;
				document.form1.Doriginal.disabled = false;
				document.form1.Dlocal.disabled = false;
				document.form1.Cconcepto.disabled = false;
				document.form1.Eperiodo.disabled = false;
				document.form1.Emes.disabled = false;
			}
			
			if (boton == "CambiarD") {
				var estado_Dtipocambio = document.form1.Dtipocambio.disabled;
				var estado_Doriginal = document.form1.Doriginal.disabled;
				var estado_Dlocal = document.form1.Dlocal.disabled;
	
				document.form1.Dtipocambio.disabled = false;
				document.form1.Doriginal.disabled = false;
				document.form1.Dlocal.disabled = false; 			
			}	
			
			var dioError = false;
	
			if (!dioError && objForm.Cdescripcion.isNotEmpty() == false) {
				mensaje = 'Debe seleccionar una cuenta';
				alert(mensaje);
				dioError = true;
			}
	
			if (!dioError && objForm.Ddescripcion.isNotEmpty() == false) {
				alert("Debe digitar una Descripcion");
				dioError = true;
			}
	
			if (!dioError && objForm.Ddocumento.isNotEmpty() == false) {
				alert("Debe digitar el documento (detalle)");
				dioError = true;
			}
	
			if (!dioError && !validaNumero(document.form1.Doriginal,2))  {
				document.form1.Doriginal.select();
				dioError = true;
			}
			
			if (!dioError && !validaNumero(document.form1.Dlocal,2)) {
				document.form1.Dlocal.select();
				dioError = true;
			}	
			if (!dioError && !validaNumero(document.form1.Dtipocambio,4)) {
				document.form1.Dtipocambio.select();
				dioError = true;
			}
			
			if (!dioError && new Number(document.form1.Doriginal.value) == 0 ) {
				alert("El monto debe ser mayor que cero");
				document.form1.Doriginal.select();
				dioError = true;
			}
			if (!dioError && new Number(document.form1.Dtipocambio.value) == 0 ) {
				alert("El monto debe ser mayor que cero");
				document.form1.Dtipocambio.select();
				dioError = true;
			}
			
			// Activa o desactiva los campos que se necesitaban para el post, segn el botn que se presion
			if (dioError) {
				if (boton == "AgregarD") {				
					document.form1.Dtipocambio.disabled = estado_Dtipocambio;
					document.form1.Doriginal.disabled = estado_Doriginal;
					document.form1.Dlocal.disabled = estado_Dlocal;
					document.form1.Cconcepto.disabled = estado_Cconcepto;
					//document.form1.Eperiodo.disabled = true;
					//document.form1.Emes.disabled = estado_Emes;
					document.form1.Eperiodo.disabled = false;
					document.form1.Emes.disabled = false;
				}
				if (boton == "CambiarD") {
					document.form1.Dtipocambio.disabled = estado_Dtipocambio;
					document.form1.Doriginal.disabled = estado_Doriginal;
					document.form1.Dlocal.disabled = estado_Dlocal;			
				}			
				return false;
			}		
			return true;
		}
	
	
		function get_montoLocal(){
			<cfif modo NEQ "ALTA">
			var estant = document.form1.Dtipocambio.disabled;
				document.form1.Dtipocambio.disabled = false;
				document.form1.Dlocal.disabled = false;
				var t = qf(document.form1.Dtipocambio.value);
				var m = qf(document.form1.Doriginal.value);
				var r = 0;
	
				if (new Number(t)!=0){			
					r = new Number(m) * new Number(t);
					document.form1.Dlocal.value =  redondear(r,2);
					formatCurrency(document.form1.Dlocal,2);
				}
				document.form1.Dlocal.disabled = true;		
				document.form1.Dtipocambio.disabled = estant;
			</cfif>
		}
		
		function sugerirTC() {		
			 <cfif modo NEQ "ALTA">
				document.form1.Dtipocambio.disabled = false;
				if (document.form1.Mcodigo.value == "<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>")  {
					document.form1.Dtipocambio.value = "1.00";
					document.form1.Dtipocambio.disabled = true;	
				}		
				else {
						<cfwddx action="cfml2js" input="#TCsug#" topLevelVariable="rsTCsug"> 
						//Verificar si existe en el recordset
						var nRows = rsTCsug.getRowCount();
						if (nRows > 0) {
							for (row = 0; row < nRows; ++row)
							{
								if (rsTCsug.getField(row, "Mcodigo") == document.form1.Mcodigo.value) {
									document.form1.Dtipocambio.value = rsTCsug.getField(row, "TCcompra");
									break;
								}
								else
									document.form1.Dtipocambio.value = "0.00";					
							}
						}
						else
							{
								document.form1.Dtipocambio.value = "0.00";
							}
					document.form1.Dtipocambio.disabled = false;	
				}
				<cfif rsDocumento.ECauxiliar EQ "S"> 
					Deshabilitar();		
				</cfif>
			</cfif>
		}
		
		function Postear(){
			if (confirm('Desea aplicar este documento?')) {
				document.form1.Ccuenta.value = '-1';
				document.form1.CFcuenta.value = '-1';
				document.form1.Ddescripcion.value = '.';
				document.form1.Cconcepto.disabled = false;
				document.form1.Eperiodo.disabled = false;
				document.form1.Emes.disabled = false;
				document.form1.Edocumento.disabled = false; 
				var correcto = true;
				<cfif isdefined("rsBalanceO")>
				<cfloop query="rsBalanceO">
					<cfif rsBalanceO.Creditos - rsBalanceO.Debitos NEQ 0 or rsBalanceO.CreditosL - rsBalanceO.DebitosL NEQ 0>
						<cfif inter EQ 'N'>
							alert('La poliza no esta balanceada para la Moneda <cfoutput>#rsBalanceO.Mnombre#</cfoutput> en la Oficina <cfoutput>#rsBalanceO.Odescripcion#!</cfoutput>');
						<cfelse>
							alert('La poliza no esta balanceada para la Moneda <cfoutput>#rsBalanceO.Mnombre#</cfoutput>');
						</cfif>
						correcto = false;
						<cfbreak>
					</cfif>
				</cfloop>
				</cfif>
				if (correcto==false) {
				document.form1.Ccuenta.value = '';
				document.form1.CFcuenta.value = '';
				document.form1.Ddescripcion.value = '';
				}
				return correcto;
			} 
			else return false; 	
		}
	
	function sugerirTClocal() {
		<cfif modoDet EQ "ALTA" and modo NEQ "ALTA">
			document.form1.Mcodigo.onchange(); 
		</cfif>
		<cfif modo NEQ "ALTA">
			//document.form1.Eperiodo.disabled=true;
			//document.form1.Emes.disabled=true;
			document.form1.Cconcepto.disabled=true;
		</cfif>
		return;
	}	
	
	function exportar() {
		var top = (screen.height - 500) / 2;
		var left = (screen.width - 450) / 2;
		<cfif modo neq 'ALTA'>
			window.open('exportarPoliza.cfm?IDcontable=<cfoutput>#IDcontable#</cfoutput>', 'Modulos','menu=no,scrollbars=yes,top='+top+',left='+left+',width=350,height=200');
		</cfif>			
	}
	
	function _finalizar(){
		if ( document.form1.paramretro ){
			document.form1.paramretro.disabled = false;
		}

		document.form1.Edocumento.disabled = false;
		document.form1.Cconcepto.disabled = false;
		<cfif modo NEQ "ALTA">
			document.form1.Dlocal.value=qf(document.form1.Dlocal);
			document.form1.Doriginal.value=qf(document.form1.Doriginal);
		</cfif>
	}
	
	function deshabilitarValidacion(){
		<cfif modoDet NEQ "ALTA">			
			objForm.Cconcepto.required = false;
			objForm.Edescripcion.required= false;
			objForm.Efecha.required= false;
			objForm.Edocbase.required= false;
			objForm.Ddocumento.required= false;
		</cfif>
		objForm.Ccuenta.required = false;
		objForm.CFcuenta.required = false;
		objForm.Ddescripcion.required= false;
		objForm.Ocodigo.required= false;
	}
	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	<cfif modo EQ "ALTA">
		objForm.Cconcepto.required = true;
		objForm.Cconcepto.description="Concepto";		
		//objForm.Eperiodo.required= true;
		//objForm.Eperiodo.description="Periodo";			
		//objForm.Emes.required= true;
		//objForm.Emes.description="Mes";			
		objForm.Edescripcion.required= true;
		objForm.Edescripcion.description="Descripcion";			
		objForm.Efecha.required= true;
		objForm.Efecha.description="Fecha";			
		objForm.Edocbase.required= true;
		objForm.Edocbase.description="Documento";	
	<cfelse>
		<cfif modoDet NEQ "ALTA">			
			objForm.Cconcepto.required = true;
			objForm.Cconcepto.description="Concepto";		
			//objForm.Eperiodo.required= true;
			//objForm.Eperiodo.description="Periodo";			
			//objForm.Emes.required= true;
			//objForm.Emes.description="Mes";			
			objForm.Edescripcion.required= true;
			objForm.Edescripcion.description="Descripcion";			
			objForm.Efecha.required= true;
			objForm.Efecha.description="Fecha";			
			objForm.Edocbase.required= true;
			objForm.Edocbase.description="Documento";
			objForm.Ddocumento.required= true;
			objForm.Ddocumento.description="Documento";
		</cfif>
		objForm.Ccuenta.required = true;
		objForm.CFcuenta.required = true;
		objForm.Ccuenta.description="Cuenta";
		objForm.CFcuenta.description="Cuenta Financiera";
		objForm.Ddescripcion.required= true;
		objForm.Ddescripcion.description="Descripcion";			
		objForm.Ocodigo.required= true;
		objForm.Ocodigo.description="Oficina";
	</cfif>		
</script>


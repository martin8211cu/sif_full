
<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 23-2-2006.
		Motivo: Se agrega el checkbox ChkReversible. Se corrige el pintado, se corrige la navegación por tabs.
		
	Modificado por Gustavo Fonseca H.
		Fecha: 27-2-2006.
		Motivo: Se permite pintar los meses anteriores al mes actual de la conta. Se pinta un año anterior, 
		actual y un año porterior al periodo del a conta (Con el fin de tener Importación de Documentos retroactivos 
		implícitos). Pedido por Mauricio Esquivel.

	Modificado por: Gustavo Fonseca H.
		Fecha: 3-3-2006.
		Motivo:
		-  Se agrega el botón de Consultar. 
		-  Se incluye filtro por Línea.
		-  Se trabaja la navegación de la lista del detalle y la lista del detalle para que el query traiga 
			solamente 40 registros en vez de traerse todas las líneas, esto para corregir que se pegue cualquier 
			servidor donde se trabaje con asientos de 32 000  registros o mas, la navegación hacia atras no 
			existe, tiene que usar el filtro por línea. 
		-  Cada vez que se da de baja una línea se actualiza el consecutivo de todas las líneas. Esto para 
			mantener la navegación.
			
	Modificado por: Gustavo Fonseca H.
		Fecha: 8-3-2006.
		Motivo: Se modifica para alinear bien los totales de débitos y créditos. Se cambia los count por sum en el rsCheck1.
 --->
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfparam name="params" 			default="">
<cfparam name="campos_extra" 	default="">
<cfparam name="navegacion" 		default="">
<cfif isdefined('URL.NuevoE')>
	<cf_navegacion name="ECIid" value="" session>
</cfif>
<cf_navegacion name="ECIid" session>

<cfset modo = "ALTA">
<cfset mododet = "ALTA">

<!---Descripcion--->
<cfif isdefined("url.descripcion") and len(trim(url.descripcion)) and not isdefined("form.descripcion")>
	<cfset form.descripcion = url.descripcion >
</cfif>
<cfif isdefined("Url.fDescripcion") and not isdefined("Form.fDescripcion")>
	<cfparam name="Form.fDescripcion" default="#Url.fDescripcion#">
</cfif>
<cfif isdefined("form.descripcion") >
	<cfset params = params & "&descripcion=#form.descripcion#">
	<cfset campos_extra = campos_extra & ", '#form.descripcion#' as descripcion" >
</cfif>
<!---Periodo-Mes--->
<cfif isdefined("url.periodo") and len(trim(url.periodo)) and not isdefined("form.periodo")>
	<cfset form.periodo = url.periodo >
</cfif>
<cfif isdefined("url.mes") and len(trim(url.mes)) and not isdefined("form.mes")>
	<cfset form.mes = url.mes >
</cfif>
<cfif isdefined("form.periodo") >
	<cfset params = params & "&periodo=#form.periodo#">
	<cfset campos_extra = campos_extra & ", '#form.periodo#' as periodo" >	
</cfif>
<cfif isdefined("form.mes")>
	<cfset params = params & "&mes=#form.mes#">
	<cfset campos_extra = campos_extra & ", '#form.mes#' as mes" >	
</cfif>

<cfif isdefined("url.fechadesde") and len(trim(url.fechadesde)) and not isdefined("form.fechadesde")> 
	<cfset form.fechadesde = url.fechadesde >
</cfif>
<!---ver--->
<cfif isdefined("url.ver") and len(trim(url.ver)) and not isdefined("form.ver")>
	<cfset form.ver = url.ver >
</cfif>
<cfif isdefined("form.ver")>
	<cfset params = params & "&ver=#form.ver#">
	<cfset campos_extra = campos_extra & ", '#form.ver#' as ver " >	
</cfif>
<cfif isdefined("url.Usucodigo") and len(trim(url.Usucodigo)) and not isdefined("form.Usucodigo")>
	<cfset form.Usucodigo = url.Usucodigo >
</cfif>
<cfif isdefined("url.origen") and len(trim(url.origen)) and not isdefined("form.origen")>
	<cfset form.origen = url.origen >
</cfif>
<cfif isdefined("url.fechahasta") and len(trim(url.fechahasta)) and not isdefined("form.fechahasta")>
	<cfset form.fechahasta = url.fechahasta >
</cfif>
<!---Numero de pagina--->
<cfif isdefined("url.pageNum_lista") and len(trim(url.pageNum_lista)) and not isdefined("form.pageNum_lista")>
	<cfset form.pageNum_lista = url.pageNum_lista >
</cfif>
<cfif isdefined("Url.flinea") and not isdefined("Form.flinea")>
	<cfparam name="Form.flinea" default="#Url.flinea#">
</cfif>

<cfif isdefined("Url.fCformato") and not isdefined("Form.fCformato")>
	<cfparam name="Form.fCformato" default="#Url.fCformato#">
</cfif>
<cfif isdefined("Url.fOcodigo") and not isdefined("Form.fOcodigo")>
	<cfparam name="Form.fOcodigo" default="#Url.fOcodigo#">
</cfif>

<cfif isdefined("form.Usucodigo")>
	<cfset params = params & "&Usucodigo=#form.Usucodigo#">
	<cfset campos_extra = campos_extra & ", '#form.Usucodigo#' as Usucodigo" >	
</cfif>
<cfif isdefined("form.fechadesde") >
	<cfset params = params & "&fechadesde=#form.fechadesde#">
	<cfset campos_extra = campos_extra & ", '#form.fechadesde#' as fechadesde" >	
</cfif>
<cfif isdefined("form.fechahasta") >
	<cfset params = params & "&fechahasta=#form.fechahasta#">
	<cfset campos_extra = campos_extra & ", '#form.fechahasta#' as fechahasta" >	
</cfif>

<cfif isdefined("Url.ECIid") and Len(Trim(Url.ECIid)) and not isdefined("Form.ECIid")>
	<cfparam name="Form.ECIid" default="#Url.ECIid#">
<cfelseif isdefined("Session.ImportarAsientos") and isdefined("Session.ImportarAsientos.ECIid") and Len(Trim(Session.ImportarAsientos.ECIid)) and not isdefined("Form.ECIid")>
	<cfparam name="Form.ECIid" default="#Session.ImportarAsientos.ECIid#">
</cfif>

<cfif isdefined("url.NuevoE") and not isdefined("form.NuevoE")>
	<cfset form.NuevoE = url.NuevoE>
</cfif>
<cfparam name="Form.flinea" default="">

<!--- Solamente actualiza los que se van a visualizar, los que se aplican desde la lista los actualiza en el componente de posteo --->
<cfif isdefined("Form.ECIid") and len(trim(Form.ECIid)) NEQ 0 >
    <cfquery datasource="#session.DSN#">
        update DContablesImportacion 
        set EcodigoRef = Ecodigo
        where ECIid = #Form.ECIid#
          and EcodigoRef is null
    </cfquery>
    
    <cfquery datasource="#session.DSN#">
        update DContablesImportacion 
        set EcodigoRef = Ecodigo
        where ECIid = #Form.ECIid#
          and (EcodigoRef = 0 or EcodigoRef = -1)
    </cfquery>
</cfif>

<cfif isdefined("Form.ECIid") and len(trim(Form.ECIid)) and not isdefined("form.btnNuevo")>
	<cfset modo = "CAMBIO">
</cfif>
<cfif isdefined("Form.DCIlinea") and len(trim(Form.DCIlinea))>
	<cfset mododet = "CAMBIO">
</cfif>

<cfset LbanderaMonedas = false>
<cfif modo eq "CAMBIO">
	<cfquery name="rsMcodigo" datasource="#session.DSN#">
		select Mcodigo, Ecodigo 
		from Empresas 
		where Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfquery name="rsCheck1" datasource="#session.DSN#">
		select 
			sum(case when d.Mcodigo <> #rsMcodigo.Mcodigo# then 1 else 0 end) as CantidadMoneda,
			sum(1) as CantidadRegistros
		from DContablesImportacion d
		where d.ECIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECIid#">
	</cfquery>
	<cfset LbanderaMonedas = rsCheck1.CantidadMoneda GT 0>
	
	<cfquery name="rsOficinas" datasource="#Session.DSN#">
		select 
			d.EcodigoRef as Ecodigo, 
			d.Ocodigo as Ocodigo, 
			((select min( Edescripcion #_Cat# ' - ' #_Cat# o.Oficodigo) 
				from Oficinas o
					inner join Empresas e 
						on e.Ecodigo = o.Ecodigo
				where o.Ecodigo = d.EcodigoRef
				  and o.Ocodigo = d.Ocodigo
			)) as Odescripcion
		from DContablesImportacion d
		where ECIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECIid#">
		group by d.EcodigoRef, d.Ocodigo
	</cfquery>
</cfif>

<cfset ListaAplicar = "">
<cfif isDefined("Form.Aplicar") and Len(Trim(Form.ECIid)) NEQ 0>
	<cfset ListaAplicar = Form.ECIid>
</cfif>
<cfif isDefined("Form.btnAplicar") and isdefined("Form.chk") and Len(trim(Form.chk))>
	<cfset ListaAplicar = Form.chk>	
</cfif>
<cfset request.error.backs = 2>

<cfif len(trim(ListaAplicar))>
	<p><center><img src="/cfmx/sif/imagenes/esperese.gif" alt="Procesando la Aplicación de Asientos.... Por favor espere" width="320" height="90" border="0"></center></p>
    <cfflush interval="20">
	<!--- CODIGO PARA APLICACION DE IMPORTACION DE ASIENTOS CONTABLES --->
	<cfloop list="#ListaAplicar#" index="ECIid">

		<cfquery name="rsDatos" datasource="#session.DSN#">
            select Cconcepto, Edocbase 
			  from EContablesImportacion
            where ECIid = #ECIid#
        </cfquery>

		<cfset LvarAsientoProcesado = true>

        <p align="left"> Procesando el Documento <cfoutput>#rsDatos.Cconcepto# - #rsDatos.Edocbase# </cfoutput>....</p>
		<cftry>
			<cfinvoke component="sif.Componentes.CG_AplicaImportacionAsiento" method="CG_AplicaImportacionAsiento">
                <cfinvokeargument name="ECIid" value="#ECIid#">
            </cfinvoke>
            <cfcatch type="any">
				<cfset LvarAsientoProcesado = false>
                <p align="left">Se presentó un error al aplicar el documento: <cfoutput>#rsDatos.Cconcepto# - #rsDatos.Edocbase# </cfoutput>....</p>
                <cfif cfcatch.Message eq "LvarMensajeDescuadre">
                    <p align="left">El asiento se encuentra desbalanceado ...</p>
                <cfelse>
                    <p align="left"><cfoutput>#cfcatch.Message# #cfcatch.detail#</cfoutput></p>
                </cfif>
            </cfcatch>
        </cftry>
        <cfif LvarAsientoProcesado>
        	<p align="left"> ..... Aplicado </p> <br />
        </cfif>
	</cfloop>
    <p align="center">&nbsp;</p>
    <p align="center">Proceso Finalizado.</p>
	<p align="center">Oprima <u><cfoutput><a href="DocContablesImportacion-lista.cfm?1=1#params#" style="color:##FF0000">regresar</a></cfoutput></u> para volver a la lista.</p>
    <cfabort>
</cfif>

<cfif modo neq "ALTA">
	<cfquery name="rsDImportacion" datasource="#Session.DSN#">
		select count(1) as cantidad
		from DContablesImportacion
		where ECIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECIid#">
		and Ecodigo <> EcodigoRef
	</cfquery>
	
	<cfset Intercompany = (rsDImportacion.cantidad GT 0)>
	<cfif Intercompany>
		<cfquery datasource="#Session.DSN#">
			update EContablesImportacion set
				ECIreversible = 0
			where ECIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECIid#">
			and Ecodigo = #Session.Ecodigo#
		</cfquery>

		<cfquery name="rsBalanceO" datasource="#Session.DSN#">
			select 
				a.Mcodigo,
				((select min(Mnombre) from Monedas m where m.Mcodigo = a.Mcodigo)) as Mnombre,
				((select min(Msimbolo) from Monedas m where m.Mcodigo = a.Mcodigo)) as Msimbolo,
				sum(case when a.Dmovimiento = 'D' then a.Doriginal else 0.00 end) as Debitos,
				sum(case when a.Dmovimiento = 'C' then a.Doriginal else 0.00 end) as Creditos,
				sum(case when a.Dmovimiento = 'D' then a.Dlocal else 0.00 end) as DebitosL,
				sum(case when a.Dmovimiento = 'C' then a.Dlocal else 0.00 end) as CreditosL,
				sum(0.005) as HolguraL
			from DContablesImportacion a
			where a.ECIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECIid#">
			group by a.Mcodigo
		</cfquery>

		<cfquery name="rsBalanceT" dbtype="query">
			select 
				sum(DebitosL) as DebitosL, 
				sum(CreditosL) as CreditosL 
			from rsBalanceO
		</cfquery>
	<cfelse>
		<cfquery name="rsBalanceO" datasource="#Session.DSN#">
			select 
				a.Ecodigo, a.Ocodigo, a.Mcodigo,
				((select min(Mnombre) from Monedas m where m.Mcodigo = a.Mcodigo)) as Mnombre,
				((select min(Msimbolo) from Monedas m where m.Mcodigo = a.Mcodigo)) as Msimbolo,
				((select min(Oficodigo) from Oficinas o where o.Ecodigo = a.Ecodigo and o.Ocodigo = a.Ocodigo)) as Odescripcion,
				sum(case when a.Dmovimiento = 'D' then a.Doriginal else 0.00 end) as Debitos,
				sum(case when a.Dmovimiento = 'C' then a.Doriginal else 0.00 end) as Creditos,
				sum(case when a.Dmovimiento = 'D' then a.Dlocal else 0.00 end) as DebitosL,
				sum(case when a.Dmovimiento = 'C' then a.Dlocal else 0.00 end) as CreditosL,
				sum(0.005) as HolguraL
			from DContablesImportacion a
			where a.ECIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECIid#">
			group by a.Ecodigo, a.Ocodigo, a.Mcodigo
		</cfquery>
		<cfquery name="rsBalanceT" dbtype="query">
			select 
				sum(DebitosL) as DebitosL, 
				sum(CreditosL) as CreditosL 
			from rsBalanceO
		</cfquery>
		<cfif rsBalanceT.DebitosL EQ rsBalanceT.CreditosL>
			<cfquery name="rsBalanceOfic" datasource="#session.dsn#">
				select 
						d.Ocodigo as Oficina, 
						d.Mcodigo as Mcodigo,
						sum(d.Dlocal * case Dmovimiento when  'D' then 1.00 else -1.00 end)     as Dlocal, 
						sum(d.Doriginal *case Dmovimiento when  'D' then 1.00 else -1.00 end) 	as Doriginal
				from DContablesImportacion d
				where d.ECIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECIid#">
				group by d.Ocodigo, d.Mcodigo
				having sum(d.Dlocal * case Dmovimiento when  'D' then 1.00 else -1.00 end) <> 0 or sum(d.Doriginal *  case Dmovimiento when  'D' then 1.00 else -1.00 end) <> 0
			</cfquery>
		</cfif>		
	</cfif>
</cfif>
<cfquery name="rsConceptos" datasource="#Session.DSN#">
	select a.Cconcepto, a.Cdescripcion
	from ConceptoContableE a
	where a.Ecodigo = #Session.Ecodigo#
</cfquery>

<cfquery name="rsPrePeriodo" datasource="#Session.DSN#">
	select Pvalor as periodo
	from Parametros 
	where Ecodigo = #Session.Ecodigo# 
	and Pcodigo = 30
	and Mcodigo = 'CG'	  
</cfquery>
<cfset rsPeriodo = QueryNew("Pvalor")>
<cfset temp = QueryAddRow(rsPeriodo,3)>
<cfset temp = QuerySetCell(rsPeriodo,"Pvalor",rsPrePeriodo.periodo-1,1)>
<cfset temp = QuerySetCell(rsPeriodo,"Pvalor",rsPrePeriodo.periodo,2)>
<cfset temp = QuerySetCell(rsPeriodo,"Pvalor",rsPrePeriodo.periodo+1,3)>

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
	select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as mes, b.VSdesc as descripcion
	 from Idiomas a
	   inner join VSidioma b 
		 on a.Iid = b.Iid
	where a.Icodigo = '#Session.Idioma#'
	and b.VSgrupo = 1
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
	<cfquery name="rsOficinasDet" datasource="#Session.DSN#">
		select o.Ecodigo, o.Ocodigo, o.Odescripcion
		from Oficinas o
		inner join Empresas e
			on o.Ecodigo = e.Ecodigo
		where(select count(1)
			   from Empresas x
			  where x.cliente_empresarial = #Session.CEcodigo#
			  and x.Ecodigo = o.Ecodigo ) > 0
	</cfquery>

	<cfquery name="rsDocumento" datasource="#Session.DSN#">
		select 
			a.ECIid, 
			a.Ecodigo, 
			a.Cconcepto, 
			a.Eperiodo, 
			a.Emes, 
			a.Efecha, 
			a.Edescripcion, 
			a.Edocbase, 
			a.Ereferencia, 
			a.ts_rversion,
			b.Cdescripcion,
			a.ECIreversible
		from EContablesImportacion a
			inner join ConceptoContableE b
				on b.Ecodigo = a.Ecodigo
				and b.Cconcepto = a.Cconcepto
		where a.ECIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECIid#">
	</cfquery>

	<cfquery name="TCsug" datasource="#Session.DSN#">
		select tc.Mcodigo, tc.TCcompra, tc.TCventa
		from Htipocambio tc
		where tc.Ecodigo = #Session.Ecodigo#
		and tc.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsDocumento.Efecha#">
		and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#rsDocumento.Efecha#">
	</cfquery>
	<cfif mododet NEQ "ALTA">
		<cfquery name="rsLinea" datasource="#Session.DSN#">
			select  a.ECIid, DCIlinea, a.EcodigoRef as Ecodigo, a.Cconcepto, a.Eperiodo, a.Emes, a.Ocodigo, a.Ddescripcion, 
					a.Ddocumento, a.Dreferencia, a.Dmovimiento, a.Ccuenta, a.CFcuenta, a.Doriginal, a.Dlocal, a.Mcodigo, a.Dtipocambio, a.ts_rversion,
					b.CFformato, b.CFdescripcion, c.Cmayor, c.Cformato, c.Cdescripcion, CFid, CFcodigo
			from DContablesImportacion a
				left outer join CFinanciera b
					on a.CFcuenta = b.CFcuenta
				left outer join CContables c 
					on c.Ccuenta = b.Ccuenta
			where a.DCIlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DCIlinea#">
			and a.ECIid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECIid#">
		</cfquery>
		<cfset QuerySetCell(rsLinea,"Dtipocambio", rsLinea.Dlocal / rsLinea.Doriginal)>
	</cfif>
</cfif>

<cfset adicional = "">
<cfif isdefined("Form.fDescripcion") and Len(Trim(Form.fDescripcion))>
	<cfset navegacion = navegacion & "&fDescripcion=" & Form.fDescripcion>
</cfif>
<cfif isdefined("Form.fCformato") and Len(Trim(Form.fCformato))>
	<cfset navegacion = navegacion & "&fCformato=" & Form.fCformato>
</cfif>
<cfif isdefined("Form.fOcodigo") and Len(Trim(Form.fOcodigo))>
	<cfset navegacion = navegacion & "&fOcodigo=" & Form.fOcodigo>
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
	function AgregarCombo(combo,codigo) {
		var cont = 0;
		combo.length=0;
		<cfoutput query="rsMeses">
			//if (#Trim(rsMeses.mes)# >= codigo) 
			//{
				combo.length=cont+1;
				combo.options[cont].value='#rsMeses.mes#';
				combo.options[cont].text='#rsMeses.descripcion#';
			<cfif modo NEQ "ALTA" and #rsMeses.mes# EQ #rsDocumento.Emes#>
				combo.options[cont].selected=true;
			<cfelseif modo EQ "ALTA" and isdefined("mesactual") and #rsMeses.mes# EQ #mesactual#>
				combo.options[cont].selected=true;			
			</cfif>
				cont++;
			//};
		</cfoutput>
	}	
	
	function Lista() {
		location.href="DocContablesImportacion-lista.cfm?1=1<cfoutput>#params#</cfoutput>";
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
	.niv { font-size: 12px; }

</style>

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset PolizaMon = t.Translate('PolizaMon','Balance de Póliza en Moneda Origen')>
<cfset MonLoc = t.Translate('PolizaMonLoc','Balance de Póliza en Moneda Local')>
<cfset PolizaMon2 = t.Translate('PolizaMon2','La Póliza no está balanceada para la Moneda')>


<form action="DocContablesImportacion-sql.cfm" method="post" name="form1" onSubmit="javascript: _finalizar();">
	<!---- MANTENER FILTROS---->
	<cfoutput>
		<!---<input name="LvarDCIconsecutivo" value="#form.LvarDCIconsecutivo#" type="hidden">--->
		<input name="PageNum_lista" type="hidden" value="<cfif isdefined("form.PageNum_lista") and len(trim(form.PageNum_lista))>#form.PageNum_lista#</cfif>" tabindex="-1">
		<input name="descripcion" 	type="hidden" value="<cfif isdefined("form.descripcion")and len(trim(form.descripcion))>#form.descripcion#</cfif>" tabindex="-1">
		<input name="periodo" 		type="hidden" value="<cfif isdefined("form.periodo")and len(trim(form.periodo))>#form.periodo#</cfif>" tabindex="-1">
		<input name="mes" 			type="hidden" value="<cfif isdefined("form.mes") and len(trim(form.mes))>#form.mes#</cfif>" tabindex="-1">
		<input name="ver" 			type="hidden" value="<cfif isdefined("form.ver") and len(trim(form.ver)) >#form.ver#</cfif>" tabindex="-1">
		<input name="Usucodigo" 	type="hidden" value="<cfif isdefined("form.Usucodigo") and len(trim(form.Usucodigo))>#form.Usucodigo#</cfif>" tabindex="-1">
		<input name="fechadesde" 	type="hidden" value="<cfif isdefined("form.fechadesde") and len(trim(form.fechadesde))>#form.fechadesde#</cfif>" tabindex="-1">
		<input name="fechahasta" 	type="hidden" value="<cfif isdefined("form.fechahasta") and len(trim(form.fechahasta))>#form.fechahasta#</cfif>" tabindex="-1">
		<input name="flinea" 		type="hidden" value="<cfif isdefined("Form.flinea")>#Form.flinea#</cfif>">
		<input name="fDescripcion" 	type="hidden" value="<cfif isdefined("Form.fDescripcion")>#Form.fDescripcion#</cfif>">
		<input name="fCformato" 	type="hidden" value="<cfif isdefined("Form.fCformato")>#Form.fCformato#</cfif>">
		<input name="fOcodigo" 	    type="hidden" value="<cfif isdefined("Form.fOcodigo")>#Form.fOcodigo#</cfif>">
		<input name="ECIid_F" 	    type="hidden" value="<cfif isdefined("form.ECIid")>#form.ECIid#</cfif>">
	</cfoutput>
		
<table width="94%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td rowspan="6" valign="top" colspan="5">
		<cfif LbanderaMonedas>
			<table width="300" cellpadding="0" cellspacing="0" border="0">
				<tr> 
					<td colspan="<cfif not (modo EQ "CAMBIO" and Intercompany)>5<cfelse>4</cfif>+10" class="tituloBalance" align="center" nowrap>
						<cfoutput>#PolizaMon#</cfoutput>
					</td>
				</tr>
				<tr> 
					<td width="20%" class="detalleBalance" nowrap><cf_translate key="monto">Mon</cf_translate>.&nbsp;</td>
					<cfif not (modo EQ "CAMBIO" and Intercompany)>
						<td width="25%" class="detalleBalance" nowrap><cf_translate key="oficina">Oficina</cf_translate>&nbsp;</td>
					</cfif>
					<td width="25%" class="detalleBalance" nowrap><cf_translate key="debito">D&eacute;bitos</cf_translate></td>
					<td width="5%" class="detalleBalance" nowrap>&nbsp;</td>
					<td width="25%" class="detalleBalance" nowrap><cf_translate key="credito">Cr&eacute;ditos</cf_translate></td>
				</tr>
			</table>
			<div id="divComponentes" style="overflow:auto; height: 40; margin:0">
			<table width="300" border="0" cellspacing="0" cellpadding="0">
				<cfif isdefined("rsBalanceO")>
				
					<cfoutput query="rsBalanceO"> 
						<tr> 
							<td width="20%"><font color="##0033CC">#rsBalanceO.Msimbolo#</font></td>
							<cfif not (modo EQ "CAMBIO" and Intercompany)>
								<td width="25%">#rsBalanceO.Odescripcion#</td>
							</cfif>
							<td width="25%" align="right">#LSNumberFormat(rsBalanceO.Debitos,',9.00')#</td>
							<td width="5%">&nbsp;</td>
							<td width="25%" align="right">#LSNumberFormat(rsBalanceO.Creditos,',9.00')#</td>
						</tr>
					</cfoutput> 
					<tr><td colspan="<cfif not (modo EQ "CAMBIO" and Intercompany)>5<cfelse>4</cfif>">&nbsp;</td></tr>
				</cfif>
			</table>
			</div>
		</cfif>
		<table width="300" border="0" cellspacing="0" cellpadding="0">
			<tr> 
				<td colspan="<cfif not (modo EQ "CAMBIO" and Intercompany)>5<cfelse>4</cfif>" class="tituloBalance" nowrap align="center" ><cfoutput>#MonLoc#</cfoutput></td>
			</tr>
			<tr> 
				<td width="20%" class="detalleBalance" nowrap><cf_translate key="monto">Mon</cf_translate>.&nbsp;</td>
				<cfif not (modo EQ "CAMBIO" and Intercompany)>
					<td width="25%" class="detalleBalance" nowrap><cf_translate key="oficina">Oficina</cf_translate>&nbsp;</td>
				</cfif>
				<td width="25%" class="detalleBalance" nowrap><cf_translate key="debito">D&eacute;bitos</cf_translate></td>
				<td width="5%" class="detalleBalance" nowrap>&nbsp;</td>
				<td width="25%" class="detalleBalance" nowrap><cf_translate key="credito">Cr&eacute;ditos</cf_translate></td>
			</tr>
		</table>
		<div id="divComponentes" style="overflow:auto; height: 40; margin:0" >
		<table width="300" border="0" cellspacing="0" cellpadding="0">
			<cfif isdefined("rsBalanceO")>
				<cfoutput query="rsBalanceO"> 
					<tr> 
						<td width="20%"><font color="##0033CC">#rsBalanceO.Msimbolo#</font></td>
						<cfif not (modo EQ "CAMBIO" and Intercompany)>
							<td width="25%">#rsBalanceO.Odescripcion#</td>
						</cfif>
						<td width="25%" align="right">#LSNumberFormat(rsBalanceO.DebitosL,',9.00')#</td>
						<td width="5%">&nbsp;</td>
						<td width="25%" align="right">#LSNumberFormat(rsBalanceO.CreditosL,',9.00')#</td>
					</tr>
				</cfoutput> 
			</cfif>
		</table>
		</div>
	</td>
    <td colspan="7" align="center"><strong><cf_translate key="titulodoc">Importaci&oacute;n de Documento Contable</cf_translate></strong></td>
  </tr>
  <tr>
   <td width="6%" align="right" nowrap><cf_translate key="concepto">Concepto</cf_translate>:&nbsp;</td>
    <td width="15%">
		<select name="Cconcepto" tabindex="1">
			<cfoutput query="rsConceptos"> 
				<option value="#rsConceptos.Cconcepto#" <cfif modo NEQ "ALTA" and rsConceptos.Cconcepto EQ rsDocumento.Cconcepto>selected</cfif>>#rsConceptos.Cdescripcion#</option>
			</cfoutput>
		</select>
	</td>
    <td width="5%" align="right" nowrap><cf_translate key="periodo">Per&iacute;odo</cf_translate>:&nbsp;</td>
	<td width="12%">
		<select name="Eperiodo" tabindex="1" onChange="javascript:if (document.form1.Eperiodo.value == '<cfoutput>#periodoActual#</cfoutput>') AgregarCombo(document.form1.Emes,'<cfoutput>#mesActual#</cfoutput>'); else AgregarCombo(document.form1.Emes,'1');">
			<cfoutput query="rsPeriodo"> 
				<option value="#rsPeriodo.Pvalor#" <cfif modo NEQ "ALTA" and rsPeriodo.Pvalor EQ rsDocumento.Eperiodo>selected<cfelseif modo EQ "ALTA" and rsPeriodo.Pvalor EQ periodoActual>selected</cfif>>#rsPeriodo.Pvalor#</option>
			</cfoutput>
		</select>
	</td>
	<td width="15%" align="right" nowrap><cf_translate key="mes">Mes</cf_translate>:&nbsp;</td>
	<td width="5%">
		<select name="Emes" tabindex="1"></select>
	</td>
	
    </tr>
  
   <tr>
	<td nowrap align="right"><cf_translate key="documento">Documento</cf_translate>:&nbsp;</td>
	<td colspan="1">
      <input name="Edocbase" type="text" tabindex="1" value="<cfif modo NEQ "ALTA"><cfoutput>#rsDocumento.Edocbase#</cfoutput></cfif>" size="17" maxlength="20" onFocus="javascript:this.select();">
	  <script language="JavaScript">document.form1.Edocbase.focus();</script>
    </td>
	<td nowrap align="right"><cf_translate key="referencia">Referencia</cf_translate>:&nbsp;</td>
	<td colspan="1">
      <input name="Ereferencia" type="text" tabindex="1" value="<cfif modo NEQ "ALTA"><cfoutput>#rsDocumento.Ereferencia#</cfoutput></cfif>" size="15" maxlength="25" onFocus="javascript:this.select();">
    </td>
	<td nowrap align="right"><cf_translate key="fecha">Fecha</cf_translate>:&nbsp;</td>
	<td>
      <cfif modo EQ "CAMBIO">
        <cfset fechadoc = LSDateFormat(rsDocumento.Efecha,'dd/mm/yyyy')>
        <cfelse>
        <cfset fechadoc = LSDateFormat(Now(),'dd/mm/yyyy')>
      </cfif>
      <cf_sifcalendario name="Efecha" value="#fechadoc#" tabindex="1">
      <script language="JavaScript">if (document.form1.Eperiodo.value == '<cfoutput>#periodoActual#</cfoutput>') AgregarCombo(document.form1.Emes,'<cfoutput>#mesActual#</cfoutput>'); else AgregarCombo(document.form1.Emes,'1');</script>
    </td>
   </tr>
   <tr>
   	<td nowrap align="right"><cf_translate key="descripcion">Descripci&oacute;n</cf_translate>:&nbsp;</td>
	<td colspan="3">
		<input name="Edescripcion" type="text" tabindex="1" value="<cfif modo NEQ "ALTA"><cfoutput>#rsDocumento.Edescripcion#</cfoutput></cfif>" size="65" maxlength="100" onFocus="javascript:this.select();">
		
	</td>
	<td align="right">
		<input name="ChkReversible" type="checkbox" tabindex="1" value="1" <cfif isdefined("Intercompany") and Intercompany>disabled<cfelse><cfif isdefined("rsDocumento") and rsDocumento.ECIreversible eq 1>checked</cfif> </cfif>>
	</td>
	<td align="left">
		&nbsp;Reversible
	</td>
    </tr>
	<tr>
		<td colspan="6">
			<cfset tsE = "">
			<cfif modo NEQ "ALTA">
				<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsDocumento.ts_rversion#" returnvariable="tsE"></cfinvoke>
			</cfif>
			<input type="hidden" name="ECIid" value="<cfif modo NEQ "ALTA"><cfoutput>#rsDocumento.ECIid#</cfoutput></cfif>"> 
			<input type="hidden" name="timestampE" value="<cfif modo NEQ "ALTA"><cfoutput>#tsE#</cfoutput></cfif>"> 
		</td>
	</tr>
	<!---------------------------------------------------------------------------------->
	<!--- Detalle del Documento--->
</table>
<table width="100%" border="0">
	<tr>
    <td colspan="12">&nbsp;</td>
    </tr>
	<cfif not isDefined("Form.NuevoE") and modo NEQ "ALTA">
		<tr>
			<td style="border-top:1px solid #666666; font-size:12px; color:#666666;" colspan="12" align="center"><strong>Detalle de Importaci&oacute;n </strong></td>
		</tr>
		<tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		
		</tr>
		<tr>

			<td nowrap align="right">  <cf_translate key="cuenta_contable">Cuenta Financiera</cf_translate>: </td> 
			<td colspan="9">
			<cfif modoDet NEQ "ALTA">
				<cf_cuentas Intercompany="yes" conexion="#Session.DSN#" conlis="S" query="#rsLinea#" auxiliares="C" movimiento="S" frame="frame1" descwidth="26" onchange="" onchangeIntercompany="CambiarOficina(this);" tabindex="1">
			<cfelse>
				<cf_cuentas Intercompany="yes" conexion="#Session.DSN#" conlis="S" auxiliares="C" movimiento="S" frame="frame1" descwidth="26" onchange="" onchangeIntercompany="CambiarOficina(this);" tabindex="1">
			</cfif>
			</td>
			<td nowrap align="right"><cf_translate key="movimiento">Movimiento</cf_translate>:&nbsp;</td>
			<td >
              <select name="Dmovimiento" tabindex="2">
                <cfoutput query="rsDebCred">
                  <option value="#rsDebCred.tipo#" <cfif modoDet NEQ "ALTA" and "#rsDebCred.tipo#" EQ "#rsLinea.Dmovimiento#">selected</cfif>>#rsDebCred.descripcion#</option>
                </cfoutput>
              </select>
		</td>
			
		</tr>
		<cfif modoDet NEQ "ALTA" AND rsLinea.Cformato NEQ rsLinea.CFformato>
			<tr id="trCcuenta">
				<td nowrap align="right"><cf_translate key="cuenta_contable">Cuenta Contable</cf_translate>:</td>
				<td colspan="3">&nbsp;</td>
				<cfoutput>
					<td nowrap>
						<input maxlength="4" size="4"  type="text" disabled tabindex="-1"
							value="#mid(rsLinea.Cformato,1,4)#">
					</td>
					<td nowrap colspan="3"> 
						<input maxlength="30" size="15" type="text" disabled tabindex="-1"
						value="#mid(rsLinea.Cformato,6,100)#">
					</td>
					<td nowrap colspan="3">
						<input type="text" maxlength="80" size="40" disabled tabindex="-1"
						value="#rsLinea.Cdescripcion#">
					</td>
				</cfoutput>
			</tr>
		</cfif>
		<tr>
			<td nowrap align="right"><cf_translate key="oficina">Oficina </cf_translate>:&nbsp;</td>
			<td> 
			<select name="Ocodigo" tabindex="2">
				<cfoutput query="rsOficinasDet"> 
					<option value="#rsOficinasDet.Ocodigo#" <cfif modoDet NEQ "ALTA" and rsOficinasDet.Ocodigo EQ rsLinea.Ocodigo>selected</cfif>>#rsOficinasDet.Odescripcion#</option>
				</cfoutput>
			</select>
			</td>
			<td> 
				C.&nbsp;Funcional:
			</td>
			<td colspan="9"> 
								<cfif modoDet neq 'ALTA' and isdefined('rsLinea') and (len(trim(rsLinea.CFid)) or len(trim(rsLinea.CFcodigo)))>
                                    <cfif len(trim(rsLinea.CFid))>
										<cfquery name="rsCFuncional" datasource="#session.DSN#">
											select CFid, CFcodigo, CFdescripcion
												from CFuncional
											where Ecodigo = #session.Ecodigo#
											 and CFid = #rsLinea.CFid#
                                    	</cfquery>
									<cfelse>
										<cfquery name="rsCFuncional" datasource="#session.DSN#">
											select CFid, CFcodigo, CFdescripcion
												from CFuncional
											where Ecodigo = #session.Ecodigo#
											 and CFcodigo = '#rsLinea.CFcodigo#'
                                    	</cfquery>
										<cfif rsCFuncional.Recordcount EQ 0>
											<cfquery name="rsCFuncional" datasource="#session.DSN#">
												select <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> CFid, '#rsLinea.CFcodigo#'  CFcodigo,'--ERROR--' CFdescripcion
													from dual			
                                    	</cfquery>
										</cfif>
									</cfif>
                                    <cf_rhcfuncional size="22" query="#rsCFuncional#" tabindex="2">
                                <cfelse>
                                    <cf_rhcfuncional size="22"   tabindex="2">
                                </cfif>
			</td>
		</tr>
		
		<tr>
			<td nowrap align="right"><cf_translate key="descripcion">Descripci&oacute;n</cf_translate>:</td>
			<td colspan="11">
			<input name="Ddescripcion" type="text" tabindex="2" value="<cfif modoDet NEQ "ALTA"><cfoutput>#rsLinea.Ddescripcion#</cfoutput><cfelse><cfoutput>#rsDocumento.Edescripcion#</cfoutput></cfif>" size="80" maxlength="100" onFocus="javascript:this.select();"> 
			<cfif modo NEQ "ALTA">
				<script language="JavaScript">document.form1.Cmayor.focus();</script> 
			</cfif>
			</td>
			
			
		</tr>
		<tr>
			<td nowrap align="right"><cf_translate key='documento'>Documento</cf_translate>:</td>
			<td colspan="7">
				<input type="text" name="Ddocumento" tabindex="2" size="25" maxlength="20" value="<cfoutput><cfif modoDet NEQ "ALTA">#rsLinea.Ddocumento#<cfelse>#rsDocumento.Edocbase#</cfif></cfoutput>" onFocus="this.select();">
			</td>
			<td nowrap align="right">Moneda:&nbsp;</td>
			<td > 
				<cfif modoDet NEQ "ALTA">
					<cf_sifmonedas query="#rsLinea#" valuetc="#rsLinea.Dtipocambio#" onchange="sugerirTC();get_montoLocal();" tabindex="2">
				<cfelse>
					<cf_sifmonedas onchange="sugerirTC();get_montoLocal();" tabindex="2">
				</cfif>
			</td>
			<td nowrap>Tipo Cambio:&nbsp;</td>
			<td >
				<input name="Dtipocambio" type="text" tabindex="2" 
				onChange="javascript:get_montoLocal();" 
				onBlur='javascript:this.disabled=false; validaNumero(this,8);'
				onKeyUp="javascript:if(snumber(this,event,8)){ if(Key(event)=='13') {this.blur();}}"					
				value="<cfif modoDet NEQ "ALTA"><cfoutput>#rsLinea.Dtipocambio#</cfoutput><cfelse>1.00</cfif>" size="20" maxlength="20"> 
			
			</td>
		</tr>
		<tr>
			<td nowrap align="right">Monto Origen:</td>
			<td colspan="7">
				<input name="Doriginal" type="text"  tabindex="2"
				onChange="javascript:get_montoLocal();" 
				onBlur="javascript: if(validaNumero(this,2)){get_montoLocal();formatCurrency(this,2);}"
				onFocus="javascript:this.select();"
				onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}};"					
				value="<cfif modoDet NEQ "ALTA"><cfoutput>#LSNumberFormat(rsLinea.Doriginal,',9.00')#</cfoutput><cfelse>0.00</cfif>" size="20" maxlength="20"> 
			</td>
			<td valign="baseline" nowrap align="right">&nbsp;</td>
			<td valign="baseline">&nbsp;
</td>
			<td>Monto Local:</td>
			<td><input name="Dlocal" type="text" tabindex="2" value="<cfif modoDet NEQ "ALTA"><cfoutput>#LSNumberFormat(rsLinea.Dlocal,',9.00')#</cfoutput></cfif>" size="20" maxlength="20" disabled></td>
		</tr>
		 <tr>
			<td nowrap>&nbsp;</td>
			<td colspan="7">&nbsp;
			</td>
			<td nowrap align="right">
				<cfset tsD = "">
				<cfif modoDet NEQ "ALTA">
					<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsLinea.ts_rversion#" returnvariable="tsD"></cfinvoke>
				</cfif>
			</td>
			<td>
				<input type="hidden" name="DCIlinea" value="<cfif modoDet NEQ "ALTA"><cfoutput>#rsLinea.DCIlinea#</cfoutput></cfif>">
				<input type="hidden" name="idConsecutivo" value="">
				<input type="hidden" name="Dreferencia" value="<cfif modoDet NEQ "ALTA"><cfoutput>#rsLinea.Dreferencia#</cfoutput><cfelse><cfoutput>#rsDocumento.Edocbase#</cfoutput></cfif>"> 
				<input type="hidden" name="timestampD" value="<cfif modoDet NEQ "ALTA"><cfoutput>#tsD#</cfoutput></cfif>"> 
				<input type="hidden" name="borrarLista" value="N">
			</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr> 
		
  </cfif> 
  <tr>
	<td colspan="12" align="center">
		<cfif not isDefined("Form.NuevoE") and modo NEQ "ALTA">
			<cfif modoDet EQ "ALTA">
				<input name="AgregarD" type="submit" value="Agregar Lin."  tabindex="2" class="btnGuardar" onClick="javascript: return valida('AgregarD');">
			<cfelse>
				<cfif not isdefined("rsLinea.Ddescripcion") OR rsLinea.Ddescripcion NEQ 'Ajuste para balancear diferencias en tipos de cambio'>
				<input name="CambiarD" type="submit" value="Cambiar Lin."  tabindex="2" class="btnGuardar" onClick="javascript:return valida('CambiarD');" >
				</cfif>
				<input name="NuevoD"   type="submit" value="Nueva Lin."    tabindex="2" class="btnNuevo">
			</cfif>
			&nbsp;
		</cfif>
		<cfif modo EQ "ALTA">
			<input type="submit" name="AgregarE" value="Agregar Doc."    tabindex="2" class="btnGuardar">
		<cfelse>
			<input type="submit" name="CambiarE" value="Modificar Doc."  tabindex="2" class="btnGuardar" onClick="javascript:return valida('CambiarE');">
			<cfif rsCheck1.CantidadRegistros GT 0>
			<input type="submit" name="Aplicar"  value="Aplicar" 	     tabindex="2" class="btnAplicar" onClick="javascript:return Postear();" >
			</cfif>
			<input type="button" name="ConsultarDoc"  	 value="Consultar"		tabindex="2"  class="btnNormal"  onClick="javascript:location.href='CDIMPContables.cfm?ECIid=<cfoutput>#Form.ECIid#</cfoutput>&regresar=<cfoutput>#URLEncodedFormat('DocContablesImportacion.cfm?ECIid=#Form.ECIid#')#</cfoutput>'">
			<input type="submit" name="NuevoE" 			 value="Nuevo Doc." 	tabindex="2"  class="btnNuevo"   onClick="javascript: deshabilitarValidacion();">
			<input type="submit" name="btnImportar" 	 value="Importar" 		tabindex="2"  class="btnNormal"  onClick="javascript: deshabilitarValidacion();">
			<input type="button" name="btnVerificarCtas" value="Verificar Ctas" tabindex="2"  class="btnNormal"  onClick="javascript: doConlisDocsContablesImport();" >
		</cfif>
		<cfif isdefined("rsBalanceT") and isdefined("rsBalanceOfic") and rsBalanceT.DebitosL EQ rsBalanceT.CreditosL and rsBalanceOfic.Recordcount NEQ 0 and (isdefined("modoDet") and modoDet EQ "ALTA")>
			<input type="submit" name="btnBalanceaOfic" value="Balancear"   tabindex="2" class="btnNormal"    onClick="javascript: deshabilitarValidacion();" alt="Balancea por Oficina" >
		</cfif>
		    <input type="button" name="ListaE" 		    value="Ir a Lista"  tabindex="2" class="btnAnterior"  onClick="javascript:Lista();">
		<cfif modo EQ "CAMBIO">
			<input type="submit" name="BorrarE" 		value="Borrar Doc." tabindex="2" class="btnEliminar"  onClick="javascript: document.form1.Ccuenta.value = '-1'; document.form1.CFcuenta.value = '-1'; document.form1.Ddescripcion.value = '.'; if (confirm('¿Desea borrar este documento?')) return true; else return false;">
		</cfif>
	</td>
	</tr>
</table>
</form>
<!--- Filtros para el Detalle del Documento Contable de Importación --->
<cfoutput>
	<form name="filtroDetalle" method="post" action="#GetFileFromPath(GetTemplatePath())#">
		<input name="ECIid"			type="hidden" value="<cfif modo NEQ "ALTA"><cfoutput>#rsDocumento.ECIid#</cfoutput></cfif>">
		<input name="PageNum_lista" type="hidden" value="<cfif isdefined("form.PageNum_lista") and len(trim(form.PageNum_lista))>#form.PageNum_lista#</cfif>">
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		  <tr>
		    <td class="fileLabel"><cf_translate key="linea">L&iacute;nea</cf_translate></td>
			<td class="fileLabel"><cf_translate key="descripcion">Descripci&oacute;n</cf_translate></td>
			<td class="fileLabel"><cf_translate key="cuenta_contable">Cuenta Financiera</cf_translate></td>
			<td class="fileLabel"><cf_translate key="oficina">Oficina</cf_translate></td>
	      </tr>
		  <tr>
		    <td><cf_monto name="flinea" form="filtroDetalle" negativos="false" decimales="0" size="13" tabindex="3" value="#Form.flinea#"></td>
			<td><input type="text" name="fDescripcion" 	size="30" tabindex="3" value="<cfif isdefined("Form.fDescripcion")>#Form.fDescripcion#</cfif>"></td>
			<td><input type="text" name="fCformato" 	size="30" tabindex="3" value="<cfif isdefined("Form.fCformato")>#Form.fCformato#</cfif>"></td>
			<td>
				<cfif isdefined("Form.fOcodigo") and Len(Trim(Form.fOcodigo))>
					<cfset ofic = ListToArray(Form.fOcodigo, '|')>
				</cfif>
				<select name="fOcodigo" tabindex="3">
					<option value="">(Todas)</option>
					<cfif modo EQ "CAMBIO">
						<cfloop query="rsOficinas">
							<option value="#rsOficinas.Ecodigo#|#rsOficinas.Ocodigo#"<cfif isdefined("Form.fOcodigo") and Len(Trim(Form.fOcodigo)) and rsOficinas.Ecodigo EQ ofic[1] and rsOficinas.Ocodigo EQ ofic[2]> selected</cfif>>#rsOficinas.Odescripcion#</option>
						</cfloop>
					</cfif>
				</select>
			</td>
			<td align="center" colspan="9">
				<input type="submit" name="btnBuscar" value="Buscar" tabindex="3" class="btnFiltrar">
			</td>
		  </tr>
		  <tr>
		  <td colspan="12"> 
		  		<!---Solo muestra las 100 primeras lineas, si usan el Filtro se muestran las 500 primeras Lineas --->
			  	<cfset maxRow = 100>
				<cfif (isdefined("Form.fDescripcion") and Len(Trim(Form.fDescripcion))) or (isdefined("Form.fCformato") and Len(Trim(Form.fCformato))) or (isdefined("Form.fOcodigo") and Len(Trim(Form.fOcodigo)))>
					<cfset maxRow= 500>
				</cfif>
				<cfif modo EQ "CAMBIO">
					 <cfset LvarTotalDebitos = 0.00>
					 <cfset LvarTotalCreditos = 0.00>
					 <cfif isdefined("rsBalanceT") and rsBalanceT.recordcount gt 0>
						 <cfset LvarTotalDebitos = rsBalanceT.DebitosL>
						 <cfset LvarTotalCreditos = rsBalanceT.CreditosL>
					 </cfif>
					 	
						<cf_dbfunction name="to_char" args="a.DCIlinea" returnvariable="DCIlinea">
						<cf_dbfunction name="to_char" args="a.DCIconsecutivo" returnvariable="DCIconsecutivo">
						
						<cf_dbfunction name="concat" returnvariable="LvarBorrar" args="<img alt=''Borrar'' border=''0'' src=''/cfmx/sif/imagenes/Borrar01_S.gif'' onClick=''javascript:borrar('+#DCIlinea#+','+#DCIconsecutivo#+')''> " delimiters="+">
						
						<cfquery name="rsPoliza" datasource="#session.dsn#">
							<cf_dbrowcount1 rows="#maxRow#">
							
							select #preserveSingleQuotes(adicional)#
									 a.DCIlinea, 
									 a.ECIid as ECIid_F,
									 a.DCIconsecutivo,
									 a.Ddescripcion,
									 a.CFformato,
									 c.Mnombre,
									 case when a.Dmovimiento = 'D' then a.Dlocal else 0 end as Debitos,
									 case when a.Dmovimiento = 'C' then a.Dlocal else 0 end as Creditos,
									 '#preserveSingleQuotes(LvarBorrar)#' as IMGborrar,
									 d.Oficodigo as Odescripcion
									 #preservesinglequotes(campos_extra)#
							from DContablesImportacion a
								inner join Monedas c
									on c.Mcodigo = a.Mcodigo
								left join Oficinas d
									on d.Ecodigo = a.EcodigoRef
									and d.Ocodigo = a.Ocodigo
							where a.ECIid = #Form.ECIid#
							<cfif isdefined("Form.fDescripcion") and Len(Trim(Form.fDescripcion))>
								and upper(a.Ddescripcion) like '%#UCase(Form.fDescripcion)#%'
							</cfif> 
							<cfif isdefined("Form.fCformato") and Len(Trim(Form.fCformato))>
								and upper(a.CFformato) like '%#UCase(Form.fCformato)#%'
							</cfif>
							<cfif isdefined("Form.fOcodigo") and Len(Trim(Form.fOcodigo))>
								and a.EcodigoRef = #ofic[1]# and a.Ocodigo = #ofic[2]#
							</cfif>
							<cfif isdefined("Form.flinea") and Len(Trim(Form.flinea))>
								and a.DCIconsecutivo >= #form.flinea#
							</cfif>
							<cf_dbrowcount2_a rows="#maxRow#">
							    order by a.DCIconsecutivo 
							<cf_dbrowcount2_b rows="#maxRow#">
					
						</cfquery>
						
					 	<cfflush interval="128">
						 <cfinvoke component="sif.Componentes.pListas" method="pListaQuery"  returnvariable="pListaRet">
								<cfinvokeargument name="query" 				value="#rsPoliza#"/>	
								<cfinvokeargument name="desplegar" 			value="DCIconsecutivo, Ddescripcion, CFformato, Odescripcion, Mnombre, Debitos, Creditos, IMGborrar"/>
								<cfinvokeargument name="etiquetas" 			value="Línea, Descripción, Cuenta Financiera, Oficina, Moneda, Débitos, Créditos, "/>
								<cfinvokeargument name="formatos" 			value=" I, S, S, S, S, M, M, S"/>
								<cfinvokeargument name="align" 				value="center, left, left, left, left, right, right, center"/>
								<cfinvokeargument name="ajustar" 			value="N"/>
								<cfinvokeargument name="irA" 				value="DocContablesImportacion.cfm?a=a"/>
								<cfinvokeargument name="navegacion" 		value="#navegacion##params#">
								<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
								<cfinvokeargument name="MaxRows" 			value="30">
								<cfinvokeargument name="Incluyeform" 		value="true">
								<cfinvokeargument name="formname" 			value="filtroDetalle">
								<cfinvokeargument name="keys"				value="ECIid_F, DCIlinea">
								<cfinvokeargument name="totales" 			value="Debitos,Creditos">
								<cfinvokeargument name="pasarTotales" 		value="#LvarTotalDebitos#,#LvarTotalCreditos#">
						</cfinvoke>
				  </td>
				  </tr>

			</cfif>
		</table>
	</form>
</cfoutput>
<script language="JavaScript" type="text/javascript">
	<!--
		var popUpWin=0;
		function popUpWindow(URLStr, left, top, width, height)
		{
			if(popUpWin)
			{
			if(!popUpWin.closed) popUpWin.close();
			}

		//popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');		
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+''); }
		function doConlisDocsContablesImport() {
			popUpWindow("ConlisDocContablesImportacion.cfm?form=form1&ECIid=<cfoutput>#Form.ECIid#</cfoutput>",100,25,800,650);
		}
		
	//-->
</script>

<cfif modo EQ "CAMBIO">
	<script language="javascript" type="text/javascript">
		function borrar(idLinea, idConsecutivo){
			if((confirm('Desea eliminar la línea ' + idConsecutivo + ' del asiento contable ?')) && (idLinea != "")){
				document.filtroDetalle.nosubmit=true;										
				document.form1.DCIlinea.value = idLinea;
				document.form1.idConsecutivo.value = idConsecutivo;
				document.form1.borrarLista.value = 'S';
				document.form1.submit();
			}
			return false;							
		}
	</script>						
</cfif>

<br>

<script language="JavaScript" type="text/javascript">		
		if(document.form1.Ecodigo_Ccuenta){
			function CambiarOficina(){
				var oCombo   = document.form1.Ocodigo;
				var EcodigoI = document.form1.Ecodigo_Ccuenta.value;
				var cont = 0;
				oCombo.length=0;
				<cfif modo EQ "CAMBIO">
					<cfoutput query="rsOficinasDet">
					if ('#Trim(rsOficinasDet.Ecodigo)#' == EcodigoI ){
						oCombo.length=cont+1;
						oCombo.options[cont].value='#Trim(rsOficinasDet.Ocodigo)#';
						oCombo.options[cont].text='#Trim(rsOficinasDet.Odescripcion)#';
						<cfif  isdefined("rsLinea") and rsLinea.Ocodigo eq rsOficinasDet.Ocodigo >
							oCombo.options[cont].selected = true;
						</cfif>
					cont++;
					};
					</cfoutput>
				</cfif>
			}
			CambiarOficina();
		}	
		/* aquí asigna el hidden creado por el tag de monedas al objeto que realmente se va a usar como el tipo de cambio */
		<cfif modo NEQ "ALTA">
			if (document.form1.Mcodigo.value == "<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>") {
				formatCurrency(document.form1.TC,2);
				document.form1.Dtipocambio.disabled = true;			
			}		
			document.form1.Dtipocambio.value = document.form1.TC.value;
		</cfif>
		
		get_montoLocal();
	
		function valida(boton) {
		
			if (boton == "AgregarD") {
				var estado_Dtipocambio = document.form1.Dtipocambio.disabled;
				var estado_Doriginal = document.form1.Doriginal.disabled;
				var estado_Dlocal = document.form1.Dlocal.disabled;
				var estado_Cconcepto = document.form1.Cconcepto.disabled;
				var estado_Eperiodo = document.form1.Eperiodo.disabled;
				var estado_Emes = document.form1.Emes.disabled;
	
				document.form1.Dtipocambio.disabled = false;
				document.form1.Doriginal.disabled = false;
				document.form1.Dlocal.disabled = false;
				document.form1.Cconcepto.disabled = false;
				document.form1.Eperiodo.disabled = false;
				document.form1.Emes.disabled = false;
			}

			if (boton == "CambiarE") {
				<cfif modoDet NEQ "ALTA">
					objForm.Cconcepto.required = false;
					objForm.Edescripcion.required = false;
					objForm.Efecha.required = false;
					objForm.Edocbase.required = false;
					objForm.Ddocumento.required = false;
				</cfif>
				objForm.Ccuenta.required = false;
				objForm.CFcuenta.required = false;
				objForm.Ddescripcion.required = false;
				objForm.Ocodigo.required = false;
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
				
			// Activa o desactiva los campos que se necesitaban para el post, según el botón que se presionó
			if (dioError) {
				if (boton == "AgregarD") {				
					document.form1.Dtipocambio.disabled = estado_Dtipocambio;
					document.form1.Doriginal.disabled = estado_Doriginal;
					document.form1.Dlocal.disabled = estado_Dlocal;
					document.form1.Cconcepto.disabled = estado_Cconcepto;
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
			</cfif>
		}
		
		function Postear(){
			if (confirm('¿Desea aplicar este documento?')) {
				document.form1.Ccuenta.value = '-1';
				document.form1.CFcuenta.value = '-1';
				document.form1.Ddescripcion.value = '.';
				document.form1.Cconcepto.disabled = false;
				document.form1.Eperiodo.disabled = false;
				document.form1.Emes.disabled = false;
				var correcto = true;
				<cfif isdefined("rsBalanceO")>
				<cfloop query="rsBalanceO">
					<cfif rsBalanceO.Creditos - rsBalanceO.Debitos NEQ 0 or abs(rsBalanceO.CreditosL - rsBalanceO.DebitosL) GT rsBalanceO.HolguraL>
						<cfif Intercompany>
							alert('<cfoutput>#PolizaMon2# #rsBalanceO.Mnombre#</cfoutput>');
						<cfelse>
							alert('<cfoutput>#PolizaMon2# #rsBalanceO.Mnombre#</cfoutput> en la Oficina <cfoutput>#rsBalanceO.Odescripcion#!</cfoutput>');
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
	
	function _finalizar(){
		document.form1.Cconcepto.disabled = false;
		<cfif modo NEQ "ALTA">
			document.form1.Dlocal.value = qf(document.form1.Dlocal);
			document.form1.Doriginal.value = qf(document.form1.Doriginal);
		</cfif>
	}
	
	function deshabilitarValidacion(){
		<cfif modoDet NEQ "ALTA">			
			objForm.Cconcepto.required = false;
			objForm.Edescripcion.required = false;
			objForm.Efecha.required = false;
			objForm.Edocbase.required = false;
			objForm.Ddocumento.required = false;
		</cfif>
		objForm.Ccuenta.required = false;
		objForm.CFcuenta.required = false;
		objForm.Ddescripcion.required = false;
		objForm.Ocodigo.required = false;
	}
	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.Cconcepto.required = true;
	objForm.Cconcepto.description = "Concepto";
	objForm.Edescripcion.required = true;
	objForm.Edescripcion.description = "Descripción";
	objForm.Efecha.required = true;
	objForm.Efecha.description = "Fecha";
	objForm.Edocbase.required = true;
	objForm.Edocbase.description ="Documento";
	<cfif modo EQ "CAMBIO">
		<cfif modoDet NEQ "ALTA">			
			objForm.Cconcepto.required = true;
			objForm.Cconcepto.description ="Concepto";
			objForm.Edescripcion.required = true;
			objForm.Edescripcion.description = "Descripción";
			objForm.Efecha.required = true;
			objForm.Efecha.description = "Fecha";
			objForm.Edocbase.required = true;
			objForm.Edocbase.description = "Documento";
			objForm.Ddocumento.required = true;
			objForm.Ddocumento.description = "Documento";
		</cfif>
		objForm.Ccuenta.required = true;
		objForm.CFcuenta.required = true;
		objForm.Ccuenta.description = "Cuenta";
		objForm.CFcuenta.description = "Cuenta Financiera";
		objForm.Ddescripcion.required = true;
		objForm.Ddescripcion.description = "Descripción";
		objForm.Ocodigo.required = true;
		objForm.Ocodigo.description = "Oficina";
	</cfif>		
</script>
<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 27-9-2005.
			Motivo: Se corrige el filtro de la fecha que no levantaba el calendario.
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloCL  = t.Translate('LB_TituloCL','Lista de documentos','/sif/generales.xml')>
<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacci&oacute;n','/sif/generales.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento','/sif/cc/operacion/PagosCxC.xml')>
<cfset LB_De = t.Translate('LB_De','de','/sif/cc/operacion/ListaPagos.xml')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')> 
<cfset BTN_Filtrar = t.Translate('BTN_Filtrar','Filtrar','/sif/generales.xml')> 
<cfset BTN_Limpiar = t.Translate('BTN_Limpiar','Limpiar','/sif/generales.xml')> 
<cfset LB_SocioNegocio = t.Translate('LB_SocioNegocio','Socio de Negocios','/sif/generales.xml')>
<cfset LB_Todos = t.Translate('LB_Todos','(Todos)','/sif/cc/operacion/ListaPagos.xml')>
<cfset LB_FechaPago = t.Translate('LB_FechaPago','Fecha Pago','/sif/cc/operacion/ListaPagos.xml')>
<cfset LB_YRelacionados = t.Translate('LB_YRelacionados','y Relacionados','/sif/cc/operacion/ListaPagos.xml')>
<cfset LB_Cuota = t.Translate('LB_Cuota','Cuota','/sif/cc/operacion/ListaPagos.xml')>
<cfset LB_Saldo = t.Translate('LB_Saldo','Saldo','/sif/cc/operacion/ListaPagos.xml')>
<cfset LB_Mora = t.Translate('LB_Mora','Mora','/sif/cc/operacion/ListaPagos.xml')>
 
<html>
<head>
<title="#LB_TituloCL#"></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<cfif isdefined("Url.fSNnombre") and not isdefined("Form.fSNnombre")>
	<cfparam name="Form.fSNnombre" default="#Url.fSNnombre#">
</cfif>
<cfif isdefined("Url.GSNid") and Url.GSNid gt 0 and not isdefined("Form.GSNid")>
	<cfparam name="Form.GSNidm" default="#Url.GSNid#">
</cfif>
<cfif isdefined("Url.GSNidm") and Url.GSNidm gt 0 and not isdefined("Form.GSNidm")>
	<cfparam name="Form.GSNidm" default="#Url.GSNidm#">
</cfif>

<cfif isdefined("Url.CCTcodigoConlis") and not isdefined("Form.CCTcodigoConlis")>
	<cfparam name="Form.CCTcodigoConlis" default="#Url.CCTcodigoConlis#">
</cfif>

<cfif isdefined("Url.DatoCCTcodigo") and not isdefined("Form.DatoCCTcodigo")>
	<cfparam name="Form.CCTcodigo" default="#Url.DatoCCTcodigo#">
</cfif>

<cfif isdefined("Url.id") and not isdefined("Form.id")>
	<cfparam name="Form.id" default="#Url.id#">
</cfif>

<cfif isdefined("Url.desc") and not isdefined("Form.desc")>
	<cfparam name="Form.desc" default="#Url.desc#">
</cfif>

<cfif isdefined("Url.form") and not isdefined("Form.form")>
	<cfparam name="Form.form" default="#Url.form#">
</cfif> 

<cfif isdefined("Url.name") and not isdefined("Form.name")>
	<cfparam name="Form.name" default="#Url.name#">
</cfif> 

<cfif isdefined("Url.SNcodigo") and not isdefined("Form.SNcodigo")>
	<cfparam name="Form.SNcodigo" default="#Url.SNcodigo#">
</cfif>
<cfif isdefined("Url.Ddocumento") and not isdefined("Form.Ddocumento")>
	<cfparam name="Form.Ddocumento" default="#Url.Ddocumento#">
</cfif>
<cfif isdefined("Url.Mcodigo") and not isdefined("Form.Mcodigo")>
	<cfparam name="Form.Mcodigo" default="#Url.Mcodigo#">
</cfif>
<cfif isdefined("Url.Dfecha") and not isdefined("Form.Dfecha")>
	<cfparam name="Form.Dfecha" default="#Url.Dfecha#">
</cfif>

<!--- <cfset filtro = ""> --->
<cfset navegacion = "">

<cfif isdefined("Form.GSNid") and Form.GSNid gt 0 and not isdefined("url.GSNid")>
	<cfparam name="url.GSNidm" default="#Form.GSNid#">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "GSNid=" & form.GSNid>	
</cfif>
<!--- esta varible pasa el nombre del campo () --->
<cfif isdefined("Form.CCTcodigoConlis") and Len(Trim(Form.CCTcodigoConlis)) NEQ 0 and not isdefined("url.CCTcodigoConlis")>
	<cfparam name="url.CCTcodigoConlis" default="#Form.CCTcodigoConlis#">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CCTcodigoConlis=" & form.CCTcodigoConlis>	
</cfif>

<!--- esta varible pasa el valor del campo (ok) --->
<cfif isdefined("Form.DatoCCTcodigo") and Len(Trim(Form.DatoCCTcodigo)) NEQ 0 and not isdefined("url.DatoCCTcodigo")>
	<cfparam name="url.CCTcodigo" default="#Form.DatoCCTcodigo#">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DatoCCTcodigo=" & form.DatoCCTcodigo>	
</cfif>

<cfif isdefined("Form.fSNnombre") and Form.fSNnombre gt 0>
	<cfparam name="url.fSNnombre" default="#Form.fSNnombre#">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fSNnombre=" & form.fSNnombre>	
</cfif>


<cfif isdefined("form.id") and Len(Trim(Form.id)) NEQ 0 and not isdefined("url.id")>
	<cfparam name="url.id" default="#form.id#">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "id=" & form.id>	
</cfif>

<cfif isdefined("form.desc") and Len(Trim(Form.desc)) NEQ 0 and not isdefined("url.desc")>
	<cfparam name="url.desc" default="#form.desc#">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "desc=" & form.desc>	
</cfif>

<cfif isdefined("form.form") and Len(Trim(Form.form)) NEQ 0 and not isdefined("url.form")>
	<cfparam name="url.form" default="#form.form#">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "form=" & form.form>	
</cfif> 

<cfif isdefined("form.name") and Len(Trim(Form.name)) NEQ 0 and not isdefined("url.name")>
	<cfparam name="url.name" default="#form.name#">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "name=" & form.name>	
</cfif>

<cfif isdefined("form.SNcodigo") and Len(Trim(Form.SNcodigo)) NEQ 0 and not isdefined("url.SNcodigo")>
	<cfparam name="url.SNcodigo" default="#form.SNcodigo#">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SNcodigo=" & form.SNcodigo>	
</cfif>

<cfif isdefined("form.Ddocumento") and Len(Trim(Form.Ddocumento)) NEQ 0 and not isdefined("url.Ddocumento")>
	<cfparam name="url.Ddocumento" default="#form.Ddocumento#">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Ddocumento=" & form.Ddocumento>	
</cfif>

<cfif isdefined("Form.Mcodigo") and Len(Trim(Form.Mcodigo)) NEQ 0 and not isdefined("url.Mcodigo")>
	<cfparam name="url.Mcodigo" default="#Form.Mcodigo#">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Mcodigo=" & form.Mcodigo>
</cfif>

<cfif isdefined("Form.Dfecha") and Len(Trim(Form.Dfecha)) NEQ 0 and not isdefined("url.Dfecha")>
	<cfparam name="url.Dfecha" default="#Form.Dfecha#">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Dfecha=" & form.Dfecha>
</cfif>

<script language="JavaScript" src="../js/calendar.js"></script>
<script language="JavaScript" src="../js/utilesMonto.js"></script>

<!--- Calculo de intereses moratorios para el cliente especificado en form.SNcodigo	--->
<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
	<cfquery datasource="#session.dsn#" name="rsExistenporActualizar">
		select count(1) as Cantidad
		from Documentos d
			inner join CCTransacciones t
					on t.CCTcodigo = d.CCTcodigo
					and t.Ecodigo = d.Ecodigo
					and t.CCTtipo = 'D'
			inner join PlanPagos pp
					 on pp.Ecodigo = d.Ecodigo
					and pp.CCTcodigo = d.CCTcodigo
					and pp.Ddocumento = d.Ddocumento
					and pp.PPtasamora > 0
					and pp.PPfecha_pago is null
		where d.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
		  and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>

	<cfif rsExistenporActualizar.Cantidad GT 0>
		<cfquery datasource="#session.dsn#">
			update PlanPagos
				set PPpagomora = case when datediff (dd, PPfecha_vence, getdate()) <= 0
					<!---  cuota no ha vencido  --->
					then 0
				else
					<!---  cuota vencida, calcular intereses moratorios  --->
					round (datediff (dd, PPfecha_vence, getdate()) * PPtasamora * PPsaldoant / 36000, 2)
				end
			from Documentos d
				inner join CCTransacciones t
					 on t.CCTcodigo = d.CCTcodigo
					and t.Ecodigo = d.Ecodigo
					and t.CCTtipo = 'D'
				inner join PlanPagos pp
					 on pp.Ecodigo = d.Ecodigo
					and pp.CCTcodigo = d.CCTcodigo
					and pp.Ddocumento = d.Ddocumento
			where d.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
			  and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and pp.PPfecha_pago is null
			  and pp.PPtasamora > 0
		</cfquery>
	</cfif> 
	
	<!--- Busca el "SNidPadre", el nombre de SN y el grupo--->
	<cfquery name="rsNombreSocio" datasource="#Session.DSN#">
		select SNid, SNnombre, GSNid, SNidPadre
		from SNegocios
		where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
</cfif>

<cfquery name="rsTransacciones" datasource="#Session.DSN#">
	select CCTcodigo, CCTdescripcion 
	from CCTransacciones 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	  and CCTtipo = 'D' 
	  and coalesce(CCTpago, 0) < 1
	  and coalesce(CCTvencim, 0) > -1
	  and NOT CCTdescripcion like '%Tesorer_a%'
	order by CCTcodigo 
</cfquery>

<cfquery name="rsMonedas" datasource="#Session.DSN#">
	select 
		b.Mcodigo, 
		b.Mnombre, 
		case when b.Mcodigo = e.Mcodigo then 1 else 2 end as Orden
	from Empresas e
		inner join Monedas b 
			on b.Ecodigo = e.Ecodigo
	where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	order by Orden, b.Mnombre
</cfquery>

<cfquery name="rsParametroCcuentaTransitoConlis" datasource="#session.DSN#">
		select Pvalor, Pdescripcion
		from Parametros 
		where Pcodigo = 650
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfif rsParametroCcuentaTransitoConlis.Pvalor eq ''>
	<cf_errorCode	code = "50159" msg = "La Cuenta Depsitos en Trnsito no est defnida.">
</cfif>
	
<cfquery name="conlis" datasource="#Session.DSN#" maxrows="1000">
	select 
			a.Mcodigo, 
			b.Ccuenta as Ccuenta, 
			left(c.Cdescripcion, 40) as Cdescripcion,
			Dtipocambio, 
			coalesce (b.Rcodigo, '%') as Rcodigo,
			<cf_dbfunction name="concat" args="rtrim( b.CCTcodigo + '-' + rtrim(b.Ddocumento) +'-' + a.Mnombre)" delimiters= '+'> as Descripcion,
			a.Mnombre, 
			b.Dfecha, 
			d.CCTcodigo, 
			rtrim(b.Ddocumento) as Ddocumento,
			b.Dsaldo,
			(
					select min(pp.PPnumero)
					from PlanPagos pp
					where pp.Ecodigo = b.Ecodigo
					  and pp.CCTcodigo = b.CCTcodigo
					  and pp.Ddocumento = b.Ddocumento
					  and pp.PPfecha_pago is null <!--- documentos sin pagar --->
			) as PPnumero,
			
			coalesce( (
					select sum(pp.PPprincipal + pp.PPinteres)
					from PlanPagos pp
					where pp.Ecodigo    = b.Ecodigo
					  and pp.CCTcodigo  = b.CCTcodigo
					  and pp.Ddocumento = b.Ddocumento
					  and pp.PPnumero   = (
										select min(pp2.PPnumero)
										from PlanPagos pp2
										where pp2.Ecodigo = b.Ecodigo
										  and pp2.CCTcodigo = b.CCTcodigo
										  and pp2.Ddocumento = b.Ddocumento
										  and pp2.PPfecha_pago is null <!--- documentos sin pagar --->
					  						)
					  and pp.PPfecha_pago is null  		<!--- documentos sin pagar --->
			), 0) - (isnull(b.EDMRetencion,0))as MontoCuota,
			
			coalesce( (
					select sum(pp.PPpagomora)
					from PlanPagos pp
					where pp.Ecodigo    = b.Ecodigo
					  and pp.CCTcodigo  = b.CCTcodigo
					  and pp.Ddocumento = b.Ddocumento
					  and pp.PPnumero   = (
										select min(pp2.PPnumero)
										from PlanPagos pp2
										where pp2.Ecodigo = b.Ecodigo
										  and pp2.CCTcodigo = b.CCTcodigo
										  and pp2.Ddocumento = b.Ddocumento
										  and pp2.PPfecha_pago is null <!--- documentos sin pagar --->
					  						)
					  and pp.PPfecha_pago is null  		<!--- documentos sin pagar --->
			),0) as InteresMora,
			
			(
					select min(pp.PPfecha_vence)
					from PlanPagos pp
					where pp.Ecodigo    = b.Ecodigo
					  and pp.CCTcodigo  = b.CCTcodigo
					  and pp.Ddocumento = b.Ddocumento
					  and pp.PPnumero   = (
										select min(pp2.PPnumero)
										from PlanPagos pp2
										where pp2.Ecodigo = b.Ecodigo
										  and pp2.CCTcodigo = b.CCTcodigo
										  and pp2.Ddocumento = b.Ddocumento
										  and pp2.PPfecha_pago is null <!--- documentos sin pagar --->
					  						)
					  and pp.PPfecha_pago is null  		<!--- documentos sin pagar --->
			) as PPfecha_vence,
				
			'' as codigo,

			f.SNnombre
			from Documentos b

				inner join SNegocios f
					 on b.Ecodigo=f.Ecodigo 
					and b.SNcodigo = f.SNcodigo

				inner join CContables c
					on c.Ccuenta = b.Ccuenta
					
				inner join Monedas a
					on a.Mcodigo = b.Mcodigo 

				inner join CCTransacciones d
					 on d.Ecodigo = b.Ecodigo 
					and d.CCTcodigo = b.CCTcodigo 
					and d.CCTtipo = 'D'
					and coalesce( d.CCTpago, 0) < 1
					and coalesce( d.CCTvencim, 0) > -1
					
			where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
			  and b.Dsaldo > 0 

			  and not exists (
					select 1 
					from DPagos h
					where h.Ecodigo = b.Ecodigo
					  and h.Doc_CCTcodigo = b.CCTcodigo
					  and h.Ddocumento = b.Ddocumento
				)
			  and not exists (select 1
							from DFavor z 
							where z.CCTRcodigo = b.CCTcodigo
								and z.DRdocumento = b.Ddocumento
								and z.Ecodigo = b.Ecodigo
							)
				<!---Cambio para que no tome los documentos que se encuentran en alguna lista de Generacion de Recibos--->
				and not exists (
				select 1
					from DAgrupador g
						where g.Ecodigo=b.Ecodigo
						and g.CCTcodigo=b.CCTcodigo
						and g.Ddocumento=b.Ddocumento
						and g.DdocumentoId=b.DdocumentoId
				)
       			<!---****--->
				<cfif isdefined("Form.CCTcodigo") and (Len(Trim(Form.CCTcodigo)) NEQ 0) and (Form.CCTcodigo NEQ "-1")>
				and b.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">
				</cfif>
			
				<cfif isdefined("Form.Ddocumento") and (Len(Trim(Form.Ddocumento)) NEQ 0)>
				and upper(b.Ddocumento) like '%#Ucase(Form.Ddocumento)#%'
				</cfif>
			
				<cfif isdefined("Form.Mcodigo") and (Len(Trim(Form.Mcodigo)) NEQ 0) and (Form.Mcodigo NEQ "-1")>
				and b.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">
				</cfif>
			
				<cfif isdefined("Form.Dfecha") and Len(Trim(Form.Dfecha)) >
				and b.Dfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.Dfecha)#">
				</cfif>

				<cfif isdefined("Form.GSNidm") and Len(Trim(Form.GSNidm))>
				and f.GSNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.GSNidm#">
				</cfif>
			
			
				<cfif isdefined("Form.fSNnombre") and Len(Trim(Form.fSNnombre))>
				and upper(rtrim(f.SNnombre)) like '%#ucase(trim(Form.fSNnombre))#%'
				</cfif>

				<cfif isdefined("rsNombreSocio") and rsNombreSocio.recordcount gt 0 and rsNombreSocio.SNid NEQ ''>
				<!--- Para no utilizar un "Union all"  se usa el or en este caso particular --->
					and (f.SNidPadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNombreSocio.SNid#"> OR f.SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNombreSocio.SNid#">)
				<cfelse>
					<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
						and b.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#"> 
					</cfif>
				</cfif>
<!---			order by b.Dfecha, b.Mcodigo, b.Dsaldo desc, b.CCTcodigo, b.Ddocumento --->
			order by b.Ddocumento
</cfquery>

<cfloop query="conlis"> 
	<!--- OBTENCION DEL TIPO DE CAMBIO HISTORICO --->
	<cfquery name="rsTipoCambioH" datasource="#session.DSN#">
		SELECT top 1 TCventa
		FROM Htipocambio
		WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		  AND Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Mcodigo#">
		ORDER BY Hfecha DESC
	</cfquery>
	<cfset lVarTC = 0>
	<cfif rsTipoCambioH.RecordCount GT 0>
		<cfset lVarTC = rsTipoCambioH.TCventa>
	</cfif>
	<cfset QuerySetCell(conlis, 'codigo', 
	Mcodigo &'|'&
	CCTcodigo &'|'&
	rtrim(Ddocumento) &'|'& 
	Ccuenta &'|'&
	Dtipocambio &'|'& 
	(MontoCuota + InteresMora ) &'|'&
	Cdescripcion &'|'&
	rtrim(Rcodigo) &'|'&
	PPnumero &'|'&
	Dsaldo &'|'&
	lVarTC, CurrentRow)>
</cfloop>

 <script language="JavaScript" type="text/javascript"> 
	function Asignar(cod,desc,name,tipo) { 	

		if (window.opener) {
			<cfoutput>
			window.opener.document.#url.form#.#url.desc#.value = desc;
			window.opener.document.#url.form#.#url.name#.value = name;
			

			window.opener.document.#url.form#.Cod#url.id#.value = cod;


		//Esto selecciona en el campo del combo del tag sifDocsPagoCxC el tipo de documento que se seleccion en el conlis 
		if (window.opener.document.#url.form#.#url.CCTcodigoConlis#.options) {
			for (var i = 0; i < window.opener.document.#url.form#.#url.CCTcodigoConlis#.options.length; i++) {
				if (window.opener.document.#url.form#.#url.CCTcodigoConlis#.options[i].value == tipo) {
					window.opener.document.#url.form#.#url.CCTcodigoConlis#.options.selectedIndex = i;
				}
			}
		}
		// Meter luego el id (SNcodigo2)
		if (window.opener.func#url.name#) { window.opener.func#url.name#(); }
		</cfoutput>
		window.close();
		}
	}
	function Limpiar(f) {
		f.CCTcodigo.selectedIndex = 0;
		f.Mcodigo.selectedIndex = 0;
		f.Ddocumento.value = "";
		f.Dfecha.value = "";
		f.fSNnombre.value= "";
	}
	
</script>


<style type="text/css">
	.encabezado {
		font-weight: bold; 
		font-size: x-small; 
		background-color: #F5F5F5;
	}
	.encabReporte {
		background-color: #006699;
		font-weight: bold;
		color: #FFFFFF;
		padding-top: 3px;
		padding-bottom: 3px;
	}
</style>

<cfform action="ConlisDocsPagoCxC.cfm" name="conlis" method="post">
  <table width="100%" border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td colspan="5" class="tituloAlterno">
		<cfif isdefined("rsNombreSocio") and rsNombreSocio.recordcount gt 0 and rsNombreSocio.SNid NEQ '' and rsNombreSocio.SNidPadre EQ ''>
			<cfoutput>#LB_Documento#&nbsp;#LB_De#&nbsp;#rsNombreSocio.SNnombre#&nbsp;#LB_YRelacionados#</cfoutput>
		<cfelseif isdefined("form.SNcodigo") and form.SNcodigo gt 0>
			<cfoutput>#LB_Documento#&nbsp;#LB_De#&nbsp;#rsNombreSocio.SNnombre#</cfoutput>
		</cfif>
		</td>
	</tr>
    <tr> 
      <td align="center" class="encabezado"><cfoutput>#LB_Transaccion#</cfoutput></td>
      <td align="center" class="encabezado"><cfoutput>#LB_Documento#</cfoutput></td>
      <td align="center" class="encabezado"><cfoutput>#LB_Moneda#</cfoutput></td>
      <td align="center" class="encabezado"><cfoutput>#LB_Fecha#</cfoutput></td>
	  <cfif isdefined("rsNombreSocio") and rsNombreSocio.recordcount gt 0 and rsNombreSocio.SNid NEQ '' and rsNombreSocio.SNidPadre EQ ''>
	  	<td align="center" class="encabezado"><cfoutput>#LB_SocioNegocio#</cfoutput></td>
	  <cfelseif not (isdefined("form.SNcodigo") and form.SNcodigo gt 0)> 
	  	<td align="center" class="encabezado"><cfoutput>#LB_SocioNegocio#</cfoutput></td>
	  </cfif>
    </tr>
    <tr> 
      <td align="center"> 
        <select name="CCTcodigo" id="CCTcodigo">
          <option value="-1" <cfif isdefined("Form.CCTcodigo") AND Form.CCTcodigo EQ "-1">selected</cfif>><cfoutput>#LB_Todos#</cfoutput></option>
          <cfoutput query="rsTransacciones"> 
            <option value="#CCTcodigo#" <cfif isdefined("Form.CCTcodigo") AND rsTransacciones.CCTcodigo EQ Form.CCTcodigo>selected</cfif>>#CCTcodigo#</option>
          </cfoutput> 
        </select>
      </td>
      <td align="center">
	  	<input name="Ddocumento" type="text" id="Ddocumento" size="30" alt="El Documento" value="<cfif isdefined("Form.Ddocumento")><cfoutput>#Form.Ddocumento#</cfoutput></cfif>">
	  </td>
      <td align="center">
        <select name="Mcodigo" id="Mcodigo">
          <option value="-1" <cfif isdefined("Form.Mcodigo") AND Form.Mcodigo EQ "-1">selected</cfif>><cfoutput>#LB_Todos#</cfoutput></option>
          <cfoutput query="rsMonedas"> 
            <option value="#Mcodigo#" <cfif isdefined("Form.Mcodigo") AND rsMonedas.Mcodigo EQ Form.Mcodigo>selected</cfif>>#Mnombre#</option>
          </cfoutput> 
        </select>
	  </td>
        <td align="center" nowrap>
			<cfif isdefined("form.Dfecha") and len(trim(form.Dfecha))>
            	<cf_sifcalendario name="Dfecha" value="#LSDateFormat(form.Dfecha,'dd/mm/yyyy')#" tabindex="1">
            <cfelse>
            	<cf_sifcalendario name="Dfecha" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1">
            </cfif>
      </td>
	  <cfif isdefined("rsNombreSocio") and rsNombreSocio.recordcount gt 0 and rsNombreSocio.SNid NEQ '' and rsNombreSocio.SNidPadre EQ ''>
		  <td align="center">
			<input name="fSNnombre" type="text" id="fSNnombre" size="30" value="<cfif isdefined("Form.fSNnombre")><cfoutput>#Form.fSNnombre#</cfoutput></cfif>">
		  </td>
	  <cfelseif not (isdefined("form.SNcodigo") and form.SNcodigo gt 0)> 
  		  <td align="center">
			<input name="fSNnombre" type="text" id="fSNnombre" size="30" value="<cfif isdefined("Form.fSNnombre")><cfoutput>#Form.fSNnombre#</cfoutput></cfif>">
		  </td>
	  </cfif>
    </tr>

    <tr align="center"> 
      <td colspan="5"> 
		<input name="GSNidm" type="hidden" id="GSNidm" value="<cfif isdefined("Form.GSNidm")><cfoutput>#Form.GSNidm#</cfoutput></cfif>">
	 	<input name="CCTcodigoConlis" type="hidden" id="CCTcodigoConlis" value="<cfif isdefined("Form.CCTcodigoConlis")><cfoutput>#Form.CCTcodigoConlis#</cfoutput></cfif>">
        <input name="id" type="hidden" id="id" value="<cfif isdefined("Form.id")><cfoutput>#Form.id#</cfoutput></cfif>">
        <input name="desc" type="hidden" id="desc" value="<cfif isdefined("Form.desc")><cfoutput>#Form.desc#</cfoutput></cfif>">
		<input name="name" type="hidden" id="name" value="<cfif isdefined("Form.name")><cfoutput>#Form.name#</cfoutput></cfif>">
        <input name="form" type="hidden" id="form" value="<cfif isdefined("Form.form")><cfoutput>#Form.form#</cfoutput></cfif>">
        <input name="SNcodigo" type="hidden" id="SNcodigo" value="<cfif isdefined("Form.SNcodigo")><cfoutput>#Form.SNcodigo#</cfoutput></cfif>">
        <input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
        <input name="btnLimpiar" type="button" id="btnLimpiar" value="Limpiar" onClick="javascript:Limpiar(this.form);">
      </td>
    </tr>
    <tr> 
      <td colspan="5"> 
	  <cfinvoke 
		component="sif.Componentes.pListas"
		method="pListaQuery"
		returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#conlis#"/>
			<cfif isdefined("rsNombreSocio") and rsNombreSocio.recordcount gt 0 and rsNombreSocio.SNid NEQ '' and rsNombreSocio.SNidPadre EQ ''>
				<cfinvokeargument name="desplegar" value="CCTcodigo,Ddocumento,PPnumero,Mnombre,Dsaldo,MontoCuota,InteresMora,Dfecha,PPfecha_vence,SNnombre"/>
				<cfinvokeargument name="etiquetas" value="#LB_Transaccion#,#LB_Documento#,#LB_Cuota#,#LB_Moneda#,#LB_Saldo#,#LB_Cuota#,#LB_Mora#,#LB_Fecha#,#LB_FechaPago#,#LB_SocioNegocio#"/>
				<cfinvokeargument name="formatos" value="S,S,S,S,M,M,M,D,D,S"/>
				<cfinvokeargument name="align" value="left,left,left,left,left,left,left,left,left,left"/>
			<cfelseif isdefined("form.SNcodigo") and form.SNcodigo gt 0> 
				<cfinvokeargument name="desplegar" value="CCTcodigo,Ddocumento,PPnumero,Mnombre,Dsaldo,MontoCuota,InteresMora,Dfecha,PPfecha_vence"/>
				<cfinvokeargument name="etiquetas" value="#LB_Transaccion#,#LB_Documento#,#LB_Cuota#,#LB_Moneda#,#LB_Saldo#,#LB_Cuota#,#LB_Mora#,#LB_Fecha#,#LB_FechaPago#"/>
				<cfinvokeargument name="formatos" value="S,S,S,S,M,M,M,D,D"/>				
				<cfinvokeargument name="align" value="left,left,left,left,left,left,left,left,left"/>
			<cfelse>
				<cfinvokeargument name="desplegar" value="CCTcodigo,Ddocumento,PPnumero,Mnombre,Dsaldo,MontoCuota,InteresMora,Dfecha,PPfecha_vence,SNnombre"/>
				<cfinvokeargument name="etiquetas" value="#LB_Transaccion#,#LB_Documento#,#LB_Cuota#,#LB_Moneda#,#LB_Saldo#,#LB_Cuota#,#LB_Mora#,#LB_Fecha#,#LB_FechaPago#,#LB_SocioNegocio#"/>
				<cfinvokeargument name="formatos" value="S,S,S,S,M,M,M,D,D,S"/>
				<cfinvokeargument name="align" value="left,left,left,left,left,left,left,left,left,left"/>
			</cfif>
			<cfinvokeargument name="ajustar" value="S"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="keys" value="Ddocumento"/> 
			<cfinvokeargument name="showEmptyListMsg" value= "1"/>
			<cfinvokeargument name="checkboxes" value="N"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="incluyeform" value="false">
			<cfinvokeargument name="formname" value="lista"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="Codigo,Descripcion,Ddocumento,CCTcodigo"/>
			<!--- <cfinvokeargument name="botones" value="Nuevo, Eliminar"/> --->
			<cfinvokeargument name="irA" value= "ConlisDocsPagoCxC"/>
	</cfinvoke>
      </td>
    </tr>
  </table>
</cfform>
</body>
</html>




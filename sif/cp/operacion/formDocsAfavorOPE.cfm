<!---
	Modificado por: Ana Villavicencio
	Fecha: 31 de octubre del 2005
	Motivo: Correccion de error de disponible, Error de redondeo.

	Modificado por: Ana Villavicencio
	Fecha: 02 de noviembre del 2005
	Motivo: Mejora en la forma del manejo de los datos y el despliegue de los mismos.
			Uso de los nuevos componentes de listas y conlis
			Mejora en las consultas.
 --->

<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>
<cfif not isdefined("Form.modoDet")>
	<cfset modoDet = "ALTA">
</cfif>
<cfif isDefined("Form.NuevoE")>
	<cfset modo = "ALTA">
	<cfset modoDet = "ALTA">
<cfelseif isDefined("Form.datos") and Form.datos NEQ "">
	<cfset modo = "CAMBIO">
	<cfset modoDet = "ALTA">
</cfif>

<cfset IDpago = "">
<cfset DAlinea = "">

<cfif not isDefined("Form.NuevoE")>
	<cfif isDefined("Form.datos") and Len(Trim(Form.datos)) NEQ 0 >
		<cfset arreglo = ListToArray(Form.datos,"|")>
		<cfset sizeArreglo = ArrayLen(arreglo)>
		<cfset IDpago = Trim(arreglo[1])>
 		<cfif sizeArreglo EQ 2>
			<cfset DAlinea = Trim(arreglo[2])>
			<cfset modoDet = "CAMBIO">
		</cfif>
	<cfelseif isdefined("Form.IDpago")>
		<cfset IDpago = Trim(Form.IDpago)>
		<cfif isDefined("Form.DAlinea") and Len(Trim(Form.DAlinea)) NEQ 0>
			<cfset DAlinea = Trim(Form.DAlinea)>
		</cfif>
	</cfif>
</cfif>

<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select Mcodigo as Mcodigo
	from Empresas
	where Ecodigo =  #Session.Ecodigo#
</cfquery>
<cfif modo NEQ "ALTA">
<cf_dbfunction name="to_char"     args="a.ID"      returnvariable="ID">
<cf_dbfunction name="to_sdateDMY" args="a.EAfecha" returnvariable="EAfecha">
	<cfset sql ="
			select
				a.Ecodigo as Ecodigo,
				a.CPTcodigo as CPTcodigo,
				rtrim(a.Ddocumento) as Ddocumento,
				a.SNcodigo,
				b.SNnumero,
				b.SNnombre,
				a.Mcodigo,
				c.Mnombre,
				a.EAtipocambio,
				a.EAtotal,
				a.EAselect,
				#EAfecha# as EAfecha,
				#ID# as IDpago,
				a.ts_rversion
		from EAplicacionCP a
		inner join SNegocios b
		  on b.Ecodigo = a.Ecodigo
		 and b.SNcodigo = a.SNcodigo

		inner join Monedas c
		  on c.Ecodigo = a.Ecodigo
		 and c.Mcodigo = a.Mcodigo
        where a.Ecodigo = #Session.Ecodigo#
		  and a.ID  = #IDpago#">

	<cfquery name="rsDocumento" datasource="#Session.DSN#">
		#preserveSingleQuotes(sql)#
	</cfquery>

	<cfquery name="rsCalculaSaldo" datasource="#Session.DSN#">
		select <cf_dbfunction name="to_char" args="coalesce(a.EDsaldo, 0.00)"> as EDsaldo
        from EDocumentosCP a
        where a.Ecodigo =  #Session.Ecodigo#
		  and a.CPTcodigo = '#rsDocumento.CPTcodigo#'
          and rtrim(a.Ddocumento) = rtrim('#rsDocumento.Ddocumento#')
		<cfif rsDocumento.recordcount GT 0>
          and a.SNcodigo = #rsDocumento.SNcodigo#
		</cfif>
	</cfquery>

	<cfquery name="rsTieneLineas" datasource="#Session.DSN#">
		select
			<cf_dbfunction name="to_char" args="ID"> as ID,
			<cf_dbfunction name="to_char" args="DAlinea"> as DAlinea,
			Ecodigo,
			SNcodigo,
			<cf_dbfunction name="to_char" args="DAidref"> as DAidref,
			DAtransref,
			DAdocref,
			DAmonto,
			DAtotal,
			DAmontodoc,
			DAtipocambio,
			ts_rversion
		from DAplicacionCP  a
		where a.Ecodigo =  #Session.Ecodigo#
		<cfif isDefined("Form.IDpago") and Len(Trim(Form.IDpago)) NEQ 0 >
		  	and a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDpago#">
		  </cfif>
	</cfquery>

	<cfquery name="rsAplicado" datasource="#Session.DSN#">
		select coalesce(sum(DAmonto),0.00) as DAmonto
		from DAplicacionCP
		where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDpago#">
		<cfif modo NEQ "ALTA" and modoDet NEQ "ALTA">
		and DAlinea != <cfqueryparam cfsqltype="cf_sql_numeric" value="#DAlinea#">
		</cfif>
	</cfquery>

	 <cfif modoDet NEQ "ALTA">

		<cfquery name="rsLinea" datasource="#Session.DSN#">
		 	select
				ID,
				DAlinea,
				d.Ecodigo,
				d.SNcodigo,
				DAidref,
				DAtransref,
				DAdocref,
				DAmonto,
				DAtotal,
				DAmontodoc,
				DAtipocambio,
				d.ts_rversion,
				CPTcodigo, m.Mnombre
				from DAplicacionCP da
				inner join EDocumentosCP d
				  on  d.Ecodigo = da.Ecodigo
				  and d.IDdocumento = da.DAidref
				inner join Monedas m
				   on d.Ecodigo = m.Ecodigo
				  and d.Mcodigo = m.Mcodigo
		 	where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDpago#">
			  and DAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DAlinea#">
		</cfquery>
		<cfquery name="rsMontolinea" datasource="#Session.DSN#">
		 	select DAmonto from DAplicacionCP
		 	where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDpago#">
			  and DAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DAlinea#">
		</cfquery>
		<cfquery name="rsMoneda" datasource="#Session.DSN#">
		 	select
				<cf_dbfunction name="to_char" args="b.Mcodigo"> as Mcodigo,
				c.Mnombre
			from DAplicacionCP a
			inner join EDocumentosCP b
			   on b.Ecodigo = a.Ecodigo
			  and b.IDdocumento = a.DAidref
			inner join Monedas c
			   on c.Ecodigo = a.Ecodigo
			  and c.Mcodigo = b.Mcodigo
            where a.Ecodigo =  #Session.Ecodigo# and a.DAidref = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLinea.DAidref#">
		</cfquery>
	</cfif>
</cfif>
<script language="JavaScript" src="../../js/utilesMonto.js"></script>
<script language="JavaScript" src="../../js/calendar.js"></script>
<script language="JavaScript" src="../../js/qForms/qforms.js"></script>
<script language="JavaScript">
 	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	botonActual = "";

	function setBtn(boton) {
		botonActual = boton.name;
	}

	function btnSelected(name) {
		return (botonActual == name)
	}

//-----------------------------------------------------------------------------------------------------------

	function Lista() {
		var params   = '?pageNum_Lista='+document.form1.pageNum_Lista.value;
			params += (document.form1.filtro_CPTdescripcion.value != '') ? "&filtro_CPTdescripcion=" + document.form1.filtro_CPTdescripcion.value : '';
			params += (document.form1.filtro_Ddocumento.value != '') ? "&filtro_Ddocumento=" + document.form1.filtro_Ddocumento.value : '';
			params += (document.form1.filtro_EAfecha.value != '') ? "&filtro_EAfecha=" + document.form1.filtro_EAfecha.value : '';
			params += (document.form1.filtro_EAusuario.value != '') ? "&filtro_EAusuario=" + document.form1.filtro_EAusuario.value : '';
			params += (document.form1.filtro_Mnombre.value != -1) ? "&filtro_Mnombre=" + document.form1.filtro_Mnombre.value : '';

			params += (document.form1.hfiltro_CPTdescripcion.value != '') ? "&hfiltro_CPTdescripcion=" + document.form1.hfiltro_CPTdescripcion.value : '';
			params += (document.form1.hfiltro_Ddocumento.value != '') ? "&hfiltro_Ddocumento=" + document.form1.hfiltro_Ddocumento.value : '';
			params += (document.form1.hfiltro_EAfecha.value != '') ? "&hfiltro_EAfecha=" + document.form1.hfiltro_EAfecha.value : '';
			params += (document.form1.hfiltro_EAusuario.value != '') ? "&hfiltro_EAusuario=" + document.form1.hfiltro_EAusuario.value : '';
			params += (document.form1.hfiltro_Mnombre.value != -1) ? "&hfiltro_Mnombre=" + document.form1.hfiltro_Mnombre.value : '';

		location.href="listaDocsAfavor.cfm"+params;
	}

	function validaForm(f) {
		if (btnSelected("AgregarD") || btnSelected("CambiarD")) {
			f.EAtipocambio.obj.disabled = false;
			f.EAtipocambio.obj.value = qf(f.EAtipocambio.obj.value);
			f.DAmontodoc.obj.readonly = false;
			f.DAmontodoc.obj.value = qf(f.DAmontodoc.obj.value);
			f.DAmonto.obj.value = qf(f.DAmonto.obj.value);
		}
		return true;
	}

	function validaSaldo(f)
	{
		if (f.FC.value == "encabezado") {
			f.DAmontodoc.value = new Number(qf(f.DAmonto.value)) * new Number(qf(f.EAtipocambio.value));
			fm (f.DAmontodoc, 2);
		} else if (f.FC.value == "iguales") {
			f.DAmontodoc.value = f.DAmonto.value;
		}
	}

	function sugerirMonto() {
		document.form1.DAmonto.disabled = false;
		document.form1.EDsaldoD.disabled = true;

		if (document.form1.McodigoD.value == document.form1.McodigoE.value) {
				// LA MONEDA DEL DOCUMENTO ES IGUAL A LA DEL ENCABEZADO
				document.form1.DAmontodoc.readonly = true;
				document.form1.FC.value = "iguales";
			} else {
				if (document.form1.monedalocal.value != document.form1.McodigoD.value) {
					// LA MONEDA LOCAL ES DIFERENTE A LA DEL DOCUMENTO
					document.form1.DAmontodoc.readonly = false;
					document.form1.FC.value = "calculado";
				} else {
					// LA MONEDA LOCAL ES IGUAL A LA DEL DOCUMENTO
					document.form1.DAmontodoc.readonly = true;
					document.form1.FC.value = "encabezado";
				}
			}

		document.form1.DAmontodoc.value = fm(document.form1.EDsaldoD.value, 2);
		if (document.form1.FC.value == "encabezado") {
			if ((new Number(qf(document.form1.disponible.value)) * new Number(qf(document.form1.EAtipocambio.value))) <= new Number(qf(document.form1.EDsaldoD.value))) {
				document.form1.DAmonto.value = fm(document.form1.disponible.value,2);
			} else {
				document.form1.DAmonto.value = fm(new Number(qf(document.form1.EDsaldoD.value)) / new Number(qf(document.form1.EAtipocambio.value)), 2);
			}
		} else if (document.form1.FC.value == "iguales") {
			if (new Number(qf(document.form1.disponible.value)) <= new Number(qf(document.form1.EDsaldoD.value))) {
				document.form1.DAmonto.value = fm(document.form1.disponible.value, 2);
			} else {
				document.form1.DAmonto.value = fm(document.form1.EDsaldoD.value, 2);
			}
		}
		validaSaldo(document.form1);
	}

	function validatcLOAD(f) {
		if (f.McodigoE != null && f.McodigoE.value == f.monedalocal.value) {
			f.EAtipocambio.value = "1.0000"
			f.EAtipocambio.disabled = true
		}
		f.EAtipocambio.value = fm(f.EAtipocambio.value, 4);
    }

	function doLimpiarE() {
		document.form1.CPTcodigo.value="";
		document.form1.Ddocumento.value="";
		document.form1.IDdocumento.value="";
		document.form1.EAtipocambio.value="";
		document.form1.Mnombre.value="";
		document.form1.SaldoEncabezado.value="";
		document.form1.IDpago.value="";
		document.form1.McodigoE.value="";
		document.form1.ECselect.value="";
		document.form1.Aplicado.value="";
	}
</script>

<cfset LB_EncabezadoDoc = t.Translate('LB_EncabezadoDoc','Encabezado del Documento')>
<cfset LB_PROVEEDOR = t.Translate('LB_PROVEEDOR','Proveedor','/sif/generales.xml')>
<cfset LB_LstTran = t.Translate('LB_LstTran','Lista de Transacciones')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_Monto = t.Translate('LB_Monto','Monto','/sif/generales.xml')>
<cfset LB_Saldo = t.Translate('LB_Saldo','Saldo')>
<cfset LB_Tipo_de_Cambio = t.Translate('LB_Tipo_de_Cambio','Tipo de Cambio','/sif/generales.xml')>
<cfset LB_Disponible	= t.Translate('LB_Disponible','Disponible')>
<cfset BTN_Agregar	= t.Translate('BTN_Agregar','Agregar','/sif/generales.xml')>
<cfset BTN_Regresar	= t.Translate('BTN_Regresar','Regresar','/sif/generales.xml')>
<cfset LB_LstDoct = t.Translate('LB_LstDoct','Lista de Documentos')>
<cfset LB_MontoMonDoc = t.Translate('LB_MontoMonDoc','Monto en Moneda del documento')>
<cfset LB_SaldoMonDoc = t.Translate('LB_SaldoMonDoc','Saldo en moneda del documento')>
<cfset LB_MontMonPAgo = t.Translate('LB_MontMonPAgo','el monto de la moneda del pago')>
<cfset BTN_Cambiar	= t.Translate('BTN_Cambiar','Cambiar','/sif/generales.xml')>
<cfset BTN_BorrarLin	= t.Translate('BTN_BorrarLin','Borrar Linea')>
<cfset BTN_NvoDoct	= t.Translate('BTN_NvoDoct','Nuevo Documento')>
<cfset BTN_DelDoct	= t.Translate('BTN_DelDoct','Borrar Documento')>
<cfset BTN_Aplicar	= t.Translate('BTN_Aplicar','Aplicar','/sif/generales.xml')>


<form action="SQLDocsAfavor.cfm" method="post" name="form1" id="form1" onsubmit="javascript:return validaForm(this);">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
    	<tr>
      		<td>
				<table width="100%" border="0">
            		<tr><td colspan="6" class="tituloAlterno"><strong><cfoutput>#LB_EncabezadoDoc#</cfoutput></strong></td></tr>
            		<tr>
						<td align="right" nowrap ><cfoutput>#LB_PROVEEDOR#:</cfoutput></td>
						<td nowrap valign="bottom">
							<cfif modo neq 'ALTA'>
								<cf_sifsociosnegociosFA query="#rsDocumento#" readonly="true" tabindex="1">
							<cfelse>
								<cf_sifsociosnegociosFA tabindex="1">
							</cfif>
							<input type="hidden" name="monedalocal" value="<cfif modo NEQ "ALTA"><cfoutput>#rsMonedalocal.Mcodigo#</cfoutput></cfif>" tabindex="-1">
						</td>
                        <cfoutput>
						<td nowrap align="right"><input type="hidden" name="IDdocumento" value="" tabindex="-1">#LB_Transaccion#:</td>
                        </cfoutput>
						<td nowrap>
							<cfif modo eq "ALTA">
                        	<cfoutput>
								<cfset valuesArray = ArrayNew(1)>
								<cf_dbfunction name="concat"	args="a.CPTcodigo, rtrim(a.Ddocumento)" returnvariable="codDoc">
								<cf_dbfunction name="concat"	args="z.CPTcodigo, rtrim(z.Ddocumento)" returnvariable="codDoc2">
							<cf_conlis
									title="#LB_LstTran#"
								campos = "CPTcodigo, Ddocumento"
								desplegables = "S,S"
								modificables = "N,N"
								size = "5,40"
								valuesarray="#valuesArray#"
								tabla="EDocumentosCP a

										inner join CPTransacciones b
										   on b.Ecodigo = a.Ecodigo
										  and b.CPTcodigo = a.CPTcodigo

										inner join Monedas c
										   on c.Ecodigo = a.Ecodigo
										  and c.Mcodigo = a.Mcodigo

										inner join CContables d
										   on d.Ecodigo = a.Ecodigo
										  and d.Ccuenta = a.Ccuenta"

								columnas="a.CPTcodigo, a.Ddocumento, a.Dfecha, a.Mcodigo as McodigoE, a.Ccuenta, c.Mnombre, d.Cdescripcion, a.Dtotal,
										   a.EDsaldo as SaldoEncabezado, a.EDsaldo,
										   a.EDsaldo as disponible,a.IDdocumento,a.IDdocumento as IDpago, b.CPTdescripcion,
										   a.Ddocumento , a.Dtipocambio as EAtipocambio"

								filtro="a.Ecodigo  = #Session.Ecodigo#
								    and a.SNcodigo = $SNcodigo,integer$
								    and a.EDsaldo > 0
								    and (#codDoc#) not in (select (#codDoc2#)
																	from EAplicacionCP z
																  where a.Ecodigo=z.Ecodigo)
								    and b.CPTtipo = 'D'
								    and coalesce(b.CPTpago, 0) != 1"

								desplegar="CPTcodigo, Ddocumento, Dfecha, Mnombre, Dtotal, EDsaldo"
								filtrar_por="a.CPTcodigo, a.Ddocumento, a.Dfecha, c.Mnombre, a.Dtotal, a.EDsaldo"
								etiquetas="#LB_Transaccion#,#LB_Documento#,#LB_Fecha#,#LB_Moneda#,#LB_Monto#,#LB_Saldo#"
								formatos="S,S,D,S,M,M"
								align="left,left,left,left,left,left"
								asignar="CPTcodigo, Ddocumento,Mnombre, EAtipocambio, SaldoEncabezado, disponible,IDdocumento,McodigoE,IDpago"
								asignarformatos="S,S,S,M,M,M,V,S,V"
								tabindex = "1">
                        	</cfoutput>
							<cfelse>
								<cfoutput>
								<input name="CPTcodigo" type="text" size="5" class="cajasinborde"
									value="#rsDocumento.CPTcodigo#"
									readonly tabindex="1">
								<input name="Ddocumento" type="text" size="30" class="cajasinborde"
									value="#rsDocumento.Ddocumento#"
									readonly tabindex="1">
								</cfoutput>
							</cfif>
						</td>
                        <cfoutput>
						<td align="right" nowrap> #LB_Fecha#:</td>
                        </cfoutput>
						<td nowrap>
							<cfif modo NEQ "ALTA">
								<cfset fecha=LSDateFormat(rsDocumento.EAfecha,'dd/mm/yyyy')>
							<cfelse>
								<cfset fecha = LSDateFormat(Now(),'dd/mm/yyyy')>
							</cfif>
							<cf_sifcalendario name="EAfecha" value="#fecha#" tabindex="1">
							<input type="hidden" tabindex="-1" name="_EAfecha" value="<cfif modo NEQ "ALTA"><cfoutput>#LSDateFormat(rsDocumento.EAfecha,'dd/mm/yyyy')#</cfoutput></cfif>">
					</td>
					</tr>
					<tr>
                        <cfoutput>
						<td align="right" nowrap>#LB_Moneda#:</td>
						<td nowrap>
							<input name="Mnombre" tabindex="-1"
							value="<cfif modo NEQ "ALTA"><cfoutput>#rsDocumento.Mnombre#</cfoutput></cfif>"
							style="text-align:left" type="text" class="cajasinborde" size="15" readonly="">
						</td>
						<td align="right" nowrap> #LB_Tipo_de_Cambio#:</td>
                        </cfoutput>
						<td nowrap>
							<input name="EAtipocambio" tabindex="1" style="text-align:right" type="text"
							value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsDocumento.EAtipocambio,'none')#</cfoutput></cfif>"
							<cfif modo NEQ "ALTA" >disabled</cfif> size="20" maxlength="20"
							onfocus="this.value=qf(this); this.select();"
							onblur="fm(this,4);"
							onkeyup="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}" >
						</td>
                        <cfoutput>
						<td align="right" nowrap>#LB_Saldo#:</td>
                        </cfoutput>
						<td nowrap>
							<input type="text" size="20" maxlength="18" name="SaldoEncabezado" tabindex="-1" class="cajasinborde"
							style="text-align:right"
							value="<cfif modo NEQ 'ALTA'><cfoutput>#LSCurrencyFormat(rsCalculaSaldo.EDsaldo,'none')#</cfoutput></cfif>"
							onfocus="this.value=qf(this); this.select();"
							onblur="fm(this,2);"
							onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
							readonly>
						</td>
					</tr>
					<tr>
						<td nowrap colspan="2">&nbsp;</td>
						<td nowrap>
							<cfset tsE = "">
							<cfif modo NEQ "ALTA">
								<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp"
									artimestamp="#rsDocumento.ts_rversion#" returnvariable="tsE">
								</cfinvoke>
							</cfif>
						</td>
						<td nowrap>

							<input type="hidden" name="IDpago" id="IDpago" tabindex="-1" value="<cfif modo NEQ "ALTA"><cfoutput>#rsDocumento.IDpago#</cfoutput></cfif>">
							<input type="hidden" name="McodigoE" tabindex="-1" value="<cfif modo NEQ "ALTA"><cfoutput>#rsDocumento.Mcodigo#</cfoutput></cfif>">
							<input type="hidden" name="ECselect" tabindex="-1" value="0"> <input type="hidden" name="timestampE" value="<cfif modo NEQ "ALTA"><cfoutput>#tsE#</cfoutput></cfif>">
							<input type="hidden" name="Aplicado" tabindex="-1" value="<cfif modo NEQ "ALTA"><cfoutput>#rsAplicado.DAmonto#</cfoutput></cfif>">
							<input type="hidden" name="docrefb" id="docrefb" value="">
						</td>
						<td align="right" nowrap><cfoutput>#LB_Disponible#:</cfoutput></td>
						<cfparam name="sdisponible" default="0.00">
						<cfif modo NEQ "ALTA">

							<cfquery name="rsDisponible" datasource="#Session.DSN#">
								select
									a.ID as ID,
									c.Ecodigo,
									c.CPTcodigo,
									c.Ddocumento,
									c.EDsaldo as EDsaldo,
									coalesce
									((
										select sum(b.DAmonto)
										from DAplicacionCP b
										where b.ID = a.ID
									), 0)
									as MontoDet,
									round(
										coalesce(c.EDsaldo, 0) - 	coalesce((
														select sum(b.DAmonto)
														from DAplicacionCP b
														where b.ID = a.ID), 0)
									,2) as disponible
								from EAplicacionCP a
									inner join EDocumentosCP c
										on c.Ecodigo             = a.Ecodigo
										and c.CPTcodigo    = a.CPTcodigo
										and c.Ddocumento = a.Ddocumento
										and c.SNcodigo       = a.SNcodigo
								where a.Ecodigo =  #Session.Ecodigo#
								and a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDpago#">
							</cfquery>
						</cfif>
						<cfif isdefined("rsDisponible") and rsDisponible.recordcount neq 0>
							<cfset sdisponible = #LSCurrencyFormat(rsDisponible.disponible,'none')#>
						</cfif>
						<cfoutput>
							<td nowrap>
								<input type="text" name="disponible" value="#sdisponible#" class="cajasinborde"
									style="text-align: right" readonly size="20" maxlength="18" tabindex="-1">
								<cfif isdefined("rsDisponible") and rsDisponible.recordcount eq 0>
									<script language="JavaScript">
										document.form1.disponible.value = document.form1.SaldoEncabezado.value;
									</script>
								</cfif>
							</td>
						</cfoutput>
					</tr>
					<tr align="center">
						<cfoutput>
						<td colspan="6">
							<cfif modo EQ "ALTA">
								<font size="2">
								<input name="AgregarE" type="submit" tabindex="1" value="#BTN_Agregar#" onclick="javascript:setBtn(this);">
								<input type="button" name="Regresar" tabindex="1" value="#BTN_Regresar#" onclick="javascript:Lista();">
								</font>
						  	</cfif>
						</td>
						</cfoutput>
					</tr>
					<cfif modo neq "ALTA">
						<cfoutput>
            			<cfset LB_TituloAlterno = t.Translate('LB_TituloAlterno','Detalle del Documento')>
						<tr><td colspan="6" class="tituloAlterno"><strong>#LB_TituloAlterno#</strong></td></tr>
						</cfoutput>
					</cfif>
				</table>
			</td>
		</tr>
    	<cfif not isDefined("Form.NuevoE") and modo NEQ "ALTA">
      	<tr>
        	<td>
          		<table width="100%" border="0">
					<tr id="trUno">
						<td align="right" nowrap><cfoutput>#LB_Documento#:</cfoutput></td>
						<td nowrap>
						<cfif modoDet neq "ALTA"><cfoutput>
 								<input type="hidden" name="DAidref" value="<cfif modoDet NEQ "ALTA">#rsLinea.DAidref#</cfif>" tabindex="-1">
								<input type="hidden" name="DAtransref" value="<cfif modoDet NEQ "ALTA">#rsLinea.CPTcodigo#</cfif>" tabindex="-1">
								<input type="hidden" name="mantenimientoDetalle" value="CAMBIO" tabindex="-1">
								<input name="DAdocref" type="text" tabindex="5"
									value="#rsLinea.DAdocref#" size="40" class="cajasinborde" readonly tabindex="-1">
								</cfoutput>
							<cfelse>
							<cfset valuesArray = ArrayNew(1)>
						<cf_dbfunction name="concat" returnvariable="LvarDdocumento"args="b.CPTcodigo,b.Ddocumento">
						<cf_dbfunction name="concat" returnvariable="LvarDAdocref"args="h.DAtransref, h.DAdocref">
						<cf_dbfunction name="concat" returnvariable="LvarMnombre"args="rtrim(b.CPTcodigo),'-',rtrim(b.Ddocumento),'-',rtrim(a.Mnombre)">
							<cf_conlis
								title="#LB_LstDoct#"
								campos = "DAtransref, DAdocref,MnombreD,DAidref"
								desplegables = "S,S,S,N"
								modificables = "N,N,N,N"
								size = "3,30,20,0"
								valuesarray="#valuesArray#"
								tabla="EDocumentosCP b
									inner join Monedas a
									   on a.Mcodigo = b.Mcodigo

									inner join CContables c
									   on b.Ecodigo = c.Ecodigo
									  and b.Ccuenta = c.Ccuenta

									inner join CPTransacciones d
									   on d.Ecodigo = b.Ecodigo
									  and d.CPTtipo = 'C'
									  and coalesce(d.CPTpago,0) = 0 and coalesce(d.CPTanticipo,0) = 0
									  and b.Ecodigo = d.Ecodigo
									  and b.CPTcodigo = d.CPTcodigo"
								columnas="b.IDdocumento as DAidref,a.Mcodigo as McodigoD,b.CPTcodigo as DAtransref,
										b.Ddocumento as DAdocref,b.Ccuenta,
										Dtipocambio as DAtipocambio,EDsaldo as EDsaldoD,Cdescripcion,b.IDdocumento,b.Ddocumento,
										Cdescripcion,
										#LvarMnombre# as Documento,
										a.Mnombre as MnombreD"
								filtro="b.Ecodigo  = #Session.Ecodigo#
								    and b.SNcodigo = $SNcodigo,integer$
								    and b.EDsaldo > 0
									and #LvarDdocumento# not in
											  (select #LvarDAdocref#
											     from DAplicacionCP h
												where b.Ecodigo=h.Ecodigo )"
								desplegar="DAtransref, Ddocumento, MnombreD, EDsaldoD"
								filtrar_por="b.CPTcodigo, b.Ddocumento, a.Mnombre, EDsaldo"
								etiquetas="#LB_Transaccion#,#LB_Documento#,#LB_Moneda#,#LB_Saldo#"
								formatos="S,S,S,M"
								align="left,left,left,left"
								asignar="DAtransref,DAdocref,MnombreD,DAidref,EDsaldoD,McodigoD"
								asignarformatos="S,S,S,V,M,S"
								funcion="sugerirMonto"
								tabindex="-1">
							</cfif>
 						</td>
						<td align="right" nowrap><cfoutput>#LB_MontoMonDoc#:</cfoutput></td>
						<td nowrap>
							<input name="DAmontodoc" tabindex="1"
								onblur="javascript: fm(this,2); validaSaldo(this.form); "
								style="text-align:right" type="text"
								onchange="javascript:validaSaldo(this.form);"
								alt=<cfoutput>"#LB_MontoMonDoc#"</cfoutput>
								value="<cfif modo NEQ "ALTA" and modoDet NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsLinea.DAmontodoc,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>"
								size="20" maxlength="18"
								onfocus="this.value=qf(this); this.select();"
								onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
								<cfif modo NEQ "ALTA" and modoDet NEQ "ALTA" and (rsLinea.DAtipocambio EQ 1 or rsLinea.DAtipocambio EQ rsDocumento.EAtipocambio)>readonly<cfelseif modo NEQ "ALTA" and modoDet EQ "ALTA">readonly</cfif>>
						</td>
					</tr>
					<tr id="trDos">
						<td align="right" nowrap><cfoutput>#LB_SaldoMonDoc#:</cfoutput></td>
						<td nowrap >
							<input name="EDsaldoD" tabindex="-1"
								value="<cfif modoDet NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsCalculaSaldo.EDSaldo,'none')#</cfoutput></cfif>"
								style="text-align:right" type="text" class="cajasinborde" size="20"  maxlength="18"  readonly="">
						</td>
						<td align="right" nowrap><cfoutput>#LB_MontoMoneda#</cfoutput></td>
						<td nowrap>
							<input name="DAmonto" type="text" tabindex="7"
								onchange="javascript: validaSaldo(this.form)"
								onblur="javascript: fm(this,2); validaSaldo(this.form)"
								onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
								onfocus="this.value=qf(this); this.select();"
								style="text-align:right" alt=<cfoutput>"#LB_MontMonPAgo#"</cfoutput>
								size="20"  maxlength="18"
								value="<cfif modo NEQ "ALTA" and modoDet NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsLinea.DAmonto,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>"
								<cfif modo NEQ "ALTA" and modoDet EQ "ALTA">disabled</cfif>>
						</td>
					</tr>
					<tr align="right">
						<td colspan="4" nowrap>
							<cfset tsD = "">
							<cfif modoDet NEQ "ALTA">
								<cfinvoke component="sif.Componentes.DButils"
									method="toTimeStamp" artimestamp="#rsLinea.ts_rversion#" returnvariable="tsD">
								</cfinvoke>
							</cfif>
							<input type="hidden" name="DAlinea" value="<cfif modoDet NEQ 'ALTA'><cfoutput>#rsLinea.DAlinea#</cfoutput></cfif>" tabindex="-1">
							<input type="hidden" name="DAtotal" value="<cfif modoDet NEQ 'ALTA'><cfoutput>#rsLinea.DAtotal#</cfoutput></cfif>" tabindex="-1">
							<input type="hidden" name="McodigoD" value="<cfif modoDet NEQ 'ALTA'><cfoutput>#rsMoneda.Mcodigo#</cfoutput></cfif>" tabindex="-1">
							<input type="hidden" name="timestampD" value="<cfif modoDet NEQ 'ALTA'><cfoutput>#tsD#</cfoutput></cfif>" tabindex="-1">
							<input name="FC" tabindex="-1" type="hidden" id="FC" value="<cfif modo NEQ "ALTA" and modoDet NEQ "ALTA" and rsLinea.DAtipocambio EQ 1><cfoutput>iguales</cfoutput><cfelseif modo NEQ "ALTA" and modoDet NEQ "ALTA" and rsLinea.DAtipocambio EQ rsDocumento.EAtipocambio><cfoutput>encabezado</cfoutput><cfelse><cfoutput>calculado</cfoutput></cfif>">
						</td>
					</tr>
                    <cfset MSG_BorraLinea = t.Translate('MSG_BorraLinea','¿Realmente desea borrar esta línea del documento?')>
                    <cfset MSG_BorraDocto = t.Translate('MSG_BorraDocto','¿Realmente desea borrar este documento?')>

					<tr align="center">
						<td colspan="4">
							<cfif modoDet EQ "ALTA">
                            	<cfoutput>
								<input name="AgregarD" type="submit" id="btnAgregar"  tabindex="1" value="#BTN_Agregar#" onclick="javascript:setBtn(this);">
                            	</cfoutput>
								<input type="hidden" name="Montolinea" value="0" tabindex="-1">
							<cfelse>
                            	<cfoutput>
								<input type="hidden" name="Montolinea" tabindex="-1" value="#rsMontolinea.DAmonto#">
								<input name="CambiarD" type="submit" value="#BTN_Cambiar#" tabindex="1" onclick="javascript: setBtn(this);">
								<input name="BorrarD" type="submit" tabindex="1" value="#BTN_BorrarLin#" onclick="javascript:setBtn(this); deshabilitarValidacion(this.name); return confirm('#MSG_BorraLinea#')">
                                </cfoutput>
							</cfif>
                            <cfoutput>
							<input name="NuevoE" type="submit" value="#BTN_NvoDoct#" tabindex="1" onclick="javascript: setBtn(this); deshabilitarValidacion(this.name); funcNuevoE();">
                            </cfoutput>
                           	<cfoutput>
							<input name="BorrarE" type="submit" value="#BTN_DelDoct#" tabindex="1" onclick="javascript: setBtn(this); deshabilitarValidacion(this.name); return confirm('#MSG_BorraDocto#')">
                            </cfoutput>
							<cfif rsTieneLineas.RecordCount GT 0 >
                           	<cfoutput>
								<input type="submit" name="Aplicar" id="Aplicar"  value="#BTN_Aplicar#" tabindex="1" onclick="javascript:setBtn(this); deshabilitarValidacion(this.name); return Postear();">
                           	</cfoutput>
							</cfif>
                            <cfoutput>
							<input type="button" name="ListaE" tabindex="1" value="#BTN_Regresar#" onclick="javascript:Lista();">
                            </cfoutput>
							<input name="Comprobante" type="button" tabindex="1" value="Comprobante" onclick="javascript: imprimeDoc('<cfoutput>#rsDocumento.IDpago#</cfoutput>');" >
						</td>
					</tr>
          		</table>
        	</td>
		</tr>
    	</cfif>
	</table>

	<cfoutput>
	<input type="hidden" tabindex="-1" name="pageNum_Lista" value="<cfif isdefined('form.PageNum_Lista') and len(trim(form.PageNum_Lista))>#form.PageNum_Lista#<cfelse>1</cfif>" />
	<input type="hidden" tabindex="-1" name="filtro_CPTdescripcion" value="<cfif isdefined('form.filtro_CPTdescripcion') and len(trim(form.filtro_CPTdescripcion))>#form.filtro_CPTdescripcion#</cfif>" />
	<input type="hidden" tabindex="-1" name="filtro_Ddocumento" value="<cfif isdefined('form.filtro_Ddocumento') and len(trim(form.filtro_Ddocumento)) >#form.filtro_Ddocumento#</cfif>" />
	<input type="hidden" tabindex="-1" name="filtro_EAfecha" value="<cfif isdefined('form.filtro_EAfecha') and len(trim(form.filtro_EAfecha)) >#form.filtro_EAfecha#</cfif>" />
	<input type="hidden" tabindex="-1" name="filtro_EAusuario" value="<cfif isdefined('form.filtro_EAusuario') and len(trim(form.filtro_EAusuario)) >#form.filtro_EAusuario#</cfif>" />
	<input type="hidden" tabindex="-1" name="filtro_Mnombre" value="<cfif isdefined('form.filtro_Mnombre') and len(trim(form.filtro_Mnombre)) and form.filtro_Mnombre neq -1 >#form.filtro_Mnombre#<cfelse>-1</cfif>" />

	<input type="hidden" tabindex="-1" name="hfiltro_CPTdescripcion" value="<cfif isdefined('form.hfiltro_CPTdescripcion') and len(trim(form.hfiltro_CPTdescripcion)) >#form.hfiltro_CPTdescripcion#</cfif>" />
	<input type="hidden" tabindex="-1" name="hfiltro_Ddocumento" value="<cfif isdefined('form.hfiltro_Ddocumento') and len(trim(form.hfiltro_Ddocumento)) >#form.hfiltro_Ddocumento#</cfif>" />
	<input type="hidden" tabindex="-1" name="hfiltro_EAfecha" value="<cfif isdefined('form.hfiltro_EAfecha') and len(trim(form.hfiltro_EAfecha)) >#form.hfiltro_EAfecha#</cfif>" />
	<input type="hidden" tabindex="-1" name="hfiltro_EAusuario" value="<cfif isdefined('form.hfiltro_EAusuario') and len(trim(form.hfiltro_EAusuario)) >#form.hfiltro_EAusuario#</cfif>" />
	<input type="hidden" tabindex="-1" name="hfiltro_Mnombre" value="<cfif isdefined('form.hfiltro_Mnombre') and len(trim(form.hfiltro_Mnombre)) and form.hfiltro_Mnombre neq -1 >#form.hfiltro_Mnombre#<cfelse>-1</cfif>" />
	</cfoutput>

</form>
<cfset idFactura = 0>
<cfif  isdefined("IDpago") AND #IDpago# GT 0>
	<cfquery name="rsGetFacID" datasource="#Session.DSN#">
		SELECT DAidref
		FROM DAplicacionCP
		WHERE ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDpago#">
		  AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	</cfquery>

	<cfif rsGetFacID.recordCount GT 0>
		<cfset idFactura = "#rsGetFacID.DAidref#">
	<cfelse>
		<cfset idFactura = 0>
	</cfif>
</cfif>

<cfset MSG_AplicaDocto = t.Translate('MSG_AplicaDocto','¿Desea aplicar este documento?')>
<cfset MSG_ElCampo = t.Translate('MSG_ElCampo','El campo')>
<cfset MSG_NoPuedeSer0 = t.Translate('MSG_NoPuedeSer0','no puede ser cero')>
<cfset MSG_MontoDig = t.Translate('MSG_MontoDig','El monto digitado supera el saldo del documento, debe ser inferior o igual a ')>
<cfset MSG_MontoLin = t.Translate('MSG_MontoLin','El monto de las líneas de detalle supera el saldo del documento')>

<script>window.jQuery || document.write('<script src="/cfmx/jquery/librerias/jquery-1.11.1.min.js"><\/script>')</script>
<script language="JavaScript">
	<cfif modo NEQ "ALTA" and modoDet EQ "ALTA">
		validatcLOAD(document.form1);
	</cfif>

	var popupdoc = 0 ;
	function imprimeDoc(id){
		if(popupdoc){ if(!popupdoc.closed) popupdoc.close(); }
		var width = 800;
		var height = 800;
		var top = 60;
		var left = 170;
		popupdoc = open('/cfmx/sif/cp/consultas/DocsFavorComprobante.cfm?id='+id, 'popupdoc', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);

	}

	function Postear() {
		var submit = true;
		eliminaRelaciones();
		<cfoutput>
		if (confirm('#MSG_AplicaDocto#')) {
			document.form1.IDpago.value = "#IDpago#";
			document.form1.action="AplicaDocsAfavor.cfm";
			getRelacionLineas("#IDpago#", "#idFactura#", "#IDpago#");
		}
		else {
			submit = false;
		};
		submit = false;
		</cfoutput>
		return submit;
	}

	function eliminaRelaciones(){
		<cfoutput>
			$.ajax({
				method: "post",
			    url: "AjaxRelacionaLineasNcFc.cfc",
			    async:false, //Validacion si espera o no a que termine ajax
			    data: {
			    	method: "deleteRelacion",
			        returnFormat: "JSON",
			        movAplicacion: "#IDpago#",
			    },
			    dataType: "json",
			    success: function(obj) {
					if(obj.MSG == 'DeleteOK'){
						<!--- Cierra ventana --->
					} else {
						alert(obj.MSG);
					}
			     }
			 });
		</cfoutput>
	}

	function getRelacionLineas(IdNC, IdFC, Movimiento) {
	    var popupRelacionLineas =
	    window.open("popupPorLinea.cfm?IdNC="+IdNC+"&IdFC="+IdFC+"&Mov="+Movimiento, "Relación de lineas",
	    "location=no,menubar=no,titlebar=yes,resizable=no,toolbar=no,scrollbars=yes, menubar=no,top=40,left=300,width=870,height=620");
	}

	function funcNuevoE(){
		document.form1.action="AplicaDocsAfavor.cfm";
		return true;
	}


	function deshabilitarValidacion(boton) {
		objForm.EAfecha.required = false;
		<cfif modoDet EQ "ALTA">
			objForm.DAidref.required = false;
		</cfif>
		objForm.DAmonto.required = false;
		objForm.DAmontodoc.required = false;
	}
	<cfoutput>
	function __isNotCero() {
		if ((btnSelected("AgregarE") || btnSelected("AgregarD") || btnSelected("CambiarD")) && (!this.obj.disabled) && ((this.value == "") || (this.value == " ") || (new Number(qf(this.value)) == 0))) {
			this.obj.focus();
			this.error = "#MSG_ElCampo# " + this.description + " #MSG_NoPuedeSer0#";
		}
	}
	// Se aplica sobre el monto del documento
	function __isMontoDoc() {
		if (btnSelected("AgregarE") || btnSelected("AgregarD") || btnSelected("CambiarD")) {
			// Valida Monto de Documento contra saldo del documento
			if ((new Number(qf(this.obj.form.DAmontodoc.value))) > (new Number(qf(this.obj.form.EDsaldoD.value)))) {
				if (!this.obj.form.DAmontodoc.readonly) this.obj.form.DAmontodoc.focus();
				else this.obj.form.DAmonto.focus();
				this.error = "#MSG_MontoDig#" + this.obj.form.EDsaldoD.value;
			}
		}
	}
	// Se aplica sobre el monto del documento
	function __isMontoPago() {
		if (btnSelected("AgregarE") || btnSelected("AgregarD") || btnSelected("CambiarD")) {
			// Valida que el Pago sea menor al disponible en el documento de pago
			if (redondear(parseFloat(qf(this.obj.form.DAmonto.value))+parseFloat(qf(this.obj.form.Aplicado.value)),2) > new Number(qf(this.obj.form.SaldoEncabezado.value))) {
				this.obj.form.DAmonto.focus();
				this.error = "#MSG_MontoLin#";
			}
		}
	}
	</cfoutput>

	qFormAPI.errorColor = "#FFFFCC";
	_addValidator("isNotCero", __isNotCero);
	_addValidator("isMontoDoc", __isMontoDoc);
	_addValidator("isMontoPago", __isMontoPago);
	objForm = new qForm("form1");
	<cfoutput>
	<cfif modo EQ "ALTA">
		objForm.SNnombre.required = true;
		objForm.SNnombre.description = "#LB_PROVEEDOR#";
		objForm.CPTcodigo.required = true;
		objForm.CPTcodigo.description = "#LB_TransaccionM#";
		objForm.EAfecha.required = true;
		objForm.EAfecha.description = "#LB_Fecha#";
	<cfelseif modo EQ "CAMBIO">
		objForm.EAfecha.required = true;
		objForm.EAfecha.description = "#LB_Fecha#";

		<cfif modoDet EQ "ALTA">
			objForm.DAidref.required = true;
			objForm.DAidref.description = "#LB_Documento#";
		</cfif>

		objForm.DAmonto.required = true;
		objForm.DAmonto.description = "#LB_MontoMoneda#";
		objForm.DAmonto.validateNotCero();
		objForm.DAmonto.validateMontoPago();
		objForm.DAmontodoc.required = (!objForm.DAmontodoc.obj.readonly);
		objForm.DAmontodoc.description = "#LB_MontoMonDoc#";
		objForm.DAmontodoc.validateNotCero();
		objForm.DAmontodoc.validateMontoDoc();
	</cfif>
	</cfoutput>
	<cfif isdefined("modo") and modo eq 'ALTA'>
		objForm.SNnumero.focus();
	</cfif>
</script>
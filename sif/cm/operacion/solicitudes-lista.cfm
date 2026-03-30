<cfinclude template="../../Utiles/sifConcat.cfm">
<script language="javascript1.2" type="text/javascript">
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

<cfif isdefined("url.impOrden") and isdefined("url.ESidsolicitud") and len(trim(url.ESidsolicitud))>
	<cfoutput>
		function imprimeOrden() {
			var width = 500;
			var height = 200;
			var left = (screen.width-width)/2;
			var top = (screen.height-height)/2;
			var URLStr = "/cfmx/sif/cm/operacion/ordenCompra-resumen.cfm?ESidsolicitud=#url.ESidsolicitud#"
			window.open(URLStr, 'DetalleOrden', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
		}
		imprimeOrden();
	</cfoutput>
</cfif>

<cfif isdefined("url.imprimir") and isdefined("url.ESidsolicitud") and len(trim(url.ESidsolicitud))>
	<cfoutput>
		function imprime() {
			var params ="";
			popUpWindow("/cfmx/sif/cm/operacion/imprimeSolicitud.cfm?ESidsolicitud=#url.ESidsolicitud#",200,100,650,600);
		}
		imprime();
	</cfoutput>
</cfif>

</script>

<cf_navegacion name="SC_INV" default="-1">
<cfif url.SC_INV NEQ -1>
	<cfset LvarHeader = "Solicitudes de Compra de Inventario">
	<cfset LvarCFM_form		= "solicitudes_IN.cfm">
<cfelse>
	<cfset LvarHeader = "Solicitudes de Compras">
	<cfset LvarCFM_form		= "solicitudes.cfm">
</cfif>
<cfif isdefined('session.compras.solicitante') and len(trim(session.compras.solicitante))>
	<cfset lvarSolicitante = session.compras.solicitante>
<cfelse>
    <cfset lvarSolicitante = -1>
</cfif>
<cf_templateheader title="#LvarHeader#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LvarHeader#'>
		<cfinclude template="../../portlets/pNavegacionCM.cfm">
		<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<cfinclude template="solicitudes-filtroglobal.cfm">
					<cfset navegacion = "">

					<cfif isdefined("form.fCMTScodigo") and len(trim(form.fCMTScodigo)) >
						<cfset navegacion = navegacion & "&fCMTScodigo=#Trim(form.fCMTScodigo)#">
					</cfif>
					<cfif isdefined("form.fCMTSdescripcion") and len(trim(form.fCMTSdescripcion)) >
						<cfset navegacion = navegacion & "&fCMTSdescripcion=#form.fCMTSdescripcion#">
					</cfif>

					<cfif isdefined("form.fESnumero") and len(trim(form.fESnumero)) >
						<cfset navegacion = navegacion & "&fESnumero=#form.fESnumero#">
					</cfif>

					<cfif isdefined("form.fESnumero2") and len(trim(form.fESnumero2)) >
						<cfset navegacion = navegacion & "&fESnumero2=#form.fESnumero2#">
					</cfif>

					<cfif isdefined("form.fObservaciones") and len(trim(form.fObservaciones)) >
						<cfset navegacion = navegacion & "&fObservaciones=#form.fObservaciones#">
					</cfif>
					<cfif isdefined("Form.CFid_filtro") and len(trim(form.CFid_filtro)) >
						<cfset navegacion = navegacion & "&CFid_filtro=#form.CFid_filtro#">
					</cfif>
					<cfif isdefined("Form.CFcodigo_filtro") and len(trim(form.CFcodigo_filtro)) >
						<cfset navegacion = navegacion & "&CFcodigo_filtro=#form.CFcodigo_filtro#">
					</cfif>

					<cfif isdefined("Form.fESfecha") and len(trim(form.fESfecha))>
						<cfset navegacion = navegacion & "&fESfecha=#form.fESfecha#">
					</cfif>

					<cfquery name="rsLista" datasource="#session.DSN#">
						select a.ESidsolicitud, a.Ecodigo, a.ESnumero, a.CFid,
							   a.CMSid, a.CMTScodigo, a.SNcodigo, a.Mcodigo, Mnombre,
							   a.CMCid, a.CMElinea, a.EStipocambio, a.ESfecha,
							   a.ESobservacion, a.NAP, a.NRP, a.NAPcancel,
							   a.EStotalest, a.ESestado, a.Usucodigo, a.ESfalta,
							   a.Usucodigomod, a.fechamod, a.ESreabastecimiento,
							   b.CFdescripcion,
							   c.CMTScodigo#_Cat#'-'#_Cat# c.CMTSdescripcion as descripcion,
							   c.CMTScompradirecta,
							   case when NRP is not null then 'Rechazada' else '' end as Rechazada
							<cfif url.SC_INV NEQ -1>
								, 1 as SC_INV
							</cfif>
						from ESolicitudCompraCM a

						inner join CFuncional b
							on b.CFid = a.CFid

						inner join CMTiposSolicitud c
							on c.Ecodigo = a.Ecodigo
							and c.CMTScodigo = a.CMTScodigo
							<cfif url.SC_INV NEQ -1>
								and (c.CMTStarticulo = 1 AND c.CMTSservicio = 0 AND c.CMTSactivofijo = 0)
							</cfif>

						inner join Monedas m
							on a.Ecodigo = m.Ecodigo
							and a.Mcodigo = m.Mcodigo

						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and a.CMSid   = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarSolicitante#">
							and a.ESestado >= 0
							and a.ESestado < 10
						<cfif url.SC_INV NEQ -1>
							and TRcodigo IS NULL
						</cfif>
						<cfif isdefined("form.fCMTScodigo") and len(trim(form.fCMTScodigo)) >
							and a.CMTScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(form.fCMTScodigo)#">
						</cfif>

						<cfif isdefined("form.fESnumero") and len(trim(form.fESnumero)) and isdefined("form.fESnumero2") and len(trim(form.fESnumero2))>
							and a.ESnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumero#"> and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumero2#">
						<cfelseif isdefined("form.fESnumero") and len(trim(form.fESnumero))>
							and a.ESnumero >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumero#">
						<cfelseif isdefined("form.fESnumero2") and len(trim(form.fESnumero2))>
							and a.ESnumero <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumero2#">
						</cfif>

						<cfif isdefined("form.CFid_filtro") and len(trim(form.CFid_filtro)) >
							and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid_filtro#">
						</cfif>

						<cfif isdefined("form.fObservaciones") and len(trim(form.fObservaciones)) >
							and upper(ESobservacion) like  upper('%#form.fObservaciones#%')
						</cfif>

						<cfif isdefined("Form.fESfecha") and len(trim(Form.fESfecha)) >
							<cfset vdFin = dateadd('d', 1, LSParsedatetime(form.fESfecha)) >
							<cfset vdFin = dateadd('l', -1, vdFin) >
							and ESfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fESfecha)#">
											and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vdFin#">
						</cfif>
						order by descripcion,ESnumero
					</cfquery>

					<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
						<cfinvokeargument name="query" 		value="#rsLista#"/>
						<cfinvokeargument name="cortes" 	value="descripcion"/>
						<cfinvokeargument name="desplegar" 	value="ESnumero, ESobservacion, CFdescripcion, ESfecha, Mnombre, EStotalest"/>
						<cfinvokeargument name="etiquetas" 	value="N&uacute;mero, Descripci&oacute;n, Centro Funcional, Fecha, Moneda, Total Estimado"/>
						<cfinvokeargument name="formatos" 	value="V, V, V, D, V, M"/>
						<cfinvokeargument name="align" 		value="left, left, left, left, left, right"/>
						<cfinvokeargument name="ajustar" 	value="N"/>
						<cfinvokeargument name="irA" 		value="#LvarCFM_form#"/>
						<cfinvokeargument name="botones" 	value="Nuevo,Aplicar"/>
						<cfinvokeargument name="checkall" 	value="S"/>
                        <cfinvokeargument name="checkboxes" value="S"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="keys" 		value="ESidsolicitud"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
					</cfinvoke>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>

<script language="javascript1.2" type="text/javascript">
	var directa = new Object();
	<cfoutput query="rsLista">directa['#rsLista.ESidsolicitud#'] = #rsLista.CMTScompradirecta#;</cfoutput>

	function funcNuevo(){
		document.lista.ESIDSOLICITUD.value = '';
	}

	function funcAplicar(){
		if (!fnAlgunoMarcadolista()){
			alert('Debe seleccionar al menos una solicitud de compra');
			return false;
		}
		cd = 0;
		cnd = 0;
		id = 0;
		if (!document.lista.chk.value){
			for (var i=0; i<document.lista.chk.length; i++) {
				if (document.lista.chk[i].checked && directa[document.lista.chk[i].value] == 1){
					cd = cd + 1;
					id = document.lista.chk[i].value;
				}
				if (document.lista.chk[i].checked && directa[document.lista.chk[i].value] == 0)
					cnd = 1;
				if(cd > 1 || (cnd == 1 && cd > 0)){
					alert("Solo se permite la aplicación en grupo de Solicitudes que no sea directas.");
					return false;
				}
			}
		}
		if(id == 0)
			document.lista.action = 'solicitudes-sql.cfm';
		else
			document.lista.action = 'ordenCompra-solicitud.cfm';
		return true;
	}

</script>


<cfparam  name="LvarTransaccionPagina" default="TransaccionesCRC.cfm">

<!---Se obtienen la informacion de la caja, Si no se tiene la caja en session, se sale de la pantalla--->
<cfif not isDefined("Session.Caja") OR NOT LEN(TRIM(Session.Caja))>
	<cflocation addtoken="no" url="../catalogos/AbrirCaja.cfm">
<cfelse>
	<cfquery name="rsCaja" datasource="#session.dsn#">
		select FCcodigo, FCdesc
	  		from FCajas
	  	where FCid    = #session.Caja#
	      and Ecodigo = #session.Ecodigo#
	</cfquery>
</cfif>
<cfparam name="PageNum_rsTransacciones" default="1">
<!---Variables de los Filtros--->
<cfset filtro 		 = "">
<cfset fETnumero 	 = "">
<cfset fETnombredoc  = "">
<cfset fOdescripcion = "">
<cfset fETfecha      = "">
<cfset fMnombre      = "">
<cfif isdefined("form.fETnumero") AND Len(Trim(form.fETnumero)) GT 0 >
	<cfset filtro = filtro & " and a.ETnumero = " & Trim(form.fETnumero) >
	<cfset fETnumero = Trim(form.fETnumero)>
</cfif>
<cfif isdefined("form.fETnombredoc") AND Len(Trim(form.fETnombredoc)) GT 0 >
	<cfset filtro = filtro & " and coalesce(a.ETnombredoc,sn.SNnombre) like upper('%" & Trim(form.fETnombredoc) & "%')" >
	<cfset fETnombredoc = Trim(form.fETnombredoc)>
</cfif>
<cfif isdefined("form.fOdescripcion") AND Len(Trim(form.fOdescripcion)) GT 0 >
	<cfset filtro = filtro & " and upper(b.Odescripcion) like upper('%" & Trim(form.fOdescripcion) & "%')" >
	<cfset fOdescripcion = Trim(form.fOdescripcion)>
</cfif>
<cfif isdefined("form.fETfecha") AND Len(Trim(form.fETfecha)) GT 0 >
	<cfset filtro = filtro & " and a.ETfecha >= convert(datetime,'#LSDateFormat(Form.fETfecha,'YYYYMMDD')#')" >
	<cfset fETfecha = Trim(form.fETfecha)>
</cfif>
<cfif isdefined("form.Mnombre") AND Len(Trim(form.Mnombre)) GT 0 >
	<cfset filtro = filtro & " and upper(c.Mnombre) like upper('%" & Trim(form.Mnombre) & "%')">
	<cfset fMnombre = Trim(form.Mnombre)>
</cfif>
<!--- Lista de la Facturas--->
<cfquery name="rsTransacciones" datasource="#Session.DSN#">
	select a.FCid, a.ETnumero, a.Ocodigo, a.SNcodigo, a.Mcodigo, c.Mnombre,	a.CCTcodigo,a.ETfecha,
		   a.ETtotal, a.ETestado, a.ETobs, coalesce(a.ETnombredoc,sn.SNnombre) as cliente,
           a.FACid, a.ts_rversion, b.Odescripcion
	from ETransacciones a
		inner join Oficinas b
			on a.Ecodigo = b.Ecodigo
		   and a.Ocodigo = b.Ocodigo
		inner join Monedas c
	   		on a.Ecodigo = c.Ecodigo
	       and a.Mcodigo = c.Mcodigo
		inner join SNegocios sn
	   		on a.SNcodigo = sn.SNcodigo
	  	   and a.Ecodigo  = sn.Ecodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and (a.ETestado = <cfqueryparam cfsqltype="cf_sql_char" value="P">
		or a.ETestado = <cfqueryparam cfsqltype="cf_sql_char" value="T">)
	  and a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Caja#">
	  and a.ETesLiquidacion = 0
	  <cfif Len(Trim(filtro)) GT 0 >
	  	<cfoutput>#preservesinglequotes(filtro)#</cfoutput>
	  </cfif>
		order by a.ETnumero
</cfquery>

<!--- Vlaida la existencia de registros para recuperar---->
<cfquery name="rsExistenciaRecuperacion" datasource="#session.dsn#">
		select
			count(1) as cantidad
		from FAERecuperacion e
		inner join FADRecuperacion d
		    on e.FAERid = d.FAERid
		where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and e.IndGenFact = 'R'
		and d.estado = 'P'
</cfquery>


<!--- Variables de la paginación --->
<cfset CurrentPage			       = 'listaTransaccionesFA.cfm'>
<cfset MaxRows_rsTransacciones     = 15>
<cfset StartRow_rsTransacciones    = Min((PageNum_rsTransacciones-1)*MaxRows_rsTransacciones+1,Max(rsTransacciones.RecordCount,1))>
<cfset EndRow_rsTransacciones      = Min(StartRow_rsTransacciones+MaxRows_rsTransacciones-1,rsTransacciones.RecordCount)>
<cfset TotalPages_rsTransacciones  = Ceiling(rsTransacciones.RecordCount/MaxRows_rsTransacciones)>
<cfset QueryString_rsTransacciones = Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
<cfset tempPos					   = ListContainsNoCase(QueryString_rsTransacciones,"PageNum_rsTransacciones=","&")>
<cfif tempPos NEQ 0>
	<cfset QueryString_rsTransacciones=ListDeleteAt(QueryString_rsTransacciones,tempPos,"&")>
</cfif>
<cfset cuantosReg = 0 >

<link rel="stylesheet" type="text/css" href="/cfmx/sif/fa/css/listaTransaccionesFA.css">
<cf_importLibs>

<cf_templateheader title="Registro de transacciones">
		<!--- panel para recuperacion DEBE LLAMARSE pnlRecuperar--->
		<div id="pnlRecuperar" style="display:none" class="row contenedorFA">
			<div class="col-xs-12 contenido">
				<iframe src="pnlRecuperarFacturas.cfm" width="100%" height="500px" frameborder="0" scrolling="si" id="iframe"></iframe>
			</div>
			<br/>
		</div>
<cf_web_portlet_start border="true" skin="#session.preferences.skin#" tituloalign="center" titulo="Lista de Transacciones">
		<div class="row contenedorFA">
			<div class="col-xs-12 contenido">
				<div class="row">
					<div class="col-sm-6" id="PendienteEnvioElectronica"></div>
					<div class="col-sm-6"
						<cfoutput><strong>Caja activa:</strong>  #rsCaja.FCcodigo# - #rsCaja.FCdesc#</cfoutput>
					</div>
				</div>
		  		<form style="margin:0" name="form1" method="post" action="<cfoutput>#LvarTransaccionPagina#</cfoutput>">
              		<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<!--- Títulos de las columnas en los filtros--->
						<tr class="areaFiltro">
						  <td width="1%">&nbsp;</td>
						  <td width="7%"> <div align="right"><strong>Doc.</strong></div></td>
						  <td width="31%"><strong>Cliente</strong></td>
						  <td width="30%"><strong>Oficina</strong></td>
						  <td width="5%"><strong>Fecha</strong></td>
						  <td width="8%"><strong>Moneda</strong></td>
						  <td width="6%">&nbsp;</td>
						  <td colspan="2">&nbsp;</td>
						</tr>
						<!--- Filtros --->
						<cfoutput>
						  <tr class="areaFiltro">
							<td>&nbsp;</td>
							<td> <div align="right">
								<input name="fETnumero" type="text" size="7" maxlength="7" style="text-align: right;"
								onBlur="javascript:fm(this,0); "
								onFocus="javascript:this.value=qf(this); this.select();"
								onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"
								value="#fETnumero#">
							  </div></td>
							<td> <input type="text" name="fETnombredoc" value="#fETnombredoc#" size="35" maxlength="35"></td>
							<td> <input type="text" name="fOdescripcion" value="#fOdescripcion#" size="35" maxlength="35"></td>
							<td><cf_sifcalendario form="form1" name="fETfecha" value="#fETfecha#"></td>
							<td><input type="text" name="Mnombre" value="#fMnombre#" size="15" maxlength="15"></td>
							<td colspan="2">&nbsp;</td>
							<td width="12%" ><div align="right">
								<input type="submit" name="btnFiltrar" class="btnFiltrar" value="Filtrar"  onClick="javascript:filtrar(this.form)">
							  </div></td>
						  </tr>
						</cfoutput>
						<tr>
						  <td><div align="right">

							</div></td>
						  <td colspan="8"></td>
						</tr>
						<!--- Titulos de la lista --->
						<tr class="tituloListas">
							<td>&nbsp;</td>
							<td><div align="right"><strong>Doc.</strong></div></td>
							<td nowrap><strong>Cliente</strong></td>
							<td nowrap><strong>Oficina</strong></td>
							<td nowrap><strong>Fecha</strong></td>
							<td nowrap><strong>Moneda</strong></td>
							<td nowrap><strong>Monto</strong></td>
							<td colspan="2" nowrap>&nbsp;</td>
						</tr>
	                	<cfif rsTransacciones.Recordcount EQ 0>
							<tr>
								<td colspan="8">
									<div align="center"><strong>--- No hay datos ---</strong></div>
								</td>
							</tr>
						</cfif>
						<cfoutput query="rsTransacciones" startrow="#StartRow_rsTransacciones#" maxrows="#MaxRows_rsTransacciones#">
						  <tr <cfif CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif> onMouseOver="style.backgroundColor='##E4E8F3';" onMouseOut="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
								<td></td>
							<td onClick="javascript:Procesar('#FCid#|#ETnumero#');"><div align="right"><a href="javascript: Procesar('#FCid#|#ETnumero#');">#ETnumero#</div></td>
							<td onClick="javascript:Procesar('#FCid#|#ETnumero#');" nowrap>&nbsp;<a href="javascript: Procesar('#FCid#|#ETnumero#');" title="#cliente#">
							  <cfif len(cliente) LTE 30>
								#cliente#
								<cfelse>
								#Mid(cliente,1,30)#...</cfif></td>
							<td onClick="javascript:Procesar('#FCid#|#ETnumero#');" nowrap>&nbsp;<a href="javascript: Procesar('#FCid#|#ETnumero#');" title="#Odescripcion#">
							  <cfif len(Odescripcion) LTE 25>
								#Odescripcion#
								<cfelse>
								#Mid(Odescripcion,1,25)#...</cfif></td>
							<td onClick="javascript:Procesar('#FCid#|#ETnumero#');" nowrap>&nbsp;<a href="javascript: Procesar('#FCid#|#ETnumero#');">#LSDateFormat(ETfecha,'DD/MM/YYYY')#</td>
							<td onClick="javascript:Procesar('#FCid#|#ETnumero#');" nowrap>&nbsp;<a href="javascript: Procesar('#FCid#|#ETnumero#');">#Mnombre#</td>
							<td onClick="javascript:Procesar('#FCid#|#ETnumero#');" nowrap align="right">&nbsp;<a href="javascript: Procesar('#FCid#|#ETnumero#');">#LSCurrencyFormat(ETtotal,'none')#</td>
							<td onClick="javascript:Procesar('#FCid#|#ETnumero#');" colspan="2" nowrap>&nbsp;</td>
						  </tr>
						  <cfset cuantosReg = cuantosReg + 1 >
						</cfoutput>
						<tr>
							<td colspan="9">&nbsp;</td>
						</tr>
						<tr>
						  <td colspan="9" valign="top"><div align="center">
							  <input type="submit" name="NuevoL" class="btnNuevo" value="Nuevo">
						<!--- Si existen registros por recuperar. pinto el boton ----->
						<cfif rsExistenciaRecuperacion.cantidad gt 0>
							  <input name="btnRecuperar" type="button" class="btnNormal" value="Recuperar" onClick="MostrarRecuperar(event);">
						</cfif>
							</div></td>
						</tr>
						<input type="hidden" name="datos" value="">
						<input type="hidden" name="Cambio" value="Cambio">
              		</table>
				</form>
			</div>
		  <table border="0" width="150" align="center">
			<cfoutput>
			  <tr>
				<td width="23%" align="center"> <cfif PageNum_rsTransacciones GT 1>
					<a href="#CurrentPage#?PageNum_rsTransacciones=1#QueryString_rsTransacciones#"><img src="../../imagenes/First.gif" border=0></a></cfif>
				</td>
				<td width="31%" align="center"> <cfif PageNum_rsTransacciones GT 1>
					<a href="#CurrentPage#?PageNum_rsTransacciones=#Max(DecrementValue(PageNum_rsTransacciones),1)##QueryString_rsTransacciones#"><img src="../../imagenes/Previous.gif" border=0></a></cfif>
				</td>
				<td width="23%" align="center"> <cfif PageNum_rsTransacciones LT TotalPages_rsTransacciones>
					<a href="#CurrentPage#?PageNum_rsTransacciones=#Min(IncrementValue(PageNum_rsTransacciones),TotalPages_rsTransacciones)##QueryString_rsTransacciones#"><img src="../../imagenes/Next.gif" border=0></a>
				  </cfif> </td>
				<td width="23%" align="center"> <cfif PageNum_rsTransacciones LT TotalPages_rsTransacciones>
					<a href="#CurrentPage#?PageNum_rsTransacciones=#TotalPages_rsTransacciones##QueryString_rsTransacciones#"><img src="../../imagenes/Last.gif" border=0></a></cfif>
				</td>
			  </tr>
			</cfoutput>
		  </table>
		</div>
 	<cf_web_portlet_end>
<cf_templatefooter>

<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>

<script language="JavaScript1.2" >
	function filtrar( form ){
		form.action = '';
		form.submit();
	}

	function valida() {
		if (validaChecks())
			return confirm('¿Desea aplicar los documentos seleccionados?');
		return false;
	}

	function validaChecks() {
		var f = document.form1;
		//f.action='listaTransaccionesFA.cfm';
		<cfif cuantosReg NEQ 0>
			<cfif cuantosReg EQ 1>
				if (f.chk.checked)
					return true;
				else
					alert("Debe seleccionar al menos un documento para aplicar");
			<cfelse>
				var bandera = false;
				var i;
				for (i = 0; i < f.chk.length; i++) {
					if (f.chk[i].checked) bandera = true;
				}
				if (bandera)
					return true;
				else
					alert("Debe seleccionar al menos un documento para aplicar");
			</cfif>
		<cfelse>
			alert("¡No existen documentos por aplicar!");
		</cfif>
		return false;
	}

	function Marcar(c) {
		var f = document.form1;
		<cfif cuantosReg GT 0>
		if (c.checked) {
			for (counter = 0; counter < f.chk.length; counter++)
			{
				if ((!f.chk[counter].checked) && (!f.chk[counter].disabled))
					{  f.chk[counter].checked = true;}
			}
			if ((counter==0)  && (!f.chk.disabled)) {
				f.chk.checked = true;
			}
		}
		else {
			for (var counter = 0; counter < f.chk.length; counter++)
			{
				if ((f.chk[counter].checked) && (!f.chk[counter].disabled))
					{  f.chk[counter].checked = false;}
			};
			if ((counter==0) && (!f.chk.disabled)) {
				f.chk.checked = false;
			}
		};
		</cfif>
	}

	function Procesar(data) {

		var f = document.form1;
		if (data != "") {
			f.datos.value = data;
			f.action='<cfoutput>#LvarTransaccionPagina#</cfoutput>';
			f.submit();
		}
	}

	//Muestra el panel de recuperacion.
	function MostrarRecuperar(e){
		e.preventDefault();
		lineasSeleccionadas = "";
		$('#pnlRecuperar').show('slow');
	}
	//Funcion para buscar las transacciones pendientes de envio a la facturación Electronica
	var ObjPeticionAnterior ;
	function ConsultaEnvioPediente(FCid,RegistrosPrincipales){
	  var dataP = {
					method: "ConsultaBitacoraStatusPorCaja",
					FCid:FCid,
					RegistrosPrincipales:  RegistrosPrincipales
				  }

			try {
				$.ajax ({
					type: "get",
					url: "/cfmx/sif/Componentes/FA_EnvioElectronica.cfc",
					data: dataP,
					dataType: "json",
					success: function( objResponse ){
						if (objResponse.LISTA.length)
							PrintPending(objResponse.LISTA);
						},
					error:  function( objRequest, strError ){
						alert('ERROR'+objRequest + ' - ' + strError);
						console.log(objRequest);
						console.log(strError);
						}
				});
			} catch(ss){
			 alert('FALLO Inesperado');
			 console.log(ss);
			}
	}
	function PrintPending(LvarList){
		$("#PendienteEnvioElectronica").html('<ul class="list-group" id="GrupoFacs"></ul>')
		$.each(LvarList, function( index, value ) {
			if(value.ESTADO == 0)
				Estado='Pendiente Envio...';
			else
				Estado = 'Enviando...';
		 	$( "#GrupoFacs" ).append( '<li class="list-group-item"><strong>'+value.NUMERODOCUMENTO +'</strong> '+ Estado +'</li>' );
		});
	}
//COMENTADO POR JEREMIAS... SOLO APLICA PARA FACTURACIÓN ELECTRÓNICA EN LA NACIÓN, HAY QUE VER COMO SE PARAMETRIZA ESTO EN LOS CLIENTES
//POR FAVOR NO DESCONMENTAR PARA NINGÚN OTRO CLIENTE HASTA QUE SEA SOLUCIONADO DE RAIZ

//*var myVar = setInterval(function(){ConsultaEnvioPediente(<cfoutput>#session.Caja#</cfoutput>,true);}, 5000);

</script>
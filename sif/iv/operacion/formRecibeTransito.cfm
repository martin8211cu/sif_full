<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!-- modo para el detalle -->
<cfif isdefined("form.DRTlinea")>
	<cfset modoDet="CAMBIO">
<cfelse>
	<cfif not isdefined("form.DRTlinea")>
		<cfset modoDet="ALTA">
	<cfelseif form.modoDet EQ "CAMBIO">
		<cfset modoDet="CAMBIO">
	<cfelse>
		<cfset modoDet="ALTA">
	</cfif>
</cfif>

<!--- Consultas --->
<cfif modo NEQ 'ALTA'>
	<!--- Datos del Encabezado --->
	<cfquery name="rsForm" datasource="#Session.DSN#">
		select 
		<cf_dbfunction name="to_char" args="ERTid"> as ERTid,
		ERTfecha, 
		ERTdocref, 
		ERTobservacion, 
		ERTaplicado, 
		<cf_dbfunction name="to_char" args="Usucodigo"> as Usucodigo,
		Ulocalizacion, 
		ts_rversion 
			from ERecibeTransito
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			<cfif isdefined ('form.ERTid') and len(trim(form.ERTid))>
		    and ERTid = #Form.ERTid#
			</cfif>
	</cfquery>

	<cfquery name="rsAlmacenes" datasource="#Session.DSN#">
		select 
		<cf_dbfunction name="to_char" args="alm.Aid"> as Aid,
		alm.Bdescripcion 
			from Almacen alm
			where alm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	
	
	<cfif modoDet NEQ "ALTA">
	<!--- Datos del Detalle --->	
		<cfquery name="rsFormDetalle" datasource="#Session.DSN#">
			select 
			<cf_dbfunction name="to_char" args="d.DRTlinea"> as DRTlinea,
			<cf_dbfunction name="to_char" args="d.Tid"> as Tid,
			<cf_dbfunction name="to_char" args="d.Alm_Aid"> as Alm_Aid,
			d.DRTcantidad, 
			<cf_dbfunction name="to_char" args="d.Aid"> as Aid,
			d.DRTfecha, 
			d.Ddocumento, 
			d.DRTcostoU, 
			d.Ucodigo, 
			d.Kunidades, 
			d.Kcosto, 
			d.DRTembarque, 
			d.DRTgananciaperdida, 
			d.ts_rversion
				from DRecibeTransito d
					inner join ERecibeTransito e
					on d.ERTid = e.ERTid	
				where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and d.ERTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERTid#">
				  and d.DRTlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DRTlinea#">
		</cfquery>
		
		<!--- Datos del Artículo --->
		<cfquery name="rsArticulo" datasource="#Session.DSN#">
			select Acodigo, Adescripcion 
			from Articulos 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
			  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormDetalle.Aid#">
		</cfquery>
		
		<!--- Cantidades del Artículo en Tránsito --->
		<cfquery name="rsSaldoArticulo" datasource="#Session.DSN#">
			<cfif isDefined("rsFormDetalle.Tid") and Len(Trim(rsFormDetalle.Tid)) GT 0>		
				select (Tcantidad - Trecibido) as Saldo, Trecibido, Tcantidad, (TcostoLinea / Tcantidad) as CostoUnitario
				from Transito
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
				  and Tid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormDetalle.Tid#">
			<cfelse>
  		      	select 0.00 as Saldo, 0.00 as Trecibido
 		    </cfif>			  
		</cfquery>
		

		<!--- Almacenes que tienen existencias para ese artículo --->
		<cfquery name="rsAlmacenesDet" datasource="#Session.DSN#">
			select e.Alm_Aid, 
			alm.Bdescripcion
				from Existencias e
					inner join Articulos a
					on e.Aid = a.Aid
			  		and e.Ecodigo = a.Ecodigo
						inner join Almacen alm
						on e.Alm_Aid = alm.Aid
			  			and e.Ecodigo = alm.Ecodigo
				where a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormDetalle.Aid#">
		</cfquery>
	</cfif>
</cfif>

<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="JavaScript">
	var popUpWin=0;
	
	function popUpWindow(URLStr, left, top, width, height){
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlisMasivo(ERTid,Alm_Aid) {	
		popUpWindow("ConlisMasivo.cfm?"
		+ "form=form2"
		+ "&ERTid=" + ERTid 
		+ "&Alm_Aid=" + Alm_Aid
		,250,200,650,450);
	}

</script>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" src="/cfmx/sif/js/NumberFormat150.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	// función similar al fm pero mejorada
	function fm_2(campo,decimales) 
	{
		var nf = new NumberFormat();
		
		nf.setNumber(campo.value);
		nf.setPlaces(decimales); 
		nf.setCommas(true);
		nf.setCurrency(false); 
	
		var s = nf.toFormatted();
		campo.value = s;
	}
</script>

<script language="JavaScript">
//----------------------------------------------------------------
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<cf_templatecss>

<form name="form1" method="post" action="SQLRecibeTransito.cfm" style="margin:0">
<cfoutput>
<input type="hidden" name="modo" value="#modo#">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Encabezado">
<!--- Encabezado --->
<table width="100%" border="0" cellspacing="1" cellpadding="1">
  <tr>
    <td width="24%"><div align="right"><strong>Fecha:</strong></div></td>
    <td width="24%"><cfif modo NEQ 'ALTA'>
			<cf_sifcalendario name="ERTfecha" value="#LSDateFormat(rsForm.ERTfecha,'DD/MM/YYYY')#">
		<cfelse>
			<cf_sifcalendario name="ERTfecha" value="#LSDateFormat(Now(),'DD/MM/YYYY')#">			
		</cfif></td>
    <td width="13%"><div align="right"><strong>Documento</strong>:</div></td>
    <td width="19%"><input type="text" name="ERTdocref" size="20" maxlength="20" <cfif modo NEQ 'ALTA'>readonly</cfif> value="<cfif modo NEQ 'ALTA'>#rsForm.ERTdocref#</cfif>"></td>
    <td width="20%"><cfif modo NEQ "ALTA"><div align="right"><strong>Almac&eacute;n:</strong></div></cfif></td>
    <td width="39%">
	<cfif modo NEQ "ALTA">
	<select name="Alm_Aid">	
		  <cfloop query="rsAlmacenes">
			<option value="#Aid#" >#Bdescripcion#</option>
		  </cfloop>
		</select>
	</cfif>	
		</td>
  </tr>
  
  <tr>
    <td><div align="right"><strong>Observaci&oacute;n:</strong></div></td>
    <td colspan="5"><textarea name="ERTobservacion" cols="50" <cfif modo NEQ 'ALTA'>readonly</cfif> rows="2"><cfif modo NEQ 'ALTA'>#rsForm.ERTobservacion#</cfif></textarea></td>
    </tr>
	
  <tr>
    <td colspan="6"><div align="center">

		<script language="JavaScript" type="text/javascript">
			// Funciones para Manejo de Botones
			botonActual = "";		
			function setBtn(obj) {
				botonActual = obj.name;
			}
			function btnSelected(name, f) {
				if (f != null) {
					return (f["botonSel"].value == name)
				} else {
					return (botonActual == name)
				}
			}
			
			// a la pantalla de importación de un archivo de texto
			function importar() {
				location.href = "ImportadorRecepcion.cfm";
			}
			
		</script>
		
		<cfif not isdefined('modo')>
			<cfset modo = "ALTA">
		</cfif>
		
		<input type="hidden" name="botonSel" value="">		
		<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
		
		<!--- Botones --->
		<cfif modo EQ "ALTA">
			<input type="submit" name="btnAgregarE" value="Agregar" 	class="btnGuardar" 	onClick="javascript: this.form.botonSel.value = this.name">
			<input type="reset"  name="btnLimpiar"  value="Limpiar" 	class="btnLimpiar" 	onClick="javascript: this.form.botonSel.value = this.name">
			<input type="button" name="btnImportar" value="Importación" class="btnNormal"  	onClick="javascript: importar();">
		<cfelse>
			<input type="submit" name="btnBorrarE" 	value="Eliminar" 	class="btnEliminar" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('¿Desea Eliminar el Documento?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
			<input type="submit" name="btnNuevo" 	value="Nuevo" 		class="btnNuevo" 	onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); ">					
			<input type="button" name="btnMasivo" 	value="Masivo"  	class="btnNormal"	onClick="javascript: doConlisMasivo(document.form1.ERTid.value, document.form1.Alm_Aid.value);">
			<input type="submit" name="btnAplicar" 	value="Aplicar"		class="btnAplicar"  onClick="javascript: this.form.botonSel.value = this.name; if ( confirm('¿Desea Aplicar el Documento?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
		</cfif></div>
		<!--- / Botones --->
		
		<!--- ts_rversion del Encabezado --->		
		<cfif modo NEQ "ALTA">
		  <cfset tsE = "">
		  <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsForm.ts_rversion#" returnvariable="tsE">
		  </cfinvoke>
		  <input name="ERTid" type="hidden" value="<cfif modo NEQ "ALTA">#rsForm.ERTid#</cfif>">
		  <input type="hidden" name="timestampE" value="<cfif modo NEQ "ALTA">#tsE#</cfif>">
		</cfif>
				
	  </td>
	</tr>
	
</table>
<!--- / Encabezado --->

<cf_web_portlet_end>
</cfoutput>
</form>

<!--- Detalle --->
<cfif modo NEQ 'ALTA'>
	<form name="form2" method="post" action="SQLRecibeTransito.cfm" style="margin:0" 
		onSubmit="javascript:
			var e = document.form1;
			var f = document.form2; 
			if ((f.botonSel.value == 'btnAgregarD') || (f.botonSel.value == 'btnCambiarD') || (f.botonSel.value == 'btnBorrarD')) 
			{
				// quita las comas de las cantidades
				f.DRTcantidad.value = qf(f.DRTcantidad.value);
				f.DRTcostoU.value = qf(f.DRTcostoU.value);
				f.DRTgananciaperdida.value = qf(f.DRTgananciaperdida.value);
				f.TotalLinea.value = qf(f.TotalLinea.value);
				f.DRTcantidad_ant.value = qf(f.DRTcantidad_ant.value);
				// asigna los valores del encabezado en hiddens en el detalle
				f.ERTfecha.value = e.ERTfecha.value;
				f.ERTdocref.value = e.ERTdocref.value;
				f.ERTobservacion.value = e.ERTobservacion.value;												
			}">
	
	<cfoutput>
	
	<div id="idTablaDetalle" style="display: none;"> 
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Detalle">
	
	<table width="100%" border="0" cellspacing="1" cellpadding="1">
  
	  <tr bgcolor="##CCCCCC">
		<td width="12%"><strong>&nbsp;Embarque</strong></td>
		<td width="9%"><strong>Art&iacute;culo</strong></td>
		<td colspan="2"><strong>Nombre</strong></td>
		<td width="15%"><strong>Unid. Med.</strong></td>
		<td width="25%"><strong>Documento</strong></td>
	  </tr>
	  
	  <tr class="listaPar">
		<td><input type="text" name="DRTembarque" class="cajasinbordeb" size="20" maxlength="20" value="<cfif modoDet NEQ 'ALTA'>#rsFormDetalle.DRTembarque#</cfif>" readonly></td>
		<td><input type="text" name="Acodigo" class="cajasinbordeb" value="<cfif modoDet NEQ "ALTA">#rsArticulo.Acodigo#</cfif>" size="15" maxlength="15" readonly></td>
		<td colspan="2"><input type="text" name="Adescripcion" class="cajasinbordeb" size="35" maxlength="80" value="<cfif modoDet NEQ "ALTA">#rsArticulo.Adescripcion#</cfif>" readonly>
		  <input type="hidden" name="Aid" value="<cfif modoDet NEQ "ALTA">#rsFormDetalle.Aid#</cfif>"></td>
		<td><input type="text" name="Ucodigo" class="cajasinbordeb" size="5" maxlength="5" value="<cfif modoDet NEQ 'ALTA'>#rsFormDetalle.Ucodigo#</cfif>" readonly>
		</td>
		<td><input type="text" name="Ddocumento" class="cajasinbordeb" value="<cfif modoDet NEQ 'ALTA'>#rsFormDetalle.Ddocumento#</cfif>" readonly></td>
	  </tr>  
	
	  <tr bgcolor="##CCCCCC">
	    <td colspan="2" nowrap>&nbsp;<strong>Almac&eacute;n</strong></td>
	    <td width="17%" nowrap><div align="right"><strong>Cantidad</strong></div></td>
	    <td width="22%"><div align="right"><strong>Costo Unit.</strong></div></td>
	    <td><div align="right"><strong>Gananc./P&eacute;rd.</strong></div></td>
	    <td><div align="right"><strong>Total</strong></div></td>
	    </tr>
	  <tr>
	    <td colspan="2" nowrap><select name="Alm_Aid">
			<cfif modoDet NEQ 'ALTA'>
			<cfloop query="rsAlmacenesDet">
			  <option value="#Aid#" <cfif modoDet NEQ 'ALTA' and rsFormDetalle.Alm_Aid EQ Aid> selected </cfif>>#Bdescripcion#</option>
			</cfloop>
			</cfif>
		  </select></td>
	    <td nowrap><div align="right">
	      <input type="text" name="DRTcantidad" onFocus="javascript:document.form2.DRTcantidad.select();"style="text-align:right" onChange="javascript:fm_2(this,2);" onBlur="javascript:calcular();" value="<cfif modoDet NEQ "ALTA">#LSCurrencyFormat(rsFormDetalle.DRTcantidad,'none')#<cfelse>0.00</cfif>" size="20" maxlength="20">
	      </div></td>
	    <td><div align="right">
	      <!--- NO BORRAR
		  <input type="text" name="DRTcostoU" onFocus="javascript:document.form2.DRTcostoU.select();" style="text-align:right" onChange="javascript:fm_2(this,2);" onBlur="javascript:calcular();" value="<cfif modoDet NEQ "ALTA">#LSCurrencyFormat(rsFormDetalle.DRTcostoU,'none')#<cfelse>0.00</cfif>" size="20" maxlength="20">--->
		  <input type="text" name="DRTcostoU" class="cajasinbordeb" style="text-align:right" readonly value="<cfif modoDet NEQ "ALTA">#LSCurrencyFormat(rsFormDetalle.DRTcostoU,'none')#<cfelse>0.00</cfif>" tabindex="-1" size="20" maxlength="20">
	      </div></td>
	    <td><div align="right"><input type="text" name="DRTgananciaperdida" onFocus="javascript:document.form2.DRTgananciaperdida.select();" style="text-align:right" onChange="javascript:fm_2(this,2);" value="<cfif modoDet NEQ "ALTA">#LSCurrencyFormat(rsFormDetalle.DRTgananciaperdida,'none')#<cfelse>0.00</cfif>" size="20" maxlength="20"></div></td>
	    <td><div align="right">
	      <input type="text" name="TotalLinea" class="cajasinbordeb" tabindex="-1" style="text-align:right;" size="18" maxlength="18" value="0.00" readonly>
	      </div></td>
	    </tr>
	  <tr>
		<td colspan="2" nowrap>
		  <input type="hidden" name="Tid" value="<cfif modoDet NEQ 'ALTA'>#rsFormDetalle.Tid#</cfif>">
		  <input type="hidden" name="Saldo" value="<cfif modoDet NEQ 'ALTA'>#rsSaldoArticulo.Saldo#<cfelse>0.00</cfif>">
		  <input type="hidden" name="Trecibido" value="<cfif modoDet NEQ "ALTA">#rsSaldoArticulo.Trecibido#<cfelse>0.00</cfif>">
		  <input type="hidden" name="DRTcantidad_ant" value=""></td>
		<td nowrap><strong> </strong></td>
		<td></td>
		<td></td>
		<td></td>
	  </tr>
	
	  <tr>
		<td colspan="6"><div align="center">
	
		  <input type="hidden" name="botonSel" value="">
		  <!--- Botones --->
		  <cfif modo NEQ 'ALTA' and modoDet EQ 'ALTA'>
			<!--- <input type="submit" name="btnAgregarD"  value="Agregar Línea" onClick="javascript: this.form.botonSel.value = this.name; return validarCantidad();" > --->
		  </cfif>
		  <cfif modo NEQ 'ALTA' and modoDet NEQ 'ALTA'>
			<input type="submit" name="btnCambiarD" value="Modificar" onClick="javascript: this.form.botonSel.value = this.name; 	document.form2.DRTcantidad_ant.value = document.form2.DRTcantidad.defaultValue; return validarCantidad2();" >
			<input type="submit" name="btnBorrarD"  value="Eliminar L&iacute;nea" onClick="javascript: this.form.botonSel.value = this.name; if ( confirm('¿Desea Eliminar la línea?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}" >
			<!--- <input type="submit" name="btnNuevoD"   value="Nueva L&iacute;nea" onClick="javascript:this.form.botonSel.value = this.name;" > --->
		  </cfif>
		  <!--- / Botones --->
	
		  <input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
		  <input type="hidden" name="DDdocref" value="">
	
		  <!--- ts_rversion del Detalle --->
		  <cfif modo NEQ "ALTA" and modoDet NEQ 'ALTA'>
			<cfset tsD = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsFormDetalle.ts_rversion#" returnvariable="tsD">
			</cfinvoke>
			<input name="DRTlinea" type="hidden" value="<cfif modoDet NEQ "ALTA">#rsFormDetalle.DRTlinea#</cfif>">
			<input type="hidden" name="timestampD" value="<cfif modoDet NEQ "ALTA">#tsD#</cfif>">
		  </cfif>

		  <!--- Campos hidden del encabezado --->
		  <input name="ERTid" type="hidden" value="<cfif modo NEQ "ALTA">#rsForm.ERTid#</cfif>">		  
		  <input name="ERTfecha" type="hidden" value="">
		  <input name="ERTdocref" type="hidden" value="">
		  <input name="ERTobservacion" type="hidden" value="">
		  <input name="timestampE" type="hidden" value="#tsE#">
		</div></td>
		</tr>
	</table>
	
	<cf_web_portlet_end>
	</div>
	
	</cfoutput>
	
	<script language="JavaScript1.2" type="text/javascript">
		
		ocultar();
		
		<cfif modo NEQ 'ALTA' and modoDet NEQ 'ALTA'>
			calcular();
		</cfif>			
		
		function ocultar() {
			<cfif modo NEQ 'ALTA'>			
				<cfif modoDet NEQ 'ALTA'>
					document.getElementById("idTablaDetalle").style.display = "";
				<cfelse>
					document.getElementById("idTablaDetalle").style.display = "none";
				</cfif>
			</cfif>
		}
					
		// Obtiene el costo total de la línea
		function calcular() {
			var f = document.form2;
			var TotalLinea = new Number(qf(f.TotalLinea.value));
			var DRTcostoU = new Number(qf(f.DRTcostoU.value));
			var DRTcantidad = new Number(qf(f.DRTcantidad.value));
			// Costo total de la línea = costo unitario * cantidad recibida
			f.TotalLinea.value = (DRTcostoU * DRTcantidad);
			//f.TotalLinea.value = fm_2(f.TotalLinea,2);
		}
	
		// valida la cantidad a cambiar (solo para cambiar líneas de detalle)	
		function validarCantidad2() {
			var f = document.form2;
			var cantidad_inicial = new Number(qf(f.DRTcantidad.defaultValue));
			var cantidad = new Number(qf(f.DRTcantidad.value));
			var saldo = new Number(qf(f.Saldo.value));
			<!--- Comentado por Mauricio Esquivel 21/10/2004 --->
			/*
			if (cantidad_inicial + saldo < cantidad) {
				alert("Debe digitar una cantidad menor o igual que "+ eval(cantidad_inicial + saldo));
				return false;
			}
			else
			*/
				return true;		
		}	
	</script>
	
	</form>
</cfif>
<!--- / Detalle --->

<script language="JavaScript1.2" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	<cfif modo NEQ "ALTA">
		objForm2 = new qForm("form2");
	</cfif>
	objForm.ERTdocref.required = true;
	objForm.ERTdocref.description="Documento de referencia";

	<cfif modo NEQ "ALTA">
		objForm.ERTdocref.required = true;
		objForm.ERTdocref.description="Documento de Referencia";
		objForm2.DRTcantidad.required = true;
		objForm2.DRTcantidad.description="Cantidad";
		objForm2.DRTcostoU.required = true;
		objForm2.DRTcostoU.description="Costo Unitario";			
	</cfif>		
	
	function deshabilitarValidacion(){
		objForm.ERTdocref.required = false;
		<cfif modoDet NEQ "CAMBIO">
			objForm2.DRTcantidad.required = false;
			objForm2.DRTcostoU.required = false;
			objForm2.DRTcostoU.description="Costo Unitario";						
		</cfif>
	}
	function habilitarValidacion(){
		objForm.ERTdocref.required = true;
		<cfif modoDet EQ "CAMBIO">
			objForm2.DRTcantidad.required = true;
			objForm2.DRTcostoU.required = true;
			objForm2.DRTcostoU.description="Costo Unitario";						
		</cfif>
	}	
</script>

<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif not isdefined("form.modoDet")>
	<cfset modoDet = "ALTA">
<cfelse>
	<cfset modoDet = form.modoDet >
</cfif>

<cfif isDefined("form.NuevoE")>
	<cfset modo = "ALTA">
	<cfset modoDet = "ALTA">
</cfif>

<cfif isDefined("Form.EMid") and len(trim(Form.EMid)) gt 0 and modo NEQ "ALTA">								

	<cfquery name="rsEMinteralmacen" datasource="#session.DSN#">
		select EMid, EMdoc, EMalm_Orig, EMalm_Dest, EMfecha, ts_rversion
		from EMinteralmacen 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	  			
			and EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EMid#">
	</cfquery>

	<cfif isDefined("Form.DMlinea") and Form.DMlinea NEQ "" and modoDet NEQ "ALTA">		
		<cfquery name="rsDMinteralmacen" datasource="#session.DSN#">
			select EMid, DMlinea, DMAid, DMcant, ts_rversion 
			from DMinteralmacen 
			where EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EMid#">
			  and DMlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DMlinea#">
		</cfquery>

		<cfquery name="rsArticulo" datasource="#session.DSN#">
			select Aid as DMAid , Acodigo, Adescripcion from Articulos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DMAid#">
		</cfquery>
		
		<cfquery name="rsSumaCantidad" datasource="#session.DSN#">
			select coalesce(sum(DMcant),0.00) Acumulado
			from DMinteralmacen 
			where EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EMid#"> 
			  and DMAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DMAid#">
		</cfquery>
	</cfif>
</cfif>		

<cfset rsFecha = QueryNew("FechaHoy")>
<cfset rsTempFecha = QueryAddRow(rsFecha, 1)>
<cfset rsTempFecha = QuerySetCell(rsFecha,"FechaHoy",Now())>

<cfquery name="rsAlmacenesIni" datasource="#session.DSN#">
    select A.Aid, A.Bdescripcion
	from Almacen A
    	inner join AResponsables R
           on R.Aid = A.Aid
           and A.Ecodigo =  R.Ecodigo
	where A.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" > 
     and R.Usucodigo = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_integer" > 
	order by Bdescripcion
</cfquery>

<cfquery name="rsAlmacenesFin" datasource="#session.DSN#">
	SELECT Aid, Bdescripcion FROM Almacen 
	WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	ORDER BY Bdescripcion 
</cfquery>

<cfquery name="rsArticulos" datasource="#session.DSN#">
	select a.Alm_Aid, a.Aid, b.Adescripcion 
	from Existencias a
	inner join Articulos b
	  on a.Aid = b.Aid
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	order by b.Adescripcion		
</cfquery>

<cfif modo NEQ "ALTA" and modoDet NEQ "ALTA">
	<cfquery name="rsExistencias" datasource="#session.DSN#">				
		select Eexistencia
		from Existencias 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
		  and Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AlmIni#">
		  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DMAid#">				  
	</cfquery>						
</cfif>

<script language="JavaScript" src="../../js/calendar.js"></script>
<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="JavaScript" type="text/JavaScript">
function validaConlisArt() {
	<cfif modoDet EQ "ALTA" and modo EQ "CAMBIO">
		doConlis();
	</cfif>
}

function DeshabilitarEnc(valor) {
	document.form1.AlmIni.disabled = valor;
	document.form1.AlmFin.disabled = valor;
}

function DeshabilitarDet(valor) {
	if (valor == true) novalor = false; else novalor = true;		
	<cfif modoDet NEQ "ALTA">
		document.form1.CambiarD.disabled = novalor;
		document.form1.BorrarD.disabled = novalor;
	</cfif>
}

function Lista() {
	document.form1.action='listaMovInterAlmacen.cfm';
	document.form1.EMid.value='';
	document.form1.submit();		
	return true;	
}

function AgregarCombo2(combo,codigo) {
	var cont = 0;
	combo.length=0;
	<cfoutput query="rsAlmacenesFin">
		if (#Trim(rsAlmacenesFin.Aid)#!=codigo){
			combo.length=cont+1;
			combo.options[cont].value='#rsAlmacenesFin.Aid#';
			combo.options[cont].text='#rsAlmacenesFin.Bdescripcion#';
			cont++;
		};
	</cfoutput>
}

function AgregarCombos() {
	AgregarCombo2(document.form1.AlmFin,document.form1.AlmIni.value);
}

var popUpWin=0;
function popUpWindow(URLStr, left, top, width, height){
  if(popUpWin){
    if(!popUpWin.closed) popUpWin.close();
  }
  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
}

function doConlis(){
	// Se envía el almacén inicial como parámetro para que filtre el donlis	
	popUpWindow("ConlisExistencias.cfm?form=form1&id=DMAid&desc=Adescripcion&AlmIni="+document.form1.AlmIni.value
					+"&cant=Cantidad&cantTemp=CantidadTemp",250,200,650,350);
}

function validaConlis() {
	showCalendar('document.form1.EMfecha');
}

function AsignarHiddensEncab(){
	document.form1._AlmIni.value = document.form1.AlmIni.value;
	document.form1._AlmFin.value = document.form1.AlmFin.value;
	document.form1._Documento.value = document.form1.Documento.value;
	document.form1._EMfecha.value = document.form1.EMfecha.value;
}

function AsignarHiddensDet() {
	document.form1._Aid.value = document.form1.DMAid.value;
	document.form1._Cantidad.value = document.form1.Cantidad.value;
}

function ValidaForm(){
	var mensaje = "Se presentaron los siguientes errores:\n\n";
	var paso = true;
	if (document.form1.Documento.value == "") {
		paso = false;
		mensaje += " - El Documento es requerido.\n"
	}
	
	if (document.form1.EMfecha.value == "") {
		mensaje += " - La Fecha es requerida.\n"		
		paso = false;
	}

	<cfif modo EQ "CAMBIO">
		if (document.form1.DMAid.value == "") {
			mensaje += " - El Artículo es requerido.\n"					
			paso = false;
		}
		
		if (parseFloat(document.form1.Cantidad.value) == 0) {
			mensaje += " - La cantidad debe ser mayor que cero.\n"					
			paso = false;
		}
	<cfelse>
		if (document.form1.AlmIni.value == "") {
			mensaje += " - El Almacén Inicial es requerido.\n"					
			paso = false;
		}
		if (document.form1.AlmFin.value == "") {
			mensaje += " - El Almacén Final es requerido.\n"								
			paso = false;
		}
	</cfif>

	if ( paso ){
		document.form1.AlmIni.disabled = false;
		document.form1.AlmFin.disabled = false;
	}
	else{
		alert(mensaje)
	}
	return paso;
}
</script>

<form action="SQLMovInterAlmacen.cfm" name="form1" method="post" onSubmit="javascript:return ValidaForm();">  
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr><td class="tituloAlterno"><div align="center">Encabezado de Movimiento</div></td></tr>
		<tr>
			<td align="center">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr><td colspan="4">&nbsp;</td></tr>
					<tr> 
						<td align="right">Documento:&nbsp;</td>
						<td>
							<cfoutput>	
							<cfif modo NEQ "ALTA">
								<input name="Documento" type="text" size="20" maxlength="20" value="#rsEMinteralmacen.EMdoc#" alt=""El Documento>
							<cfelse>
								<input name="Documento" type="text" size="20" maxlength="20" value="" alt="El Documento">
							</cfif>		
							</cfoutput>
						</td>
				
						<td align="right" nowrap>Almac&eacute;n Inicial:&nbsp;</td>
						<td>
							<cfif modo EQ "ALTA"> 
                            	<cfif rsAlmacenesIni.recordcount eq 0>
                                	<script>
											alert("El usuario no tiene Almacenes asociados, debe de ir al Catalogo y asociarle el Almacén.")
									</script>
                                <cfelse>       	
								<select name="AlmIni" onChange="javascript:AgregarCombos();">
									<cfoutput query="rsAlmacenesIni"> 
										<option value="#rsAlmacenesIni.Aid#">#rsAlmacenesIni.Bdescripcion#</option>
									</cfoutput>
								</select>
                                </cfif>
							<cfelse>
								<select name="AlmIni" disabled >
									<cfoutput query="rsAlmacenesIni"> 
										<cfif rsEMinteralmacen.EMalm_Orig eq rsAlmacenesIni.Aid>
											<option value="#rsAlmacenesIni.Aid#" selected>#rsAlmacenesIni.Bdescripcion#</option>
										</cfif>	
									</cfoutput>
								</select>
							</cfif>	
						</td>
				
						<td align="right" nowrap>Almac&eacute;n Final:&nbsp;</td>
						<td>
							<cfif modo EQ "ALTA">   
								<select name="AlmFin" ></select>
							<cfelse>
								<select name="AlmFin" disabled>
									<cfoutput query="rsAlmacenesFin">
										<cfif rsEMinteralmacen.EMalm_Dest eq rsAlmacenesFin.Aid>
											<option value="#rsAlmacenesFin.Aid#" selected>#rsAlmacenesFin.Bdescripcion#</option>
										</cfif>	
									</cfoutput>
								</select>
							</cfif>	
						</td>

						<td align="right" nowrap>Fecha:&nbsp;</td>
						<td nowrap>
							<cfoutput>
								<cfif modo neq 'ALTA' ><cfset fecha = LSDateformat(rsEMinteralmacen.EMfecha,'dd/mm/yyyy')><cfelse><cfset fecha = LSDateformat(Now(),'dd/mm/yyyy') ></cfif>
								<cf_sifcalendario Conexion="#session.DSN#" form="form1" name="EMfecha" value="#fecha#" >
							</cfoutput>										
					
							<cfif modo EQ 'CAMBIO'>
								<input type="hidden" name="_EMfecha" value="<cfoutput>#rsEMinteralmacen.EMfecha#</cfoutput>" alt="La Fecha del Ajuste" >
							</cfif>
						</td>

						<cfset tsE = "">
							<cfif modo NEQ "ALTA">        
								<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsEMinteralmacen.ts_rversion#" returnvariable="tsE">
							</cfinvoke>
						</cfif>	
				
						<td>
						<input type="hidden" name="EMid" value="<cfif modo NEQ "ALTA"><cfoutput>#rsEMinteralmacen.EMid#</cfoutput></cfif>">
						<input type="hidden" name="timestampE" value="<cfif modo NEQ "ALTA"><cfoutput>#tsE#</cfoutput></cfif>"> 
						<input type="hidden" name="_AlmIni" value="">
						<input type="hidden" name="_AlmFin" value="">
						<input type="hidden" name="_Documento" value="">
						<input type="hidden" name="_EMfecha" value="">
						</td>		
						
					  <cfif modo eq 'ALTA'>
						  <script language="JavaScript">
							AgregarCombo2(document.form1.AlmFin,document.form1.AlmIni.value);
							AsignarHiddensEncab();
						  </script>
					  </cfif>	  
					</tr>
				
					<tr><td>&nbsp;</td></tr>
					<tr> 
						<td colspan="8" align="center">
							<cfif modo EQ "ALTA">
								<input type="submit" name="AgregarE" value="Agregar">
								<input type="button" name="ListaE" value="Regresar" onClick="javascript:Lista();">
							</cfif>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
				</table>
			</td>	
		</tr>	
		
		<cfif modo neq 'ALTA'>
			<tr><td class="tituloAlterno" align="center">Detalle de Movimiento</td></tr>
			<tr>
				<td align="center">
						<cfoutput>
						<table width="65%" border="0" cellspacing="0" cellpadding="0">
					
							<tr><td colspan="4" >&nbsp;</td></tr>
						
							<tr> 
								<td align="right" >Art&iacute;culo:&nbsp;</td>
								<td nowrap>
<!---
									<cfif modoDet neq "ALTA">
										<input name="Adescripcion" type="text" readonly size="50" maxlength="80" value="#PreserveSingleQuotes(rsArticulo.Adescripcion)#" alt="El Artículo es requerido."> 
									<cfelse>
										<input name="Adescripcion" type="text" readonly size="50" maxlength="80" value="" alt="El Artículo es requerido!"> 
									</cfif>
									<a href="##"><img src="../../imagenes/Description.gif" alt="Lista de Artículos" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:validaConlisArt();"></a> 
									<input type="hidden" name="DMAid" value="<cfif modoDet NEQ "ALTA">#rsDMinteralmacen.DMAid#</cfif>"> 
									<div align="right"></div>
--->
									<cfif modoDet neq 'ALTA'>
										<cf_sifarticulos form="form1" id="DMAid" query="#rsArticulo#" Almacen="AlmIni" Existencias="true">
									<cfelse>
										<cf_sifarticulos form="form1" id="DMAid" Almacen="AlmIni"  Existencias="true">
									</cfif>
								</td>
					
								<td align="right">Cantidad:&nbsp;</td>
								<td>
									<cfif modoDet neq "ALTA"><cfset Cant = "#rsDMinteralmacen.DMcant#"><cfelse><cfset Cant = "0.00"></cfif>
									<input type="text" name="Cantidad" value="#LSCurrencyFormat(Cant, 'none')#"  
										size="18" 
										maxlength="16" 
										style="text-align: right;" 
										onblur="javascript:fm(this,5); "
										onfocus="javascript:this.value=qf(this); this.select();"  
										onkeyup="javascript:if(snumber(this,event,5)){ if(Key(event)=='13') {this.blur();}}" 
										alt="La Cantidad">
								</td>
							</tr>	
					
							<tr> 
								<td>
									<cfset tsD = "">
										<cfif modoDet NEQ "ALTA">
											<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsDMinteralmacen.ts_rversion#" returnvariable="tsD"></cfinvoke>
										</cfif>
										<input type="hidden" name="CantidadTemp" value="<cfif modoDet NEQ "ALTA">#rsDMinteralmacen.DMcant#<cfelse>0.00</cfif>"> 
										<input type="hidden" name="CantidadTemp2" value="<cfif modoDet NEQ "ALTA">#rsDMinteralmacen.DMcant#<cfelse>0.00</cfif>"> 
										<input type="hidden" name="sumaCantidad" value="<cfif modoDet NEQ "ALTA">#rsSumaCantidad.Acumulado#<cfelse>0.00</cfif>"> 
										<input type="hidden" name="DMlinea" value="<cfif modoDet NEQ "ALTA">#rsDMinteralmacen.DMlinea#</cfif>"> 
										<input type="hidden" name="timestampD" value="<cfif modoDet NEQ "ALTA">#tsD#</cfif>"> 
								</td>
								<td>
									<input type="hidden" name="_Aid" value="">
									<input type="hidden" name="_Cantidad" value="">
								</td>
								<td>&nbsp;</td>
							</tr>
					
							<script language="JavaScript">
								AsignarHiddensDet();
							</script>
					
							<tr> 
								<td align="center" colspan="4">
									<cfif modoDet EQ "ALTA">
										<input type="submit" name="AgregarD" value="Agregar">
									<cfelse>
										<input type="submit" name="CambiarD" value="Cambiar" >
										<input type="submit" name="BorrarD" value="Borrar Art&iacute;culo" onclick="javascript:if (confirm('¿Desea borrar este artículo del traslado?')) return true; else return false;">
										<input type="submit" name="NuevoD"   value="Nuevo Artículo">
									</cfif>
									<input type="submit" name="BorrarE" value="Borrar Documento" onclick="javascript:document.form1.DMAid.value='-1';document.form1.Cantidad.value='1';return confirm('¿Desea borrar el documento?');">
                                    <input type="button" name="Imprimir" value="Imprimir" onClick="javascript:funcImprimir();">
									<input type="button" name="ListaE" value="Regresar" onClick="javascript:Lista();">
								</td>
							</tr>
						</table>
						</cfoutput>
				</td>	
			</tr>
		</cfif>	
	</table>	
</form>

<script language="JavaScript">
	<cfif modo neq 'ALTA'>
		DeshabilitarEnc(true); 
	</cfif>
	
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	<cfif isDefined("Form.EMid") and len(trim(Form.EMid)) gt 0 and modo NEQ "ALTA">		
		function funcImprimir(){
			var PARAM  = "ImprimeInterAlmacen.cfm?EMid=<cfoutput>#Form.EMid#</cfoutput>" 
			open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=860,height=520')
			return false;
		}
	</cfif>
</script>
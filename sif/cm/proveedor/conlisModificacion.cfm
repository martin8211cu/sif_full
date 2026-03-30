<cfif isdefined("Url.f") and not isdefined("Form.f")>
	<cfparam name="Form.f" default="#Url.f#">
</cfif>
<cfif isdefined("Url.i") and not isdefined("Form.i")>
	<cfparam name="Form.i" default="#Url.i#">
</cfif>
<cfif isdefined("Url.DSlinea1") and not isdefined("Form.DSlinea1")>
	<cfparam name="Form.DSlinea1" default="#Url.DSlinea1#">
</cfif>
<cfif isdefined("Url.Unidad") and not isdefined("Form.Unidad")>
	<cfparam name="Form.Unidad" default="#Url.Unidad#">
</cfif>

<cfquery datasource="#session.DSN#" name="rsUnidades">
	Select Ucodigo,Udescripcion
	from Unidades
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by Udescripcion
</cfquery>

<html>
<head>
<title>Modificar Item</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
<cf_templatecss>
</head>

<body>
	<cfif isdefined("Form.i") and Len(Trim(Form.i))>
		<script src="/cfmx/sif/js/utilesMonto.js" language="javascript" type="text/javascript"></script>
		<cfoutput>
			<script language="javascript" type="text/javascript">
				function Asignar() {
					window.opener.document.#Form.f#.DCPcantidad_#Form.i#.value = document.form1.DCPcantidad.value;
					window.opener.document.#Form.f#.DCPunidadcot_#Form.i#.value = document.form1.DCPunidadcot.value;
					window.opener.document.#Form.f#.DCPconversion_#Form.i#.value = document.form1.DCPconversion.value;
					window.opener.document.#Form.f#.DCPdescprov_#Form.i#.value = document.form1.DCPdescprov.value;
					window.close();
				}

				function obtenerDescripciones() {
					document.form1.DCPcantidad.value = window.opener.document.#Form.f#.DCPcantidad_#Form.i#.value;
					document.form1.DCPunidadcot.value = window.opener.document.#Form.f#.DCPunidadcot_#Form.i#.value;
					document.form1.DCPconversion.value = window.opener.document.#Form.f#.DCPconversion_#Form.i#.value;
					document.form1.DCPdescprov.value = window.opener.document.#Form.f#.DCPdescprov_#Form.i#.value;
				}
				//Funciones para mostrar popup con los archivos adjuntos 
				var popUpWin = 0;
				function popUpWindow(URLStr, left, top, width, height){
					if(popUpWin){
						if(!popUpWin.closed) popUpWin.close();
					}
					popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
				}
				
				function doConlis(DSlinea1,LPCid) {
					popUpWindow('ObjetosCotizaciones.cfm?DSlinea1='+DSlinea1+'&LPCid='+LPCid,200,100,700,500);
				}

				// Funcion para ejecutar componente de observaciones 			
				function info(linea){
					//popUpWindow("Solicitudes-info.cfm" ,250,200,600,400);
					open('cotizaciones-info.cfm?linea='+linea, 'Cotizaciones', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=600,height=420,left=250, top=200,screenX=250,screenY=200');
				}
			</script>
			<form name="form1" action="conlisModificacion.cfm" method="post" onSubmit="javascript: return validaForm(this);">
				<table width="100%"  border="0" cellspacing="0" cellpadding="2">
				  <tr>
					<td width="15%" align="right" nowrap class="fileLabel">Cantidad</td>
					<td width="49%" nowrap>
						<input name="DCPcantidad" type="text" style="text-align: right;" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);"  onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" size="6" maxlength="18">					
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" name="Ver Observaciones" value="Ver Observaciones" onClick="javascript: info(#form.i#,#form.DSlinea1#);">
						&nbsp;&nbsp;&nbsp;<input type="button" name="Ver Observaciones" value="Ver Archivos Adjuntos" onClick="javascript: doConlis(#form.DSlinea1#,#form.i#);">
					</td>		
				  </tr>
				  <tr>
					<td align="right" nowrap class="fileLabel">Unidades</td>
					<td nowrap>
						<!--- <input name="DCPunidadcot" type="text" size="15" maxlength="15"> --->

						<select name="DCPunidadcot">
							<cfif isdefined('rsUnidades') and rsUnidades.recordCount GT 0>
								<cfloop query="rsUnidades">
									<option value="#rsUnidades.Ucodigo#" <cfif isdefined('form.Unidad') and trim(form.Unidad) EQ trim(rsUnidades.Ucodigo)> selected</cfif>>#rsUnidades.Ucodigo#-#rsUnidades.Udescripcion#</option>
								</cfloop>
							</cfif>
						</select>

					</td>
				  </tr>
				  <tr>
					<td align="right" nowrap class="fileLabel">Conversi&oacute;n</td>
					<td nowrap>
					<input name="DCPconversion" type="text" style="text-align: right;" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" size="15" maxlength="18">
					</td>
				  </tr>
				  <tr>
					<td align="right" valign="top" nowrap class="fileLabel">Descripci&oacute;n</td>
					<td nowrap>
						<textarea name="DCPdescprov" rows="5" style="width: 100%"></textarea>
					</td>
				  </tr>
				  <tr>
					<td align="right" nowrap>&nbsp;</td>
					<td nowrap>&nbsp;</td>
				  </tr>
				  <tr align="center">
					<td colspan="2" nowrap>
						<input type="button" name="Submit" value="Guardar" onClick="javascript: Asignar();">
						<input type="button" name="Cerrar" value="Cerrar" onClick="javascript: cerrar();">
					</td>
				  </tr>
				  <tr>
					<td align="right" nowrap>&nbsp;</td>
					<td nowrap>&nbsp;</td>
				  </tr>
			  </table>
			</form>
			<script language="javascript" type="text/javascript">
				obtenerDescripciones();
				function cerrar(){
					window.close();
				}
			</script>
		</cfoutput>
	</cfif>
</body>
</html>

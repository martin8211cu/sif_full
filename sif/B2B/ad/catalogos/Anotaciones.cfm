<cfif isdefined ("url.SNcodigo") and NOT isdefined("form.SNcodigo")>
	<cfset form.SNcodigo = url.SNcodigo>
</cfif>	

<script language="JavaScript" src="../../js/calendar.js"></script>

<cfoutput>
<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>

	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<cfquery name="NombreSocio" datasource="#session.DSN#">
		  select SNnombre,SNnumero from SNegocios
		  where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
		</cfquery>
	
		<cfset modo='ALTA'>
	
		<cfif isdefined("form.SNAid") and len(trim(form.SNAid))>
			<cfset modo = 'CAMBIO'> 
		</cfif>
		
		<cfif modo NEQ 'ALTA'>
			<cfquery name = "rsdata" datasource="#session.DSN#">
				select SNAid, SNcodigo, SNAtipo,SNAdescripcion,SNAfecha,SNAobs,SNApeso, SNApuntoVenta, SNAfechaCierre, ts_rversion
				from   SNAnotaciones
				where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value = "#session.ecodigo#" >
					   and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
					   and SNAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNAid#">
			</cfquery>
		</cfif>
			<table width="99%" cellpadding="2" cellspacing="0">
				<tr>
					<td valign="top" width="50%">
						<cfquery name="rsAnotaciones" datasource="#Session.DSN#">
							select 	
								SNcodigo,
								SNAid,
								SNAtipo,
								SNAdescripcion,
								SNAfecha,
								SNApeso,
								fechaalta
							from   SNAnotaciones   
							where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value = "#session.ecodigo#" >
									and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
							order by SNAid
						</cfquery>
						<cfif isdefined("LvarReadOnly")>
							<cfset Lvartab = 'DatosGSocio.cfm?tabs=5&Ocodigo_F=#form.Ocodigo_F#'>	
						<cfelse>
							<cfset Lvartab = 'Socios.cfm?tab=5'>	
						</cfif>
						
						<cfinvoke 
							component="sif.Componentes.pListas"
							method="pListaQuery"
							returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsAnotaciones#"/>
							<cfinvokeargument name="desplegar" value="SNAdescripcion, SNAfecha, SNApeso"/>
							<cfinvokeargument name="etiquetas" value="Descripción, Fecha, Peso"/>
							<cfinvokeargument name="formatos" value="V,D,V"/>
							<cfinvokeargument name="align" value="left, left,left"/>
							<cfinvokeargument name="formname" value="listaAnotaciones"/>
							<cfinvokeargument name="irA" value="#Lvartab#"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys" value="SNAid,SNcodigo"/>
							 </cfinvoke>
					</td>
					<td>
						<form name="form5" method="post" action="SQLAnotaciones.cfm">
							<cfif modo NEQ 'ALTA'>
								<input type = "hidden" name="SNAid" value="#rsdata.SNAid#">
							</cfif>	
							<table width="100%" border="0">
								<tr>
									<td align="right" nowrap><strong>Fecha:&nbsp;</strong> </td>	
									<td>	
									<cfif modo NEQ 'ALTA' and isdefined("rsdata.SNAfecha") and len(trim(rsdata.SNAfecha))>
										<cf_sifcalendario form="form5" value="#LSDateFormat(rsdata.SNAfecha,'dd/mm/yyyy')#" name="SNAfecha"> 
									<cfelse>
										<cf_sifcalendario form="form5" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" name="SNAfecha"> 
									</cfif>
									</td>
									<td  width="31%" align="right" nowrap><strong>Tipo:&nbsp;</strong></td>	
							  		<td>
											<select name="LTipo" id="LTipo">
												<option value="">- No especificada -</option> 
												<option value="P" <cfif modo NEQ 'ALTA' and isdefined("rsdata.SNAtipo") and rsdata.SNAtipo EQ 'P'>selected</cfif>>Positiva</option>
												<option value="N" <cfif modo NEQ 'ALTA' and isdefined("rsdata.SNAtipo") and rsdata.SNAtipo EQ 'N'>selected</cfif>>Negativa</option>
											</select>
									</td>

								</tr>
								<tr>
									<td align="right" nowrap><strong>Fecha&nbsp;de&nbsp;Cierre:&nbsp;</strong></td>	
									<td>
									<cfif modo NEQ 'ALTA' and isdefined("rsdata.SNAfechaCierre")>
										<cf_sifcalendario form="form5" value="#LSDateFormat(rsdata.SNAfechaCierre,'dd/mm/yyyy')#" name="SNAfechaCierre"> 
									<cfelse>	
										<cf_sifcalendario form="form5" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" name="SNAfechaCierre"> 
									</cfif>
									</td>
									<td align="right" nowrap><strong>Aplica&nbsp;Punto&nbsp;de&nbsp;Ventas:&nbsp;</strong></td>
									<td> <input name="SNApuntoVenta" value="1" type="checkbox" <cfif modo NEQ 'ALTA' and isdefined("rsdata.SNApuntoVenta") and  rsdata.SNApuntoVenta eq 1>checked</cfif>></td>
								
								</tr>
								<tr>
									<td align="right" nowrap><strong>Descripción: </strong> </td>	
									<td colspan="3" width="100%">
										<input name="SNAdescripcion" type="text" size="80" maxlength="255" value="<cfif modo neq 'ALTA' and isdefined("rsdata.SNAdescripcion")>#rsdata.SNAdescripcion#</cfif>">
									</td>	
								</tr>			
								<tr>
									
								</tr>									
								<tr>
									<td align="right" nowrap><strong>Peso: </strong> </td>	
									<td>
										<input name="SNApeso" type="text" size="10" maxlength="10"  value="<cfif modo neq 'ALTA' and isdefined("rsdata.SNApeso")>#rsdata.SNApeso#</cfif>" style="text-align: right;" onBlur="javascript:fm(this,-1); "  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" alt="El campo Peso de la Anotación">
									</td>	
								</tr>
								<tr>
								<td colspan="4" align="center">
			<!---*******************************Editor TEXTO************************************					--->
								<textarea name="SNAobs" id="SNAobs" rows="15" style="width: 100%"><cfif modo EQ 'CAMBIO' and isdefined("rsdata.SNAobs")>#rsdata.SNAobs#</cfif></textarea>
									<script language="Javascript1.2">
										<!-- // load htmlarea
										_editor_url = "/cfmx/sif/Utiles/htmlarea/";  // URL to htmlarea files
										var win_ie_ver = parseFloat(navigator.appVersion.split("MSIE")[1]);
										if (navigator.userAgent.indexOf('Mac')        >= 0) { win_ie_ver = 0; }
										if (navigator.userAgent.indexOf('Windows CE') >= 0) { win_ie_ver = 0; }
										if (navigator.userAgent.indexOf('Opera')      >= 0) { win_ie_ver = 0; }
										if (win_ie_ver >= 5.5) {
										  document.write('<scr' + 'ipt src="' +_editor_url+ 'editor.js"');
										  document.write(' language="Javascript1.2"></scr' + 'ipt>');  
										} else { document.write('<scr'+'ipt>function editor_generate() { return false; }</scr'+'ipt>'); }
										// --> 
									</script>
									<script language="javascript1.2">
										var config = new Object();    // create new config object	
										config.width = "100%";
										config.height = "200px";
										config.bodyStyle = 'background-color: white; font-family: "Verdana"; font-size: x-small;';
										config.debug = 0;
										// NOTE:  You can remove any of these blocks and use the default config!
										config.toolbar = [
											['fontname'],
											['fontsize'],
											['fontstyle'],
											['linebreak'],
											['bold','italic','underline','separator'],
										//  ['strikethrough','subscript','superscript','separator'],
											['justifyleft','justifycenter','justifyright','separator'],
											['OrderedList','UnOrderedList','Outdent','Indent','separator'],
											['forecolor','backcolor','separator'],
											['HorizontalRule','Createlink','InsertImage','InsertTable','htmlmode'],
										//	['about','help','popupeditor'],
										];
										config.fontnames = {
											"Arial":           "arial, helvetica, sans-serif",
											"Courier New":     "courier new, courier, mono",
											"Georgia":         "Georgia, Times New Roman, Times, Serif",
											"Tahoma":          "Tahoma, Arial, Helvetica, sans-serif",
											"Times New Roman": "times new roman, times, serif",
											"Verdana":         "Verdana, Arial, Helvetica, sans-serif",
											"impact":          "impact",
											"WingDings":       "WingDings"
										};
										config.fontsizes = {
											"1 (8 pt)":  "1",
											"2 (10 pt)": "2",
											"3 (12 pt)": "3",
											"4 (14 pt)": "4",
											"5 (18 pt)": "5",
											"6 (24 pt)": "6",
											"7 (36 pt)": "7"
										  };
										//config.stylesheet = "http://www.domain.com/sample.css";
										config.fontstyles = [   // make sure classNames are defined in the page the content is being display as well in or they won't work!
										  { name: "headline",     className: "headline",  classStyle: "font-family: arial black, arial; font-size: 28px; letter-spacing: -2px;" },
										  { name: "arial red",    className: "headline2", classStyle: "font-family: arial black, arial; font-size: 12px; letter-spacing: -2px; color:red" },
										  { name: "verdana blue", className: "headline4", classStyle: "font-family: verdana; font-size: 18px; letter-spacing: -2px; color:blue" }
										// leave classStyle blank if it's defined in config.stylesheet (above), like this:
										//  { name: "verdana blue", className: "headline4", classStyle: "" }  
										];				
										editor_generate('SNAobs', config);
									</script>
			<!---*******************************Editor TEXTO************************************--->
								</td>
								</tr>
								<tr>
									<td colspan="4" align="center">
										<cfif isdefined("LvarReadOnly")>
											<cf_botones Regresar="#Regresa#" exclude="Alta,Baja,Cambio,Limpiar">
										<cfelse>
											<cf_botones modo=#modo# form="form5" sufijo="Anotaciones">
										</cfif>
										
									</td>	
							  </tr>
						</table>
						<cfif modo NEQ "ALTA" and isdefined("rsdata.ts_rversion")>
							<cfset ts = "">
							<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp= "#rsdata.ts_rversion#" returnvariable="ts">
							</cfinvoke>
                            	<input type="hidden" name = "ts_rversion" value ="#ts#">
						</cfif>
						<input type="hidden" name = "SNcodigo" value ="#form.SNcodigo#">
					</form> 
			</td>
		</tr>
	</table>
	<cf_qforms objForm="objForm5" form="form5">
	<script language="JavaScript1.2" type="text/javascript">
		// Valida que el campo no sea mayor que 100
		function __isMayorQue() {
			if (this.value > 100.00) {
				this.error = "El campo " + this.description + " no puede ser mayor a cien!";
			}
		}			

		_addValidator("isMayorQue", __isMayorQue);
		
		objForm5.LTipo.required = true;
		objForm5.LTipo.description="Tipo de Anotación";
	
		objForm5.SNAdescripcion.required = true;
		objForm5.SNAdescripcion.description="Descripción";
	
		objForm5.SNAfecha.required = true;
		objForm5.SNAfecha.description="Fecha";
	
		objForm5.SNApeso.required = true;
		objForm5.SNApeso.description="Peso";
			
	</script>
<cfelse>
	<table align="center">
		<tr>
			<td>Primero&nbsp;debe&nbsp;ingresar&nbsp;los&nbsp;<strong>Datos&nbsp;Generales</strong>&nbsp;del&nbsp;Socio&nbsp;de&nbsp;Negocios</td>
		</tr>
	</table>
</cfif>
</cfoutput>
			



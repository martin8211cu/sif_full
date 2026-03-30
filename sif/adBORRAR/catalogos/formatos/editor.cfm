<!--- <cfdump var="#form#">	
 <cf_dump var="#url#"> --->
<cfset session.FMT01COD=url.FMT01COD>
<cfif isdefined('session.FMT01COD') and len(trim(session.FMT01COD))>
	<cfset url.FMT01COD = session.FMT01COD>
</cfif>


<cf_templateheader title="Editor">

		<cfif isdefined('Form.Guardar')>
			<cfquery datasource="#session.DSN#">
				update FMT001
				   set FMT01TXT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DFtexto#">
				where FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.FMT01COD#">   
			</cfquery>
		</cfif>
		
		<cfquery datasource="#session.dsn#" name="hdr">
			select FMT01COD, FMT01DES, FMT01TIP, FMT01tipfmt, FMT01TXT
			from FMT001
			where FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.FMT01COD#">
		</cfquery>
		
		<cfset Regresar='/cfmx/sif/ad/catalogos/EFormatosImpresion.cfm?FMT01COD=' & URLEncodedFormat(hdr.FMT01COD)>
		
		<cfinclude template="/home/menu/pNavegacion.cfm">
		<!--- /cfmx/sif/ad/catalogos/EFormatosImpresion.cfm?FMT01COD=<cfoutput>#URLEncodedFormat(hdr.FMT01COD)#</cfoutput>		 --->
		
		<form name="Edita" method="post" action="editor.cfm?FMT01COD=<cfoutput>#URLEncodedFormat(hdr.FMT01COD)#</cfoutput>" >
			<cfoutput> 
				<table align="left" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td valign="top" class="tituloListas" colspan="2">
							<table width="100%" cellpadding="0" cellspacing="0" border="0">
								<tr>
									<td class="tituloListas" >
										Formato de Impresi&oacute;n: #HTMLEditFormat(Trim(hdr.FMT01COD))# - #HTMLEditFormat(Trim(hdr.FMT01DES))#
									</td>
									<td align="right" class="tituloListas">
										<input 	type="button" value="Regresar" 
												style="height:20px; font-size:10px" 
												onclick="location.href='#Regresar#';">
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td valign="top" width="850">
							<div style="width:670px;height:870px;overflow:scroll">
							<cfif hdr.FMT01tipfmt EQ 3>
								<cfquery name="rsCampos" datasource="sifcontrol">
									select FMT11NOM, FMT11DES, FMT02SQL, upper(FMT11NOM) AS FMT11NOM_UPPERCASE
									from FMT011
									where FMT00COD = <cfqueryparam cfsqltype="cf_sql_integer"    value="#hdr.FMT01TIP#">
									order by FMT11NOM_UPPERCASE
								</cfquery>
								<BR>
								<select name="FMT02CAM">
									<cfloop query="rsCampos">
										<option value="#rsCampos.FMT11NOM_UPPERCASE#">#rsCampos.FMT11NOM#</option>
									</cfloop>
								</select>
								
								<input type="button" value="Agregar Campo" onClick="sbInsertarCampo();">
								<input name="Guardar" type="submit" value="Guardar" onclick="return fnGuardar();">
								<input name="Salir" type="button" value="Salir" onclick="location.href='../EFormatosImpresion.cfm?FMT01COD=#url.FMT01COD#';">
								<BR><BR>
								<textarea name="DFtexto" id="DFtexto" rows="15" style="width: 100%">
									<cfoutput>#hdr.FMT01TXT#</cfoutput>
								</textarea>
								<script language="javascript">
									var _editor_url = "/cfmx/sif/Utiles/htmlarea/";  // URL to htmlarea files
									
									var win_ie_ver = parseFloat(navigator.appVersion.split("MSIE")[1]);
									if (navigator.userAgent.indexOf('Mac')        >= 0) { win_ie_ver = 0; }
									if (navigator.userAgent.indexOf('Windows CE') >= 0) { win_ie_ver = 0; }
									if (navigator.userAgent.indexOf('Opera')      >= 0) { win_ie_ver = 0; }
									if (win_ie_ver >= 5.5) 
									{
										document.write('<script src="/cfmx/sif/Utiles/htmlarea/editor.js"');
										document.write(' language="Javascript1.2"></scr' + 'ipt>');  
									} 
									else 
									{ 
										document.write('<script>function editor_generate() { return false; }</scr'+'ipt>'); 
									}
								</script>
								
								<script language="javascript">
									function sbInsertarCampo ()
									{
										editor_insertHTML('DFtexto','##' + document.all['FMT02CAM'].value + '##');
										document.getElementById('ifrSQL').src='FMT002-sql.cfm?btnInsertCampo=1&FMT01COD=#URLEncodedFormat(session.FMT01COD)#&FMT11NOM='+escape(document.all['FMT02CAM'].value);
									}
								</script>
								
								<script language="javascript">
									var config = new Object();    // create new config object
									
									config.width = "100%";
									config.height = "325px";
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
									
									editor_generate('DFtexto', config);
									
									function fnGuardar()
									{
									<cfquery name="rsSQL" datasource="sifcontrol">
										select count(1) as cantidad
										  from FMT011
										 where FMT00COD = <cfqueryparam cfsqltype="cf_sql_integer"    value="#hdr.FMT01TIP#">
										   and FMT11CNT = 1
									</cfquery>

									<cfif rsSQL.cantidad GT 0>
										var LvarDetPto = document.getElementById("DFtexto").value.toLowerCase().indexOf('<a href="detalle">');
										var LvarDetTxt = document.getElementById("DFtexto").value;
										if ( LvarDetPto == -1)
										{
											alert("No se ha definido la línea de detalle: dentro de una tabla agregar un link Type:(other) URL:detalle");
										}
										else
											LvarPto1 = LvarDetPto;
											while (LvarPto1 >= 0)
											{
												LvarPto1--;
												if (LvarDetTxt.substr(LvarPto1,3).toLowerCase() == "<tr")
													break;
											}
											LvarPto2 = LvarDetTxt.toLowerCase().indexOf('</tr',LvarPto1);
											if ( LvarPto1 == -1 || LvarPto2 < LvarDetPto)
											{
												alert("No se definio la línea de detalle dentro de una tabla");
											}
											
									<cfelseif rsSQL.cantidad EQ 0>
										var LvarDetPto = document.getElementById("DFtexto").value.toLowerCase().indexOf('<a href="detalle">');
										if (LvarDetPto != -1)
										{
											alert("Se definió una línea de detalle pero el Tipo de Formato no tiene campo de control");
										}
									</cfif>
									}
								</script>
								<iframe width="0" height="0" name="ifrSQL" id="ifrSQL" frameborder="0"
								></iframe>
							<cfelse>
								<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
									codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab##version=7,0,0,0" 
									width="850" height="850" id="editor" align="middle">
									<param name="allowScriptAccess" value="sameDomain" />
									<param name="movie" value="editor.swf?r=#Rand()#" />
									<param name="quality" value="high" />
									<param name="bgcolor" value="##ffffff" />
									<embed src="editor.swf" quality="high" bgcolor="##ffffff"
									width="850" height="850"
									name="editor" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
								</object>
							</cfif>
							</div>
						</td>
						<td valign="top">
							<cfif not isdefined("url.FMT02LIN")>
								<cfset url.FMT02LIN = "">
							</cfif>
							<iframe width="300" height="840" name="iframe_detalle" id="iframe_detalle" frameborder="0"
							<cfif Len(url.FMT02LIN)> src="FMT002-form.cfm?FMT01COD=#URLEncodedFormat(session.FMT01COD)#&amp;linea=#URLEncodedFormat(url.FMT02LIN)#" </cfif>
							<cfif hdr.FMT01tipfmt EQ 3>src="FMT002-list.cfm?FMT01COD=#URLEncodedFormat(session.FMT01COD)#" </cfif>
							></iframe>
						</td>
					</tr>
				</table>
			</cfoutput> 
		</form>
<cf_templatefooter>

<cfinclude template="encabezadofondos.cfm">

<cfif isdefined("btnFiltrar")>

	<cfif isdefined("URL.PROCON") and len(URL.PROCON)>
		<cfset Form.PROCON = URL.PROCON>
	</cfif>
	<cfif isdefined("URL.PRONOM") and len(URL.PRONOM)>
		<cfset Form.PRONOM = URL.PRONOM>
	</cfif>
	<cfif isdefined("URL.PROCED") and len(URL.PROCED)>
		<cfset Form.PROCED = URL.PROCED>
	</cfif>			

	<cfquery datasource="#session.Fondos.dsn#" name="VerSel">
	Select A.PROCOD, B.PROCED, B.PRONOM
	from CJX051 A, CPM002 B
	where A.PROCOD = B.PROCOD
	  and A.PROUSR = '#trim(session.usuario)#'
	</cfquery>

</cfif>

<link href="/cfmx/sif/fondos/css/estilos.css" rel="stylesheet" type="text/css">
<link href="/cfmx/sif/fondos/css/sif.css" rel="stylesheet" type="text/css">

<table width="100%" border="0" onClick="javascript:PierdeFoco()">	
<tr>
	<td  align="center" colspan="2" >

			<form name="form1" action="cjc_CedulasJuridicas.cfm" method="post">
			<table width="100%" border="0" cellpadding="2" cellspacing="0">
				<tr>
					<td align="left" colspan="10">
					
					
						<table border='0' cellspacing='0' cellpadding='0' width='100%'>
						<tr>
							<td class="barraboton">&nbsp;
								<a id ="ACEPTAR" href="javascript:document.form1.cnscolor.value = '#FFFF33';document.form1.submit();" onmouseover="overlib('Generar reporte',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Consultar'; return true;" onmouseout="nd();"></span><span class="LeftNavOff" buttonType=LeftNav>&nbsp;<font id="letra">Consultar</font>&nbsp;</span></a>
								<a id ="LIMPIAR" href="javascript:document.location = '../operacion/cjc_CedulasJuridicas.cfm?lmpcolor=FFFF33';window.parent.frm_reporte.location = '../operacion/cjc_sqlRLiquidacionesDetalladas.cfm'" onmouseover="overlib('Limpiar filtros',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Limpiar'; return true;" onmouseout="nd();"><span class="LeftNavOff" buttonType=LeftNav>&nbsp;<font id="letra1">Limpiar</font>&nbsp;</span></a>
								<cfif isdefined("btnFiltrar")>
									<a id ="SELECCIONAR" href="javascript:document.form2.selcolor.value = '#FFFF33';ValidarSeleccion();" onmouseover="overlib('Seleccionar Proveedores',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Limpiar'; return true;" onmouseout="nd();"><span class="LeftNavOff" buttonType=LeftNav>&nbsp;<font id="letra2">Seleccionar</font>&nbsp;</span></a>
								</cfif>
								<cfif isdefined("VerSel") and VerSel.recordcount gt 0>
									<a id ="ASIGNAR" href="javascript:document.form2.selcolor.value = '#FFFF33';ValidaAsignacion();" onmouseover="overlib('Seleccionar Proveedores',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Procesar Proveedores'; return true;" onmouseout="nd();"><span class="LeftNavOff" buttonType=LeftNav>&nbsp;<font id="letra3">Asignar</font>&nbsp;</span></a>
								</cfif>
							</td>
							<td class=barraboton>
								<p align=center><font color='#FFFFFF'><b> </b></font></p>
							</td>
						</tr>
						</table>					
						<input type="hidden" id="btnFiltrar" name="btnFiltrar">
						<input type="hidden" id="cnscolor" name="cnscolor" value="<cfif isdefined("form.cnscolor")><cfoutput>#form.cnscolor#</cfoutput><cfelse>#FFFFFF</cfif>">
						<input type="hidden" id="lmpcolor" name="lmpcolor" value="#<cfif isdefined("url.lmpcolor")><cfoutput>#url.lmpcolor#</cfoutput><cfelse>FFFFFF</cfif>">
					</td>
				</tr>				
				<tr>

					<td width="20%" align="left">Tipo de Proveedor:</td>
					<td width="80%"> 

						<select name="PROCON" style="width:215px">
							<option value="L" <cfif isdefined("PROCON") and PROCON eq "L">selected</cfif>>Local</option>
							<option value="E" <cfif isdefined("PROCON") and PROCON eq "E">selected</cfif>>Extranjero</option>
						</select>
								
					</td>
				</tr>			
				<tr>

					<td width="20%" align="left">Cédula de Proveedor:</td>
					<td width="80%"> 
						<!--- Conlis de Proveedores --->
						<input type="text" name="PROCED" id="PROCED" size="30" value="<cfif isdefined("Form.PROCED")><cfoutput>#Form.PROCED#</cfoutput></cfif>">		
					</td>								
				</tr>
				<tr>

					<td width="20%" align="left">Nombre Proveedor:</td>
					<td width="80%"> 
						<!--- Conlis de Proveedores --->							
						<input type="text" name="PRONOM" id="PRONOM" size="30" value="<cfif isdefined("Form.PRONOM")><cfoutput>#Form.PRONOM#</cfoutput></cfif>">		
					</td>								
				</tr>						
				</table>			
			</form>
	</td>		
</tr>		
<cfif isdefined("btnFiltrar")>

	<tr><td>&nbsp;</td></tr>

	<tr>
		<td>
		
			<form action="cjc_sqlCedulasJuridicas.cfm" method="post" name="form2">
			<input type="hidden" id="selcolor" name="selcolor" value="<cfif isdefined("form.selcolor")><cfoutput>#form.selcolor#</cfoutput><cfelse>#FFFFFF</cfif>">
			<table cellpadding="0" cellspacing="0" width="100%" border="0">
			<tr>				
				<td width="40%" valign="top">
				
					<cfset condicion=" ">
					<cfset navegacion = ""> 	
					
					<cfset filtros = "">
					
					<cfset navegacion = "btnFiltrar=1">
																			
					<cfif isdefined("Form.PROCON") and len(Form.PROCON)>
						<cfset navegacion = navegacion & "&PROCON=#Form.PROCON#"> 	
						<cfset filtros = filtros & condicion & "Upper(PROCON) = Upper('" & #Form.PROCON# & "')">
						<cfset condicion=" AND ">
					</cfif>
					<cfif isdefined("Form.PRONOM") and len(Form.PRONOM)>
						<cfset navegacion = navegacion & "&PROCON=#Form.PRONOM#">
						<cfset filtros = filtros & condicion & "Upper(PRONOM) like Upper('" & #Form.PRONOM# & "')">
						<cfset condicion=" AND ">
					</cfif>
					<cfif isdefined("Form.PROCED") and len(Form.PROCED)>
						<cfset navegacion = navegacion & "&PROCED=#Form.PROCED#">
						<cfset filtros = filtros & condicion & "Upper(PROCED) like Upper('" & #Form.PROCED# & "')">
					</cfif>					
										
					<cfinvoke 
						component="sif.fondos.Componentes.pListas"
						method="pLista"
						returnvariable="pListaRet">
						<cfinvokeargument name="conexion" value="#session.Fondos.dsn#"/>
						<cfinvokeargument name="tabla" value="CPM002"/>
						<cfinvokeargument name="columnas" value="PROCOD,case when PROCON = 'L' then 'Local' else 'Extranjero' end Tipo,PRONOM as LPRONOM,PROCED as LPROCED"/>
						<cfinvokeargument name="desplegar" value="Tipo,LPRONOM,LPROCED"/>
						<cfinvokeargument name="etiquetas" value="Tipo, Nombre, Cédula"/>
						<cfinvokeargument name="formatos" value="S,S,S"/>
						<cfinvokeargument name="filtro" value=" #filtros#"/>
						<cfinvokeargument name="align" value="left,left,left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="MaxRows" value="15"/>
						<cfinvokeargument name="checkboxes" value="S"/>
						<cfinvokeargument name="keys" value="PROCOD"/>
						<cfinvokeargument name="incluyeForm" value="false"/>
						<cfinvokeargument name="showlink" value="false"/>						
						<!--- <cfinvokeargument name="irA" value="cjc_CedulasJuridicas.cfm"/> --->
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
					</cfinvoke>
			
				</td>
				<td width="10%">&nbsp;</td>
				<td width="50%" valign="top">
					
					<fieldset>
					<legend><b>Proveedor Destino</b></legend>
					
					<table border="0" cellpadding="0" cellspacing="0">					
					<tr>
						<td>
					
							<cfif isdefined("NPROCOD")>
								
								<cfquery name="rsProveedor" datasource="#session.Fondos.dsn#">
									SELECT PROCED, PROCOD, PRONOM, PROCOD as NPROCOD
									FROM CPM002
									where  PROCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#NPROCOD#" >
								</cfquery>
										
								<cf_cjcConlis
										size		="40"  
										tabindex    ="1"
										name 		="PROCED" 
										desc 		="PRONOM" 
										id			="NPROCOD" 
										onblur		="CambiarLink('');" 
										cjcConlisT 	="cjc_traeProv2"
										query       ="#rsProveedor#"
										form		="form2"
										frame		="PROCED_FRM"
								>
							<cfelse>	
								<cf_cjcConlis 	
										tabindex    ="1"
										size		="40"  
										name 		="PROCED" 
										desc 		="PRONOM" 
										id			="NPROCOD" 
										onblur		="CambiarLink('');" 
										cjcConlisT 	="cjc_traeProv2"
										form		="form2"
										frame		="PROCED_FRM"
								>
							</cfif>							
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					
					<cfif isdefined("VerSel") and VerSel.recordcount gt 0>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td align="center">
								<table align="center" cellpadding="0" cellspacing="0" width="100%">
								<tr>
									<td colspan="3" align="center"><strong>Proveedores Seleccionados</strong><HR></td>
								</tr>
								<cfoutput query="VerSel">
								<tr>
									<td>#PROCED#</td>
									<td>#PRONOM#</td>
									<td>
										<a href="javascript:Eliminar('#trim(PROCOD)#')">
										<img src="../../imagenes/Borrar01_S.gif" width="20" height="18" border="0">
										</a>
									</td>
								</tr>
								</cfoutput>
								</table>
							</td>
						</tr>						
					<cfelse>
						<tr>
							<td align="center">
								<strong>Es necesario seleccionar el proveedor destino y los proveedores origen</strong>
							</td>
						</tr>
					</cfif>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td>
						
								<table align="center" width="100%" class="areafiltro">
								<tr>
									<td>
										<P>
										Para realizar el cambio de los proveedores origen, a los proveedores destino, siga
										los siguientes pasos:
										</P>
										<P>
										1. Seleccione el <strong>proveedor destino</strong><br><br>
										2. Elija de la lista del lado izquierdo los proveedores que desea sean cambiados
										   por el proveedor destino. Esto usando la opción <strong>Seleccionar</strong> que aparece en 
										   la barra de opciones en la parte superior de la pantalla<br><br>
										3. Una vez que este seguro de que todo esta correcto presione la opción <strong>Asignar</strong>
										   la cual se muestra en la barra de opciones en la parte superior.
										</P>
									</td>
								</tr>
								</table>						
						
						</td>
					</tr>
					</table>
					
					</fieldset>
					
				</td>					
			</tr>			
			</table>
			<input type="hidden" id="HPROCON" name="HPROCON">
			<input type="hidden" id="HPROCED" name="HPROCED">
			<input type="hidden" id="HPRONOM" name="HPRONOM">
			
			<input type="hidden" id="seleccion" name="seleccion" value="1">
			<input type="hidden" id="btnFiltrar" name="btnFiltrar">
		
			</form>
		</td>
	</tr>
</cfif>
</table>

<script>
	var ltr = document.getElementById("letra");
	var ltr1 = document.getElementById("letra1");		
	ltr.style.color = document.form1.cnscolor.value
	ltr1.style.color = document.form1.lmpcolor.value
	<cfif isdefined("btnfiltrar")>
		var ltr2 = document.getElementById("letra2");
		ltr2.style.color = document.form2.selcolor.value
	</cfif> 
	
	function PierdeFoco()
	{
		var ltr = document.getElementById("letra");
		var ltr1 = document.getElementById("letra1");
		ltr.style.color = "#FFFFFF"
		ltr1.style.color = "#FFFFFF"
		<cfif isdefined("btnfiltrar")>
			var ltr2 = document.getElementById("letra2");
			ltr2.style.color = "#FFFFFF"
		</cfif> 
	}
	
	<cfif isdefined("btnfiltrar")>
		function ValidarSeleccion()		
		{			
			var doc = document.forms[1]							
			var campos= document.forms[1].elements.length
			var bandera=0;
			
			for( i=0 ; i<campos ; i++)
			{								
				if (doc.elements[i].name=='chk' && doc.elements[i].checked == true)
				{
					bandera=1;
				}
			}
			if (bandera == 0)
			{
				alert("Es necesario seleccionar al menos 1 proveedor");
			}
			else
			{
				doc.HPROCON.value = document.form1.PROCON.value;
				doc.HPROCED.value = document.form1.PROCED.value;
				doc.HPRONOM.value = document.form1.PRONOM.value;
				doc.submit();
			}
		}

		function Eliminar(Procod)
		{			
			var PROCON = document.form1.PROCON.value;
			var PROCED = document.form1.PROCED.value;
			var PRONOM = document.form1.PRONOM.value;
			var NPROCOD = document.form2.NPROCOD.value;
						 
			var param = "?borsel=1&PROCOD=" + escape(Procod) + "&PROCON=" + escape(PROCON) + "&PROCED=" + escape(PROCED) + "&PRONOM=" + escape(PRONOM) + "&NPROCOD=" + escape(NPROCOD)
			
			document.location = "cjc_sqlCedulasJuridicas.cfm" + param
		}
		function CambiarLink(npro)
		{			
				pos = 10;
				
				for(num=0;num<document.links.length;num++) 
				{
					if (document.links[num].href.indexOf("cjc_CedulasJuridicas.cfm?PageNum_lista") != -1) 
					{
						if (document.links[num].href.indexOf("&NPROCOD=") > 0) 
						{
							p_1 = document.links[num].href.indexOf("&NPROCOD=");							
							document.links[num].href = document.links[num].href.substring(0,p_1) + "&NPROCOD=" + npro;
						}
						else
						{
							document.links[num].href = document.links[num].href + "&NPROCOD=" + npro;
						}
					}
				}			
		}
		
		function ValidaAsignacion()
		{
			if (document.form2.PROCED.value == "")
			{
				alert("Es necesario seleccionar un proveedor destino");
			}
			else
			{
				var NPROCOD = document.form2.NPROCOD.value;
				document.location = "cjc_sqlCedulasJuridicas.cfm?asign=1&NPROCOD=" + NPROCOD
			}
		}
		
	</cfif> 
</script>
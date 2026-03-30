<cf_templateheader title="Lista de Precios">
	<cfinclude template="../../portlets/pNavegacionFA.cfm">
		<cf_web_portlet_start titulo="Listas de Precios">
			<script language="JavaScript1.2" type="text/javascript">
				// ==================================================================================================
				// 								Usadas para conlis de fecha
				// ==================================================================================================
				function MM_findObj(n, d) { //v4.01
				  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
					d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
				  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
				  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
				  if(!x && d.getElementById) x=d.getElementById(n); return x;
				}
			
				function MM_swapImgRestore() { //v3.0
				  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
				}
				
				function MM_swapImage() { //v3.0
				  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
				   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
				}
				// ==================================================================================================
				// ==================================================================================================	

				function nuevo(){
					document.lista.action = "ListaPrecios.cfm";
					document.lista.submit();
				}
			</script>

			<!--- crea el filtro --->
			<cfquery datasource="#session.dsn#" name="lista_query">
				 select LPid, LPdescripcion, moneda, meses_financiamiento
				 from EListaPrecios
				 where Ecodigo= #session.Ecodigo#
				<cfif isdefined("form.fLPdescripcion") and len(trim(form.fLPdescripcion)) gt 0 >
					and upper(LPdescripcion) like upper('%#form.fLPdescripcion#%')
				</cfif>
	
				<cfif isdefined("form.fLPfechaini") and len(trim(form.fLPfechaini)) gt 0 >
					and LPfechaini = convert(datetime, '#form.fLPfechaini#', 103)
				</cfif>
	
				<cfif isdefined("form.fLPfechafin") and len(trim(form.fLPfechafin)) gt 0 >
					and LPfechafin = convert(datetime, '#form.fLPfechafin#', 103)
				</cfif>
			   order by LPdescripcion
			</cfquery>
			<table border="0" width="100%" cellpadding="0" cellspacing="0">
				<!--- filtro --->
				<tr>
					<td>
						<form style="margin:0"  name="filtro" method="post">
							<table class="areaFiltro" width="100%" border="0">
								<!--- Titulos --->
								<tr>
									<td width="42%" >Lista de Precios</td>
								</tr>
								<!--- inputs --->
								<tr>
									<td nowrap><input type="text" name="fLPdescripcion" size="50" maxlength="80"></td>
									<td nowrap><input type="submit" name="btnFiltrar" value="Filtrar"></td>
								</tr>
							</table>
						</form>
					</td>
				</tr>
				<tr>
					<td>
						<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" query="#lista_query#" form_method="get" returnvariable="pListaRet">
							<cfinvokeargument name="desplegar" 	value="LPdescripcion, moneda, meses_financiamiento "/>
							<cfinvokeargument name="etiquetas" 	value="Lista de Precios, Moneda, Meses del Financiamiento "/>
							<cfinvokeargument name="formatos" 	value="V, V, V"/>
							<cfinvokeargument name="align" 		value="left, left, left"/>
							<cfinvokeargument name="ajustar" 	value="N"/>
							<cfinvokeargument name="checkboxes" value="N"/>
							<cfinvokeargument name="irA" 		value="ListaPrecios.cfm"/>
						</cfinvoke>
					</td>
				</tr>
				<tr><td align="center"><input type="button" name="btnNuevo" value="Nuevo" onClick="javascript:nuevo();"></td></tr>
			</table>		  
		<cf_web_portlet_end>
<cf_templatefooter>  
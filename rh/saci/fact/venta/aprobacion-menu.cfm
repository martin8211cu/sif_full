<!--- Determinar si se pueden agregar o modificar anotaciones --->
	<cfquery name="rsDatosVerif" datasource="#session.DSN#">
		select 1 
		from 
			ISBcuenta a
			inner join ISBpersona b
			on  b.Pquien = a.Pquien
																
			inner join ISBproducto c
			on  a.CTid = c.CTid
			and CTcondicion = '0'	
														
			inner join ISBpaquete d
			on  d.PQcodigo = c.PQcodigo
		
			inner join ISBvendedor e
			on e.Vid = c.Vid
		where 
			a.CTid = <cfqueryparam value="#form.CTid#" cfsqltype="cf_sql_numeric">
			and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		order by  a.CUECUE
	</cfquery>


<cfparam name="params_anotaciones" default="">
<cfoutput>
	<cf_web_portlet_start tituloalign="left" titulo="Aprobaci&oacute;n de Ventas">
		<script language="javascript" type="text/javascript">
			var popUpWin=0; 
			function popUpWindow(URLStr, left, top, width, height)
			{
			  if(popUpWin)
			  {
				if(!popUpWin.closed) popUpWin.close();
			  }
			  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
			}
			function abrirAnotaciones()
			{
				popUpWindow("anotaciones.cfm#params_anotaciones#",150,100,750,600);<!---200,100,650,600--->
			}
			function goPage(f, paso) {
				if (paso == 99) {
					f.paso.value = '1';
					f.cue.value = '';
					<!--- f.contra.value = ''; --->
					<!--- f.pq.value = ''; --->
				} else if (paso == 98) {
					if (arguments[2] != undefined) {
						f.cue.value = arguments[2];
						<!--- f.contra.value = #form.Contratoid#; --->
						<!--- f.pq.value = #Form.Pquien#; --->
					}
				} else {
					f.paso.value = paso;
				}
				f.submit();
			}
			function aprobar(){
				if(confirm('Desea aprobar este contrato ?')){
					document.form1.btnRechazar.value=0;
					document.form1.btnAprobar.value=1;
					document.form1.submit();
				}
			}
			function rechazar(){
				if(confirm('Desea rechazar este contrato ?')){
					document.form1.btnRechazar.value=1;
					document.form1.btnAprobar.value=0;					
					document.form1.submit();
				}
			}
		</script>
		
		<form name="formCuadroOpt" action="#CurrentPage#" method="get" style="margin: 0;">
			<cfinclude template="aprobacion-hiddens.cfm">
			<table border="0" cellpadding="2" cellspacing="0">
			
			  <!--- 1 --->
			  <tr>
				<td width="1%" align="right">
				  <cfif Form.paso GT 1>
					<img src="/cfmx/saci/images/w-check.gif" border="0">
				  <cfelseif Form.paso EQ 1>
					<img src="/cfmx/saci/images/addressGo.gif" border="0">
				  <cfelse>
					&nbsp;
				  </cfif>
				</td>
				<td width="1%" align="right"> <img src="/cfmx/saci/images/number1_16.gif" border="0"> </td>
				<td  nowrap>
					<a href="javascript: goPage(document.formCuadroOpt, 1);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
						<cfif Form.paso EQ 1><strong></cfif>
						Consultar Servicios
						<cfif Form.paso EQ 1></strong></cfif>
					</a>
				</td>
			  </tr>
	
			  <!--- 2 --->
			  <tr>
				<td width="1%" align="right">
				  <cfif Form.paso GT 2>
					<img src="/cfmx/saci/images/w-check.gif" border="0">
				  <cfelseif Form.paso EQ 2>
					<img src="/cfmx/saci/images/addressGo.gif" border="0">
				  <cfelse>
					&nbsp;
				  </cfif>
				</td>
				<td align="right"><img src="/cfmx/saci/images/number2_16.gif" border="0"></td>
				<td  nowrap>
					<cfif ExistePersona>
					<a href="javascript: goPage(document.formCuadroOpt, 2);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
					</cfif>
						<cfif Form.paso EQ 2><strong></cfif>Mecanismo de Env&iacute;o<cfif Form.paso EQ 2></strong></cfif>
					<cfif ExistePersona>
					</a>
					</cfif>
				</td>
			  </tr>
	
			  <!--- 3 --->
			  <tr>
				<td width="1%" align="right">
				  <cfif Form.paso GT 3>
					<img src="/cfmx/saci/images/w-check.gif" border="0">
				  <cfelseif Form.paso EQ 3>
					<img src="/cfmx/saci/images/addressGo.gif" border="0">
				  <cfelse>
					&nbsp;
				  </cfif>
				</td>
				<td align="right"><img src="/cfmx/saci/images/number3_16.gif" border="0"></td>
				<td  nowrap>
					<cfif ExistePersona>
					<a href="javascript: goPage(document.formCuadroOpt, 3);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
					</cfif>
						<cfif Form.paso EQ 3><strong></cfif>Forma de Cobro<cfif Form.paso EQ 3></strong></cfif>
					<cfif ExistePersona>
					</a>
					</cfif>
				</td>
			  </tr>
			  
			  <!--- 4 --->
<!--- 			  <tr>
				<td width="1%" align="right">
				  <cfif Form.paso GT 4>
					<img src="/cfmx/saci/images/w-check.gif" border="0">
				  <cfelseif Form.paso EQ 4>
					<img src="/cfmx/saci/images/addressGo.gif" border="0">
				  <cfelse>
					&nbsp;
				  </cfif>
				</td>
				<td align="right"><img src="/cfmx/saci/images/number4_16.gif" border="0"></td>
				<td  nowrap>
					<cfif ExistePersona>
					<a href="javascript: goPage(document.formCuadroOpt, 4);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
					</cfif>
						<cfif Form.paso EQ 4><strong></cfif>Dep&oacute;sito de Garant&iacute;a<cfif Form.paso EQ 4></strong></cfif>
					<cfif ExistePersona>
					</a>
					</cfif>
				</td>
			  </tr> --->
			  <cfset linea = "">
			  <cfif isdefined('rsDatosVerif') and rsDatosVerif.recordCount GT 0>
			  	<cfset linea = " style='border-bottom: 1px solid black; '">
			  </cfif>
			 <!--- <!--- 5 --->
			  <tr>
				<td width="1%" align="right">
				  <cfif Form.paso GT 5>
					<img src="/cfmx/saci/images/w-check.gif" border="0">
				  <cfelseif Form.paso EQ 5>
					<img src="/cfmx/saci/images/addressGo.gif" border="0">
				  <cfelse>
					&nbsp;
				  </cfif>
				</td>
				<td align="right"><img src="/cfmx/saci/images/number5_16.gif" border="0"></td>
				<td nowrap>
					<cfif ExistePersona><a href="javascript: goPage(document.formCuadroOpt, 5);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;"></cfif>
					<cfif Form.paso EQ 5><strong></cfif>
						Comprobar Informaci&oacute;n
					<cfif Form.paso EQ 5></strong></cfif>
					<cfif ExistePersona></a></cfif>
				</td>
			  </tr>--->
			  
			  <!--- 6 --->
			  <tr>
				<td width="1%" align="right" #linea#>
				  <cfif Form.paso GT 6>
					<img src="/cfmx/saci/images/w-check.gif" border="0">
				  <cfelseif Form.paso EQ 6>
					<img src="/cfmx/saci/images/addressGo.gif" border="0">
				  <cfelse>
					&nbsp;
				  </cfif>
				</td>
				<td align="right" #linea#><img src="/cfmx/saci/images/number4_16.gif" border="0"></td>
				<td #linea# nowrap>
					<cfif Form.paso EQ 4>
						<strong>
					</cfif>
					<cfif ExistePersona>
						<a href="javascript: aprobar(document.formCuadroOpt, 4);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
					</cfif>
						Aprobar
					<cfif ExistePersona>
						</a>
					</cfif>
						&nbsp;/&nbsp;
					<cfif ExistePersona>
						<a href="javascript: rechazar(document.formCuadroOpt, 4);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
					</cfif>										
						Rechazar
					<cfif ExistePersona>
						</a>
					</cfif>						
					<cfif Form.paso EQ 4>
						</strong>
					</cfif>
				</td>
			  </tr>			  
			<cfif linea NEQ ''>
				<!--- Anotaciones --->
				<tr>
					<td>&nbsp;</td>
					<td align="center"><img src="/cfmx/saci/images/file.png" border="0"></td>
					<td  nowrap><a href="javascript: abrirAnotaciones();" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">Agregar Anotaciones</a></td>
				  </tr>
			</cfif>
			</table>
			
		</form>
	<cf_web_portlet_end>  
</cfoutput>

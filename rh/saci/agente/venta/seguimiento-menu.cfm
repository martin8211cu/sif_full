<cfparam name="params_incidencias" default="">
<cfoutput>
	<cf_web_portlet_start tituloalign="left" titulo="Seguimiento de Ventas">
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
			function abrirIncidencias()
			{
				popUpWindow("incidencias.cfm#params_incidencias#",200,100,650,500);
			}
			function goPage(f, paso) {
				if (paso == 99) {
					f.paso.value = '1';
					f.cue.value = '';
				} else if (paso == 98) {
					if (arguments[2] != undefined) {
						f.cue.value = arguments[2];
					}
				} else {
					f.paso.value = paso;
				}
				f.submit();
			}
		</script>
		
		<form name="formCuadroOpt" action="#CurrentPage#" method="get" style="margin: 0;">
			<cfinclude template="seguimiento-hiddens.cfm">
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
						<cfif Form.paso EQ 1><strong></cfif>Configurar Servicios<cfif Form.paso EQ 1></strong></cfif>
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
			  <tr>
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
			  </tr>
			  
			  <!--- 5 --->
			  <tr>
				<td width="1%" align="right" style="border-bottom: 1px solid black; ">
				  <cfif Form.paso GT 5>
					<img src="/cfmx/saci/images/w-check.gif" border="0">
				  <cfelseif Form.paso EQ 5>
					<img src="/cfmx/saci/images/addressGo.gif" border="0">
				  <cfelse>
					&nbsp;
				  </cfif>
				</td>
				<td align="right" style="border-bottom: 1px solid black; "><img src="/cfmx/saci/images/number5_16.gif" border="0"></td>
				<td  style="border-bottom: 1px solid black; " nowrap>
					<cfif ExistePersona>
					<a href="javascript: goPage(document.formCuadroOpt, 5);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
					</cfif>
						<cfif Form.paso EQ 5><strong></cfif>Comprobar Informaci&oacute;n<cfif Form.paso EQ 5></strong></cfif>
					<cfif ExistePersona>
					</a>
					</cfif>
				</td>
			  </tr>
			  
			<!--- Anotaciones o Incidencias--->
			<tr>
				<td>&nbsp;</td>
				<td align="center"><img src="/cfmx/saci/images/file.png" border="0"></td>
				<td  nowrap><a href="javascript: abrirIncidencias();" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">Modificar Anotaciones</a></td>
			  </tr>
			</table>
			
		</form>
	<cf_web_portlet_end> 
	
	
	
</cfoutput>

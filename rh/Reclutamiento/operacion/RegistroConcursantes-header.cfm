<!---*******************************--->
<!--- funcion general para los      --->
<!--- botones siguientes y anterior --->
<!---*******************************--->
<script language="javascript" type="text/javascript">
		function funcSiguiente(){
			if (document.form1.paso){
				var vpaso = parseInt(document.form1.paso.value) + 1;
				document.form1.paso.value = vpaso;
				if (window.deshabilitar) deshabilitar();
			}
		}
		function funcAnterior(){
			if (document.form1.paso)
				var vpaso = parseInt(document.form1.paso.value) - 1;
				document.form1.paso.value = vpaso;
				if (window.deshabilitar) deshabilitar();
		}
</script>
<cfoutput>
<!---*******************************--->
<!--- Pintado del encabezado        --->
<!--- Titulos                       --->
<!---*******************************--->
<table width="100%" border="0" cellspacing="0" cellpadding="4">
  <tr>
	<td width="1%" align="right">
		 <img src="/cfmx/rh/imagenes/number#Gpaso#_64.gif" border="0"> 
	</td>
	<td style="padding-left: 10px;" valign="top">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td style="border-bottom: 1px solid black " nowrap><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#Gdescpasos[Gpaso+1]#</strong></td>
		  </tr>
		  <tr>
			<td class="tituloPersona" align="left" style="text-align:left" nowrap>#Gdescpasos[Gpaso+1]#</td>
		  </tr>
		  <cfif isdefined("rsGconcurso")>
		  <tr>
			<td class="ayuda" align="left" nowrap>Modificando: <font color="##003399"><strong>#rsGconcurso.RHCcodigo#-#rsGconcurso.RHCdescripcion#</strong></font></td>
		  </tr>
		  </cfif>
		</table>
	</td>
  </tr>
</table>
</cfoutput>
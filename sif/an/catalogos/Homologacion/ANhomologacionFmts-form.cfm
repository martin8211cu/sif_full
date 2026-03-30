<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Mensaje" 	default="M&aacute;scara de Cuenta Financiera" 
returnvariable="LB_Mensaje" xmlfile="ANhomologacionFmts-form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Mensaje1" 	default="Digite la cuenta mayor y presione TAB" 
returnvariable="LB_Mensaje1" xmlfile="ANhomologacionFmts-form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Sumar" 	default="Sumar" 
returnvariable="LB_Sumar" xmlfile="ANhomologacionFmts-form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Restar" 	default="Restar" 
returnvariable="LB_Restar" xmlfile="ANhomologacionFmts-form.xml"/>

<cfparam name="mododet" default="ALTA">
<cfif isdefined('form.ANHFid')>
	<cfset mododet="CAMBIO">
	<cfquery name="rsCuenta" datasource="#session.dsn#">
		select c.ANHid, c.ANHCid, f.ANHFid , f.Cmayor, f.AnexoCelFmt, f.AnexoSigno, 'S' as Mov
			from ANhomologacionFmts f
				inner join ANhomologacionCta c
				 on c.ANHCid = f.ANHCid
			where f.ANHFid = #form.ANHFid#
	</cfquery>	
</cfif>
<cfoutput>
 <form method="post" name="form1" action="ANhomologacionCta-sql.cfm" onSubmit="return validar();">
 	<input type="hidden" name="ANHid" value="#form.ANHid#"/> 
 	<input type="hidden" name="ANHCid" value="#form.ANHCid#"/> 

 	  <table align="center">
		<tr valign="baseline">
			<td nowrap align="right" valign="middle">&nbsp;</td>
			<td><cfoutput>#LB_Mensaje#:<br> 
		  		<strong>(#LB_Mensaje1#)</strong></cfoutput>
			</td>
		</tr>
    	<tr valign="baseline"> 
		  <td nowrap align="right" valign="middle">&nbsp;</td>
		  <td>
			<cfif mododet EQ "ALTA">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr><td nowrap>
						<input type="text" name="txt_Cmayor" maxlength="4" size="4" width="100%" 
							onfocus="this.select();" onBlur="javascript:this.value = fnRight('0000' + this.value, 4); CargarCajas(this.value);">
					</td><td>
						<iframe marginheight="0" 
								marginwidth="0" 
								scrolling="no" 
								name="cuentasIframe" 
								id="cuentasIframe" 
								width="100%" 
								height="25" 
								frameborder="0">
						</iframe>
						<input type="hidden" name="CtaFinal">
					</td>
				</tr>	
				</table>
			<cfelse>
				<cfset rsCuenta.AnexoCelFmt = replace(rsCuenta.AnexoCelFmt,"%","","ALL")>
				<cfif find("-",rsCuenta.AnexoCelFmt,1) eq 0>
					<cfset Param_Cmayor ="#rsCuenta.AnexoCelFmt#">
				<cfelse>

					<cfset Param_Cmayor ="#Mid(rsCuenta.AnexoCelFmt,1,find("-",rsCuenta.AnexoCelFmt,1)-1)#">
				</cfif>
				<input type="hidden" name="ANHFid" value="#form.ANHFid#">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td nowrap>
						<input type="text" name="txt_Cmayor" maxlength="4" size="4" width="100%" 
								onfocus="this.select()"	
							 	onBlur="javascript:this.value = fnRight('0000' + this.value, 4); CargarCajas(this.value)" 
								value="<cfif mododet neq "ALTA"><cfoutput>#Param_Cmayor#</cfoutput></cfif>"
						>
					</td>
					<td>
						<iframe marginheight="0" 
								marginwidth="0" 
								scrolling="no" 
								name="cuentasIframe" 
								id="cuentasIframe" 
								width="100%" 
								height="25" 
								frameborder="0" 
								src="<cfoutput>/cfmx/sif/Utiles/generacajas.cfm?Cmayor=#Param_Cmayor#&modo=#mododet#&formatocuenta=#rsCuenta.AnexoCelFmt#</cfoutput>">
						</iframe>
						<input type="hidden" name="CtaFinal" value="<cfoutput>#rsCuenta.AnexoCelFmt#</cfoutput>">
					</td>
				</tr>	
			</table>
		</cfif>
	  	</td>
   		 </tr>
	<tr valign="baseline">
      <td nowrap align="right">&nbsp;</td>
      <td valign="middle">
		<cfif mododet EQ "ALTA">
		  	<cfset LvarMas = "checked">
		  	<cfset LvarMenos = "">
		<cfelseif rsCuenta.AnexoSigno GT 0>
		  	<cfset LvarMas = "checked">
		  	<cfset LvarMenos = "">
		<cfelse>
		  	<cfset LvarMas = "">
		  	<cfset LvarMenos = "checked">
		</cfif>
	  <input type="radio" name="AnexoSigno" id="AnexoSignoMas" value="+1" #LvarMas#><label for="AnexoSignoMas">#LB_Sumar#</label>
		&nbsp;&nbsp;
	  <input type="radio" name="AnexoSigno" id="AnexoSignoMenos" value="-1" #LvarMenos#><label for="AnexoSignoMenos">#LB_Restar#</label>
	  </td>
    </tr>
    <tr valign="baseline"> 
		
      <td colspan="2" align="right" nowrap><div align="center">
		<cfif mododet EQ "ALTA">
		  	<cf_botones values="Agregar" names="AgregarFmts">
		<cfelse>
			<cf_botones values="Modificar, Eliminar" names="ModificarFmts, EliminarFmts">
		</cfif>
	  </td>
    </tr>
  </table>
 </form>
</cfoutput>
<script language="JavaScript1.2">
	function fnRight(LprmHilera, LprmLong)
	{
		var LvarTot = LprmHilera.length;
		return LprmHilera.substring(LvarTot-LprmLong,LvarTot);
	}		 
	function validar(){
		document.form1.CtaFinal.value="";	
		if (document.form1.txt_Cmayor.value.length == 0){
			alert('Se presentaron los siguientes errores:\n - El campo Formato de Cuenta es requerido.');
			return false;		
		}
		FrameFunction();
		return true;
	}
	function CargarCajas(Cmayor)
	{				
		var fr = document.getElementById("cuentasIframe");					
		fr.src = "/cfmx/sif/Utiles/generacajas.cfm?Cmayor="+Cmayor+"&modo=ALTA"
	}
	function FrameFunction()
	{
		// Aunque RetornaCuenta() es máscara parcial, el SQL le agrega % (solo acepta Último Nivel), equivalente a RetornaCuenta3()
		window.parent.cuentasIframe.RetornaCuenta();
	}
</script>

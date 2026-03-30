<cfif url.num eq 1>
    <cfparam name="mododet1" default="ALTA">
    <cfif isdefined('form.ANHFid1')>
        <cfset mododet1="CAMBIO">
        <cfquery name="rsCuenta1" datasource="#session.dsn#">
            select c.ANHid, c.ANHCid, f.ANHFid , f.Cmayor, f.AnexoCelFmt, f.AnexoSigno, 'S' as Mov
                from ANhomologacionFmts f
                    inner join ANhomologacionCta c
                     on c.ANHCid = f.ANHCid
                where f.ANHFid = #form.ANHFid1#
        </cfquery>	
    </cfif>
<cfelse>
    <cfparam name="mododet2" default="ALTA">
    <cfif isdefined('form.ANHFid2')>
        <cfset mododet2="CAMBIO">
        <cfquery name="rsCuenta2" datasource="#session.dsn#">
            select c.ANHid, c.ANHCid, f.ANHFid , f.Cmayor, f.AnexoCelFmt, f.AnexoSigno, 'S' as Mov
                from ANhomologacionFmts f
                    inner join ANhomologacionCta c
                     on c.ANHCid = f.ANHCid
                where f.ANHFid = #form.ANHFid2#
        </cfquery>
    </cfif>
</cfif>
<cfoutput>
<cfif url.num eq 1>
 <form method="post" name="form1" action="ANhomologacionCta-sql.cfm" onSubmit="return validar1();">
<cfelse>
 <form method="post" name="form2" action="ANhomologacionCta-sql.cfm" onSubmit="return validar2();">
</cfif>
 	<input type="hidden" name="ANHid" value="#form.ANHid#"/> 
    <cfif url.num eq 1>
 		<input type="hidden" name="ANHCid1" value="#form.ANHCid1#"/> 
    <cfelse>
    	<input type="hidden" name="ANHCid2" value="#form.ANHCid2#"/>
    </cfif>
 	  <table align="center">
		<tr valign="baseline">
			<td nowrap align="right" valign="middle">&nbsp;</td>
			<td>
				Máscara de Cuenta Financiera:<br> 
		  		<strong>(Digite la cuenta mayor y presione TAB)</strong>
			</td>
		</tr>
    	<tr valign="baseline"> 
		  <td nowrap align="right" valign="middle">&nbsp;</td>
		  <td>
			<cfif isdefined('mododet1') and mododet1 EQ "ALTA" or isdefined('mododet2') and mododet2 EQ "ALTA">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr><td nowrap>
                     <cfif url.num eq 1>
						<input type="text" name="txt_Cmayor1" maxlength="4" size="4" width="100%" 
							onfocus="this.select();" onBlur="javascript:this.value = fnRight1('0000' + this.value, 4); CargarCajas1(this.value);">
                         <cfelse>
                         <input type="text" name="txt_Cmayor2" maxlength="4" size="4" width="100%" 
							onfocus="this.select();" onBlur="javascript:this.value = fnRight2('0000' + this.value, 4); CargarCajas2(this.value);">
                     </cfif>
					</td><td>
                      <cfif url.num eq 1>
						<iframe marginheight="0" 
								marginwidth="0" 
								scrolling="no" 
								name="cuentasIframe1" 
								id="cuentasIframe1" 
								width="100%" 
								height="25" 
								frameborder="0">
						</iframe>
						<input type="hidden" name="CtaFinal1">
                    <cfelse>
                        <iframe marginheight="0" 
                                    marginwidth="0" 
                                    scrolling="no" 
                                    name="cuentasIframe2" 
                                    id="cuentasIframe2" 
                                    width="100%" 
                                    height="25" 
                                    frameborder="0">
                            </iframe>
                            <input type="hidden" name="CtaFinal2">
                    </cfif>
					</td>
				</tr>	
				</table>
			<cfelseif  url.num eq 1 >
						<cfset rsCuenta1.AnexoCelFmt = replace(rsCuenta1.AnexoCelFmt,"%","","ALL")>
                        <cfif find("-",rsCuenta1.AnexoCelFmt,1) eq 0>
                            <cfset Param_Cmayor ="#rsCuenta1.AnexoCelFmt#">
                        <cfelse>
                            <cfset Param_Cmayor ="#Mid(rsCuenta1.AnexoCelFmt,1,find("-",rsCuenta1.AnexoCelFmt,1)-1)#">
                        </cfif>
                        <input type="hidden" name="ANHFid1" value="#form.ANHFid1#">
                        <table width="100%" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td nowrap>
                                <input type="text" name="txt_Cmayor1" maxlength="4" size="4" width="100%" 
                                        onfocus="this.select()"	
                                        onBlur="javascript:this.value = fnRight1('0000' + this.value, 4); CargarCajas1(this.value)" 
                                        value="<cfif mododet1 neq "ALTA"><cfoutput>#Param_Cmayor#</cfoutput></cfif>"
                                >
                            </td>
                            <td>
                                <iframe marginheight="0" 
                                        marginwidth="0" 
                                        scrolling="no" 
                                        name="cuentasIframe1" 
                                        id="cuentasIframe1" 
                                        width="100%" 
                                        height="25" 
                                        frameborder="0" 
                                        src="<cfoutput>/cfmx/sif/Utiles/generacajas.cfm?Cmayor=#Param_Cmayor#&modo=#mododet1#&formatocuenta=#rsCuenta1.AnexoCelFmt#&VCta=CtaFinal1</cfoutput>">
                                </iframe>
                                <input type="hidden" name="CtaFinal1" value="<cfoutput>#rsCuenta1.AnexoCelFmt#</cfoutput>">
                            </td>
                            </tr>	
                        </table>
                        
                <cfelseif  url.num eq 2>

						<cfset rsCuenta2.AnexoCelFmt = replace(rsCuenta2.AnexoCelFmt,"%","","ALL")>
                        <cfif find("-",rsCuenta2.AnexoCelFmt,1) eq 0>
                            <cfset Param_Cmayor ="#rsCuenta2.AnexoCelFmt#">
                        <cfelse>
        
                            <cfset Param_Cmayor ="#Mid(rsCuenta2.AnexoCelFmt,1,find("-",rsCuenta2.AnexoCelFmt,1)-1)#">
                        </cfif>
                        <input type="hidden" name="ANHFid2" value="#form.ANHFid2#">
                        <table width="100%" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td nowrap>
                                <input type="text" name="txt_Cmayor2" maxlength="4" size="4" width="100%" 
                                        onfocus="this.select()"	
                                        onBlur="javascript:this.value = fnRight2('0000' + this.value, 4); CargarCajas2(this.value)" 
                                        value="<cfif mododet2 neq "ALTA"><cfoutput>#Param_Cmayor#</cfoutput></cfif>"
                                >
                            </td>
                            <td>
                                <iframe marginheight="0" 
                                        marginwidth="0" 
                                        scrolling="no" 
                                        name="cuentasIframe2" 
                                        id="cuentasIframe2" 
                                        width="100%" 
                                        height="25" 
                                        frameborder="0" 
                                        src="<cfoutput>/cfmx/sif/Utiles/generacajas.cfm?Cmayor=#Param_Cmayor#&modo=#mododet2#&Vform=form2&formatocuenta=#rsCuenta2.AnexoCelFmt#&VCta=CtaFinal2</cfoutput>">
                                </iframe>
                                <input type="hidden" name="CtaFinal2" value="<cfoutput>#rsCuenta2.AnexoCelFmt#</cfoutput>">
                                
                            </td>
                            </tr>	
                        </table>                
                </cfif>
	  	</td>
   		 </tr>
	<tr valign="baseline">
      <td nowrap align="right">&nbsp;</td>
      <td valign="middle">
		<cfif isdefined('mododet1') and mododet1 EQ "ALTA" or isdefined('mododet2') and mododet2 EQ "ALTA">
		  	<cfset LvarMas = "checked">
		  	<cfset LvarMenos = "">
		<cfelseif isdefined('rsCuenta1.AnexoSigno') and rsCuenta1.AnexoSigno GT 0 or isdefined('rsCuenta2.AnexoSigno')and rsCuenta2.AnexoSigno GT 0>
		  	<cfset LvarMas = "checked">
		  	<cfset LvarMenos = "">
		<cfelse>
		  	<cfset LvarMas = "">
		  	<cfset LvarMenos = "checked">
		</cfif>
        <cfif url.num eq 1>
	  <input type="radio" name="AnexoSigno1" id="AnexoSignoMas1" value="+1" #LvarMas#><label for="AnexoSignoMas1">Sumar</label>
		&nbsp;&nbsp;
	  <input type="radio" name="AnexoSigno1" id="AnexoSignoMenos1" style="visibility:hidden" value="-1" >
      <cfelse>
	  <input type="radio" name="AnexoSigno2" id="AnexoSignoMas2" value="+1" #LvarMas#><label for="AnexoSignoMas2">Sumar</label>
		&nbsp;&nbsp;
	  <input type="radio" name="AnexoSigno2" id="AnexoSignoMenos2" style="visibility:hidden" value="-1" >   
      </cfif>
	  </td>
    </tr>
    <tr valign="baseline"> 
		
      <td colspan="2" align="right" nowrap><div align="center">
       <cfif url.num eq 1>
			<cfif mododet1 EQ "ALTA">
                <cf_botones values="Agregar" names="AgregarFmts1">
            <cfelse>
                <cf_botones values="Modificar, Eliminar" names="ModificarFmts1, EliminarFmts1">
            </cfif>
       <cfelse>
       			<cfif mododet2 EQ "ALTA">
                <cf_botones values="Agregar" names="AgregarFmts2">
            <cfelse>
                <cf_botones values="Modificar, Eliminar" names="ModificarFmts2, EliminarFmts2">
            </cfif>

       </cfif>
	  </td>
    </tr>
  </table>
 </form>
</cfoutput>
<cfif url.num eq 1>
	<script language="JavaScript1.2">
        function fnRight1(LprmHilera, LprmLong)
        {
            var LvarTot = LprmHilera.length;
            return LprmHilera.substring(LvarTot-LprmLong,LvarTot);
        }		 
        function validar1(){
            document.form1.CtaFinal1.value="";	
            if (document.form1.txt_Cmayor1.value.length == 0){
                alert('Se presentaron los siguientes errores:\n - El campo Formato de Cuenta es requerido.');
                return false;		
            }
            FrameFunction1();
            return true;
        }
        function CargarCajas1(Cmayor)
        {				
            var fr = document.getElementById("cuentasIframe1");					
            fr.src = "/cfmx/sif/Utiles/generacajas.cfm?Cmayor="+Cmayor+"&modo=ALTA&VCta=CtaFinal1"
        }
        function FrameFunction1() {
            // Aunque RetornaCuenta() es máscara parcial, el SQL le agrega % (solo acepta Último Nivel), equivalente a RetornaCuenta3()
           cuentasIframe1.RetornaCuenta();
        }
    </script>
<cfelse>
	<script language="JavaScript1.2">
        function fnRight2(LprmHilera, LprmLong){
            var LvarTot = LprmHilera.length;
            return LprmHilera.substring(LvarTot-LprmLong,LvarTot);
        }		 
        function validar2(){
            document.form2.CtaFinal2.value="";	
            if (document.form2.txt_Cmayor2.value.length == 0){
                alert('Se presentaron los siguientes errores:\n - El campo Formato de Cuenta es requerido.');
                return false;		
            }
            FrameFunction2();
            return true;
        }
        function CargarCajas2(Cmayor){				
            var fr = document.getElementById("cuentasIframe2");					
            fr.src = "/cfmx/sif/Utiles/generacajas.cfm?Cmayor="+Cmayor+"&modo=ALTA&VCta=CtaFinal2&Vform=form2"
        }
        function FrameFunction2(){
            // Aunque RetornaCuenta() es máscara parcial, el SQL le agrega % (solo acepta Último Nivel), equivalente a RetornaCuenta3()
            cuentasIframe2.RetornaCuenta2();
        }
    </script>
</cfif>

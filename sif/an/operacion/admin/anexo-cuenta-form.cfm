
<cfparam name="modo" default="ALTA">

<cfif isdefined('url.Ppagina')>
	<cfset form.Ppagina = #url.Ppagina#>
</cfif>

<cfif isdefined('url.AnexoCelDid2') and len(trim(url.AnexoCelDid2)) GT 0 or (isdefined("url.AnexoCelDid") and len(trim(url.AnexoCelDid)) GT 0) >
	<cfset modo = "CAMBIO">
<cfelse>	
	<cfset modo = "ALTA">
</cfif>

<cfquery name="rsLinea" datasource="#Session.DSN#">
	select 
		<cf_dbfunction name="to_char" args="a.AnexoCelDid"> as AnexoCelDid, 
		<cf_dbfunction name="to_char" args="a.AnexoCelId">  as AnexoCelId, 
		a.AnexoCelFmt, 
		a.AnexoCelFmt as Cformato, 
		a.AnexoCelMov,
		a.AnexoSigno,
		'' as Cdescripcion,
		'' as Ccuenta
		, b.AnexoCon
	from AnexoCel b
		left join AnexoCelD a
			on a.AnexoCelId = b.AnexoCelId
	where b.AnexoCelId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoCelId#">
	<cfif isdefined("url.AnexoCelDid")>
	  and a.AnexoCelDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoCelDid#">
	<cfelseif isdefined("url.AnexoCelDid2")>
	  and a.AnexoCelDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoCelDid2#">
	</cfif>
</cfquery>

<cfif modo neq 'ALTA'>
	<cfset formato = ListToArray(rsLinea.Cformato, '%')>
	<cfloop  from="1" index="i" to="#ArrayLen(formato)#" >
		<cfset vFormato = trim(formato[i])>
	</cfloop>

	<cfset vDescripcion = '' >
	<cfif ArrayLen(formato) gt 0>
		<cfquery name="descripcion" datasource="#session.DSN#">
			select Cdescripcion 
			from CContables 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
			and Cformato = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(formato[1])#">
		</cfquery>
	
		<cfif descripcion.RecordCount gt 0>
			<cfset vDescripcion = descripcion.Cdescripcion >
		</cfif>
	</cfif>
	
	<cfif len(trim(rsLinea.Cdescripcion)) gt 0>
		<cfset vDescripcion = rsLinea.Cdescripcion >
	</cfif>

	<cfset rsCuenta = QueryNew("Cformato,AnexoCelDid,AnexoCelId,AnexoCelFmt,Cdescripcion,Ccuenta")>
	<cfset temp = QueryAddRow(rsCuenta,1)>
	<cfset temp = QuerySetCell(rsCuenta, "Cformato", trim(formato[1]), 1)>
	<cfset temp = QuerySetCell(rsCuenta, "AnexoCelDid", trim(rsLinea.AnexoCelDid), 1)>
	<cfset temp = QuerySetCell(rsCuenta, "AnexoCelId", trim(rsLinea.AnexoCelId), 1)>
	<cfset temp = QuerySetCell(rsCuenta, "AnexoCelFmt", trim(rsLinea.AnexoCelFmt), 1)>
	<cfset temp = QuerySetCell(rsCuenta, "Cdescripcion", vDescripcion, 1)>
	<cfset temp = QuerySetCell(rsCuenta, "Ccuenta", '', 1)>

</cfif>

<cfoutput>
 <form method="post" name="form1" action="anexo-cuenta-apply.cfm" onSubmit="return validar();">
 	<input type="hidden" name="anexocon" value="#rsLinea.AnexoCon#" />
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
	  	<cfif modo EQ "ALTA">

			<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td nowrap>
					<input type="text" name="txt_Cmayor" maxlength="4" size="4" width="100%" 
							onfocus="this.select();"
							onBlur="javascript:this.value = fnRight('0000' + this.value, 4); CargarCajas(this.value);"
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
							frameborder="0"></iframe>
					<input type="hidden" name="CtaFinal">
				</td>
			</tr>	
			</table>
			
			<!--- 
			<cf_cuentasAnexo 
				AUXILIARES="S" 
				MOVIMIENTO="N"
				CONLIS="S"
				ccuenta="Ccuenta" 
				cdescripcion="Cdescripcion" 
				cformato="Cformato" 
				conexion="#Session.DSN#"
				form="form1"
				frame="frAn"
				comodin="_">	 --->
		<cfelse>	
				<cfif find("-",rsCuenta.Cformato,1) eq 0>
					<cfset Param_Cmayor ="#rsCuenta.Cformato#">
				<cfelse>
					<cfset Param_Cmayor ="#Mid(rsCuenta.Cformato,1,find("-",rsCuenta.Cformato,1)-1)#">
				</cfif>

				<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td nowrap>
						<input type="text" name="txt_Cmayor" maxlength="4" size="4" width="100%" 
								onfocus="this.select()"	
							 	onBlur="javascript:this.value = fnRight('0000' + this.value, 4); CargarCajas(this.value)" 
								value="<cfif modo neq "ALTA"><cfoutput>#Param_Cmayor#</cfoutput></cfif>"
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
								src="<cfoutput>/cfmx/sif/Utiles/generacajas.cfm?Cmayor=#Param_Cmayor#&MODO=#modo#&formatocuenta=#rsCuenta.Cformato#</cfoutput>">
								</iframe>
						<input type="hidden" name="CtaFinal" value="<cfoutput>#rsCuenta.Cformato#</cfoutput>">
					</td>
				</tr>	
				</table>
				
				<!--- 
			<cf_cuentasAnexo 
				AUXILIARES="S" 
				MOVIMIENTO="N"
				CONLIS="S"
				ccuenta="Ccuenta" 
				cdescripcion="Cdescripcion" 
				cformato="Cformato" 
				conexion="#Session.DSN#"
				form="form1"
				query="#rsCuenta#"
				frame="frAn"
				comodin="_"> --->
		</cfif>
		
	  </td>
    </tr>
    <tr valign="baseline">
      <td nowrap align="right">&nbsp;</td>
      <td valign="middle">
	  <input type="radio" name="AnexoSigno" id="AnexoSignoMas" value="+1" <cfif rsLinea.AnexoSigno NEQ -1>checked</cfif>><label for="AnexoSignoMas">Sumar</label>
	&nbsp;&nbsp;
	  <input type="radio" name="AnexoSigno" id="AnexoSignoMenos" value="-1" <cfif rsLinea.AnexoSigno EQ -1>checked</cfif>><label for="AnexoSignoMenos">Restar</label>
	  
	  </td>
    </tr>
    <tr valign="baseline"> 
        <td nowrap align="right">&nbsp;</td>
        <td valign="middle"> 
			<cfif rsLinea.AnexoCon GTE 50 AND rsLinea.AnexoCon LTE 69>
				<input	type="checkbox" name="AnexoCelMov"  id="AnexoCelMov" value="S" checked disabled>
			<cfelse>
				<input	type="checkbox" name="AnexoCelMov"  id="AnexoCelMov" 
						value="<cfif modo neq "ALTA">#rsLinea.AnexoCelMov#</cfif>"
						<cfif rsLinea.AnexoCelMov EQ 'S'>checked</cfif>
				>
			</cfif>
			<label for="AnexoCelMov">Obtener hijas que aceptan Movimiento</label>
		</td>
    </tr>
    <tr valign="baseline"> 
      <td colspan="2" align="right" nowrap><div align="center"><cfinclude template="../../../portlets/pBotones.cfm">
            <input type="Button" name="btnRegresar" value="Regresar" onclick="regresar()">
			<!--- <input type="Button" name="btntest" value="test" onclick="FrameFunction()"> --->
          </div></td>
    </tr>
  </table>

	<cfif isdefined("url.nav") and len(trim(url.nav)) gt 0>
		<input type="hidden" name="nav" value="#url.nav#">
	</cfif>	
	<cfif isdefined("url.F_Hoja") and len(trim(url.F_Hoja)) gt 0>
		<input type="hidden" name="F_Hoja" value="#url.F_Hoja#">
	</cfif>
	<cfif isdefined("url.F_columna") and url.F_columna gt 0>
		<input type="hidden" name="F_columna" value="#url.F_columna#">
	</cfif>
	<cfif isdefined("url.F_fila") and url.F_fila gt 0>
		<input type="hidden" name="F_fila" value="#url.F_fila#">
	</cfif>
	<cfif isdefined("url.F_Rango") and len(trim(url.F_Rango)) gt 0>
		<input type="hidden" name="F_Rango" value="#url.F_Rango#">
	</cfif>				
	<cfif isdefined("url.F_Estado") and url.F_Estado gt 0>
		<input type="hidden" name="F_Estado" value="#url.F_Estado#">
	</cfif>	
	<cfif isdefined("url.F_Cuentas") and url.F_Cuentas gt -1>
		<input type="hidden" name="F_Cuentas" value="#url.F_Cuentas#">
	</cfif>	

  <input type="hidden" name="AnexoCelDid" value="<cfif isdefined('url.AnexoCelDid2')>#url.AnexoCelDid2#<cfelseif isdefined("url.AnexoCelDid")>#url.AnexoCelDid#</cfif>">
  <input type="hidden" name="AnexoCelId" value="#url.AnexoCelId#">
  <input type="hidden" name="AnexoId" value="#url.AnexoId#">
  <input type="hidden" name="Ppagina" value="<cfif isdefined('form.Ppagina')>#form.Ppagina#<cfelse>1</cfif>">
</form>
</cfoutput>
<script language="JavaScript1.2">
	// advv -- document.form1.Cformato.focus();

	function fnRight(LprmHilera, LprmLong)
	{
		var LvarTot = LprmHilera.length;
		return LprmHilera.substring(LvarTot-LprmLong,LvarTot);
	}		 

	function validar(){
		//if ( document.form1.Cformato.value.length == 0 || document.form1.Cmayor.value.length == 0 ){
		/* advv
		if ( document.form1.Cmayor.value.length == 0 ){
			alert('Se presentaron los siguientes errores:\n - El campo Formato de Cuenta es requerido.')
			return false;
		}*/

		document.form1.CtaFinal.value="";	
		if (document.form1.txt_Cmayor.value.length == 0){
			alert('Se presentaron los siguientes errores:\n - El campo Formato de Cuenta es requerido.');
			return false;		
		}
		FrameFunction();
		return true;
	}
	function regresar(){
	<cfoutput>
	
		<cfset fltr = "&nav=1">
		<cfif isdefined("url.F_Hoja") and len(trim(url.F_Hoja)) gt 0>
			<cfset fltr = fltr & "&F_Hoja=#url.F_Hoja#">
		</cfif>
		<cfif isdefined("url.F_columna") and url.F_columna gt 0>
			<cfset fltr = fltr & "&F_columna=#url.F_columna#">
		</cfif>
		<cfif isdefined("url.F_fila") and url.F_fila gt 0>
			<cfset fltr = fltr & "&F_fila=#url.F_fila#">
		</cfif>
		<cfif isdefined("url.F_Rango") and len(trim(url.F_Rango)) gt 0>
			<cfset fltr = fltr & "&F_Rango=#url.F_Rango#">
		</cfif>				
		<cfif isdefined("url.F_Estado") and url.F_Estado gt 0>
			<cfset fltr = fltr & "&F_Estado=#url.F_Estado#">
		</cfif>	
		<cfif isdefined("url.F_Cuentas") and url.F_Cuentas gt -1>
			<cfset fltr = fltr & "&F_Cuentas=#url.F_Cuentas#">
		</cfif>				
	
		<cfif isdefined("form.Ppagina")><cfset npag=form.Ppagina><cfelse><cfset npag=1></cfif>
		window.open("anexo.cfm?tab=2&AnexoId=#JSStringFormat(url.AnexoId)#&AnexoCelId=#JSStringFormat(url.AnexoCelId)#&pagina=#npag##fltr#",'_self');
	</cfoutput>
	}

	function CargarCajas(Cmayor)
	{				
		var fr = document.getElementById("cuentasIframe");					
		fr.src = "/cfmx/sif/Utiles/generacajas.cfm?Cmayor="+Cmayor+"&MODO=ALTA"<!--- <cfoutput>#modo#</cfoutput> --->
	}
	//Dispara la funcion del iframe que retorna los datos de la cuenta
	function FrameFunction()
	{
		// Aunque RetornaCuenta() es máscara parcial, cuando es Sólo Con Movimientos el SQL le agrega % (equivalente a RetornaCuenta3())
		window.parent.cuentasIframe.RetornaCuenta();
		
	}
</script>
<cfif isdefined("Form.PCRid") and Len(Trim(Form.PCRid))>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<!--- Obtiene la máscara de la cuenta de mayor del grupo --->
<cfquery datasource="#session.dsn#" name="rsMascara">
	Select a.PCRGDescripcion, a.Cmayor, c.PCEMformato
	from PCReglaGrupo a
			inner join CtasMayor b
				 on a.Cmayor = b.Cmayor
				and a.Ecodigo = b.Ecodigo
			inner join PCEMascaras c
				on c.PCEMid = b.PCEMid
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
	  and a.PCRGid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarGrp#">
</cfquery>

<cfif rsMascara.recordcount eq 0>

	<cfquery datasource="#session.dsn#" name="rsMascara">
		Select a.PCRGDescripcion, a.Cmayor, b.Cmascara as PCEMformato
		from PCReglaGrupo a
				inner join CtasMayor b
					 on a.Cmayor = b.Cmayor
					and a.Ecodigo = b.Ecodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		  and a.PCRGid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarGrp#">
	</cfquery>			

</cfif>


<!--- Reglas de Nivel 1 --->
<cfquery name="rsReferencias" datasource="#Session.DSN#">
	select PCRid, PCRregla 
	from PCReglas a
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and (PCRref is null or PCRid = PCRref)
	<cfif modo EQ "CAMBIO">
	  and PCRid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCRid#">
	</cfif>
</cfquery>

<cfif modo EQ "CAMBIO">

	<cfquery name="rsForm" datasource="#Session.DSN#">
		select a.PCRid, 
			   a.Cmayor, 
			   a.PCEMid, 
			   a.OficodigoM,
			   a.PCRref, 
			   a.PCRregla, 
			   a.PCRdescripcion, 
			   a.PCRvalida, 
			   a.PCRdesde, 
			   a.PCRhasta,
			   a.ts_rversion,
			   b.PCRregla as PCRref_text, 
			   (select coalesce(count(1), 0) 
			   from PCReglas x 
			   where x.Ecodigo = a.Ecodigo
			   and x.PCRref = a.PCRid
			   and x.PCRid <> a.PCRid
			   ) as cantNivel2
		from PCReglas a
			left outer join PCReglas b
				on b.PCRid = a.PCRref
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.PCRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCRid#">	
	</cfquery>
</cfif>

<cfoutput>
  <form name="form1" method="post" action="AdminReglas-sql.cfm" onSubmit="return validar();" style="margin: 0;">
  	  <cfinclude template="AdminReglas-hiddens.cfm">
      <input type="hidden" name="PCRid" value="<cfif modo EQ "CAMBIO">#form.PCRid#</cfif>">
	  <input type="hidden" name="CtaFinal" value="<cfif modo EQ "CAMBIO">#rsForm.PCRregla#</cfif>">
	  <input type="hidden" name="LvarGrp" value="#LvarGrp#">
	  <cfif isdefined("LvarRestaurar")>
			<input type="hidden" name="restaurar" value="2">
      <cfelse>
      		<input type="hidden" name="restaurar" value="1">
      </cfif>

    
	<cfif modo EQ "CAMBIO">
      <cfset ts = "">
      <cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsForm.ts_rversion#" returnvariable="ts">
      </cfinvoke>
      <input type="hidden" name="ts_rversion" value="<cfif modo EQ "CAMBIO">#ts#</cfif>">
    </cfif>
    <table width="98%" border="0" cellpadding="2" cellspacing="0" align="center">      
	  <tr>
        <td class="tituloAlterno" align="center" colspan="6">
			<cfif modo EQ "CAMBIO">
			  Modificaci&oacute;n de Regla
			  <cfelse>
			  Nueva Regla
			</cfif>
			<cfif isdefined("rsMascara.PCRGDescripcion")>
				<br>GRUPO - <cfoutput>#trim(rsMascara.PCRGDescripcion)#</cfoutput>
			</cfif>
        </td>
      </tr>
	  <tr><td colspan="6">&nbsp;</td></tr>
      <tr>
        <td align="right" class="fileLabel" nowrap>Oficina:</td>
        <td>
			<!--- <cfif modo EQ "CAMBIO">
            	<cf_sifoficinas form="form1" id="#rsForm.Ocodigo#">
            <cfelse>
            	<cf_sifoficinas form="form1">
          	</cfif> --->
			<input 	type="text" 
					name="OficodigoM" 
					maxlength="10" 
					size="13"
 					onBlur="" 
					<cfif not (modo EQ "CAMBIO" and rsForm.cantNivel2 GT 0)>
					onChange="javascript: eliminarRef();"
					</cfif>
					value="<cfif modo EQ "CAMBIO">#rsForm.OficodigoM#</cfif>">
			
        </td>
        <td align="right" class="fileLabel" nowrap>Regla de Validaci&oacute;n: </td>
        <td colspan="3">
			
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td width="8%">					
					<input 	type="text" 
							name="Cmayor" 
							maxlength="4" 
							size="4" 
							width="100%" 
							readonly="true"
							value="<cfoutput>#rsMascara.Cmayor#</cfoutput>">
					<!--- 
					<input type="text" name="Cmayor" maxlength="4" size="4" width="100%" onBlur="javascript:CargarCajas(this.value)" value="<cfif modo EQ "CAMBIO">#rsForm.Cmayor#</cfif>"
					<cfif not (modo EQ "CAMBIO" and rsForm.cantNivel2 GT 0)>
					onChange="javascript: eliminarRef();"
					</cfif>>--->
				</td>
				<td>
					<cfset LvarRegla_Formato = rsMascara.Cmayor & mid(rsMascara.PCEMformato,len(rsMascara.Cmayor)+1,100)>
					
					<cfset LvarRegla_Formato = replace(LvarRegla_Formato,"X","_","ALL")>
					<cfset LvarRegla_Niveles = listToArray(LvarRegla_Formato,"-")>
				
					<cfif modo EQ "CAMBIO">
						<cfset LvarRegla_Niveles = listToArray(rsForm.PCRregla,"-")>
					</cfif>
					<input type="hidden" id="CFformatoRegla" name="CFformatoRegla" value="#HTMLEditFormat(LvarRegla_Niveles[1])#" />
					<cfloop index="LvarIdx" from="1" to="#arrayLen(LvarRegla_Niveles)#">
					
							<cfif LvarIdx GT 1>-
							<input 
								type="text" 
								name="CFformatoRegla" 
								id="CFformatoRegla" 
								value="#HTMLEditFormat(LvarRegla_Niveles[LvarIdx])#" 
								size="#len(LvarRegla_Niveles[LvarIdx])#"
								maxlength="#len(LvarRegla_Niveles[LvarIdx])#"
								<cfset LvarNiv = LvarIdx - 1>
								onfocus="this.select()"
								onblur="this.value = fnConSubrayado(this.value,#len(LvarRegla_Niveles[LvarIdx])#);fnArmaCuenta();">															
							</cfif>
					</cfloop>

					<!--- 
					<iframe marginheight="0" 
					marginwidth="0" 
					scrolling="no" 
					name="cuentasIframe" 
					id="cuentasIframe" 
					width="100%" 
					height="25" 
					<cfif modo EQ "CAMBIO">
						src="/cfmx/sif/Utiles/generacajas.cfm?Cmayor=#rsForm.Cmayor#&MODO=#modo#&formatocuenta=#rsForm.PCRregla#"
					</cfif>
					frameborder="0"></iframe>--->
				</td>
			  </tr>
			</table>
			
		</td>
      </tr>
      <tr>
        <td align="right" class="fileLabel" nowrap>Fecha desde:</td>
        <td>
			<cfif modo EQ "ALTA">
            	<cf_sifcalendario form="form1" name="PCRdesde" value="#LSDateFormat(Now(),'DD/MM/YYYY')#">
            <cfelse>
            	<cf_sifcalendario form="form1" name="PCRdesde" value="#LSDateFormat(rsForm.PCRdesde,'DD/MM/YYYY')#">
         	 </cfif>
        </td>
        <td align="right" class="fileLabel" nowrap>Fecha hasta:</td>
        <td>
			<cfif MODO EQ "ALTA">
            	<cf_sifcalendario form="form1" name="PCRhasta" value="#LSDateFormat(DateAdd('YYYY',2099-Year(Now()),Now()),'DD/MM/YYYY')#">
            <cfelse>
            	<cf_sifcalendario form="form1" name="PCRhasta" value="#LSDateFormat(rsForm.PCRhasta,'DD/MM/YYYY')#">
          	</cfif>
        </td>
        <td align="right" class="fileLabel" nowrap>
			<input name="PCRvalida" type="checkbox" id="PCRvalida" value="PCRvalida" <cfif modo EQ 'ALTA' or (modo EQ "CAMBIO" and rsForm.PCRvalida EQ 1)> checked</cfif>>
		</td>
        <td>
			<label for="PCRvalida">Regla es V&aacute;lida</label>
        </td>
      </tr>
      <tr>
        <td align="right" class="fileLabel">Observaciones:</td>
      	<td colspan="3">
			<input type="text" name="PCRdescripcion" maxlength="255" style="width: 100%" value="<cfif modo EQ "CAMBIO">#rsForm.PCRdescripcion#</cfif>">
		</td>
        <td align="right" class="fileLabel" nowrap>
			<cfif not (modo EQ "CAMBIO" and rsForm.cantNivel2 GT 0)>
				Referencia:
			<cfelse>
				&nbsp;
			</cfif>
		</td>
        <td>
			<cfif not (modo EQ "CAMBIO" and rsForm.cantNivel2 GT 0)>
				<input type="hidden" name="PCRref" value="<cfif modo EQ "CAMBIO">#rsForm.PCRref#</cfif>">
				<input type="text" name="PCRref_text" size="30" value="<cfif modo EQ "CAMBIO">#rsForm.PCRref_text#</cfif>" readonly>
				<a href="javascript: doConlisReglasN1();"><img src="/cfmx/sif/imagenes/Description.gif" border="0" title="Lista de Reglas"></a>
				<a href="javascript: eliminarRef();"><img src="/cfmx/sif/imagenes/Borrar01_S.gif" border="0" title="Eliminar Referencia"></a>
			<cfelse>
				&nbsp;
			</cfif>
        </td>
      </tr>
    <tr>
      <td colspan="6" align="center">
		<cf_botones modo="#modo#" includebefore="Regresar">
      </td>
    </tr>
    <tr>
      <td align="center" colspan="6">&nbsp;</td>
    </tr>
    </table>
	
	<cfif isdefined("Form.RetTipos") and Form.RetTipos eq 1>
		<input type="hidden" name="RetTipos" value="1">
	</cfif>
  </form>
</cfoutput>

<script language="javascript" type="text/javascript">
	function validar() {
		var errores = "";
		if (document.form1.botonSel.value != 'Baja') {
			//document.form1.CtaFinal.value = "";
			fnArmaCuenta();
			<!--- if (document.form1.OficodigoM.value.length == 0) {
				errores = errores + '- El campo Oficina es requerido.\n';
			} --->
			if (document.form1.Cmayor.value.length == 0) {
				errores = errores + '- El campo Regla de Validación es requerido.\n';
			}
			if (document.form1.PCRdesde.value.length == 0) {
				errores = errores + '- El campo Fecha desde es requerido.\n';
			}
			if (document.form1.PCRhasta.value.length == 0) {
				errores = errores + '- El campo Fecha hasta es requerido.\n';
			}
			if (errores != "") {
				alert('Se presentaron los siguientes errores:\n' + errores);
				return false;
			}
			//FrameFunction();
		}
		return true;
	}

	function CargarCajas(Cmayor) {
		if (document.form1.Cmayor.value != '') {
			var a = '0000' + document.form1.Cmayor.value;
			a = a.substr(a.length-4, 4);
			document.form1.Cmayor.value = a;
		}
		var fr = document.getElementById("cuentasIframe");
		fr.src = "/cfmx/sif/Utiles/generacajas.cfm?Cmayor="+document.form1.Cmayor.value+"&MODO=ALTA"
	}

	//Dispara la funcion del iframe que retorna los datos de la cuenta
	function FrameFunction() {
		// RetornaCuenta2() es máscara completa, rellena con comodín
		if(window.parent.cuentasIframe.RetornaCuenta2){
			window.parent.cuentasIframe.RetornaCuenta2();
		}
	}	
	
	<cfoutput>
	function funcNuevo() {
		<cfset params = "">
		<cfif isdefined("Form.filtro_Cmayor")>
			<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_Cmayor=" & Form.filtro_Cmayor>
		</cfif>
		<cfif isdefined("Form.filtro_OficodigoM") and Len(Trim(Form.filtro_OficodigoM))>
			<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_OficodigoM=" & Form.filtro_OficodigoM>
		</cfif>		
		<cfif isdefined("Form.filtro_PCRregla") and Len(Trim(Form.filtro_PCRregla))>
			<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_PCRregla=" & Form.filtro_PCRregla>
		</cfif>
		<cfif isdefined("Form.filtro_PCRvalida") and Len(Trim(Form.filtro_PCRvalida))>
			<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_PCRvalida=" & Form.filtro_PCRvalida>
		</cfif>
		<cfif isdefined("Form.filtro_PCRdesde") and Len(Trim(Form.filtro_PCRdesde))>
			<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_PCRdesde=" & Form.filtro_PCRdesde>
		</cfif>
		<cfif isdefined("Form.filtro_PCRhasta") and Len(Trim(Form.filtro_PCRhasta))>
			<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_PCRhasta=" & Form.filtro_PCRhasta>
		</cfif>
		<cfif isdefined("Form.PageNum_lista") and Len(Trim(Form.PageNum_lista))>
			<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "PageNum_lista=" & Form.PageNum_lista>
		</cfif>
		<cfif isdefined("Form.RetTipos") and Len(Trim(Form.RetTipos))>
			<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "RetTipos=" & Form.RetTipos>
		</cfif>
		
		<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "btnElegirGrp=1&cboGrupos=" & LvarGrp>

		location.href = '#GetFileFromPath(GetTemplatePath())##params#';
		return false;
	}

	function doConlisReglasN1() {
		var width = 850;
		var height = 480;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		var params = '?f=form1&p1=PCRref&p2=PCRref_text';
		<cfif modo EQ "CAMBIO">
			params = params + '&PCRid=<cfoutput>#Form.PCRid#</cfoutput>';
		</cfif>
		/*if (document.form1.OficodigoM.value=='') {
			alert("Debe seleccionar la oficina.");
		} else*/ if (document.form1.Cmayor.value=='') {
			alert("Debe seleccionar la cuenta de mayor.");
		} else {
			//params = params + '&OficodigoM=' + document.form1.OficodigoM.value;
			params = params + '&Cmayor=' + document.form1.Cmayor.value;
			var nuevo = window.open('/cfmx/sif/Utiles/ConlisReglasN1.cfm'+params,'Reglas','menu=no,scrollbars=no,top='+top+',left='+left+',width='+width+',height='+height);
			if (nuevo) nuevo.focus();
		}
	}

	<cfif not (modo EQ "CAMBIO" and rsForm.cantNivel2 GT 0)>
	function eliminarRef() {
		document.form1.PCRref.value = '';
		document.form1.PCRref_text.value = '';
	}
	</cfif>
	</cfoutput>
	
	function fnConSubrayado(LprmHilera, LprmLong)
	{
		LprmHilera = fnTrim(LprmHilera);
		var s = "";
		for (var i=0;i<LprmLong;i++) s=s+"_";
		return (LprmHilera + s).substring(0, LprmLong);
	}
	function fnLTrim(LvarHilera)
	{
		return LvarHilera.replace(/^\s+/,'');
	}
	function fnRTrim(LvarHilera)
	{
		return LvarHilera.replace(/\s+$/,'');
	}
	function fnTrim(LvarHilera)
	{
	   return fnRTrim(fnLTrim(LvarHilera));
	}
	function funcRegresar()
	{
		<cfif (isdefined ("url.RetTipos") and url.RetTipos EQ 1) or 
		      (isdefined ("Form.RetTipos") and Form.RetTipos EQ 1)> 
			document.location = "TiposReglas.cfm";
		<cfelse>
			document.location = "AdminReglas.cfm";
		</cfif>
		return false;
	}
	function fnArmaCuenta()
	{
		//document.form1.CtaFinal
		var cta="";
		for (i=1;i<document.form1.CFformatoRegla.length;i++)
		{
			if (cta == '')
			{cta = document.form1.CFformatoRegla[i].value;}
			else
			{cta = cta + '-' + document.form1.CFformatoRegla[i].value;}
		}		
		cta = document.form1.Cmayor.value + '-' + cta;
		document.form1.CtaFinal.value = cta;
	}
</script>

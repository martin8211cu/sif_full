<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Niva" default="No afecta IVA" returnvariable="LB_Niva" xmlfile="Articulos.xml">

<cfif isdefined('url.filtro_Acodigo') and not isdefined('form.filtro_Acodigo')>
	<cfset form.filtro_Acodigo = url.filtro_Acodigo>
</cfif>
<cfif isdefined('url.filtro_Acodalterno') and not isdefined('form.filtro_Acodalterno')>
	<cfset form.filtro_Acodalterno = url.filtro_Acodalterno>
</cfif>
<cfif isdefined('url.filtro_Adescripcion') and not isdefined('form.filtro_Adescripcion')>
	<cfset form.filtro_Adescripcion = url.filtro_Adescripcion>
</cfif>
<cfif isdefined("url.Aid") and len(trim(url.Aid)) and not isdefined("form.Aid")>
	<cfset form.Aid = url.Aid >
</cfif>

<cfset modo = 'ALTA'>
<cfif isdefined("form.Aid") and len(trim(form.Aid))>
	<cfset modo = 'CAMBIO'>
</cfif>

<!-- Consultas -->
<!-- 1. Form -->
<cfquery datasource="#session.DSN#" name="rsForm">
		SELECT Aid,
	       Acodigo,
	       Acodalterno,
	       Ucodigo,
	       Ccodigo,
	       Adescripcion,
	       Acosto,
	       Aconsumo,
	       AFMid,
	       AFMMid,
	       CAid,
	       Atipocosteo,
	       Ucomprastd,
	       Icodigo,
	       Areqcert,
	       ts_rversion,
	       ClaveSAT,
	       (CASE
	            WHEN Aestado = 1 THEN 'Activo'
	            ELSE 'Inactivo'
	        END) AS Estado,
	       Aestado,
	       descalterna,
	       Observacion,
	       codIEPS,
	       afectaIVA
	FROM Articulos
	where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
	<cfif isdefined("form.Aid") and len(trim(form.Aid)) GT 0 >
		and Aid = <cfqueryparam value="#form.Aid#" cfsqltype="cf_sql_numeric">
	</cfif>
</cfquery>
<cfquery name="rsIEPS" datasource="#session.dsn#">
	select Icodigo, IDescripcion
    from Impuestos
    where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    and ieps=1
</cfquery>

<cfif modo neq 'ALTA' and isdefined('rsForm') and rsForm.recordCount GT 0>
	<cfquery name="rsClasificacion" datasource="#session.DSN#">
		select Ccodigo, Ccodigoclas, Cdescripcion, Cnivel as Nnivel
		from Clasificaciones
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsForm.Ccodigo#">
	</cfquery>
</cfif>

<!-- 2. Combo Unidades -->
<cfquery datasource="#session.DSN#" name="rsUnidades">
	select Ucodigo, Udescripcion
	from Unidades
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
		and Utipo in (0,2)
	order by Udescripcion
</cfquery>

<!-- 3. Combo Clasificaciones -->
<cfquery datasource="#session.DSN#" name="rsClasificaciones">
	select Ccodigo, Cdescripcion
	from Clasificaciones
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
	order by Cdescripcion
</cfquery>

<cfif isDefined("session.Ecodigo") and isDefined("Form.Aid") and Form.Aid NEQ "" and modo neq "ALTA">
	<cfquery name="rsImagenArt" datasource="#Session.DSN#" >
		select max(ILinea) as ILinea
		from ImagenArt
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Aid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#" >
	</cfquery>
</cfif>

<cfquery name="rsProfundidad" datasource="#session.DSN#">
	select coalesce(Pvalor,'1') as Pvalor
	from Parametros
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Pcodigo=530
</cfquery>

<cfquery name="rsCodigoArt" datasource="#session.DSN#">
	select coalesce(Pvalor,'0') as Pvalor
	from Parametros
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Pcodigo=5300
</cfquery>

<cfquery name="rsMarcas" datasource="#session.DSN#">
	select AFMid, AFMcodigo, AFMdescripcion
	from AFMarcas
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and AFMuso in ('I','A')
</cfquery>

<cfquery name="rsModelos" datasource="#session.DSN#">
	select AFMid, AFMMid, AFMMcodigo, AFMMdescripcion
	from AFMModelos
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by AFMid
</cfquery>

<cfquery name="rsImpuestos" datasource="#session.DSN#">
	select Icodigo, Idescripcion
	from Impuestos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by Icodigo
</cfquery>

<cfif rsForm.Atipocosteo eq 0>
	<cfset desctipocosteo = "Costo promedio">
<cfelseif rsForm.Atipocosteo eq 1>
	<cfset desctipocosteo = "UEPS">
<cfelseif rsForm.Atipocosteo eq 2>
	<cfset desctipocosteo = "PEPS">
</cfif>

<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="JavaScript1.2" type="text/javascript">

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_validateForm() { //v4.0
  var i,p,q,nm,test,num,min,max,errors='',args=MM_validateForm.arguments;
  for (i=0; i<(args.length-2); i+=3) {
  	test=args[i+2]; val=MM_findObj(args[i]);
    if (val) {
		if (val.alt!="")
			nm=val.alt;
		else nm=val.name;

		if ((val=val.value)!="") {
      		if (test.indexOf('isEmail')!=-1) {
				p=val.indexOf('@');
        		if (p<1 || p==(val.length-1))
					errors+='- '+nm+' no es una dirección de correo electrónica válida.\n';
      		}
			else if (test!='R') {
				num = parseFloat(val);
        		if (isNaN(val))
					errors+='- '+nm+' debe ser numérico.\n';
        		if (test.indexOf('inRange') != -1) {
					p=test.indexOf(':');
          			min=test.substring(8,p);
					max=test.substring(p+1);
          			if (num<min || max<num)
						errors+='- '+nm+' debe ser un número entre '+min+' y '+max+'.\n';
    			}
			}
		}
		else
			if (test.charAt(0) == 'R')
				errors += '- '+nm+' es requerido.\n';
	}
  }

  if (errors)
  	alert('Se presentaron los siguientes errores:\n\n'+errors);

  document.MM_returnValue = (errors == '');

}

function existencias(){
	document.articulos.action = 'Existencias.cfm';
	document.articulos.submit();
}

function conversion(){
	document.articulos.action = 'ConversionUnidadesArticulo.cfm';
	document.articulos.submit();
}

function funcCcodigoclas(){
	if( document.getElementById('profundidad').value != (parseInt(document.getElementById('Nnivel').value))+1 ){
		alert('El nivel de Clasificación seleccionada no corresponde al nivel máximo definido en Parámetros.\n Debe seleccionar otra Clasificación.');
		document.getElementById('Ccodigo').value = '';
		document.getElementById('Ccodigoclas').value = '';
		document.getElementById('Cdescripcion').value = '';
		document.getElementById('Nnivel').value = '';
	}
}

function imagenArt(){
	document.articulos.action = 'ImgArticulos.cfm';
	document.articulos.submit();
}

	function marca( valor, selected ) {
		if ( valor!= "" ) {
			//document.articulos.AFMMid.length = 0;
			//document.articulos.AFMMid.length = 1;
			//document.articulos.AFMMid.options[0].value = '';
			//document.articulos.AFMMid.options[0].text  = 'Ninguna';
			document.getElementById('AFMMid').length = 0;
			document.getElementById('AFMMid').length = 1;
			document.getElementById('AFMMid').options[0].value = '';
			document.getElementById('AFMMid').options[0].text  = 'Ninguna';

			i = 1;
			<cfoutput query="rsModelos">
				if ( #Trim(rsModelos.AFMid)# == valor ){
					document.getElementById('AFMMid').length = i+1;
					document.getElementById('AFMMid').options[i].value = '#rsModelos.AFMMid#';
					document.getElementById('AFMMid').options[i].text  = '#rsModelos.AFMMcodigo# - #JSStringFormat(rsModelos.AFMMdescripcion)#';
					if ( selected == #Trim(rsModelos.AFMMid)# ){
						document.getElementById('AFMMid').options[i].selected=true;
					}
					//document.articulos.AFMMid.length = i+1;
					//document.articulos.AFMMid.options[i].value = '#rsModelos.AFMMid#';
					//document.articulos.AFMMid.options[i].text  = '#rsModelos.AFMMcodigo# - #JSStringFormat(rsModelos.AFMMdescripcion)#';
					//if ( selected == #Trim(rsModelos.AFMMid)# ){
					//	document.articulos.AFMMid.options[i].selected=true;
					//}
					i++;
				}
			</cfoutput>
			return;
		}
		else{
			document.getElementById('AFMMid').length = 0;
			document.getElementById('AFMMid').length = 1;
			document.getElementById('AFMMid').options[0].value = '';
			document.getElementById('AFMMid').options[0].text  = 'Ninguna';
		}
	}

//funcion para habilitar el F2
	function conlis_keyup_CAcodigo(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlisCodAduanal();
		}
	}
</script>

<form action="SQLArticulos.cfm" method="post" name="articulos" onSubmit="if ( this.botonSel.value != 'Nuevo'
               && this.botonSel.value != 'Baja'
			   && this.botonSel.value != 'Regresar')
			   {
			     MM_validateForm('Acodigo','','R','Ucodigo','','R','Ccodigo','','R','Adescripcion','','R');

				   return document.MM_returnValue;

				}else
				{
				   return true;
			    }">
	<cfoutput>
		<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">
		<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">
		<input type="hidden" name="filtro_Acodigo" value="<cfif isdefined('form.filtro_Acodigo') and form.filtro_Acodigo NEQ ''>#form.filtro_Acodigo#</cfif>">
		<input type="hidden" name="filtro_Acodalterno" value="<cfif isdefined('form.filtro_Acodalterno') and form.filtro_Acodalterno NEQ ''>#form.filtro_Acodalterno#</cfif>">
		<input type="hidden" name="filtro_Adescripcion" value="<cfif isdefined('form.filtro_Adescripcion') and form.filtro_Adescripcion NEQ ''>#form.filtro_Adescripcion#</cfif>">
	</cfoutput>

	<table width="99%" border="0" cellpadding="2" cellspacing="0" align="center">
	<cfif modo neq 'ALTA'>
			<tr>
				<td colspan="3">
					<cfinclude template="articulos-link.cfm">
				</td>
			</tr>
		</cfif>
        <cfset Pvalor = 1>
		<cfif trim(rsCodigoArt.Pvalor) EQ '' OR trim(rsCodigoArt.Pvalor) EQ '0'>
        	<cfset Pvalor = 0>
        </cfif>
		<tr>
			<td valign="baseline" align="right" width="20%">C&oacute;digo:&nbsp;</td>
			<td width="34%">
				<input tabindex="1" type="text" id="Acodigo"  name="Acodigo" size="20" maxlength="15" value="<cfif modo NEQ 'ALTA'><cfoutput>#HTMLEditFormat(trim(rsForm.Acodigo))#</cfoutput></cfif>" <cfif modo NEQ 'ALTA' OR Pvalor NEQ 0>readonly</cfif> alt="El c&oacute;digo de Art&iacute;culo" onfocus="javascript:this.select();" >
				<input type="hidden" name="Aid" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Aid#</cfoutput></cfif>" >
                <input type="hidden" name="consec" value="<cfif Pvalor NEQ 0>1<cfelse>0</cfif>" >
			</td>
		    <td width="46%" valign="top" rowspan="9">
              <cfif modo neq "ALTA">
				<cf_sifcomplementofinanciero action='display'
					tabla="Articulos"
					form = "articulos"
					tabindex = "1"
					llave="#form.Aid#" />

				<p align="center">
                  <cfif rsImagenArt.RecordCount gt 0 and rsImagenArt.ILinea neq "">
                    <cf_sifleerimagen tabla="ImagenArt" campo="IAimagen" condicion="Ecodigo=#session.Ecodigo# and Aid=#form.Aid# and ILinea=#rsImagenArt.ILinea#" conexion="#session.DSN#" autosize="true" border="false" imgname="#form.Aid#_#rsImagenArt.ILinea#">
                  </cfif>
                </p>
              </cfif>
			</td>
		</tr>

		<tr>
			<td valign="baseline" align="right" nowrap>N&uacute;mero de Parte:&nbsp;</td>
			<td>
				<input tabindex="1" name="Acodalterno" size="20" maxlength="20" value="<cfif modo NEQ 'ALTA'><cfoutput>#HTMLEditFormat(trim(rsForm.Acodalterno))#</cfoutput></cfif>" onfocus="javascript:this.select();" >
			</td>
	    </tr>

		<tr>
			<td valign="baseline" align="right">Descripci&oacute;n:&nbsp;</td>
			<td>
				<input tabindex="1" type="text" name="Adescripcion" size="50" maxlength="80" value="<cfif modo NEQ 'ALTA'><cfoutput>#HTMLEditFormat(rsForm.Adescripcion)#</cfoutput></cfif>" onfocus="this.select();" alt="La Descripci&oacute;n del Art&iacute;culo" >
			</td>
	    </tr>
        <!---►►Descripcion Anterna◄◄--->
        <cfparam name="rsForm.descalterna" default="">
        <tr>
			<td valign="middle" align="right">Descripción Alterna:&nbsp;</td>
			<td>
            	<textarea name="descalterna"  cols="60" rows="4" id="descalterna"><cfoutput>#HTMLEditFormat(rsForm.descalterna)#</cfoutput></textarea>
			</td>
	    </tr>
         <!---►►Observaciones◄◄--->
        <cfparam name="rsForm.observacion" default="">
        <tr>
			<td valign="middle" align="right">Observaciones:&nbsp;</td>
			<td>
            	<textarea name="observacion" cols="60" rows="4" id="observacion"><cfoutput>#HTMLEditFormat(rsForm.observacion)#</cfoutput></textarea>
			</td>
	    </tr>


		<tr>
			<td valign="baseline" align="right">Clasificaci&oacute;n:&nbsp;</td>
			<td>
				<!---
				<select name="Ccodigo">
					<cfoutput query="rsClasificaciones">
						<cfif modo EQ 'ALTA'>
							<option value="#rsClasificaciones.Ccodigo#">#rsClasificaciones.Cdescripcion#</option>
						<cfelseif modo NEQ 'ALTA'>
							<option value="#rsClasificaciones.Ccodigo#" <cfif #rsForm.Ccodigo# EQ #rsClasificaciones.Ccodigo#>selected</cfif>  >#rsClasificaciones.Cdescripcion#</option>
						</cfif>
					</cfoutput>
				</select>
				--->
                <cfif Pvalor NEQ 0>
                	<cfset LvarC = "yes">
                <cfelse>
                	<cfset LvarC = "no">
                </cfif>
				<cfif modo neq 'ALTA'>
					<cf_sifclasificacionarticulo tabindex="1" query="#rsClasificacion#" form="articulos">
				<cfelse>
					<cf_sifclasificacionarticulo tabindex="1" form="articulos" Cconsecutivo="#LvarC#">
				</cfif>
			</td>
	    </tr>
		<tr>
			<td valign="baseline" align="right">Tipo de Costeo:&nbsp;</td>
			<td>
				<cfoutput>
				  <select name="LAtipocosteo" id="LAtipocosteo" tabindex="1">
                    <cfif modo EQ 'ALTA'>
                      <option value="0">Costo Promedio</option>
                      <option value="1">UEPS</option>
                      <option value="2">PEPS</option>
                      <cfelseif modo NEQ 'ALTA'>
                      <cfif rsform.Atipocosteo eq 0>
                        <option value="#rsform.Atipocosteo#" selected>#desctipocosteo#</option>
                        <option value="1">UEPS</option>
                        <option value="2">PEPS</option>
                        <cfelseif rsform.Atipocosteo eq 1>
                        <option value="0">Costo Promedio</option>
                        <option value="#rsform.Atipocosteo#" selected>#desctipocosteo#</option>
                        <option value="2">PEPS</option>
                        <cfelseif rsform.Atipocosteo eq 2>
                        <option value="0">Costo Promedio</option>
                        <option value="1">UEPS</option>
                        <option value="#rsform.Atipocosteo#" selected>#desctipocosteo#</option>
                      </cfif>
                    </cfif>
                  </select>
</cfoutput>
			</td>
		</tr>

		<tr>
			<td valign="baseline" align="right">C&oacute;digo Aduanal:&nbsp;</td>
			<td nowrap>
				<cfif modo neq 'ALTA' and len(trim(rsForm.CAid)) gt 0>
					<cfquery name="rsCodAduanal" datasource="#session.dsn#">
						select CAcodigo,CAdescripcion
						from CodigoAduanal
						where CAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CAid#">
					</cfquery>
				</cfif>
				<cfoutput>
					<input type="hidden" id="CAid"  name="CAid" value="<cfif modo neq 'ALTA' and len(trim(rsForm.CAid)) gt 0>#rsForm.CAid#</cfif>">
					<input name="CAcodigo" type="text"
						value="<cfif isdefined("rsCodAduanal") and len(trim(rsCodAduanal.CAcodigo))>#rsCodAduanal.CAcodigo#</cfif>"
						id="CAcodigo"
						size="15"
						maxlength="20"
						tabindex="1"
						onkeyup="javascript:conlis_keyup_CAcodigo(event);"
						onBlur="javascript:traerCodAduanal(this.value,1);">
					<input name="CAdescripcion" type="text" id="CAdescripcion" value="<cfif isDefined("rsCodAduanal") and len(trim(rsCodAduanal.CAdescripcion))>#rsCodAduanal.CAdescripcion#</cfif>" size="30" readonly disabled>
					<a href="##" tabindex="-1"> <img src="../../imagenes/Description.gif" alt="Lista de códigos aduanales" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisCodAduanal();"> </a>
				</cfoutput>
			</td>
		</tr>

		<tr>
			<td valign="baseline" align="right">Unidad:&nbsp;</td>
			<td>
				<!--- COLOCAR EL CODIGO ADUANAL DE LA CLASIFICACION (A LA QUE PERTENECE) COMO EL SUERIDO(SELECTED) EN EL COMBO---->
				<select id="Ucodigo" name="Ucodigo" tabindex="1">
					<cfoutput query="rsUnidades">
						<cfif modo EQ 'ALTA'>
							<option value="#rsUnidades.Ucodigo#">#rsUnidades.Udescripcion#</option>
						<cfelseif modo NEQ 'ALTA'>
							<option value="#rsUnidades.Ucodigo#" <cfif rsForm.Ucodigo EQ rsUnidades.Ucodigo>selected</cfif>  >#rsUnidades.Udescripcion#</option>
						</cfif>
					</cfoutput>
				</select>
			</td>
	    </tr>

<!---		<tr>
		<td></td>
		<td><cf_sifmarcamod></td>
		</tr>
--->

		<tr>
			<td valign="baseline" align="right">Marca:&nbsp;</td>
			<td>
				<select id="AFMid" name="AFMid" onChange="javascript:marca(this.value, '');" tabindex="1">
					<option value="">Ninguna</option>
					<cfoutput query="rsMarcas" >
						<option value="#rsMarcas.AFMid#"  <cfif modo neq 'ALTA' and rsMarcas.AFMid eq rsForm.AFMid >selected</cfif> >#rsMarcas.AFMcodigo# - #rsMarcas.AFMdescripcion#</option>
					</cfoutput>
				</select>
			</td>
	    </tr>

		<tr>
			<td valign="baseline" align="right">Modelo:&nbsp;</td>
			<td><select id="AFMMid" name="AFMMid" tabindex="1"></select></td>
	    </tr>

		<tr>
			<td valign="baseline" align="right">Impuesto:&nbsp;</td>
			<td>
				<select name="Icodigo" onChange="javascript:marca(this.value, '');" tabindex="1">
					<option value="">No especificado</option>
					<cfoutput query="rsImpuestos" >
						<option value="#trim(rsImpuestos.Icodigo)#"  <cfif modo neq 'ALTA' and trim(rsImpuestos.Icodigo) eq trim(rsForm.Icodigo) >selected</cfif> >#trim(rsImpuestos.Icodigo)# - #rsImpuestos.Idescripcion#</option>
					</cfoutput>
				</select>
			</td>
	    </tr>
		 <tr><cfoutput>
			<td align="right" nowrap>IEPS:&nbsp;</td>
			<td>
				<select name="codIEPS" tabindex="5">
					<option value=""></option>
				<cfloop query="rsIEPS">
					<option value="#rsIEPS.Icodigo#" <cfif modo neq 'ALTA' and trim(rsForm.codIEPS) eq trim(rsIEPS.Icodigo)  >selected</cfif> >#rsIEPS.Idescripcion#</option>
				</cfloop>
				</select>

            <input type="checkbox" tabindex="10" name="afectaIVA" id="afectaIVA"
                    <cfif (modo neq 'ALTA' and rsForm.afectaIVA eq 1)>checked</cfif>>
            <label for="afectaIVA" style="font-style:normal; font-variant:normal; font-weight:normal">#LB_Niva#&nbsp;</label>
           </td></cfoutput>
		</tr>
		<tr>
			<td valign="baseline" align="right">Estado:&nbsp;</td>
			<td>
			  <select name="estado" tabindex="1">
				<option value="">Ninguno</option>
				<option value="1"  <cfif modo neq 'ALTA' and rsForm.Aestado  eq 1>selected</cfif> ><cfoutput>Activo</cfoutput></option>
				<option value="0"  <cfif modo neq 'ALTA' and rsForm.Aestado eq 0 >selected</cfif> ><cfoutput>Inactivo</cfoutput></option>
			  </select>
			</td>
		 </tr>
		 <!--- <tr>
			<tr>
			   <td valign="baseline" align="right">Tipo Producci&oacute;n:&nbsp;</td>
			   <td>
				 <select name="Anaturaleza" tabindex="1">
				   <option value="0"  <cfif modo neq 'ALTA' and rsForm.Anaturaleza  eq 0>selected</cfif> ><cfoutput>Externa</cfoutput></option>
				   <option value="1"  <cfif modo neq 'ALTA' and rsForm.Anaturaleza eq 1>selected</cfif> ><cfoutput>Interna</cfoutput></option>
				 </select>
			   </td>
			</tr>
			<td valign="baseline" align="right">Fecha Vigencia:&nbsp;</td>
			<td>
				<cfif modo neq 'ALTA' and rsForm.aVigencia NEQ "">
					<cf_sifcalendario form="form1" value="#rsForm.aVigencia#" name="aVigencia" tabindex="1">
				<cfelse>
					<cf_sifcalendario form="form1" value="#now()#" name="aVigencia" tabindex="1">
				</cfif>
			</td>
		 </tr> --->
		<tr>
		  <td align="right" valign="baseline" nowrap>Costo Est&aacute;ndar Producci&oacute;n:&nbsp;</td>
		  <td><input tabindex="1" type="text" name="Acosto" size="18" maxlength="18" onFocus="javascript:document.articulos.Acosto.select();" onChange="javascript: fm(this,2);" style="text-align:right;"
			  	onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
			  	value="<cfif modo NEQ 'ALTA'><cfoutput>#LSCurrencyFormat(rsForm.Acosto,'none')#</cfoutput><cfelse>0.00</cfif>" ></td>
      </tr>

	    <tr nowrap >
	      <td align="right">Unidades de Pedido Estandar </td>
	      <td valign="middle"><input type="text" name="Ucomprastd" size="18" maxlength="18"
		  						onFocus="javascript: this.select();"
								onChange="javascript: fm(this,2);"
								style="text-align:right;"
								tabindex="1"
								onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
								value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Ucomprastd#</cfoutput><cfelse>0.00</cfif>"></td>
      </tr>
	  <tr nowrap >
	      <td align="right">Clave SAT </td>
	      <td valign="middle">
		    <cfset valuesArray = ArrayNew(1)>
			<cfif modo eq "CAMBIO" and rsForm.RecordCount GT 0 and trim(rsForm.ClaveSAT) neq '' >
				<cfquery name="rsConcepto" datasource="#session.DSN#">
					select top 1 CSATCodigo, CSATDescripcion
					from CSAT_ProdServ
					where CSATCodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsForm.ClaveSAT#">
				</cfquery>
				<cfset ArrayAppend(valuesArray, rsConcepto.CSATCodigo)>
				<cfset ArrayAppend(valuesArray, rsConcepto.CSATDescripcion)>
			</cfif>
		  	<cf_conlis
					campos="CSATCodigo,CSATDescripcion"
					asignar="CSATCodigo,CSATDescripcion"
					size="8,30"
					desplegables="S,S"
					modificables="S,N"
					title="Articulos SAT"
					tabla="CSAT_ProdServ a"
					columnas="CSATCodigo,CSATDescripcion"
					filtrar_por="CSATCodigo,CSATDescripcion"
					desplegar="CSATCodigo,CSATDescripcion"
					etiquetas="Clave,Descripcion"
					formatos="S,S"
					align="left,left"
					asignarFormatos="S,S"
					form="articulos"
					showEmptyListMsg="true"
					EmptyListMsg=" --- No hay registros --- "
					valuesArray="#valuesArray#"
					alt="Clave,Descripcion"
				/>
		  </td>
      </tr>
      <tr>
	  	<td></td>
		<td valign="middle"><input tabindex="1" name="Aconsumo" <cfif modo neq 'ALTA' and isdefined("rsForm.Aconsumo") and rsForm.Aconsumo eq 1>checked</cfif> type="checkbox" value="C">Consumo propio</td>
      </tr>

		<!--- Articulo requiere certificacion --->
		<tr>
			<td></td>
			<td valign="middle">
				<input name="Areqcert" tabindex="1" type="checkbox" <cfif modo neq 'ALTA' and isdefined("rsForm.Areqcert") and rsForm.Areqcert eq 1>checked</cfif>>&nbsp;Certificación
			</td>
		</tr>

		<tr><td colspan="3">&nbsp;</td></tr>

		<tr align="center">
			<td valign="baseline" colspan="3" >
				<cf_Botones modo="#modo#" include="Regresar" includevalues="Regresar" tabindex="1">
			</td>
		</tr>

		<cfset ts = "">
		<cfif modo neq "ALTA">
			<cfinvoke
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
		</cfif>
		<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>">
	</table>
    <input type="hidden" name="profundidad" value="<cfoutput>#trim(rsProfundidad.Pvalor)#</cfoutput>">

</form>

<!--- Iframe para los códigos aduanales --->
<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>

<script language="javascript" type="text/javascript">

	var id_marca = '';
	<cfif modo neq 'ALTA'>
		id_marca = '<cfoutput>#rsForm.AFMMid#</cfoutput>'
	</cfif>

	//marca( document.articulos.AFMid.value, id_marca );
	marca(document.getElementById('AFMid').value, id_marca );


	document.getElementById('Ucodigo').alt = "La Unidad";
	document.getElementById('Ccodigo').alt = "La Clasificación";
	//document.articulos.Ucodigo.alt = "La Unidad";
	//document.articulos.Ccodigo.alt = "La Clasificación";

	function funcCcodigoclas(){
		if ( document.getElementById('CAid_Ccodigoclas').value != '' ){
			document.getElementById('CAid').value = document.getElementById('CAid_Ccodigoclas').value;
		}
		else{
			document.getElementById('CAid').value = '';
		}
	}

	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function traerCodAduanal(value){
		if (value!=''){
			document.getElementById("fr").src = '../../cm/operacion/traerCodAduanal.cfm?formulario=articulos&CAcodigo='+value;
		}
		else{
			document.getElementById('CAid').value = '';
			document.getElementById('CAcodigo').value = '';
			document.getElementById('CAdescripcion').value = '';
		}
	}

	function doConlisCodAduanal() {
		popUpWindow("../../cm/operacion/conlisCodigosAduanales.cfm?formulario=articulos",250,150,550,400);
	}

</script>

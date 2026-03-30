  <body onLoad="hayMetricas();"   >
 
<cfparam name="form.Lote" default="">


<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="BTN_formular" default="Formular" returnvariable="BTN_formular" component="sif.Componentes.Translate" method="Translate"/>	
<cfif not isdefined("Form.modo") and isdefined("url.modo")>
	<cfset form.modo=url.modo>
</cfif>

<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>
<cfif not isdefined("Form.modo") and not isdefined ('URL.Nuevo') and not isdefined ('form.Nuevo')>
	<cfset form.modo=url.modo>
</cfif>

<!---filtros de la lista inicial--->
<cfparam name="pagenum" default="1">
<cfif isdefined('form.pagenum') and len(trim(form.pagenum))>
	<cfset pagenum = form.pagenum>
</cfif> 
<cfif isdefined('form.pagenumL') and len(trim(form.pagenumL))>
	<cfset pagenum = form.pagenumL>
</cfif> 
<cfif isdefined('url.pagenum') and len(trim(url.pagenum))>
	<cfset pagenum = url.pagenum>
</cfif> 

<cfparam name="fMIGMid" default="">
<cfif isdefined('form.fMIGMid') and len(trim(form.fMIGMid))>
	<cfset fMIGMid = form.fMIGMid>
</cfif> 
<cfif isdefined('form.fMIGMidL') and len(trim(form.fMIGMidL))>
	<cfset fMIGMid = form.fMIGMidL>
</cfif>
<cfif isdefined('url.fMIGMid') and len(trim(url.fMIGMid))>
	<cfset fMIGMid = url.fMIGMid>
</cfif>


<cfparam name="fLote" default="">
<cfif isdefined('form.fLote') and len(trim(form.fLote))>
	<cfset fLote = form.fLote>
</cfif> 
<cfif isdefined('form.fLoteL') and len(trim(form.fLoteL))>
	<cfset fLote = form.fLoteL>
</cfif>
<cfif isdefined('url.fLote') and len(trim(url.fLote))>
	<cfset fLote = url.fLote>
</cfif>
<!---fin Filtros --->


<cfset LvarInclude=""> 
<cfset LvarInclude="">
<cfset LvarID="">
<cfset LvarIDCuenta="">
<cfset LvarIDMoneda="">
<cfset LvarIniciales=false>
<cfset LvarReadOnly=false>

<cfif not isdefined ('form.id_datos') and isdefined ('url.id_datos') and trim(url.id_datos) >
	<cfset form.id_datos=url.id_datos>
</cfif>



<script language="javascript" src="../../js/utilesMonto.js"></script>

<cfquery datasource="#session.DSN#" name="rsLote"><!---poner condicion para que traiga solo un valor--->
	select distinct Lote from F_Datos where Ecodigo = #session.Ecodigo#  --order by  Pfecha DESC
</cfquery>


<cfquery datasource="#Session.DSN#" name="rsMetricas"><!---FILTRAR POR Lote--->
	select 	
			MIGMid,
			MIGMcodigo,
			MIGMnombre,
			MIGRecodigo,
			MIGMdescripcion,
			MIGMnpresentacion,
			MIGMsequencia,
			Ucodigo,
			case Dactiva
				when  0 then 'Inactivo'
				when  1 then 'Activo'
			else 'Dactiva desconocido'
			end as Dactiva,
			MIGMperiodicidad,
			MIGMcalculo
	from MIGMetricas
	where Dactiva = 1
	and Ecodigo = #session.Ecodigo#
	and MIGMesmetrica='M'
	order by MIGMcodigo
</cfquery>

<cfquery datasource="#Session.DSN#" name="rsCantidadMetricas"><!---Cantidad de Metricas--->
	select count(MIGMid) as cantidad
	from MIGMetricas
	where Dactiva = 1
	and Ecodigo = #session.Ecodigo#
</cfquery>

<cfif modo EQ "CAMBIO" >
	<cfquery datasource="#Session.DSN#" name="rsFDatos">
		select *
		from F_Datos
		where id_datos= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id_datos#">
	</cfquery> 
	<cfset LvarIniciales=true>
	<cfset LvarID=rsFDatos.MIGProid>
	<cfset LvarIDCuenta=rsFDatos.MIGCueid>
	<cfset form.MIGMid=rsFDatos.MIGMid>
	<cfset LvarReadOnly=true>
	<cfset LvarIDMoneda=rsFDatos.id_moneda>
</cfif>
<cfparam name="form.MIGMid" default="#rsMetricas.MIGMid#">

<cfoutput>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
<tr valign="baseline">
	<td width="200">&nbsp;</td>
	<td>
	<form method="post" name="formFDatosM" id="formFDatosM" action="FDatos.cfm" onSubmit="return validar(this);">
	<input type="hidden" name="modo" id="modo" value="<cfoutput>#modo#</cfoutput>">
	<input type="hidden" name="pagenum" id="pagenum" value="<cfoutput>#pagenum#</cfoutput>">
	<input type="hidden" name="fLote" id="fLote" value="<cfoutput>#fLote#</cfoutput>">
	<input type="hidden" name="fMIGMid" id="fMIGMid" value="<cfoutput>#fMIGMid#</cfoutput>">
	<input type="hidden" name="MIGMdetalleid" id="MIGMdetalleid" value="">
	<cfif isdefined ('form.modo') and modo eq 'CAMBIO'>
		<input type="hidden" name="id_datos" id="id_datos" value="#rsFDatos.id_datos#">
		<cfif rsFDatos.MIGProid GT 0>
			<input type="hidden" name="MIGProid" id="MIGProid" value="#rsFDatos.MIGProid#">
		</cfif>
		<cfif rsFDatos.MIGCueid GT 0>
			<input type="hidden" name="MIGCueid" id="MIGCueid" value="#rsFDatos.MIGCueid#">
		</cfif>
		<cfif rsFDatos.id_moneda GT 0>
			<input type="hidden" name="Mcodigo" id="Mcodigo" value="#rsFDatos.id_moneda#">
		</cfif>
		<cfif rsFDatos.id_atr_dim4 NEQ "">
			<input type="hidden" name="id_atr_dim4" id="id_atr_dim4" value="#rsFDatos.id_atr_dim4#">
		</cfif>
		<cfif rsFDatos.id_atr_dim5 NEQ "">
			<input type="hidden" name="id_atr_dim5" id="id_atr_dim5" value="#rsFDatos.id_atr_dim5#">
		</cfif>
	</cfif>	
	<table border="0">
		<tr>
			<td nowrap align="right">M&eacute;trica:</td>
			<td align="left">
				<select name="MIGMid" id="MIGMid" onChange="javascript: document.formFDatosM.submit(); " <cfif modo EQ 'CAMBIO'>disabled="disabled" </cfif>><!---generar un conlis de metricas--->
				<cfloop query="rsMetricas">
					<option value="#rsMetricas.MIGMid#" <cfif isdefined("form.MIGMid") and form.MIGMid EQ rsMetricas.MIGMid>selected="selected"</cfif>>#rsMetricas.MIGMcodigo#-#rsMetricas.MIGMnombre#</option>
				</cfloop>	
				</select>
			</td></tr>
		</table>
	</form>		
</td></tr>

<tr><td width="200">&nbsp;</td>
	<td><cfinclude template="FDatosFiltros.cfm"></td>

</tr>
	
<tr>
	<td width="200">&nbsp;</td>
	<td>
	<cfform method="post" name="formDatos" action="FDatosSQL.cfm" onSubmit="return validar(this);">
	<input type="hidden" name="modo" id="modo" value="<cfoutput>#modo#</cfoutput>">
	<input type="hidden" name="pagenum" id="pagenum" value="<cfoutput>#pagenum#</cfoutput>">
	<input type="hidden" name="fLote" id="fLote" value="<cfoutput>#fLote#</cfoutput>">
	<input type="hidden" name="Lote" id="Lote" value="<cfoutput>#form.Lote#</cfoutput>">
	<input type="hidden" name="fMIGMid" id="fMIGMid" value="<cfoutput>#fMIGMid#</cfoutput>">
	<input type="hidden" name="MIGMid" id="MIGMid" value="<cfoutput>#form.MIGMid#</cfoutput>">
	<input type="hidden" name="MIGMdetalleid" id="MIGMdetalleid" value="">
	<input type="hidden" name="Mes" id="Mes" value="1">
	<input type="hidden" name="Dcodigo" id="Dcodigo" value="<cfif modo EQ "CAMBIO">#rsFDatos.Dcodigo#</cfif>" >
	
	<cfif isdefined ('form.modo') and modo eq 'CAMBIO'>
		<input type="hidden" name="id_datos" id="id_datos" value="#rsFDatos.id_datos#">
		<cfif rsFDatos.MIGProid GT 0>
			<input type="hidden" name="MIGProid" id="MIGProid" value="#rsFDatos.MIGProid#">
		</cfif>
		<cfif rsFDatos.MIGCueid GT 0>
			<input type="hidden" name="MIGCueid" id="MIGCueid" value="#rsFDatos.MIGCueid#">
		</cfif>
		<cfif rsFDatos.id_moneda GT 0>
			<input type="hidden" name="Mcodigo" id="Mcodigo" value="#rsFDatos.id_moneda_origen#">
		</cfif>
		<cfif rsFDatos.id_atr_dim4 NEQ "">
			<input type="hidden" name="id_atr_dim4" id="id_atr_dim4" value="#rsFDatos.id_atr_dim4#">
		</cfif>
		<cfif rsFDatos.id_atr_dim5 NEQ "">
			<input type="hidden" name="id_atr_dim5" id="id_atr_dim5" value="#rsFDatos.id_atr_dim5#">
		</cfif>
	</cfif>
	<table border="0" cellpadding="2">
		<tr>
			<cfquery name="rsMonedaEmpresa" datasource="#session.dsn#">
				select Mcodigo,Mnombre,Msimbolo,Miso4217
				from MIGMonedas 
				where Ecodigo=#session.Ecodigo#
			</cfquery>
			<td align="right">Monedas:</td>
			<td align="left">
				<select name="Mcodigo" id="Mcodigo" <cfif modo EQ 'CAMBIO'>disabled="disabled" </cfif>><!---generar un conlis de metricas--->
				<option value="">--</option>
				
				<cfloop query="rsMonedaEmpresa">
					<option value="#rsMonedaEmpresa.Mcodigo#" <cfif modo EQ 'CAMBIO' and rsFDatos.id_moneda_origen EQ rsMonedaEmpresa.Mcodigo>selected="selected"</cfif>>#rsMonedaEmpresa.Mnombre#-#rsMonedaEmpresa.Miso4217#</option>
				</cfloop>	
				</select>
				
			</td>
		</tr>
		<tr valign="baseline"> 
			<td nowrap align="right">Valor:</td>
			<td align="left">
				<cfif modo NEQ 'ALTA'>
					<cf_inputNumber name="valor_moneda_origen"  value="#rsFDatos.valor_moneda_origen#" enteros="15" decimales="4" negativos="false" comas="no">
				<cfelse>
					<cf_inputNumber name="valor_moneda_origen"  value="" enteros="15" decimales="4" negativos="false" comas="no">
				</cfif>
			</td>
		</tr>
		<tr valign="baseline"> 
			<td nowrap align="right">Fecha:</td>
			<cfif isdefined('rsFDatos.pfecha')>
			<td align="left"><cf_sifcalendario conexion="#session.DSN#" form="formDatos" name="Pfecha"  value="#LSDateFormat(rsFDatos.pfecha,'dd/mm/yyyy')#"  tabindex="1"></td>
			<cfelse>
			<td align="left"><cf_sifcalendario conexion="#session.DSN#" form="formDatos" name="Pfecha"  value="#LSDateFormat(now(),'dd/mm/yyyy')#"   tabindex="1"></td>						
			</cfif>
		</tr>
		<tr valign="baseline"> 
			<td nowrap align="right">Cuarto Atributo:</td>
			<td align="left"><input type="text" name="id_atr_dim4" <cfif modo EQ 'CAMBIO'>disabled="disabled" </cfif> id="id_atr_dim4" maxlength="40" size="40" value="<cfif isdefined('rsFDatos.id_atr_dim4')>#htmlEditFormat(rsFDatos.id_atr_dim4)#</cfif>"></td>
		</tr>
		<tr valign="baseline"> 
			<td nowrap align="right">Quinto Atributo:</td>
			<td align="left"><input type="text" name="id_atr_dim5" id="id_atr_dim5" <cfif modo EQ 'CAMBIO'>disabled="disabled" </cfif> maxlength="40" size="40" value="<cfif isdefined('rsFDatos.id_atr_dim5')>#htmlEditFormat(rsFDatos.id_atr_dim5)#</cfif>"></td>
		</tr>						
		<tr><td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>
		<tr> 
		   <cfif rsCantidadMetricas.cantidad gt 0>
			<td colspan="2" align="center" nowrap>	<cf_botones modo="#modo#" include="#LvarInclude#"> 
			<center><input type="button" name="irLista" value="Volver a la lista" onClick="javascript: document.location.href= '/cfmx/mig/catalogos/FDatos.cfm?PageNum_lista=#pagenum#&fMIGMid=#fMIGMid#&fLote=#fLote#'"/></center>		</td>
		   </cfif>		
		</tr>
	</table>
		
	</cfform>
</td></tr>	
	
</table>
	
</cfoutput>
</body>

<!---ValidacionesFormulario--->

<script type="text/javascript">

function hayMetricas(){
<cfif rsCantidadMetricas.cantidad eq 0>
	alert('No se pueden ingresar datos ya que no existen metricas ');
</cfif>

}

function validar(formulario)	{ 

	<cfif modo EQ "CAMBIO" >
	
		if (document.formDatos.MIGMdetalleid.value == ''){
			<cfif isdefined("rsFDatos.MIGCueid") and len(trim(rsFDatos.MIGCueid))>
				document.formDatos.MIGMdetalleid.value = "<cfoutput>#rsFDatos.MIGCueid#</cfoutput>";
			</cfif>
			<cfif isdefined("rsFDatos.MIGProid") and len(trim(rsFDatos.MIGProid))>
				document.formDatos.MIGMdetalleid.value = "<cfoutput>#rsFDatos.MIGProid#</cfoutput>";
			</cfif>
			<cfif isdefined("rsFDatos.Dcodigo") and len(trim(rsFDatos.Dcodigo))>				
				document.formDatos.MIGMdetalleid.value = "<cfoutput>#rsFDatos.Dcodigo#</cfoutput>";
			</cfif>
		}
				
		if (!btnSelected('Baja',document.formDatos) && !btnSelected('Lista',document.formDatos) && !btnSelected('Nuevo',document.formDatos) ){
			if (document.formDatos.valor_moneda_origen.value == ''){
					alert('El Valor no puede quedar en blanco');return(false);
				}
			if (document.formDatos.Pfecha.value == ''){
					alert('La fecha no puede quedar en blanco');return(false);
				}
		}	
	<cfelse>	
		if (!btnSelected('Limpiar',document.formDatos) && !btnSelected('Lista',document.formDatos) ){
				if (document.formDatos.MIGMdetalleid.value == '')   {
					<cfif rsTipo.MIGMtipodetalle EQ 'C'>alert('La Cuenta no puede quedar en Blanco. Favor Elegir una Cuenta'); return(false); </cfif>
					<cfif rsTipo.MIGMtipodetalle EQ 'P'>alert('El Producto no puede quedar en Blanco. Favor Elegir un Producto'); return(false);</cfif>
				}
				if (document.formDatos.Dcodigo.value == ''){
						alert('El Departamento no puede quedar en Blanco. Favor Elegir un Departamento');return(false);
				}
				
				if (document.formFDatosM.MIGMdetalleid.value != ''){
					document.formDatos.MIGMdetalleid.value = document.formFDatosM.MIGMdetalleid.value;
				}
				if (document.formDatos.valor_moneda_origen.value == ''){
					alert('El Valor no puede quedar en blanco');return(false);
				}
				if (document.formDatos.Pfecha.value == ''){
					alert('La fecha no puede quedar en blanco');return(false);
				}
				
	    }	
	</cfif>
	
}


</script>
		
		



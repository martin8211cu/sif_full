<!--- 
	Creado por: Ana Villavicencio
	Fecha: 01 de marzo del 2006
	Motivo: Nuevo catalogo de Limite de credito adicional. Dentro del catalogo de Socios de Negocios.
 --->
<cfif isdefined("url.id_direccion") and len(trim(url.id_direccion)) and not isdefined("form.id_direccion")>
	<cfset form.id_direccion = url.id_direccion>
</cfif>
<cfif isdefined('url.SNLCid') and LEN(TRIM(url.SNLCid)) and not isdefined('form.SNLCid')>
	<cfset form.SNLCid = url.SNLCid>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->		
<cfif isdefined("url.Pagina2") and len(trim(url.Pagina2))>
	<cfset form.Pagina2 = url.Pagina2>
</cfif>		
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
<cfif isdefined("url.PageNum_Lista2") and len(trim(url.PageNum_Lista2))>
	<cfset form.Pagina2 = url.PageNum_Lista2>
</cfif>	

<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
<cfif isdefined("form.PageNum2") and len(trim(form.PageNum2))>
	<cfset form.Pagina2 = form.PageNum2>
</cfif>

<cfparam name="form.id_direccion" default="">
<cfset modo='ALTA'>
<cfset modoDet='ALTA'>
<cfif Len(form.id_direccion)>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
</cfif>
<cfif isdefined('form.SNLCid') and LEN(TRIM(form.SNLCid))>
	<cfset modoDet='CAMBIO'>
<cfelse>
	<cfset modoDet='ALTA'>
</cfif>

<cfif modoDet EQ 'CAMBIO'>
	<cfquery name="rsFormLCA" datasource="#session.DSN#">
		select *
		from SNLimiteCredito
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
		  and id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#">
		  and SNLCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNLCid#">
	</cfquery>
</cfif> 
<form name="formLCA" action="SociosLimCredAdic_sql.cfm" method="post" style="margin:0 ">
	<cfoutput>
		<input type="hidden" name="id_direccion" value="#HTMLEditFormat(form.id_direccion)#">
		<input type="hidden" name="SNid" value="#HTMLEditFormat(rsSocios.SNid)#">
		<input type="hidden" name="SNcodigo" value="#HTMLEditFormat(rsSocios.SNcodigo)#">
		<input name="Pagina" type="hidden" value="<cfif isdefined('form.Pagina')>#form.Pagina#<cfelse>1</cfif>">
		<input name="Pagina2" type="hidden" value="<cfif isdefined('form.Pagina2')>#form.Pagina2#</cfif>">
		<cfif isdefined('form.SNLCid')>
		<input name="SNLCid" type="hidden" value="#form.SNLCid#">
		</cfif>
		<table width="100%">
			<tr>
			  <td width="13%" valign="middle" nowrap><div align="right"><strong>C&oacute;digo&nbsp;Direcci&oacute;n:</strong>&nbsp;&nbsp;</div></td>
			  <td colspan="3" valign="middle" nowrap><cfif modo NEQ 'ALTA'>#trim(rsform.SNDcodigo)#</cfif><cfif modo EQ 'ALTA'>#trim(rsSocios.SNnumero) & '-' & (rsConsecutivo.cuenta +1)#</cfif></td>
			</tr>
			<tr>
			  <td valign="middle" nowrap><div align="right"><strong>Direcci&oacute;n:</strong>&nbsp;&nbsp;</div></td>
			  <td valign="middle" nowrap colspan="3"><cfif modo NEQ 'ALTA'>#trim(rsDirecciones.direccion1)#</cfif></td>
			</tr>
			<tr align="left"><td colspan="4" align="right"><hr align="left" width="100%"></td></tr>
		</table>
		<table width="100%" cellpadding="0" cellspacing="3" border="0" align="center">
			<tr>
				<td width="30%" align="right"><strong>Vigencia desde&nbsp;</strong>
				<td width="6%" nowrap>
					<cfif modoDet EQ 'CAMBIO'>
						<cfset fecha = LSDateFormat(rsFormLCA.Fdesde,'dd/mm/yyyy')>
					<cfelse>
						<cfset fecha=LSDateFormat(Now(),'dd/mm/yyyy')>
					</cfif>
					<cf_sifcalendario name="Fdesde" tabindex='1' form="formLCA" value="#fecha#">
				</td>
				<td width="5%"><strong>hasta</strong></td>
				<td width="59%">
					<cfif modoDet EQ 'CAMBIO'>
						<cfset fecha= LSDateFormat(rsFormLCA.Fhasta,'dd/mm/yyyy')>
					<cfelse>
						<cfset fecha=LSDateFormat(Now(),'dd/mm/yyyy')>
					</cfif>
					<cf_sifcalendario name="Fhasta" tabindex='1' form="formLCA" value="#fecha#">
				</td>
			</tr>
			<tr>
				<td align="right" nowrap><strong>L&iacute;mite de Cr&eacute;dito Adicional:</strong>&nbsp;</td>
				<td align="right">
					<cfif modoDet NEQ 'ALTA'>
						<cfset monto=rsFormLCA.SNLadicional>
					<cfelse>
						<cfset monto=0.00>
					</cfif>
					<cf_monto name="SNLadicional" tabindex="1"  negativos="false" modificable="true" value="#monto#" onChange="suma(this.form);">
				</td>
			</tr>
			<tr>
				<td align="right"><strong>L&iacute;mite de Cr&eacute;dito Actual:</strong>&nbsp;</td>
				<td align="right">
					<cfif modoDet NEQ 'ALTA'>
						<cfset monto = rsFormLCA.SNLactual>
					<cfelse>
						<cfset monto = rsSocios.SNmontoLimiteCC>
					</cfif>
					<cf_monto name="SNmontoLimiteCC" tabindex="-1"  negativos="false" value="#monto#"  modificable="false" class="cajasinborde">
				</td>
			</tr>
			<tr>
				<td align="right"><strong>L&iacute;mite de Cr&eacute;dito Total:</strong>&nbsp;</td>
				<td align="right">
					<cfif modoDet NEQ 'ALTA'>
						<cfset monto = rsFormLCA.SNLtotal>
					<cfelse>
						<cfset monto = 0.00>
					</cfif>
					<cf_monto name="SNLtotal" tabindex="-1"  negativos="false" modificable="false" value="#monto#" class="cajasinborde">
					<!--- <input name="SNLtotal" type="text" size="15" tabindex='-1'
						value="" 
						readonly class="cajasinborde" style="text-align:right" > --->
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td colspan="3">
					<input name="Vigente" id="Vigente" type="checkbox" value="0" tabindex="1" 
					<cfif modoDet NEQ 'ALTA' and rsFormLCA.Vigente>checked<cfelseif modoDet EQ'ALTA'>checked</cfif>>
					<label for="Vigente" style="font-style:normal; font-variant:normal;">Vigente</label>
				</td>
			</tr>
			<tr>
				<td align="right" valign="top"><strong>Motivo:</strong>&nbsp;</td>
				<td colspan="3">
					<textarea name="Motivo" cols="70" rows="5" tabindex="1"><cfif modoDet NEQ 'ALTA'>#rsFormLCA.Motivo#</cfif></textarea>
				</td>
			</tr>
			<tr><td colspan="4"><cf_botones modo="#modoDet#" tabindex="1" exclude="Baja" sufijo="Limite"></td></tr>
			</form>
			<tr>
				<td colspan="4">
					<cfset navegacion = 'SNcodigo=#form.SNcodigo#&tab=8&tabs=3&id_direccion=#form.id_direccion#'>
					<cfif isdefined('form.Pagina2')>
					<cfset navegacion = navegacion &'&Pagina2=#form.Pagina2#'>
					</cfif>
					<cfif isdefined('form.SNLCid') and LEN(TRIM(form.SNLCid))><cfset navegacion = navegacion & '&SNLCid=' & form.SNLCid></cfif>
					<cfinvoke 
							 component="sif.Componentes.pListas"
							 method="pLista"
							 returnvariable="pListaRetLCA">
						<cfinvokeargument name="columnas"  				value="SNLCid,fdesde as Ffdesde,fhasta as Ffhasta,SNLadicional as FSNLadicional,SNLactual as FSNLactual,
																				SNLtotal as FSNLtotal,Vigente as FVigente,
																			case Vigente 
																			 when 1 then '<img border=''0'' src=''../../imagenes/checked.gif''>' 
																			 when 0 then '<img border=''0'' src=''../../imagenes/unchecked.gif''>' else '' end as VigenteIcono,
																			 #form.SNcodigo# as SNcodigo,
																			 #form.id_direccion# as id_direccion,
																			 8 as tab,
																			 3 as tabs,
																			 '' as e"/>
						<cfinvokeargument name="tabla"  				value="SNLimiteCredito"/>
						<cfinvokeargument name="filtro"  				value="Ecodigo = #Session.Ecodigo#
																				and SNcodigo = #form.SNcodigo#
																				and id_direccion = #form.id_direccion#
																				order by Vigente desc,fdesde"/>
						<cfinvokeargument name="desplegar"  			value="Ffdesde,Ffhasta,FSNLadicional,FSNLactual,FSNLtotal,VigenteIcono,e"/>
						<cfinvokeargument name="filtrar_por"  			value="fdesde,fhasta,SNLadicional,SNLactual,SNLtotal,Vigente,''"/>
						<cfinvokeargument name="etiquetas"  			value="Desde,Hasta,Límite Crédito Adicional, Límite Crédito Actual, Límite Crédito Total, Vigente, "/>
						<cfinvokeargument name="formatos"   			value="D,D,M,M,M,U,U"/>
						<cfinvokeargument name="align"      			value="left,left,right,right,right,center,center"/>
						<cfinvokeargument name="ajustar"    			value="N"/>
						<cfinvokeargument name="irA"        			value="SociosDirecciones_form.cfm?tab=3&modoC=CAMBIO"/>
						<cfinvokeargument name="showLink" 				value="true"/>
						<cfinvokeargument name="showEmptyListMsg" 		value="true"/>
						<cfinvokeargument name="maxrows" 				value="10"/>
						<cfinvokeargument name="keys"             		value="SNLCid"/>
						<cfinvokeargument name="formname"				value="Lista2"/>
						<cfinvokeargument name="incluyeform"			value="true"/>
						<cfinvokeargument name="navegacion"				value="#navegacion#"/>
						<cfinvokeargument name="PageIndex"				value="2"/>
					</cfinvoke>
				</td>
			</tr>
		</table>
	</cfoutput>	


<cf_qforms form="formLCA" objForm="objFormLCA">
<script language="javascript" type="text/javascript">
	objFormLCA.allowSubmitOnError = true;
	objFormLCA.Fdesde.required = true;
	objFormLCA.Fdesde.description="Fecha desde";
	objFormLCA.Fhasta.required = true;
	objFormLCA.Fhasta.description="Fecha hasta";	
	objFormLCA.SNLadicional.required = true;
	objFormLCA.SNLadicional.validateExp("!objForm.allowSubmitOnError&&parseFloat(qf(this.getValue()))==0.00","El valor de Límite de Crédito Adicional debe ser diferente de 0");
	objFormLCA.Motivo.required = true;
	objFormLCA.Motivo.description="Motivo";
	
	function deshabilitarValidacion(){
		objFormLCA.Fdesde.required = false;
		objFormLCA.Fhasta.required = false;
		objFormLCA.SNLadicional.required = false;
		objFormLCA.Motivo.required = false;
	}

	function suma(f){
		var total;
		f.SNLtotal.value = Number(qf(f.SNLadicional.value)) + Number(qf(f.SNmontoLimiteCC.value));
		f.SNLtotal.value = fm(f.SNLtotal.value,2);
	}
</script>
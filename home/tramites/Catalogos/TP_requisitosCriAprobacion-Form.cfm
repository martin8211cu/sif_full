
<!--- <cfdump  label="url" var="#url#">
<cfdump  label="form" var="#form#">
<cfabort> --->
<cfset tipofecha = "">
<cfset numero = "">  

<cfif isdefined('url.id_requisito') and not isdefined('form.id_requisito')>
	<cfparam name="form.id_requisito" default="#url.id_requisito#">
	
</cfif>

<cfif isdefined('url.id_criterio') and not isdefined('form.id_criterio')>
	<cfparam name="form.id_criterio" default="#url.id_criterio#">
</cfif>

<cfset modo = 'ALTA'>
<cfif isdefined('form.id_criterio') and len(trim(form.id_criterio))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfquery name="combo" datasource="#session.tramites.dsn#">
	select a.es_criterio_and, c.id_campo, c.nombre_campo, c.id_tipocampo
	from 
		TPRequisito  a
		
		inner join TPDocumento b
		on b.id_documento = a.id_documento
	
		inner join DDTipoCampo c
		on c.id_tipo = b.id_tipo
		
	 where  a.id_requisito = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id_requisito#">
</cfquery>
	
<cfif modo EQ 'CAMBIO'>
	
	<cfquery name="temp" datasource="#session.tramites.dsn#">
		select  a.operador, a.valor, a.id_campo, a.campo_fijo
		from TPCriterioAprobacion  a
		where a.id_requisito = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id_requisito#">
		  and a.id_criterio = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id_criterio#">	
	</cfquery>
</cfif>

<cfinvoke component="home.tramites.componentes.cierre" method="datos_fijos"
	returnvariable="datos_fijos"></cfinvoke>

<cfoutput>	
<form method="post" name="form1" action='TP_requisitosCriAprobacion-sql.cfm?id_requisito=<cfoutput>#JSStringFormat(form.id_requisito)#</cfoutput>' >
	<table width="100%" border="0" align="left" cellpadding="0"  style="top:auto">
  		<tr><td  align="center"  bgcolor="##F4F4F4" style="padding:2px;" colspan="2"><font size="1"><cfif #modo# eq 'ALTA'>Defina un criterio <cfelse> Modifique, Elimine o Defina un criterio</cfif></font></td></tr>
		<tr>
			<td align="right">Campo</td>
			<td align="left">
				<select name="campo" id="campo" onchange="javascript: dibujar();">
					<cfif modo EQ "ALTA">
						<option  value="" selected>Elija un Campo</option>
					</cfif>
					<optgroup label="Datos Personales">
						<cfloop query="datos_fijos">
						<option value="F,#codigo#" <cfif (modo EQ "CAMBIO") and (datos_fijos.codigo EQ temp.campo_fijo)>selected</cfif>>#nombre#</option>
						</cfloop>
					</optgroup>
					<optgroup label="Documento Relacionado">
					<cfloop  query="combo">
						<option value="C,#id_campo#" <cfif (modo EQ "CAMBIO") and (combo.id_campo EQ temp.id_campo)>selected</cfif>>#nombre_campo#</option>
					</cfloop>
					</optgroup>
			  </select>
			</td>
		</tr>
		<tr>	
			<td align="right">Operador</td> 
			<td align="left">
				<select id="operador" name="operador" onChange="javascript: dibujar();">
					<option  value="">Elija un Operador</option>
					<option  value=">="	<cfif modo EQ 'CAMBIO'>	<cfif trim(#temp.operador#) EQ '>='>	selected </cfif> </cfif>>>=	Mayor igual que</option>
					<option  value="<="<cfif modo EQ 'CAMBIO'>	<cfif trim(#temp.operador#) EQ '<='>	selected </cfif> </cfif>><= Menor igual que</option>
					<option  value=">"<cfif modo EQ 'CAMBIO'>	<cfif trim(#temp.operador#) EQ '>'>	selected </cfif> </cfif>> >  Mayor que</option>
					<option  value="<"<cfif modo EQ 'CAMBIO'>	<cfif trim(#temp.operador#) EQ '<'>	selected </cfif> </cfif>> <  Menor que</option>
					<option  value="="<cfif modo EQ 'CAMBIO'>	<cfif trim(#temp.operador#) EQ '='>	selected </cfif> </cfif>>=  Igual</option>
					<option  value="<>"<cfif modo EQ 'CAMBIO'>	<cfif trim(#temp.operador#) EQ '<>'>	selected </cfif> </cfif>><> Diferente</option>
					<option  value="MAX"<cfif modo EQ 'CAMBIO'>	<cfif trim(#temp.operador#) EQ 'MAX'>	selected </cfif> </cfif>>MAX Antiguedad Máxima en días</option>
					<option  value="MIN"<cfif modo EQ 'CAMBIO'>	<cfif trim(#temp.operador#) EQ 'MIN'>	selected </cfif> </cfif>>MIN Antiguedad Minima en días</option>
			  </select>
			</td>
		</tr>
		<tr>
			<td align="right">Valor</th>
			
			<td align="left">
				<table cellspacing="0" cellpadding="0" border="0">
					<tr>
						<td id="td1">
							<input  id="valor" name="valor1" type="text" <cfif #modo# EQ 'CAMBIO'>value="#temp.valor#" </cfif>></td>
								
						<td id="td2">
							<cf_sifcalendario tabindex="5" form="form1" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" name="valor2">
							<input name="esfecha" type="hidden">
						</td>
					
					</tr>	
				</table>
			</td>
			
		</tr>
		<tr>
			<td colspan="2" align="left">
				
				<cfif modo neq 'ALTA'  >
					<cf_botones modo='CAMBIO'>
					<input type="hidden" name="id_criterio" value="#form.id_criterio#">
					<input type="hidden" name="id_requisito" value="#form.id_requisito#">
				<cfelse>
					<cf_botones modo='ALTA'>
					<input type="hidden" name="id_requisito" value="#form.id_requisito#">
					
				</cfif>
			</td>
		</tr>
	</table>
</form>

</cfoutput>


<cf_qforms>

<script type="text/javascript" language="javascript">
<!--
	var tipocampo = new Object({
	<cfoutput query="combo">
		'#id_campo#': '#id_tipocampo#',
	</cfoutput>  'dummy':0 });
	function dibujar() {
		var idx = "" + document.form1.campo.value;
		var idxc = idx.split(',');
		idx = idxc.length==2?idxc[1]:'';
		var op = document.form1.operador.value;
		var es_una_fecha = (idx == 'NAC') || (tipocampo[idx] == 4);
		var es_tipo_fecha = (es_una_fecha && op != 'MIN' && op != 'MAX');
		var a = document.getElementById("td1");
		var b = document.getElementById("td2");
		
		if (es_tipo_fecha) {
			
			document.form1.esfecha.value=1;
			if (a){
				a.style.display = 'none';
			}
			if (b){ 
				b.style.display = '';}
			
		} else {
			document.form1.esfecha.value=0;
			if (a) a.style.display = '';
			if (b) b.style.display = 'none';
			
		}
	}
	dibujar();

	objForm.campo.required = true;
	objForm.campo.description = "Campo";
	
	objForm.operador.required = true;
	objForm.operador.description = "Operador";

//-->
</script>
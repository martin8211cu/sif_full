<!--- 
	Modificado por Gustavo Fonseca Hernández.
		Fecha: 9-8-2005.
		Motivo: Se quita el SNcodigoext de este tab.
 --->

<!--- <cfdump var="#form#"> --->

<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

	<cfquery name="rsMonedas" datasource="#session.DSN#">
		select a.Mcodigo, a.Mnombre
		from Monedas a, Empresas b 
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.Ecodigo = b.Ecodigo
	</cfquery>
	
	
<cfif modo neq 'ALTA' or isdefined("form.SNcodigo")>
<cfset modo='CAMBIO'>	
	<cfquery name="rsListaPrecios" datasource="#Session.DSN#">
		select 
			b.LPid, 
			b.LPdescripcion,
			a.SNcodigo, 
			a.ts_rversion
		from EListaPrecios b
			left outer join SNegocios a
				on a.Ecodigo = b.Ecodigo
				and a.LPid = b.LPid
				and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		order by b.LPdescripcion
	</cfquery>	
<cfelse>
	<cfquery name="rsListaPrecios" datasource="#Session.DSN#">
		select 
			b.LPid, 
			b.LPdescripcion,
			null as SNcodigo
		from EListaPrecios b
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		order by b.LPdescripcion
	</cfquery>	



</cfif> <!--- modo cambio --->

<script language="JavaScript" type="text/JavaScript">
<!--


// ========================================================================================================
var valor = ""

function valido(origen){
	for(var i=0; i<origen.length-1; i++){
		if ( origen.charAt(i)=='-' && i != 3 ){
			return false;
		}
	}
	return true;
}

function anterior(obj, e, d){
	valor = obj.value;
}


function set_visibility(nombre,visible){
	var objref = document.all ? document.all[nombre] : document.getElementById(nombre);
	if (objref) {
		//objref.style.visibility = visible ? 'visible' : 'hidden';
		objref.style.display = visible ? 'inline' : 'none';
	}
}
function click_tiposocio(f){
	set_visibility('trCuentaCC1', f.SNtiposocioC.checked);
	set_visibility('trCuentaCC2', f.SNtiposocioC.checked);
	set_visibility('trCuentaCC3', f.SNtiposocioC.checked);
	set_visibility('trCuentaCC4', f.SNtiposocioC.checked);
	set_visibility('trCuentaCC5', f.SNtiposocioC.checked);
	set_visibility('trCuentaCP1', f.SNtiposocioP.checked);
	set_visibility('trCuentaCP2', f.SNtiposocioP.checked);
}

//-->
</script>

<script language="JavaScript" type="text/JavaScript">
<!--

function validarICrediticia(form){
	MM_validateForm('SNnumero', '', 'R', 'SNidentificacion','','R','SNnombre','','R','SNemail','','NisEmail','SNvencompras','','RisNum','SNvenventas','','RisNum','SNFecha','','R');
	return document.MM_returnValue;
}	

//-->
</script>

<style type="text/css">
	.cuadro{
		border: 1px solid #999999;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
</style>

<cf_templatecss>
<!--- <script language="JavaScript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script> --->

<body>

 <form action="SociosICrediticia-sql.cfm" method="post" name="form2" onSubmit="return validarICrediticia(this);"><!--- --->
<cfoutput>
<table width="100%" border="0" align="left" cellpadding="0" cellspacing="0">
	
	<tr>
		<td>&nbsp;</td>
	  <td align="center" nowrap>
	  <fieldset style="width:60%"><legend>Ventas</legend>
	  <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
	  	<tr>
			<td width="30%" align="left">
				<strong>Vencimiento&nbsp;para&nbsp;Ventas:</strong>
			</td>
		</tr>
		<tr>
			 <td>
			 	<input type="text" name="SNvenventas" value="<cfif #modo# NEQ "ALTA">#rsSocios.SNvenventas#</cfif>" size="5" style="text-align: right;" onBlur="javascript:fm(this,-1); "  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" alt="El campo Vencimiento Ventas del Socio">&nbsp;(d&iacute;as) 
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td nowrap width="30%"><strong>Plazo&nbsp;de&nbsp;Cr&eacute;dito:</strong></td>
		</tr>
		<tr>
			<td>
				<input type="text" name="SNplazocredito" value="<cfif #modo# NEQ "ALTA">#rsSocios.SNplazocredito#</cfif>" size="5" style="text-align: right;" onBlur="javascript:fm(this,-1); "  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" alt="Plazo de Cr&eacute;dito">&nbsp;(d&iacute;as)
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		
	  </table>
	  </fieldset>
	  </td>
     
	 <td align="left">
	 	<fieldset style="width:95%"><legend>Compras</legend>
	 	<table width="100%" border="0" align="left" cellpadding="0" cellspacing="0">
			<tr>
				<td width="30%" align="left"><strong>Vencimiento&nbsp;para&nbsp;Compras</strong>:</td>
			</tr>
			<tr>
				<td> 
					<input type="text" name="SNvencompras" value="<cfif modo NEQ "ALTA">#rsSocios.SNvencompras#</cfif>" size="5"  style="text-align: right;" onBlur="javascript:fm(this,-1); "  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" alt="El campo Vencimiento Compras del Socio">&nbsp;(d&iacute;as)
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td nowrap width="30%"><strong>Plazo&nbsp;de&nbsp;Entrega :</strong></td>
			</tr>
			<tr>
				<td>
					<input type="text" name="SNplazoentrega" value="<cfif modo NEQ "ALTA">#rsSocios.SNplazoentrega#</cfif>" size="5"  style="text-align: right;" onBlur="javascript:fm(this,-1); "  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" alt="Plazo de entrega">&nbsp;(d&iacute;as)
				</td>
			</tr>
			<tr>
				<td nowrap width="30%"><strong>Nombre&nbsp;para&nbsp;Pagos&nbsp;en&nbsp;Tesorer&iacute;a</strong></td>
			</tr>
			<tr>
				<td><input type="text" name="SNnombrePago" value="<cfif modo NEQ "ALTA">#rsSocios.SNnombrePago#</cfif>" size="30" maxlength="255" style="text-align: left;"></td>
			</tr> 
			
		</table>
		</fieldset>
	 </td>
	<tr>
		<td colspan="4">&nbsp;</td>
	</tr>
	<tr>
	  <td align="right" valign="middle" nowrap>&nbsp;</td>
	 
	  <td rowspan="8" width="70%" align="center">
	 	 <fieldset style="width:60%">
	 	 <legend>Informaci&oacute;n&nbsp;de&nbsp;Cr&eacute;dito</legend> 
			<table align="left" border="0" width="72%" cellpadding="1" cellspacing="0">
				<tr>
				  <td align="left"><strong>L&iacute;mite&nbsp;Cr&eacute;dito:</strong>&nbsp;</td>
				  <td><strong>Moneda:</strong>&nbsp;</td>
				</tr>
				<tr>
					<td>
						<input name="SNmontoLimiteCC" type="text" size="20" maxlength="20" value="<cfif modo NEQ 'ALTA' and rsSocios.SNmontoLimiteCC GT 0>#HTMLEditFormat(rsSocios.SNmontoLimiteCC)#</cfif>">
					</td>
					<td>
						<select name="Mcodigo" id="Mcodigo">
							<cfloop query="rsMonedas">
								<option value="#rsMonedas.Mcodigo#"<cfif modo NEQ 'ALTA' and rsMonedas.Mcodigo EQ rsSocios.Mcodigo>selected</cfif>>#HTMLEditFormat(rsMonedas.Mnombre)#</option>
							</cfloop>
						</select>
					</td>
					
				</tr>
				<tr>
					<td align="right" colspan="2">&nbsp;</td>
				</tr>
				<tr>
				  	<td align="left"><strong>D&iacute;as&nbsp;Bloqueo&nbsp;Facturaci&oacute;n:</strong>&nbsp;</td>
				  	<td align="left"><strong>D&iacute;as&nbsp;de&nbsp;Mora:</strong>&nbsp;</td>
				</tr>
	
				<tr>
					<td>
						<input name="SNdiasVencimientoCC" type="text" size="10" maxlength="5" value="<cfif modo NEQ 'ALTA' and rsSocios.SNdiasVencimientoCC GT 0>#HTMLEditFormat(rsSocios.SNdiasVencimientoCC)#</cfif>">
					</td>
					<td>
						<input name="SNdiasMoraCC" type="text" size="10" maxlength="5" value="<cfif modo NEQ 'ALTA' and rsSocios.SNdiasMoraCC GT 0>#HTMLEditFormat(rsSocios.SNdiasMoraCC)#</cfif>">
					</td>

				</tr>
			
			</table>
		</fieldset>
	  	</td>
		<td align="left" width="30%"><strong>Lista&nbsp;de&nbsp;Precios:</strong></td>
		</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="right" valign="middle" nowrap>&nbsp;</td>
		<td>
			<select name="LPid" id="LPid">
			  <option value="">- Usar predeterminada del sistema -</option>
			  <cfloop query="rsListaPrecios">
				<option value="#rsListaPrecios.LPid#" <cfif Len(rsListaPrecios.SNcodigo)>selected</cfif>>#HTMLEditFormat(rsListaPrecios.LPdescripcion)#</option>
			  </cfloop>
			</select>
		</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="4">&nbsp;</td>
	</tr>
	<tr>
	  <td align="right" valign="middle" nowrap>&nbsp;</td>
	  <td align="left" width="30%"><strong>Cobrador&nbsp;Asignado:&nbsp;</strong>
      <td>&nbsp;</td>
	</tr>
	<tr>
		<td align="right" valign="middle" nowrap>&nbsp;</td>
		<td>
		 	
		 	<cfif modo neq 'ALTA' and rsSocios.DEidCobrador gt 0>	
				<cfquery name="rsEmpleado1" datasource="#session.DSN#">
				 select a.DEid as DEid1, a.NTIcodigo as NTIcodigo1, a.DEidentificacion as DEidentificacion1, 
						<cf_dbfunction name="concat" args="a.DEapellido1+' '+a.DEapellido2+', '+a.DEnombre" delimiters="+"> as NombreEmp1
					from DatosEmpleado a, RolEmpleadoSNegocios b
					where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSocios.DEidCobrador#">
					  and a.Ecodigo = b.Ecodigo
				</cfquery>
				
				<cf_rhempleadoCxC rol=1 form='form2' size=45 index=1 query=#rsEmpleado1#>
			<cfelse>
				 <cf_rhempleadoCxC rol=1 form='form2' index=1 size=45>
			</cfif> 	
		
		</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="4">&nbsp;</td>
	</tr>
	<tr>
	  <td align="right" valign="middle" nowrap>&nbsp;</td>
	  <td width="30%"><strong>Vendedor&nbsp;Asignado:&nbsp;</strong></td>
      <td>&nbsp;</td>
	
	</tr>
	<tr>
		<td align="right" valign="middle" nowrap>&nbsp;</td>
		<td>
		 	 <cfif modo neq 'ALTA' and rsSocios.DEidVendedor gt 0>	
				<cfquery name="rsEmpleado2" datasource="#session.DSN#">
				select a.DEid as DEid2, a.NTIcodigo as NTIcodigo2, a.DEidentificacion as DEidentificacion2, 
					<cf_dbfunction name="concat" args="a.DEapellido1+' '+a.DEapellido2+', '+a.DEnombre" delimiters="+"> as NombreEmp2
				from DatosEmpleado a, RolEmpleadoSNegocios b
				where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSocios.DEidVendedor#">
					and a.Ecodigo = b.Ecodigo
				</cfquery>
				<cf_rhempleadoCxC rol=2 form='form2' index=2 size=45 query=#rsEmpleado2#>
			<cfelse>
				<cf_rhempleadoCxC rol=2 form='form2' index=2 size=45>
			</cfif>	
		</td>
		<td>&nbsp;</td>
		
	</tr>
	<tr>
		<td colspan="4">&nbsp;</td>
	</tr>
	<tr> 
	  <td align="right" valign="middle" nowrap>&nbsp;</td>
	  <td align="right" valign="middle" nowrap>&nbsp;</td>
	  <td width="30%"><strong>Ejecutivo&nbsp;de&nbsp;Cuenta&nbsp;Asignado:</strong>&nbsp;</td>
      <td>&nbsp;</td>
	 
	</tr>
	<tr>
		<td align="right" valign="middle" nowrap>&nbsp;</td>
		<td align="right" valign="middle" nowrap>&nbsp;</td>
		<td>
		 	<cfif modo neq 'ALTA' and rsSocios.DEidEjecutivo gt 0>	
				<cfquery name="rsEmpleado3" datasource="#session.DSN#">
				 select a.DEid as DEid3, a.NTIcodigo as NTIcodigo3, a.DEidentificacion as DEidentificacion3, 
					<cf_dbfunction name="concat" args="a.DEapellido1+' '+a.DEapellido2+', '+a.DEnombre" delimiters="+"> as NombreEmp3
				from DatosEmpleado a, RolEmpleadoSNegocios b
				where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSocios.DEidEjecutivo#">
					and a.Ecodigo = b.Ecodigo
				</cfquery>
				<cf_rhempleadoCxC rol=3 form='form2' index=3 size=45 query=#rsEmpleado3#>
			<cfelse>
				<cf_rhempleadoCxC rol=3 form='form2' index=3 size=45>
			</cfif>
		</td>
		<td>&nbsp;</td>
		
	</tr>
	<tr>
		<td colspan="4" align="right" valign="baseline" nowrap>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="4">&nbsp;</td>
	</tr>

	<!--- Botones --->
	<tr> 
		<td colspan="4" align="right" valign="baseline" nowrap> 
			<div align="center"> 
			<!--- Sustituye al portlet de botones, para agregar un boton mas --->
				<!--- <cfinclude template="/sif/portlets/pBotones.cfm"> --->
				<cf_botones names="Cambio" values="Modificar">
				<!--- <cf_botones names="Cambio,ActivarUsuario" values="Modificar,Activar como Usuario"> --->
			<!--- portlet botones--->
			</div>
		</td>
	</tr>
	<tr>
		<td colspan="3" align="right" valign="baseline" nowrap>&nbsp;</td>
    </tr>
		<cfif modo neq "ALTA">
      		<cfset ts = "">
      		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsSocios.ts_rversion#" returnvariable="ts">
      		</cfinvoke>
      		<input type="hidden" name="ts_rversion" value="#ts#">
    	</cfif>
  	<input type="hidden" name="SNcodigo" value="<cfif modo NEQ "ALTA">#rsSocios.SNcodigo#</cfif>">
	<input type="hidden" name="ICrediticia" value="ICrediticia">
	
</table>
 </form>
 
 <script type="text/javascript">
 <!--
 function funcActivarUsuario(){
	 location.href='SociosActivar.cfm?SNcodigo=#rsSocios.SNcodigo#';
	 return false;
 }
 //-->
 </script>
</cfoutput>

<cfelse>
	<table align="center">
		<tr>
			<td>Primero&nbsp;debe&nbsp;ingresar&nbsp;los&nbsp;<strong>Datos&nbsp;Generales</strong>&nbsp;del&nbsp;Socio&nbsp;de&nbsp;Negocios</td>
		</tr>
	</table>
</cfif>
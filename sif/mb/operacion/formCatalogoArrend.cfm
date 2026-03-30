<!--- =============================================================== --->
<!--- Autor:  Rodrigo Rivera                                          --->
<!--- Nombre: Arrendamiento                                           --->
<!--- Fecha:  28/03/2014                                              --->
<!--- Última Modificación: 04/05/2014                                 --->
<!--- =============================================================== --->
<!--- =============================================================== --->
<!---                   INICIALIZACION  VARIABLES                     --->
<!--- =============================================================== --->
<cfprocessingdirective pageencoding = "utf-8">
<cfparam name="SN"			default="">
<cfparam name="Nombre"		default="">
<cfparam name="CuentaIdif"	default="">
<cfparam name="CuentaIgan"	default="">
<cfparam name="Cid"			default="">
<cfparam name="obser"		default="">
<cfparam name="modosn"		default="">
<cfparam name="modoarr"		default="">

<cfif isDefined(url.modosn)>
	<cfset modosn= "url.modosn">
</cfif>
<cfif isDefined(url.modoarr)>
	<cfset modoarr= "url.modoarr">
</cfif>

<cfif modosn NEQ "ALTA" && modoArr EQ "CAMBIO">
	<cfquery name="rsCatalogo" datasource="#session.dsn#">
		SELECT 	IDCatArrend, Ecodigo, SNcodigo, ArrendNombre, CcuentaIDif, CcuentaIGan, Observaciones, Cid
		  FROM	CatalogoArrend
		 WHERE	Ecodigo = #Session.Ecodigo# AND SNcodigo = #form.SNcodigo# AND IDCatArrend = #Form.IDCatArrend#
	</cfquery>
		<cfset SN = rsCatalogo.SNcodigo>
		<cfset Nombre = rsCatalogo.ArrendNombre>
	<cfquery name="rsCuentaCatalogo" datasource="#session.dsn#">
	  SELECT  a.CcuentaIDif AS CcuentaIDif, b.Cformato AS CformatoIDif, b.Cdescripcion AS CdescripcionIDif, 
	      a.CcuentaIGan AS CcuentaIGan, c.Cformato AS CformatoIGan, c.Cdescripcion AS CdescripcionIGan
	  FROM  CatalogoArrend a 
	      INNER JOIN CContables b ON a.CcuentaIDif = b.Ccuenta
	      INNER JOIN CContables c ON a.CcuentaIGan = c.Ccuenta
	  WHERE a.Ecodigo = #Session.Ecodigo# AND a.SNcodigo = #form.SNcodigo# AND a.IDCatArrend = #Form.IDCatArrend#
	</cfquery>
	<cfquery name="rsConcepto" datasource="#session.DSN#">
		select Cid, Ccodigo, Cdescripcion 
		from Conceptos 
		where Ecodigo = #Session.Ecodigo#
		and Cid =#rsCatalogo.Cid#
		order by Ccodigo
	</cfquery>
</cfif>
<cfif modosn EQ 'Cambio'>
	<cfquery name="rsSN" datasource="#session.dsn#">
		SELECT * from SNegocios where SNcodigo = #form.sncodigo#
	</cfquery>
	<cfset SN = rsSN.SNcodigo>
</cfif>

<cfoutput><form method="post" name="form1" action="SQLCatalogoArrend.cfm">
 	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<input type="hidden" name="modosn" id="modosn" value="#modosn#">
		<input type="hidden" name="modoarr" id="modoarr" value="#modoarr#">
 	<tr><br></tr>
		<tr>
			<td nowrap><strong>Socio de Negocios:&nbsp;</strong></td>
			<cfif modoarr EQ 'CAMBIO' or modosn EQ 'CAMBIO'>
				<td><cf_sifsociosnegocios2 tabindex="1" size="55" idquery="#SN#" modificable='no'></td>
			<cfelse>
				<td><cf_sifsociosnegocios2 tabindex="1" size="55"></td>
			</cfif>
		</tr>
		<tr> 
			<td nowrap align="left"><strong>Nombre:&nbsp; </strong></td>
			<cfif modoarr EQ 'CAMBIO'>
				<td><input type="text" id="Nombre" name="Nombre" tabindex="1" style="width:200px;" value="#Nombre#" readOnly="true" class="cajasinborde"></td>
			<cfelse>
				<td><input type="text" id="Nombre" name="Nombre" tabindex="1" style="width:200px;" value=""></td>
			</cfif>
		</tr>
    	<tr> 
			<td nowrap align="left"><strong>Cuenta Ingreso Diferido:&nbsp; </strong></td>
			<td>
				<cfif modoarr EQ "CAMBIO">
					<cf_cuentas tabindex="1" Conexion="#Session.DSN#" query="#rsCuentaCatalogo#" Conlis="S" auxiliares="N" movimiento="S" 
                  Ccuenta="CcuentaIDif" cmayor="CmayorIDif" cdescripcion="CdescripcionIDif" cformato="CformatoIDif" CFcuenta="CFcuentaIDif" igualTabFormato="S">
                <cfelse>
                	<cf_cuentas tabindex="1" Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" 
                  Ccuenta="CcuentaIDif" cmayor="CmayorIDif" cdescripcion="CdescripcionIDif" cformato="CformatoIDif" CFcuenta="CFcuentaIDif" igualTabFormato="S">
                </cfif>
            </td>
 		</tr>
 		<tr> 
			<td nowrap align="left"><strong>Cuenta Intereses Ganados:&nbsp; </strong></td>
			<td>
				<cfif modoarr EQ "CAMBIO">
					<cf_cuentas tabindex="1" Conexion="#Session.DSN#" query="#rsCuentaCatalogo#" Conlis="S" auxiliares="N" movimiento="S" 
                  ccuenta="CcuentaIGan" cmayor="CmayorIGan" cdescripcion="CdescripcionIGan" cformato="CformatoIGan" CFcuenta="CFcuentaIGan" igualTabFormato="S">
                <cfelse>
                	<cf_cuentas tabindex="1" Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" 
                  ccuenta="CcuentaIGan" cmayor="CmayorIGan" cdescripcion="CdescripcionIGan" cformato="CformatoIGan" CFcuenta="CFcuentaIGan" igualTabFormato="S">
                </cfif>
            </td>
 		</tr>
		<tr> 
			<td nowrap align="left"><strong>Concepto:&nbsp; </strong></td>
			<cfif modoarr EQ "CAMBIO">
				<td><cf_sifconceptos size="22" verclasificacion="" tabindex="1" query="#rsConcepto#">
			<cfelse>
				<td><cf_sifconceptos size="22" verclasificacion="" tabindex="1">
			</cfif>
			</td>
		</tr>
		<tr>
			<cfif modoarr EQ 'CAMBIO'>
				<td nowrap align="left"><strong>Observaciones:&nbsp; </strong></td>
				<td><textarea tabindex="1" cols="36" rows="3" name="Observaciones">#rsCatalogo.Observaciones#</textarea></td>
			<cfelse>
				<td nowrap align="left"><strong>Observaciones:&nbsp; </strong></td>
				<td><textarea tabindex="1" cols="36" rows="3" name="Observaciones"></textarea></td>
			</cfif>
		</tr>
 		<tr>
 		<td>
 		<br><br><br>
 		</td>
 		</tr>
 		<tr>
 			<td colspan="2">
 			<div align="center">
 			<cfif modosn EQ "ALTA" or modoarr EQ "ALTA">
    			<input name="Agregar"    class="btnGuardar"  tabindex="1" type="submit" value="Agregar">
    		<cfelseif modosn EQ "CAMBIO">
    			<input name="Modificar"  class="btnGuardar"  tabindex="1" type="submit" value="Modificar">
            	<input name="Eliminar"     class="btnEliminar" tabindex="1" type="submit" value="Eliminar">
            </cfif>
            	<input name="Limpiar"    class="btnLimpiar"  tabindex="1" type="button" value="Limpiar"  onClick="javascript: LimpiarFiltros(this.form);"> 
    			<input name="Regresar"   class="btnAnterior" tabindex="1" type="button" value="Regresar" onclick="window.location='CatalogoArrendamiento-list.cfm'" >
    		</div>
    		</td>
 		</tr>
 	</table>
 </cfoutput>
 </form>


<cf_qforms form='form1'>
<script type="text/javascript">
objForm.SNnombre.required=true;
objForm.SNnombre.description = "Socio de negocios";

objForm.Nombre.required=true;
objForm.Nombre.description = "Nombre Arrendamiento";

objForm.Ccodigo.required=true;
objForm.Ccodigo.description = "Concepto";

objForm.CformatoIDif.required=true;
objForm.CformatoIDif.description = "Cuenta de Ingreso Diferido";

objForm.CformatoIGan.required=true;
objForm.CformatoIGan.description = "Cuenta de Intereses Ganados";



function LimpiarFiltros(f){
	f.SNcodigo.value="";
	f.SNnumero.value="";
	f.SNnombre.value="";
	f.Nombre.value="";
	f.Ccodigo.value="";
	f.Cdescripcion.value="";
	f.CcuentaIDif.value="";
	f.CmayorIDif.value="";
	f.CformatoIDif.value="";
	f.CdescripcionIDif.value="";
	f.CcuentaIGan.value="";
	f.CmayorIGan.value="";
	f.CformatoIGan.value="";
	f.CdescripcionIGan.value="";
	f.Observaciones.value="";
}
</script>
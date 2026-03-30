<cfif isdefined("url.id_direccion") and len(trim(url.id_direccion)) and not isdefined("form.id_direccion")>
	<cfset form.id_direccion = url.id_direccion>
</cfif>
<cfif isdefined("url.tabs") and not isdefined("form.tabs")>
	<cfset form.tabs = url.tabs>
</cfif>


<cfparam name="form.id_direccion" default="">

<cfif Len(form.id_direccion)>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
</cfif>

<cfquery name="rsform" datasource="#Session.DSN#">
	select 
		SNDcodigo,
		SNnombre,
		SNcodigoext,
		SNDtelefono,
		SNDFax,
		SNDemail,
		DEidEjecutivo,
		DEidCobrador,
		id_direccion,
		SNDcodigo,
		SNnombre,
		SNcodigoext,
		SNDfacturacion,
		SNDenvio,
		SNDactivo,
		SNDlimiteFactura,
		DEid,
		SNDCFcuentaCliente,
		SNDCFcuentaProveedor,
		ts_rversion     
	from SNDirecciones
	where Ecodigo = #session.Ecodigo#
	  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">		  
	  and id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#" null="#Len(form.id_direccion) EQ 0#">
</cfquery>
<cfquery name="rsConsecutivo" datasource="#session.DSN#">
	select coalesce(count(1),0) as cuenta
	from SNDirecciones
	where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
	and Ecodigo = #session.Ecodigo#
</cfquery>

<cfset LvarDireccionPrin = 0>

<cfquery name="rsDirPrin" datasource="#session.dsn#">
	select 
		snd.id_direccion as DirDireccion, 
		sn.id_direccion as DirSocio, 
		snd.SNDcodigo as NumeroDireccion, 
		sn.SNnumero as NumeroSocio
	from SNDirecciones snd
			inner join SNegocios sn
			on sn.Ecodigo = snd.Ecodigo
			and sn.SNcodigo = snd.SNcodigo
	where snd.Ecodigo = #session.Ecodigo#
	  and snd.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">		  
	  and snd.id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#" null="#Len(form.id_direccion) EQ 0#">
</cfquery>

<cfif isdefined("rsDirPrin") && rsDirPrin.recordcount gt 0 && rsDirPrin.DirDireccion eq rsDirPrin.DirSocio>
	<cfset LvarDireccionPrin = 1>
</cfif>

<cfoutput>
<form action="SociosDireccion-sql.cfm" method="post" name="form8direccion">
	<cfif isdefined("url.SNCat") and url.SNCat eq 1>
		<input name="SNCat" value="1" type="hidden">
	</cfif>
  <table width="67%" height="75" align="center" cellpadding="0" cellspacing="2">
    <tr> 
      <td colspan="1" align="left" class="subTitulo" valign="baseline" nowrap><cfif modo neq 'ALTA'>Modificar la direcci&oacute;n </cfif></td>
	  <td>
	  	<cfif LvarDireccionPrin EQ 1>
			<strong>Esta es la dirección principal</strong>
		</cfif>
	  </td>
      </tr>
    <tr>
      <td width="27%" align="right" valign="baseline" nowrap>&nbsp;</td>
      <td valign="middle">&nbsp;</td>
    </tr>
	<tr>
      <td valign="middle" nowrap><div align="right"><strong>C&oacute;digo&nbsp;Direcci&oacute;n:</strong>&nbsp;&nbsp;</div></td>
      <td valign="middle" nowrap>
		<input name="SNDcodigo" tabindex="1" <cfif LvarDireccionPrin EQ 1>readonly</cfif> type="text" value="<cfif modo NEQ 'ALTA'>#trim(rsform.SNDcodigo)#</cfif><cfif modo EQ 'ALTA'>#trim(rsSocios.SNnumero) & '-' & (rsConsecutivo.cuenta +1)#</cfif>" size="15" maxlength="15">
	  </td>
    </tr>
	<tr>
      <td valign="middle" nowrap><div align="right"><strong>Nombre de Direccion:</strong>&nbsp;</div></td>
      <td valign="middle" nowrap><input name="SNnombre" tabindex="1" type="text" value="<cfif modo NEQ 'ALTA'>#trim(rsform.SNnombre)#</cfif>" size="40" maxlength="255" <cfif LvarDireccionPrin EQ 1>readonly</cfif>>
		 &nbsp;&nbsp; <strong>E-mail:</strong>&nbsp;
      	 <input name="SNDemail" tabindex="1" type="text" value="<cfif modo NEQ 'ALTA'>#trim(rsform.SNDemail)#</cfif>" size="20" maxlength="100" <cfif LvarDireccionPrin EQ 1>readonly</cfif>>
	  </td>
    </tr>
	<tr>
      <td valign="middle" nowrap><div align="right"><strong>Tel&eacute;fono:</strong>&nbsp;</div></td>
      <td valign="middle" nowrap><input tabindex="1" name="SNDtelefono" type="text" value="<cfif modo NEQ 'ALTA'>#trim(rsform.SNDtelefono)#</cfif>" size="15" maxlength="30" <cfif LvarDireccionPrin EQ 1>readonly</cfif>>
	     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
 	     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		 <strong>Fax:&nbsp;</strong>
      	 <input name="SNDfax" type="text" tabindex="1" value="<cfif modo NEQ 'ALTA'>#trim(rsform.SNDfax)#</cfif>" size="15" maxlength="30" <cfif LvarDireccionPrin EQ 1>readonly</cfif>>	  
	  </td>
    </tr>
	
	<tr>
      <td valign="middle" nowrap><div align="right"><strong>C&oacute;digo&nbsp;Externo:</strong>&nbsp;</div></td>
      <td valign="middle" nowrap><input name="SNcodigoext" tabindex="1" type="text" value="<cfif modo NEQ 'ALTA'>#trim(rsform.SNcodigoext)#</cfif><cfif modo EQ 'ALTA'>#trim(rsSocios.SNcodigoext) & '-' & (rsConsecutivo.cuenta +1)#</cfif>" size="30" maxlength="30" <cfif LvarDireccionPrin EQ 1>readonly</cfif>></td>
    </tr>

    <tr>
      <td valign="middle" nowrap><div align="right"><strong>L&iacute;mite de compra:</strong>&nbsp; </div></td>
      <td valign="middle"> 
	  <cfif len(rsform.SNDlimitefactura)eq 0><cfset rsform.SNDlimitefactura=0></cfif>
			<input name="SNDlimitefactura" type="text" tabindex="1"
			 onFocus="javascript: this.select();" 
			 value="#NumberFormat(rsform.SNDlimitefactura,',0.00')#" size="45" maxlength="100" alt="L&iacute;mite de compra en una sola factura">
      </td>
    </tr>
	 <tr>
      <td valign="middle" nowrap><div align="right"><strong>Cobrador Asignado:</strong>&nbsp;</div>
      </td>
    <td valign="middle">
		<cfif modo neq 'ALTA' and rsform.DEidCobrador gt 0>	
			<cfquery name="rsEmpleado2" datasource="#session.DSN#">
			select a.DEid as DEid4, a.NTIcodigo as NTIcodigo4, a.DEidentificacion as DEidentificacion4, 
				<cf_dbfunction name="concat" args="a.DEapellido1+' '+a.DEapellido2+', '" delimiters="+"> as NombreEmp4
			from DatosEmpleado a, RolEmpleadoSNegocios b
			where a.Ecodigo = #session.Ecodigo#
				and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsform.DEidCobrador#">
				and a.Ecodigo = b.Ecodigo
				and b.RESNtipoRol = 1
				and a.Ecodigo = b.Ecodigo
				and a.DEid = b.DEid
			</cfquery>
			<cf_rhempleadoCxC tabindex="1" index=4 rol=1 form='form8direccion' query=#rsEmpleado2#>
		<cfelse>
			<cf_rhempleadoCxC tabindex="1" index=4 rol=1 form='form8direccion' >
		</cfif>
	</td>
    </tr> 
    <tr>
      <td valign="middle" nowrap><div align="right"><strong>Vendedor Asignado:</strong>&nbsp;</div>
      </td>
      <td valign="middle"><cf_rhempleado tabindex="1" index=5 idempleado="#rsform.DEid#" validateComprador="true" form="form8direccion" ></td>
    </tr>
	<tr>
      <td valign="middle" nowrap><div align="right"><strong>Ejecutivo&nbsp;de&nbsp;Cuenta&nbsp;Asignado:</strong>&nbsp;</div>
      </td>
      <td valign="middle"><cf_rhempleado tabindex="1" index=6 rol=3  idempleado="#rsform.DEidEjecutivo#" form="form8direccion" ></td>
    </tr>

	<!--- Cuentas contables por direccion --->
	<tr>
		<td align="right"><strong>Cuenta Contable Cliente:&nbsp;</strong></td>
		<td colspan="2">
			<cfif modo NEQ 'ALTA' and rsform.RecordCount gt 0 >
				<cf_cuentas 
					conexion="#session.DSN#" 
					conlis="S" 
					frame="frame1" 
					auxiliares="N" 
					movimiento="S" 
					form="form8direccion" 
					ccuenta="SNDCFcuentaCliente" 
					cdescripcion="DSNDCFcuentaCliente" 
					cformato="FSNDCFcuentaCliente" 
					query="#rsform#">
			<cfelse>
				<cf_cuentas 
					conexion="#session.DSN#" 
					conlis="S" 
					frame="frame1" 
					auxiliares="N" 
					movimiento="S" 
					form="form8direccion" 
					ccuenta="SNDCFcuentaCliente" 
					cdescripcion="DSNDCFcuentaCliente" 
					cformato="FSNDCFcuentaCliente">
			</cfif>
		</td>
	</tr>
	<tr>
		<td align="right"><strong>Cuenta Contable Proveedor:&nbsp;</strong></td>
		<td colspan="2">
			<cfif modo NEQ 'ALTA' and rsform.RecordCount gt 0 >
				<cf_cuentas 
					conexion="#session.DSN#" 
					conlis="S" 
					frame="frame2" 
					auxiliares="N" 
					movimiento="S" 
					form="form8direccion" 
					Ccuenta="SNDCFcuentaProveedor" 
					cdescripcion="DSNDCFcuentaProveedor" 
					cformato="FSNDCFcuentaProveedor" 
					query="#rsform#">
			<cfelse>
				<cf_cuentas 
					conexion="#session.DSN#" 
					conlis="S" 
					frame="frame2" 
					auxiliares="N" 
					movimiento="S" 
					form="form8direccion" 
					ccuenta="SNDCFcuentaProveedor" 
					cdescripcion="DSNDCFcuentaProveedor" 
					cformato = "FSNDCFcuentaProveedor">
			</cfif>
		</td>
	</tr>
    <tr>
      <td valign="middle" nowrap><div align="right"><strong>Uso de la direcci&oacute;n:</strong>&nbsp; </div></td>
      <td width="73%" valign="middle" nowrap>
        <input type="checkbox" id="SNDfacturacion" name="SNDfacturacion" value="1" <cfif Len(form.id_direccion) eq 0 OR rsform.SNDfacturacion>checked</cfif>>
        <label for="SNDfacturacion">Facturaci&oacute;n</label> 
        <input type="checkbox" id="SNDenvio" name="SNDenvio" value="1" <cfif Len(form.id_direccion) eq 0 OR rsform.SNDenvio>checked</cfif>>
        <label for="SNDenvio">Env&iacute;o</label></td>
    </tr>
    <tr>
      <td valign="middle" nowrap><div align="right"> </div></td>
      <td width="73%" valign="middle" nowrap>
        <input tabindex="1" type="checkbox" id="SNDactivo" name="SNDactivo" value="1" <cfif Len(form.id_direccion) eq 0 OR rsform.SNDactivo>checked</cfif>>
        <label for="SNDactivo">Activo</label>
        <input type="checkbox" id="SNDPrincipal" name="SNDPrincipal">
        <label for="SNDPrincipal">Hacer Direcci&oacute;n Principal</label></td>
    </tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr> 
      <td colspan="2" align="right" valign="middle" nowrap>
	  <input type="hidden" name="id_direccion" value="#HTMLEditFormat(rsform.id_direccion)#">
	  <cfif LvarDireccionPrin EQ 1>
	  	<input type="hidden" name="DireccionPrincipal" value="1">
		<div align="center"><cf_sifdireccion action="display" key="#rsform.id_direccion#"></div>
	  <cfelse>
		<div align="center"><cf_sifdireccion action="input" key="#rsform.id_direccion#"></div>
	  </cfif>
	  </td>
    </tr>
    <tr>
      <td align="right" valign="middle" nowrap>&nbsp;</td>
      <td valign="middle">&nbsp;</td>
    </tr>
    <tr>
      <td valign="middle" nowrap>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td align="right" valign="top" nowrap>&nbsp;</td>
      <td colspan="7" align="left" valign="baseline" nowrap>&nbsp;</td>
    </tr>
    <tr> 
      <td valign="baseline" nowrap> <div align="right"></div></td>
      <td valign="baseline">&nbsp;</td>
    </tr>
    <tr> 
      <td align="right" valign="baseline" nowrap>&nbsp;</td>
      <td align="right" valign="baseline" nowrap>&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="8" align="right" valign="baseline" nowrap> <div align="center"> 
         <!---  <cfinclude template="../../portlets/pBotones.cfm"> --->
		 
		<cfif rsSocios.id_direccion EQ rsform.id_direccion>
			<cf_botones tabindex="1" modo="#modo#" exclude="Baja" sufijo="Direccion" form="form8direccion" include="Regresar">
		<cfelse>
			<cf_botones tabindex="1" modo="#modo#" sufijo="Direccion" form="form8direccion" include="Regresar">
		</cfif>
          
        </div></td>
    </tr>
  </table>
<cfset ts = "">
    <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsform.ts_rversion#"/>
	</cfinvoke>
  <input type="hidden" name="ts_rversion" value="#ts#" size="32">
  <input type="hidden" name="SNcodigo" value="#form.SNcodigo#" alt="El campo Id del Socio" > 
  <input type="hidden" name="modo" value="<cfif isdefined("form.modo")>#form.modo#</cfif>">
</form>

<cfset params= "">
<cfif isdefined("form.SNCat") and form.SNCat eq 1>
	<cfset params= params & "?SNcat=#form.SNCat#">
</cfif>
</cfoutput>

<cf_qforms form = "form8direccion">
<script language="javascript" type="text/javascript">
	
		
	objForm.SNDcodigo.required = true;
	objForm.SNDcodigo.description="Código Dirección";
	
	function deshabilitarValidacion(){
		objForm.required("SNDcodigo",false);
	}
	<cfoutput>
		function funcRegresarDireccion(){
			document.form8direccion.action="SociosDireccion.cfm#params#";
			document.form8direccion.submit();
		}
	</cfoutput>
</script>


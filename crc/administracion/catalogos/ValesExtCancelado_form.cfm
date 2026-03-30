<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CodTienda" Default="C&oacute;digo" returnvariable="LB_CodTienda"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DescripTienda" Default="Descripci&oacute;n" returnvariable="LB_DescripTienda"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_IdDistribuidor" Default="Id Distribuidor" returnvariable="LB_IdDistribuidor"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NombreDis" Default="Nombre" returnvariable="LB_NombreDis"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Direccion" Default="Direcci&oacute;n" returnvariable="LB_Direccion"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FolioINI" Default="Folio Inicial" returnvariable="LB_FolioINI"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FolioFIN" Default="Folio Final" returnvariable="LB_FolioFIN"/>



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

<cfif isdefined("url.id") and Len("url.id") gt 0>
	<cfset form.id = url.id >
</cfif>

<cfif isdefined("Session.Ecodigo") and isdefined("Form.id") and not isDefined("Form.Nuevo")>
	<cfset modo="CAMBIO">
</cfif>

<cfset datosTiendaF = "">
<cfif modo eq "CAMBIO">
	<cfquery name="rsEstatu" datasource="#Session.DSN#">
		SELECT A.id,A.Folio,A.CRCTiendaExternaid,
			A.FechaCancelado,A.Observaciones,A.Ecodigo,
			B.id as idT,B.Codigo as CodigoT,B.Descripcion as DescipT, A.CRCCuentasid cuentasid
		FROM CRCValesExtCancelados A
		left join CRCTiendaExterna B
			on B.id = A.CRCTiendaExternaid
		WHERE A.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and A.id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
		

	</cfquery>
	<cfset datosTiendaF = "#rsEstatu.idT#,#rsEstatu.CodigoT#,#rsEstatu.DescipT#">
</cfif>

<cfset datosDistribuidor = ",,">
<cfif modo eq "CAMBIO">
	<cfquery name="rsDis" datasource="#Session.DSN#">
		select cc.id, cc.Numero, replace(sn.SNnombre,',','') SNnombre from SNegocios sn
		inner join CRCCuentas cc 
			on cc.SNegociosSNid = sn.SNid 
		inner join CRCValesExtCancelados ve 
			on ve.CRCCuentasid = cc.id
		where sn.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and ve.id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
		and  cc.Tipo = 'D'
	</cfquery>
	<cfset datosDistribuidor = "#rsDis.id#,#rsDis.Numero#,#rsDis.SNnombre#">
</cfif>

<SCRIPT SRC="../../js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
	function soloNumeros(e)
	{
		var keynum = window.event ? window.event.keyCode : e.which;
		if ((keynum == 8) || (keynum == 0))
		return true;
		return /\d/.test(String.fromCharCode(keynum));
	}

</SCRIPT>

<script language="JavaScript">

	function deshabilitarValidacion(){
		objForm.Orden.required = false;
		objForm.Descripcion.required = false;
	}

</script>
<cfoutput>


<!---Redireccion ConfiguracionParametros_sql.cfm --->
<form method="post" name="form1" action="ValesExtCancelado_sql.cfm">
	<table align="center" width="100%" cellpadding="1" cellspacing="0">
		<tr valign="baseline">
			<td nowrap align="right">#LB_FolioINI#:&nbsp;
			</td>
			<td nowrap align="left">
				<input type="text" name="folio" tabindex="1" style="text-transform:uppercase" required
					value="<cfif modo NEQ "ALTA">#rsEstatu.folio#</cfif>"
					size="10" maxlength="50" onfocus="javascript:this.select();" >
				#LB_FolioFIN#:&nbsp;
				<input type="text" name="folioFIN" tabindex="1" style="text-transform:uppercase" 
					size="10" maxlength="50" onfocus="javascript:this.select();" >
			</td>
		</tr>
		<tr>
			<td nowrap align="right">Tienda:&nbsp;</td>
			<td>
				<cf_conlis
					Campos="idTienda,CodigoTienda,DescripTienda"
					Values="#datosTiendaF#"
					Desplegables="N,S,S"
					Modificables="N,N,N"
					Size="0,10,30"
					tabindex="1"
					Tabla="CRCTiendaExterna"
					Columnas="id as idTienda,Codigo as CodigoTienda,Descripcion as DescripTienda"
					form="form1"
					Filtro="Ecodigo = #Session.Ecodigo#"
					Desplegar="CodigoTienda,DescripTienda"
					Etiquetas="#LB_CodTienda#, #LB_DescripTienda#"
					filtrar_por="Codigo,Descripcion"
					Formatos="S,S"
					Align="left,left"
					Asignar="idTienda,CodigoTienda,DescripTienda"
					Asignarformatos="S,S,S"/>
			</td>
		</tr>
		<tr>
			<td nowrap align="right">Distribuidor:&nbsp;</td>
			<td>
				<cfset tipoSN = "D">
				<cf_conlis
						Campos="idCuenta,numCuenta,Nombre"
						values="#datosDistribuidor#"
						Desplegables="N,S,S"
						Modificables="S,S,S"
						Size="0,15,30"
						tabindex="1"
						Tabla="SNegocios sn inner join CRCCuentas cc on cc.SNegociosSNid = sn.SNid"
						Columnas="
								cc.id as idCuenta
							, replace(sn.SNnombre,',','') as Nombre
							, cc.Numero numCuenta
							, sn.SNidentificacion
							, sn.SNid"
						form="form1"
						Filtro="sn.Ecodigo = #Session.Ecodigo# and cc.Tipo = 'D'"
						Desplegar="numCuenta,SNidentificacion, Nombre"
						Etiquetas="Numero de Cuenta, Identificacion del Socio, Nombre del Socio"
						filtrar_por="cc.Numero,sn.SNidentificacion,sn.SNnombre"
						Formatos="S,S,S"
						Align="left,left,left"
						Asignar="idCuenta,SNid,Nombre,numCuenta"
						Asignarformatos="S,S,S"/>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right" valign="middle"> Observaciones:&nbsp; </td>
			<td>
				<input type="text" name="observaciones" tabindex="1" required
				value="<cfif modo NEQ "ALTA">#rsEstatu.Observaciones#</cfif>"
				size="30" maxlength="255" onfocus="javascript:this.select();" >
			</td>
		</tr>
		<tr valign="baseline">
			<td colspan="2" align="right" nowrap>
				<div align="center">
					<script language="JavaScript" type="text/javascript">
						// Funciones para Manejo de Botones
						botonActual = "";

						function setBtn(obj) {
							botonActual = obj.name;
						}
						function btnSelected(name, f) {
							if (f != null) {
								return (f["botonSel"].value == name)
							} else {
								return (botonActual == name)
							}
						}
					</script>

					<input tabindex="-1" type="hidden" name="botonSel" value="">
					<input tabindex="-1" name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
					<cfif modo eq 'ALTA'>
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Agregar"
							Default="Agregar"
							XmlFile="/crc/generales.xml"
							returnvariable="BTN_Agregar"/>

							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Limpiar"
							Default="Limpiar"
							XmlFile="/crc/generales.xml"
							returnvariable="BTN_Limpiar"/>

						<input type="submit" tabindex="3" name="Alta" value="#BTN_Agregar#" onClick="javascript: this.form.botonSel.value = this.name; return funcAgregar();">
						<input type="reset" tabindex="3" name="Limpiar" value="#BTN_Limpiar#" onClick="javascript: this.form.botonSel.value = this.name">
					<cfelse>
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Eliminar"
							Default="Eliminar"
							XmlFile="/crc/generales.xml"
							returnvariable="BTN_Eliminar"/>

							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_DeseaElimarElRegistro"
							Default="Desea Eliminar el Registro?"
							XmlFile="/crc/generales.xml"
							returnvariable="LB_DeseaElimarElRegistro"/>

							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Nuevo"
							Default="Nuevo"
							XmlFile="/crc/generales.xml"
							returnvariable="BTN_Nuevo"/>

						<input tabindex="3" type="submit" name="Baja" value="#BTN_Eliminar#" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('#LB_DeseaElimarElRegistro#') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
						<input tabindex="3" type="submit" name="Nuevo" value="#BTN_Nuevo#" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); ">
					</cfif>
				</div>
			</td>
		</tr>
		<tr>
		  <td>&nbsp;</td>
		</tr>
		<tr valign="baseline">
			<input tabindex="-1" type="hidden" name="id" value="<cfif modo NEQ "ALTA">#rsEstatu.id#</cfif>">
			<input tabindex="-1" type="hidden" name="Pagina"
			value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ "">#Pagenum_lista#<cfelseif isdefined("Form.PageNum")>#PageNum#</cfif>">
			<cfif modo NEQ "ALTA">
				<td colspan="2" align="right" nowrap>
					<div align="center">
					</div>
				</td>
			</cfif>
		</tr>
	</table>
</form>
</cfoutput>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Descripcion" Default="Descripci�n" XmlFile="/crc/generales.xml" returnvariable="MSG_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Orden" Default="Orden" XmlFile="/crc/generales.xml" returnvariable="MSG_Orden"/>

<cf_qforms>
	<cf_qformsRequiredField name="Orden" description="#MSG_Orden#">
	<cf_qformsRequiredField name="Descripcion" description="#MSG_Descripcion#">
</cf_qforms>

<script>
	function funcAgregar(){
		var f1 = document.form1.folio.value;
		var f2 = document.form1.folioFIN.value;

		if(f1.trim() != '' && f2.trim() != ''){
			return confirm("Seguro quiere agregar los folios desde "+f1.trim()+" hasta "+f2.trim());
		}

		return true;

	}
</script>
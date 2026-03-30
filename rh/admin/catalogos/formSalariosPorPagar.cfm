
<cfif isDefined("Form.CBID") and len(trim(Form.CBid)) gt 0>
	<cfset Form.modo = "EDITAR">
<cfelse>	
	<cfset Form.modo='ALTA'>
</cfif>
<cfif isdefined('form.btneliminar')>
	<cfinclude template="SalariosPorPagar-sql.cfm">
</cfif>
<!--- VARIABLES DE TRADUCCION --->

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EstaCuentaYaFueAgregada"
	Default="Esta Cuenta ya fue agregada"
	returnvariable="MSG_EsteEmpleadoYaFueAgregado"/>
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BotonCambiar"
	Default="Modificar"
	XmlFile="/sif/rh/generales.xml"
	returnvariable="BotonCambiar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BotonBorrar"
	Default="Eliminar"
	XmlFile="/sif/rh/generales.xml"
	returnvariable="BotonBorrar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BotonNuevo"
	Default="Nuevo"
	XmlFile="/sif/rh/generales.xml"
	returnvariable="BotonNuevo"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BotonAgregar"
	Default="Agregar"
	XmlFile="/sif/rh/generales.xml"
	returnvariable="BotonAgregar"/>	
	
	
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Bcodigo"
	Default="Codigo Banco"	
	returnvariable="LB_Bcodigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Bdescripcion"
	Default="Descripcion Banco"	
	returnvariable="LB_Bdescripcion"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CBcodigo"
	Default="Codigo Cuenta Bancaria"	
	returnvariable="LB_CBcodigo"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CBdescripcion"
	Default="Descripcion Cuenta Bancaria"	
	returnvariable="LB_CBdescripcion"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Cdescripcion"
	Default="Cuenta por Pagar"	
	returnvariable="LB_Cdescripcion"/>		

	<cf_dbfunction name="OP_concat" returnvariable="concat">
	<cfif isdefined('form.modo') and form.modo eq 'EDITAR'>
		<cfquery name="rsCuentasBancos" datasource="#session.dsn#">
			SELECT 	b.Bid, b.Ecodigo,b.Bcodigo, b.Bdescripcion,b.Bcodigocli,cb.Ccuenta, cb.Ccuentacom, cb.CBcc, cb.CBcodigo, cb.CBdescripcion, cb.CBid, cb.CcuentaCxP
			FROM CuentasBancos cb inner join Bancos b 
				on cb.Bid=b.Bid 
				and cb.Ecodigo=b.Ecodigo
			where cb.Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
		</cfquery>
	</cfif>

	<cf_web_portlet_start border="false" skin="#Session.Preferences.Skin#" tituloalign="center" >

	<form action="SalariosPorPagar-sql.cfm" method="post" name="form1">
	<cfif isdefined('form.modo') and form.modo eq 'EDITAR'>
		<input type="hidden" name="modo" value="">
		<cfif isdefined('form.modo') and form.modo eq 'EDITAR'>
		<input type="hidden" name="CBid" value="<cfoutput>#form.CBid#</cfoutput>">
		</cfif>
		<div align="center">
		<table border="0" cellspacing="0" cellpadding="0" style="margin:0">
		  <tr><td>&nbsp;</td></tr>
		  <tr bgcolor="FAFAFA" align="left"> 
			<td nowrap class="filelabel"  colspan="2"><b>&nbsp;Banco:</b>
				<cfoutput>
				<cfif isdefined('form.modo') and form.modo eq 'EDITAR'>
					#rsCuentasBancos.Bcodigo# - #rsCuentasBancos.Bdescripcion#
				<cfelse>
					<i>Seleccione un Banco</i>
				</cfif>	
				</cfoutput>
			</td>	
		</tr>
	     <tr><td>&nbsp;</td></tr>
	  	<tr bgcolor="FAFAFA" align="left"> 
			<td nowrap class="filelabel" colspan="2"><b>&nbsp;Cuenta Bancaria:</b>
				<cfoutput>
				<cfif isdefined('form.modo') and form.modo eq 'EDITAR'>
					#rsCuentasBancos.CBcodigo# - #rsCuentasBancos.CBdescripcion#
				<cfelse>
					<i>Seleccione un Banco</i>
				</cfif>
				</cfoutput>
			</td>
		 </tr>	
		  <tr><td>&nbsp;</td></tr>
		<tr valign="baseline">
			<td nowrap align="left" valign="middle"><b>&nbsp;Cuenta por Pagar:</b></td>
			<td nowrap align="left">
					<div>
					<cfif modo NEQ "ALTA" and isDefined("rsCuentasBancos.CcuentaCxP") and Len(Trim(rsCuentasBancos.CcuentaCxP)) GT 0>
						<cfquery name="rsCuenta" datasource="#Session.DSN#">
							select Ccuenta, Cdescripcion, Cformato from CContables
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							 and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentasBancos.CcuentaCxP#">
						</cfquery>
						<cf_cuentas tabindex="1" Conexion="#Session.DSN#" Conlis="S" query="#rsCuenta#" auxiliares="N" movimiento="S" 
						ccuenta="Ccuenta" cdescripcion="Cdescripcion" cformato="Cformato">
					<cfelse>
						<cf_cuentas tabindex="1" Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" ccuenta="Ccuenta" 
						cdescripcion="Cdescripcion" cformato="Cformato">
					</cfif>	
					</div>
			</td>
		  </tr>
		  <tr><td>&nbsp;</td></tr>
		  <tr align="center">
			<td nowrap align="center" colspan="4">
				<cfoutput>
					&nbsp;<input type="submit" alt="9" class="btnGuardar" name='DCambio' value="#BotonCambiar#" onClick="javascript: return setBtn(this);" tabindex="3">						
					&nbsp;<input type="submit" alt="9" class="btnEliminar" name='DBorrar' value="#BotonBorrar#" onClick="javascript: return setBtn(this);" tabindex="4">						
					
				</cfoutput>	
			</td>
		  </tr>
			  
		</table>
	</div>
	</cfif>
	</form>
	<cf_web_portlet_end>


<cfset filtro = " cb.Ecodigo = #session.Ecodigo# ">

<cfif isdefined('form.filtro_Bcodigo') and Len(Trim(form.filtro_Bcodigo))>
	<cfset filtro = filtro & " and Upper(b.Bcodigo) like '%#ucase(trim(form.filtro_Bcodigo))#%' ">
</cfif>

<cfif isdefined('form.filtro_Bdescripcion') and Len(Trim(form.filtro_Bdescripcion))>
	<cfset filtro = filtro & " and Upper(b.Bdescripcion) like '%#ucase(trim(form.filtro_Bdescripcion))#%' ">
</cfif>
<cfif isdefined('form.filtro_CBcodigo') and Len(Trim(form.filtro_CBcodigo))>
	<cfset filtro = filtro & " and Upper(cb.CBcodigo) like '%#ucase(trim(form.filtro_CBcodigo))#%' ">
</cfif>
<cfif isdefined('form.filtro_CBdescripcion') and Len(Trim(form.filtro_CBdescripcion))>
	<cfset filtro = filtro & "and Upper(cb.CBdescripcion) like '%#ucase(trim(form.filtro_CBdescripcion))#%' ">
</cfif>
<cfif isdefined('form.filtro_Cdescripcion') and Len(Trim(form.filtro_Cdescripcion))>
	<cfset filtro = filtro & "and Upper(cc.Cdescripcion) like '%#ucase(trim(form.filtro_Cdescripcion))#%' ">
</cfif>
			<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="CuentasBancos cb 
														inner join Bancos b 
																on cb.Bid=b.Bid 
																and cb.Ecodigo=b.Ecodigo 
														left join CContables cc
																on cb.CcuentaCxP=cc.Ccuenta
																and cb.Ecodigo=cc.Ecodigo"/>
				<cfinvokeargument name="columnas" value="b.Bid, cb.CBid, b.Ecodigo,b.Bcodigo, b.Bdescripcion,cb.Ccuenta, cb.CBcodigo, cb.CBdescripcion, cc.Cdescripcion"/>
				<cfinvokeargument name="desplegar" value="Bcodigo, Bdescripcion,CBcodigo, CBdescripcion, Cdescripcion"/>
				<cfinvokeargument name="etiquetas" value="#LB_Bcodigo#,#LB_Bdescripcion#,#LB_CBcodigo#,#LB_CBdescripcion#, #LB_Cdescripcion#"/>
				<cfinvokeargument name="formatos" value="S,S,S,S,S"/>
				<cfinvokeargument name="filtro" value="#filtro# order by b.Bcodigo, b.Bdescripcion, cb.CBcodigo, cb.CBdescripcion, cc.Cdescripcion"/>
				<cfinvokeargument name="align" value="left,left,left,left, left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="SalariosPorPagar.cfm"/>
				<cfinvokeargument name="showEmptyListMsg" value="true">
				<cfinvokeargument name="mostrar_filtro" value="true">
				<cfinvokeargument name="filtrar_automatico" value="true">
				<cfinvokeargument name="incluyeForm" value="true">
				<cfinvokeargument name="formname" value="listaFormu">
				<cfinvokeargument name="debug" value="N">
				<cfinvokeargument name="index" value="10">
			</cfinvoke>
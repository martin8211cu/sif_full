<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_UsuariosEmpresas"
Default="Usuarios / Empresa"
returnvariable="LB_UsuariosEmpresas"/>	
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<!--- Querys para hacer lista --->
<cfquery name="RsUsuarios" datasource="asp">
	select  a.Usucodigo,a.Usulogin,	b.Pnombre #_Cat# ' ' #_Cat# b.Papellido1 #_Cat#' ' #_Cat# b.Papellido2 as nombre
	from Usuario a 
	inner join DatosPersonales b on b.datos_personales = a.datos_personales
	where CEcodigo    =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CEcodigo#">
</cfquery>

<cfquery name="rsEImportadorUsuario" datasource="sifcontrol">	
	select Ecodigo,EIid,Usucodigo,
	'<img border=''0'' onClick=''eliminar(' #_Cat# <cf_dbfunction name="to_char" args="Usucodigo" datasource="sifcontrol"> #_Cat# ');'' src=''/cfmx/sif/imagenes/Borrar01_S.gif''>' Eliminable
	from EImportadorUsuario
	where EIid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EIid#">
	and  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
</cfquery>

<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		<cfoutput>#LB_UsuariosEmpresas#</cfoutput>
	</cf_templatearea>
	<cf_templatearea name="body">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td valign="top">
				<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_UsuariosEmpresas#'>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>
							<cfinclude template="/sif/portlets/pNavegacion.cfm">					
						</td>
					</tr>
				</table>					
				<table width="100%"  border="0">
					<tr>
						<td  valign="top" width="50%">
							<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
								<tr>

									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="LB_Nombre"
									Default="Nombre"
									returnvariable="LB_Nombre"/>
									
									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="LB_Login"
									Default="Login"
									returnvariable="LB_Login"/>	
									
									<form name="fBusqueda" method="post">
										<td  align="left"><strong><cfoutput>#LB_Login#</cfoutput>:</strong></td>
										<td  align="left">
											<input name="Flogin" type="text" size="30" maxlength="30" 
											value="<cfif isDefined("form.Flogin")><cfoutput>#form.Flogin#</cfoutput></cfif>"
											onFocus="this.select()">&nbsp;
										</td>	
										<td  align="left"><strong><cfoutput>#LB_Nombre#</cfoutput>:</strong></td>
										<td  align="left">
											<input name="FNombreUsuario" type="text" size="30" maxlength="30" 
											value="<cfif isDefined("form.FNombreUsuario")><cfoutput>#form.FNombreUsuario#</cfoutput></cfif>"
											onFocus="this.select()">&nbsp;
										</td>										
										
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="BTN_Filtrar"
										Default="Filtrar"
										returnvariable="BTN_Filtrar"/>
										
										<td width="15%" align="center"><input name="btnFiltrar" type="submit" value="<cfoutput>#BTN_Filtrar#</cfoutput>"></td>
										<td width="58%" align="left">&nbsp;</td>
										<cfoutput>
										<input name="EIid"      type="hidden" value="<cfif isdefined("form.EIid")><cfoutput>#Form.EIid#</cfoutput></cfif>">
										<input name="CEcodigo"  type="hidden" value="<cfif isdefined("form.CEcodigo")>#Form.CEcodigo#</cfif>">
										<input name="Ecodigo"   type="hidden" value="<cfif isdefined("form.Ecodigo")>#Form.Ecodigo#</cfif>">
										<input name="Enombre"   type="hidden" value="<cfif isdefined("form.Enombre")>#Form.Enombre#</cfif>">
										<input name="MODODET"   type="hidden">
										<input name="MODO"      type="hidden">
										<input name="Usucodigo" type="hidden">
										</cfoutput>
									</form>
								</tr>
							</table>	
							
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td  colspan="4">
										<cfquery name="rsLista"  dbtype="query">	
											select  RsUsuarios.Usucodigo,RsUsuarios.Usulogin,nombre,Ecodigo,EIid,Eliminable
											from RsUsuarios, rsEImportadorUsuario 
											where RsUsuarios.Usucodigo = rsEImportadorUsuario.Usucodigo
											and EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EIid#">
											<cfif isdefined("form.FNombreUsuario")  and Len(Trim(form.FNombreUsuario)) NEQ 0>
												and UPPER(nombre) like '%#Ucase(Form.FNombreUsuario)#%'
											</cfif>
											<cfif isdefined("form.Flogin")  and Len(Trim(form.Flogin)) NEQ 0>
												and UPPER(RsUsuarios.Usulogin) like '%#Ucase(Form.Flogin)#%'
											</cfif>
											order by RsUsuarios.Usulogin
										</cfquery>

										<cfinvoke
											component="sif.Componentes.pListas"
											method="pListaQuery"
											returnvariable="pListaRet"
												query="#rsLista#"
												desplegar="Usulogin,nombre,Eliminable"
												etiquetas="#LB_Login#,#LB_Nombre#,&nbsp;"
												formatos="S,S,S"
												align="left,left,left"
												ajustar="N"
												checkboxes="N"
												irA="IMP_UsuariosXEmpresas.cfm"
												keys="Usulogin,Ecodigo,EIid"
												showEmptyListMsg="true"
												showlink="false"
												maxrows="10" />
									</td>								
								</tr> 
							</table>
						</td>
						<td valign="top"> <cfinclude template="formUsuariosXEmpresas.cfm"></td>
					</tr>
				</table>	
				<cf_web_portlet_end>
			</td>
	  	</tr>
	</table>
	</cf_templatearea>
</cf_template>

<script language="javascript" type="text/javascript">
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_DeseaEliminarElUsuario"
	Default="¿Desea eliminar el usuario?"
	returnvariable="LB_DeseaEliminarElUsuario"/> 

	function eliminar(llave){
		if (confirm('<cfoutput>LB_DeseaEliminarElUsuario</cfoutput>')){
			document.fBusqueda.MODODET.value = 'BAJA';
			document.fBusqueda.Usucodigo.value = llave;			
			document.fBusqueda.action = "SQLUsuariosXEmpresas.cfm"
			document.fBusqueda.submit();
		}else{
			return false;
		}
	}

</script>
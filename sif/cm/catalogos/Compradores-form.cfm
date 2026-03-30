<!---
	Modificado por: Yu Hui 26 de Mayo 2005
	Motivo: Cambio de Tag de Empleados

	Modificado por: Rebeca Corrales 20 de Julio 2005
	Motivo: Opcion en modo Cambio para definir y
	dar mantenimiento a Usuarios Autorizados si
	el parametro "Multiples Contratos simultanemamente
	para articulos o servicios" se encuentra activo
--->
<cfinclude template="../../Utiles/sifConcat.cfm">
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

<!---►►Se valida que el Comprador no este Asignado a un centro Funcional,
	   ya que podria existir Solicitudes que se Asignarian a un Comprador, que ya no existe◄◄--->
<cfquery name="rsCompradorCF" datasource="#session.dsn#">
    SELECT COUNT(1) AS total
    FROM CMCompradores cp
	    INNER JOIN CFuncional cf
    		ON cp.CMCid = cf.CFcomprador
    WHERE cp.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    <cfif modo EQ "CAMBIO">
    	AND cp. CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMCid#">
    <cfelse>
        AND 1 = 2
    </cfif>
</cfquery>

<cfquery name="rsRH" datasource="#Session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Pcodigo = 520
</cfquery>

<cfif isDefined("Form.Nuevo")>
	<cfquery name="rsJefe" datasource="#Session.DSN#">
		select CMCid, CMCnombre, CMCnivel, Usucodigo, ts_rversion
		from CMCompradores
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMCid#">
	</cfquery>

</cfif>

<cfif isdefined("Form.CMCid") and Len(Trim(Form.CMCid)) GT 0 and not isDefined("Form.Nuevo")>
	<cfset modo="CAMBIO">
</cfif>

<cfif modo NEQ "ALTA">
	<!--- Recupera los valores de la tabla CMCompradores --->
	<cfquery name="rsComprador" datasource="#Session.DSN#">
		select 	CMCid, Ecodigo, DEid, CMCnombre, coalesce(CMCjefe,-1) as CMCjefe, CMCdefault,
				CMCestado, Usucodigo, CMCnivel, CMTStarticulo, CMTSservicio, CMTSactivofijo,CMTSobra,
				CMCcodigo, Mcodigo, CMCmontomax, CMCautorizador, CMCparticipa, ts_rversion
		from CMCompradores
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMCid#">
	</cfquery>

	<!--- Recupera Usucodigo para este Comprador de UsuarioReferencia --->
	<cfquery name="rsUsuario" datasource="asp">
		select Usucodigo
		from UsuarioReferencia
		where llave=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsComprador.CMCid#">
			and Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
			and STabla='CMCompradores'
	</cfquery>

<cfif rsComprador.RecordCount GT 0 and len(trim(rsComprador.CMCjefe)) NEQ "-1">
		<cfquery name="rsNombreUsuario" datasource="asp">
			select Pnombre #_Cat#' '#_Cat# Papellido1 #_Cat#' '#_Cat# Papellido2  as NombreJefe
			from Usuario a, DatosPersonales b
			where a.Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsComprador.CMCjefe#">
			  and a.datos_personales=b.datos_personales
		</cfquery>
		<cfset tieneJefe = true>
	<cfelse>
		<cfset tieneJefe = false>
	</cfif>

</cfif>

<script src="../../js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<cfoutput>

<style type="text/css">
.mensajeValidacion{
		text-align:center;
		font-size:9.5px;
		font-weight:bold;
		color:C30;
	}
</style>

<form action="Compradores-sql.cfm" method="post" name="form1" onSubmit="return validar();" enctype="multipart/form-data" >
	<input type="hidden" name="BtnImagen" value="">
	<table width="100%" border="0" cellspacing="2" cellpadding="0">
    	<tr>
      		<td align="right" nowrap>
        		<cfif modo EQ "ALTA" and isDefined("Form.Nuevo")>
          			<strong>Jefe:&nbsp;</strong>
        		</cfif>
      		</td>
      		<td colspan="3" nowrap>
        		<cfif modo EQ "ALTA" and isDefined("Form.Nuevo")>
          			<strong>#rsJefe.CMCnombre#</strong>
          			<input type="hidden" name="CMCjefeid" value="#rsJefe.CMCid#">
          			<input type="hidden" name="UsucodigoJefe" value="#rsJefe.Usucodigo#">
          			<input type="hidden" name="CMCnivelJefe" value="#rsJefe.CMCnivel#">
        		</cfif>
      		</td>
      		<td width="100">&nbsp;</td>
    	</tr>

		<tr>
		  <td align="right" nowrap><strong>C&oacute;digo:</strong>&nbsp;</td>
		  <td nowrap><input name="CMCcodigo" type="text" <cfif modo neq "ALTA">readonly="true"</cfif>  id="CMCcodigo" value="<cfif modo neq "ALTA"><cfoutput>#HTMLEditFormat(rsComprador.CMCcodigo)#</cfoutput></cfif>" size="10" maxlength="10" onFocus="this.select();"  alt="El C&oacute;digo del Solicitante ">
		  <input type="hidden" name="CMCcodigo_old" id="CMCcodigo_old"  value="<cfif modo neq "ALTA"><cfoutput>#HTMLEditFormat(rsComprador.CMCcodigo)#</cfoutput></cfif>">
		  </td>
		  <td nowrap align="right">
            <input type="checkbox" name="CMCdefault" value="<cfif modo NEQ "ALTA">#rsComprador.CMCdefault#</cfif>" <cfif modo NEQ "ALTA" and #rsComprador.CMCdefault# EQ "1"> checked </cfif>>
          </td>
		  <td nowrap><strong>Comprador Default</strong> </td>
		  <td>&nbsp;</td>
	  </tr>

		<tr>
      		<td align="right" nowrap><strong>Nombre:</strong>&nbsp;</td>
      		<td nowrap>
				<cfif modo neq 'ALTA'>
					<input type="hidden" name="_Usucodigo" value="#rsUsuario.Usucodigo#">
				</cfif>
				<cfif rsRH.RecordCount GT 0 and rsRH.Pvalor EQ 'S'>
					<!---
					<cfif modo NEQ 'ALTA'>
						<cf_rhempleados conlis='false' idempleado="#rsComprador.DEid#" size="40">
					<cfelse>
						<cf_rhempleados size="40">
					</cfif>
					--->
					<cfif modo NEQ "ALTA">
						<cf_rhempleado size="40" Nombre="Nombre" DEidentificacion="Pid" validateUser="true" idempleado="#rsComprador.DEid#" readonly="true">
					<cfelse>
						<cf_rhempleado size="40" Nombre="Nombre" DEidentificacion="Pid" validateUser="true">
					</cfif>
				<cfelse>
					<cfif modo neq 'ALTA'>
						<cf_sifusuarioE conlis='false' idusuario="#rsUsuario.Usucodigo#" size="40">
					<cfelse>
						<cf_sifusuarioE size="40">
					</cfif>
				</cfif>
      		</td>
      		<td nowrap align="right">
              <input type="checkbox" name="CMCestado" value="<cfif modo NEQ "ALTA">#rsComprador.CMCestado#</cfif>" <cfif modo NEQ "ALTA"><cfif #rsComprador.CMCestado# EQ "1"> checked</cfif><cfelse> checked</cfif>>
            </td>
      		<td nowrap><strong>Activo</strong> </td>
      		<td width="100">&nbsp;</td>
    	</tr>

		<tr>
      		<td align="right"><strong>Jefe:</strong>&nbsp;</td>
      		<td nowrap>
        		<input name="CMCjefenom" type="text" value="<cfif modo NEQ "ALTA" and isDefined("rsNombreUsuario") >#rsNombreUsuario.NombreJefe#</cfif>" id="CMCjefenom3" size="40" maxlength="80" readonly tabindex="-1">
        		<a href="##" tabindex="-1">
					<img src="../../imagenes/Description.gif" alt="Lista de Jefes" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisJefes();">
				</a>
        		<input name="CMCjefe" type="hidden" id="CMCjefe2" value="<cfif modo NEQ "ALTA">#rsComprador.CMCjefe#</cfif>">
        		<input name="CambioJefe" type="hidden" id="CambioJefe2" value="">
      		</td>

      		<td nowrap align="right"><input type="checkbox" name="CMCautorizador" value="<cfif modo NEQ "ALTA">#rsComprador.CMCautorizador#</cfif>" <cfif modo NEQ "ALTA"><cfif rsComprador.CMCautorizador EQ "1">checked</cfif></cfif>></td>
      		<td nowrap><strong>Es autorizador</strong></td>
      		<td width="100">&nbsp;</td>
    	</tr>

		<tr>
		  <td align="right"><strong>Moneda:</strong>&nbsp;</td>
		  <td><cfif modo neq 'ALTA'>
              <cf_sifmonedas query="#rsComprador#">
              <cfelse>
              <cf_sifmonedas>
            </cfif>
          </td>
		  <td nowrap align="right"><input type="checkbox" name="CMCparticipa" value="<cfif modo NEQ "ALTA">#rsComprador.CMCparticipa#</cfif>" <cfif modo NEQ "ALTA"><cfif rsComprador.CMCparticipa EQ "1"> checked</cfif></cfif>></td>
		  <td nowrap><strong>Participa en asignaci&oacute;n de cargas de trabajo</strong></td>
	  </tr>
		<tr>
		  <td align="right" nowrap><strong>Monto Máximo:</strong>&nbsp;</td>
		  <td><input name="CMCmontomax" type="text" value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsComprador.CMCmontomax,'none')#<cfelse>0.00</cfif>" size="18" maxlength="18" style="text-align:right" onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" onBlur="javascript:fm(this,2);" onFocus="javascript:this.value=qf(this.value); this.select();"  >
          </td>
      		<cfif modo neq 'ALTA'>
				<td><a href="##" tabindex="-1"> <img src="../../imagenes/Description.gif" alt="cambiar firma" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisFirma();"> </a> </td>
				<td nowrap><strong>Actualizar Firma Digital:</strong>&nbsp;</td>
			<cfelse>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</cfif>
		</tr>

		<tr>
      		<td align="right" nowrap>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2" rowspan="3" align="center" valign="middle">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="1%">
							<cfif modo neq 'ALTA'>
								<cfquery datasource="#session.dsn#" name="compradorts">
									select CMFfirma, ts_rversion
									from CMFirmaComprador
									where CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid#">
								</cfquery>
								<cfif Len(compradorts.CMFfirma) GT 1>
									<cfinvoke component="sif.Componentes.DButils"
											  method="toTimeStamp"
											  returnvariable="tsurl">
										<cfinvokeargument name="arTimeStamp" value="#compradorts.ts_rversion#"/>
									</cfinvoke>
									<cfset ts2 = LSTimeFormat(Now(), 'hhmmss')>
									<img src="/cfmx/sif/cm/catalogos/firma_comprador.cfm?CMCid=#form.CMCid#&ts=#tsurl#&ts2=#ts2#" border="0">
								</cfif>
							</cfif>
						</td>
						<cfif modo neq 'ALTA'>
							<cfif Len(compradorts.CMFfirma) GT 1>
								<td valign="middle">
									<img alt="Eliminar Imagen" src="../../imagenes/Borrar01_S.gif" onClick="javascript:eliminar_imagen();" style="cursor:hand;">

								</td>
							</cfif>
						</cfif>
					</tr>
				</table>
			</td>

		</tr>

		<tr>
			<td align="right" nowrap>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>

		<tr><td>&nbsp;</td></tr>
		<tr>
      		<td align="right">&nbsp;</td>
      		<td colspan="4" nowrap>
        		<fieldset style="width:95%"><legend><strong>&nbsp;Tipos de Compra permitidos en registro de Ordenes de Compra&nbsp;</strong></legend>
        		<table width="100%" cellpadding="2" cellspacing="0" border="0" >
          			<tr>
            			<td>
              				<input type="checkbox" name="CMTSarticulo" value="<cfif modo NEQ "ALTA">#rsComprador.CMTStarticulo#</cfif>" <cfif modo NEQ "ALTA" and rsComprador.CMTStarticulo EQ "1">checked</cfif> >
              				<strong>Art&iacute;culo</strong>
						</td>
            			<td>
              				<input type="checkbox" name="CMTSactivofijo" value="<cfif modo NEQ "ALTA">#rsComprador.CMTSactivofijo#</cfif>" <cfif modo NEQ "ALTA" and rsComprador.CMTSactivofijo EQ "1">checked</cfif> >
              				<strong>Activo Fijo</strong>
						</td>
            			<td>
              				<input type="checkbox" name="CMTSservicio" value="<cfif modo NEQ "ALTA">#rsComprador.CMTSservicio#</cfif>" <cfif modo NEQ "ALTA" and rsComprador.CMTSservicio EQ "1">checked</cfif> >
              				<strong>Servicio</strong>
						</td>
							<td>
              				<input type="checkbox" name="CMTSobra" value="<cfif modo NEQ "ALTA">#rsComprador.CMTSobra#</cfif>" <cfif modo NEQ "ALTA" and rsComprador.CMTSobra EQ "1">checked</cfif> >
              				<strong>Obra</strong>
						</td>
          			</tr>
        		</table>
      			</fieldset>
	  		</td>
	  		<td width="100">&nbsp;</td>
    	</tr>

		<tr>
      		<td>&nbsp;</td>
      		<td colspan="4">
				<!---<input type="hidden" name="Usucodigo" value="<cfif modo NEQ "ALTA">#rsComprador.Usucodigo#</cfif>">--->
        		<input type="hidden" name="CMCnivel" value="<cfif modo NEQ "ALTA">#rsComprador.CMCnivel#</cfif>">
				<cfif modo neq 'ALTA'>
					<input type="hidden" name="CMCid" value="#rsComprador.CMCid#">

					<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
						<cfinvokeargument name="arTimeStamp" value="#rsComprador.ts_rversion#"/>
					</cfinvoke>
					<input type="hidden" name="ts_rversion" value="#ts#">

				</cfif>
			</td>
    	</tr>

		<tr>
      		<td colspan="5" align="center">
        		<cfif modo EQ "ALTA">
          			<input type="submit" name="Alta" value="Agregar"  >
          			<input type="reset" name="Limpiar" value="Limpiar" >
          		<cfelse>
          			<input type="submit" name="Cambio" value="Modificar" onClick="javascript:cambio();">

                    <cfif rsCompradorCF.total eq 0>
                    	<input type="submit" name="Baja" value="Eliminar" onClick="javascript:if( confirm('¿Desea Eliminar el Registro?') ){deshabilitarValidacion(); return true;} return false;">
          			</cfif>

                    <input type="submit" name="Nuevo" value="Nuevo"  onClick="javascript:deshabilitarValidacion();" >
        		</cfif>
      		</td>
    	</tr>
        <cfif rsCompradorCF.total gt 0>
            <tr>
                <td colspan="5" height="30" class="mensajeValidacion">
                    No se puede eliminar este comprador, ya fue asignado en un Centro Funcional.
                </td>
            </tr>
		</cfif>

		<cfif modo neq 'ALTA'>
			<cfquery name="rsCF" datasource="#session.DSN#">
				select a.CMElinea, a.CMTScodigo, b.CMTSdescripcion
				from CMEspecializacionComprador a inner join CMTiposSolicitud b on a.CMTScodigo = b.CMTScodigo and a.Ecodigo = b.Ecodigo
					inner join CMCompradores c on a.CMCid = c.CMCid and a.Ecodigo = c.Ecodigo
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and c.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid#">
				order by b.CMTSdescripcion
			</cfquery>

			<cfquery name="rsTipoSolicitud" datasource="#session.dsn#">
				select CMTScodigo, CMTSdescripcion
				from CMTiposSolicitud
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			</cfquery>

			<!-------------------------- Usuarios Autorizados -------------------------------------->
			<cfif isdefined('url.CMCid') and not isdefined('form.CMCid')>
				<cfparam name="form.CMCid" default="#url.CMCid#">
			</cfif>
			<cfset navegacion = "">
			<cfif isdefined("Form.CMCid") and Len(Trim(Form.CMCid)) NEQ 0>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CMCid=" & Form.CMCid>
			</cfif>

			<cfquery name="lista" datasource="#session.DSN#">
				select  a.CMUid, a.Usucodigo as UsucodigoDel, c.Pid,  c.Pnombre#_Cat#' '#_Cat#c.Papellido1#_Cat#' '#_Cat#c.Papellido2 as usuario, '#Form.CMCid#' as CMCid
				,'<img border=''0'' onMouseOver=''javascript: this.style.cursor = "pointer"'' onClick=''javascript: elimina("'#_Cat#<cf_dbfunction name="to_char" args="a.CMUid">#_Cat#'","#Form.CMCid#");'' src=''/cfmx/sif/imagenes/Borrar01_S.gif''>' as borrar
							from CMUsuarioAutorizado a
					inner join Usuario b
						on a. Usucodigo = b.Usucodigo
					inner join DatosPersonales c
						on b.datos_personales = c.datos_personales
				where  a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					and a.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid#">
					order by usuario
			</cfquery>
			<!-------------------------- Usuarios Autorizados -------------------------------------->
			<tr>
				<td align="center">
					<table width="95%" cellpadding="0" cellspacing="0" align="center" border="0">
						<tr><td>
							<input type="hidden" name="accion" value="">
							<input type="hidden" name="especializacion" value="">
							<input type="hidden" name="CMElinea" value="#rsCF.CMElinea#">
						</td></tr>
					</table>
				</td>

      			<td colspan="3">
					<fieldset><legend>&nbsp;<strong>Especializaci&oacute;n por Comprador ( Solicitudes de Compra )</strong>&nbsp;&nbsp;</legend>
						<table cellpadding="2" cellspacing="0" align="center" border="0">
							<tr>
						  		<td align="right" nowrap><strong>Tipos de Solicitud:</strong>&nbsp;</td>
						  		<td colspan="2">
									<input name="CMTScodigo" type="text" value="<!----<cfif modo NEQ "ALTA" and isDefined("rsNombreUsuario") >#rsNombreUsuario.NombreJefe#</cfif>----->"
										id="CMTScodigo" size="5" maxlength="5" tabindex="-1" onblur="javascript:traerTSolicitud(this.value,1);">
        							<input name="CMTSdescripcion" type="text" id="CMTSdescripcion" value="" size="40">
									<a href="##" tabindex="-1">
									<img src="../../imagenes/Description.gif" alt="Lista de tipos de solicitud" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisSolicitudes();">
									</a>
									<!---
									<select name="CMTScodigo">
                            			<option value=""></option>
										<cfloop query="rsTipoSolicitud">
											<option value="#rsTipoSolicitud.CMTScodigo#">#rsTipoSolicitud.CMTSdescripcion#</option>
										</cfloop>
                          			</select>
									---->
								</td>
						  		<td align="center">
									<input type="button" name="dAgregar" value="Agregar" onClick="javascript:agregar();">
								</td>
					  		</tr>

							<tr><td colspan="4">&nbsp;</td></tr>

							<tr>
								<td colspan="4">
									<table width="100%" cellpadding="2" cellspacing="0" border="0">
										<tr>
											<td class="tituloListas" nowrap colspan="2">Tipos de Solicitud Asociados</td>
											<td class="tituloListas">&nbsp;</td>
										</tr>

										<cfloop query="rsCF">
											<tr class="<cfif rsCF.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>" >
												<td width="10%" nowrap>#rsCF.CMTScodigo#</td>
												<td nowrap> #rsCF.CMTSdescripcion#</td>
												<td width="10%" align="right"><a href="javascript:eliminar(#rsCF.CMElinea#)"><img border="0" src="../../imagenes/Borrar01_S.gif" alt="Eliminar Centro Funcional #rsCF.CMTSdescripcion#"></a></td>
											</tr>
										</cfloop>
									</table>
						  		</td>
                  			</tr>
                		</table>
			  		</fieldset>
				</td>
				<td width="100">&nbsp;</td>
    		</tr>

			<!-------------------------- Usuarios Autorizados -------------------------------------->
			<!--- Valida que el parametro: "Multiples Contratos" en Parametros Adicionales
			en el modulo de Compras este activado --->
			<cfquery name="verifica_Parametro" datasource="#session.dsn#">
				select 1 from Parametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Pcodigo = 730
				and Pvalor = '1'
			</cfquery>
			<cfif verifica_Parametro.recordcount GT 0 >

			<tr>
				<td align="center">
					<table width="95%" cellpadding="0" cellspacing="0" align="center" border="0">
						<tr><td>

						</td></tr>
					</table>
				</td>
				<td colspan="3">
					<fieldset><legend>&nbsp;<strong>Usuarios Autorizados</strong>&nbsp;&nbsp;</legend>
						<table cellpadding="2" cellspacing="0" align="center" border="0" width="100%">
							<tr>
							<td>
								<input type="hidden" name="CMUid" value="">
								<table width="40%" align="center" cellpadding="0" cellspacing="0">
									<tr><td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
									<tr>
										<td><strong>Usuario:</strong>&nbsp;</td>
										<td>
											<cf_sifusuarioE Nombre="UsuAutor" Usucodigo="UsucodigoAutor" size="50">
										</td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
										<td>
											<input name="AgregarUsuario" type="submit" value="Agregar">
										</td>
									</tr>
								</table>
							</td>
							</tr>
							<tr>
							<td>
								<cfinvoke
									 component="sif.Componentes.pListas"
									 method="pListaQuery"
									 returnvariable="pListaRet">
										<cfinvokeargument name="query" value="#lista#"/>
										<cfinvokeargument name="desplegar" value="Pid, usuario, borrar"/>
										<cfinvokeargument name="etiquetas" value=" Identificaci&oacute;n, Usuario, &nbsp;"/>
										<cfinvokeargument name="formatos" value="V, V, S"/>
										<cfinvokeargument name="align" value=" left,left, left"/>
										<cfinvokeargument name="ajustar" value="N"/>
										<cfinvokeargument name="irA" value=""/>
										<cfinvokeargument name="showemptylistmsg" value="true"/>
										<cfinvokeargument name="showLink" value="false"/>
										<cfinvokeargument name="maxrows" value="16"/>
										<cfinvokeargument name="navegacion" value="#navegacion#"/>
								</cfinvoke>
								</td>
							</tr>
						</table>
					</fieldset>
				</td>
			</tr>
			</cfif>
			<!-------------------------- Usuarios Autorizados -------------------------------------->
		</cfif>

	</table>
</form>
</cfoutput>

<!---  Iframe para el conlis de tipos de Solicitud ---->
<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>

<script language="JavaScript1.2" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.Nombre.required = true;
	objForm.Nombre.description="Nombre";
	objForm.CMCcodigo.required = true;
	objForm.CMCcodigo.description="Código";

	objForm.CMCmontomax.required = true;
	objForm.CMCmontomax.description = "Monto Máximo";

	function elimina(CMUid, CMCid){
		if (!confirm('Desea eliminar el Usuario?')) return false;
			document.form1.CMCid.value = CMCid;
			document.form1.CMUid.value = CMUid;
			document.form1.submit();
	}

	function deshabilitarValidacion(){
		objForm.Nombre.required = false;
		objForm.CMCcodigo.required = false;
		objForm.CMCmontomax.required = false;
	}

	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height) {
		if(popUpWin) {
			if(!popUpWin.closed) {
				popUpWin.close();
			}
	  	}
	  	popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlisJefes() {
		popUpWindow("ConlisJefes.cfm?form=form1&usu=CMCjefe&nombre=CMCjefenom&catalogo=C",250,150,350,400);
	}

	//Funcion del conlis de tipos de solicitud
	function doConlisSolicitudes() {
		popUpWindow("conlisSolicitudes.cfm?form=form1",250,150,550,400);
	}

	//Funcion del conlis de mantenimiento firma
	function doConlisFirma() {
		popUpWindow("conlisFirma.cfm?form=form1&modo=Cambio&CMCid="+document.form1.CMCid.value,250,150,550,400);
	}

	function cambio(){
		if (document.form1.CMCjefe.value != document.form1.CMCjefe.defaultValue) {
			document.form1.CambioJefe.value = '1';
		}
		else{
			document.form1.CambioJefe.value = '0';
		}
		deshabilitarValidacion();
	}

	function agregar(){
		if(document.form1.CMTScodigo.value != ''){
			document.form1.accion.value = 'insert';
			document.form1.especializacion.value = 'Agregar';
			document.form1.submit();
		}else{
			alert('Error, el campo Tipos de Solicitud es requerido')
			document.form1.especializacion.value = '';
		}
	}

	function eliminar(value){
		if ( confirm('Desea eliminar el registro?') ) {
			document.form1.accion.value = 'delete';
			document.form1.CMElinea.value = value;
			document.form1.submit();
		}
	}

	function validar(){
		document.form1.CMCmontomax.value = qf(document.form1.CMCmontomax.value);
		return true;
	}

	function eliminar_imagen(){
		if ( confirm('Desea eliminar la firma del comprador?') ){
			document.form1.BtnImagen.value="borrar";
			document.form1.submit();
		}
	}


	//Funcion para traer datos del tipo de solicitud cuando estos fueron digitados por el usuario
	function traerTSolicitud(value){
			  if (value!=''){
			   document.getElementById("fr").src = 'traerTSolicitud.cfm?CMTScodigo='+value;
			  }
			  else{
			   document.form1.CMTScodigo.value = '';
			   document.form1.CMTSdescripcion.value = '';
			  }
			 }
</script>
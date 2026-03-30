		<cfquery name="rsRegistro" datasource="#session.dsn#">
			select <cf_dbfunction name="to_char" args="Pvalor" len="11"> as Pvalor from RHParametros where Ecodigo = #session.Ecodigo# and Pcodigo = 300
		</cfquery>
		<cfquery name="numRegOficinas" datasource="#session.dsn#">
			select COUNT(*) as numOficinas from oficinas o
			where o.Onumpatronal is not null;
		</cfquery>

		<cfset RegistroPat = #rsRegistro.Pvalor#>

		<cfif #numRegOficinas.numOficinas# gt 0>
			<cfset validaRegPatUnico = "disabled">
			<!--- RHNumeroPatronal = #numRegOficinas.numOficinas# --->
			<cfelse>
			<cfset validaRegPatUnico = "">
		</cfif>

		<table width="100%" border="0" align="center" cellpadding="1" cellspacing="0" >
		<tr>
			<td>&nbsp;</td>
			<td colspan="2" bgcolor="#FAFAFA" align="center"><hr size="0">
				<font size="2" color="#000000"><strong><cf_translate key="LB_ConsultasYReportes">Consultas y Reportes</cf_translate></strong></font>
			</td>
		</tr>

	     <tr>
			<td>&nbsp;</td>
			<td><cf_translate key="LB_ScripDeExportacionDelSeguroSocial">Script de exportaci&oacute;n del Seguro Social</cf_translate>:</td>
			<td>
				<cfquery name="rsImpSeguroSocial" datasource="sifcontrol">
				  	select EIid, EIcodigo, EIdescripcion
					from EImportador
					where EImodulo = 'rh.reppag'
				</cfquery>
				<cfoutput>
					<select name="impSeguroSocial" tabindex="1">
						<option value="">- <cf_translate key="CMB_Ninguno">Ninguno</cf_translate> -</option>
						<cfloop query="rsImpSeguroSocial">
							<option value="#rsImpSeguroSocial.EIcodigo#"
						  		<cfif trim(PvalorImpSeguroSocial.Pvalor) eq trim(rsImpSeguroSocial.EIcodigo) >
									selected
								</cfif> >
								#rsImpSeguroSocial.EIcodigo# - #rsImpSeguroSocial.EIdescripcion#
							</option>
						</cfloop>
				  	</select>
				</cfoutput>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		  	<td><cf_translate key="LB_NumeroPatronalParaReporteSeguroSocial">N&uacute;mero Patronal para reporte Seguro Social</cf_translate>:</td>
		  	<td>
					<!--- Al usar cold fusion y javascript me provocó conflictos, debido a que quice deshabilitar el input
					poniendo la propiedad disabled; lo que pasaba es que como uso una variable de cf para deshabilitar
					esta provocaba un error haciendo que no reconociera la variable CF, así que por eso estan los otros dos
					inputs--->
					<cfif #numRegOficinas.numOficinas# gt 0 >
						<input name="numPatronalMuestra" <cfoutput>#validaRegPatUnico#</cfoutput>
						   value="<cfoutput>#RegistroPat#</cfoutput>">
						<input name="RHNumeroPatronal" value="<cfoutput>#RegistroPat#</cfoutput>" type="hidden">
					<cfelse>
						<input name="RHNumeroPatronal" type="text" size="30" maxlength="30" tabindex="1"
						   value="<cfoutput><cfif PvalorNumeroPatronal.RecordCount GT 0 and len(trim(PvalorNumeroPatronal.Pvalor))>#Trim(PvalorNumeroPatronal.Pvalor)#</cfif></cfoutput>"
						   onfocus="javascript:this.select();">
					</cfif>

		  	</td>
	    </tr>
		<tr>
			<td>&nbsp;</td>
		  	<td><cf_translate key="LB_Tipo_de_Riesgo">Tipo de Riesgo</cf_translate>:</td>
		  	<td>
            	<cfquery name="rsTpoRiesgo" datasource="#session.DSN#">
                	select RHRiesgoid,RHRiesgocodigo,RHRiesgodescripcion from dbo.RHCFDI_Riesgo
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                    order by RHRiesgocodigo
            	</cfquery>
                <select name="tipoRiesgo">
                    <option value="">-<cf_translate key="LB_seleccionar" xmlfile="/rh/generales.xml">seleccionar</cf_translate> -</option>
                    <cfoutput query="rsTpoRiesgo">
                        <option value="#rsTpoRiesgo.RHRiesgoid#" <cfif rsTpoRiesgo.RHRiesgoid eq PvalorTpoRiesgo.Pvalor >selected</cfif> >#rsTpoRiesgo.RHRiesgocodigo# #rsTpoRiesgo.RHRiesgodescripcion#</option>
                    </cfoutput>
                </select>
			</td>
	    </tr>
		<tr>
			<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="305" default="N" returnvariable="vRetroSS"/>

			<td>&nbsp;</td>
		  	<td width="40%" nowrap>&nbsp;</td>
		  	<td>
			<input name="RetroativoSS" type="checkbox" tabindex="1" <cfif #vRetroSS# eq 'S' >checked</cfif> >
		  	<cf_translate key="LB_TomarRetroactivosReporte">No tomar en cuenta retroactivos para el reporte</cf_translate>
			</td>
	    </tr>


	  <!----========================= Parametro 1070 (Mes inicial para el pintado del reporte de aguinaldo por mes (Autogestion) =========================---->
	  <tr>
	  	<td nowrap>&nbsp;</td>
		<td><cf_translate key="LB_MesDeInicioParaReporteDeAguinaldoAcumulado">Mes de inicio para reporte de aguinaldo acumulado</cf_translate></td>
		<td>

			<cfoutput>
				<cfset lista_meses = 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre' >
				<cfset ordenaguinaldo = 11><!---Default noviembre--->
				<cfif len(trim(PvalorOrdenAguinaldoMensual.Pvalor))>
					<cfset ordenaguinaldo = PvalorOrdenAguinaldoMensual.Pvalor>
				</cfif>
				<select name="mesinicialrepaguimensual">
					<cfloop from="1" to="12" index="i">
						<cfset vs_nmes = listgetat(lista_meses, i) >
						<option value="#i#" <cfif ordenaguinaldo EQ i>selected="selected"</cfif>>#vs_nmes#</option>
					</cfloop>
				</select>
			</cfoutput>
		</td>
	  </tr>
		<tr>
			<td>&nbsp;</td>
		  	<td width="40%" nowrap>&nbsp;</td>
		  	<td>
			<input name="MuestraAsignado" type="checkbox" tabindex="1" <cfif existeMuestraAsignado and PvalorMuestraAsignado.Pvalor eq 'S' >checked</cfif> >
		  	<cf_translate key="LB_Mostrar_Saldo_Asignado_en_Consulta_de_Vacaciones_Autogesti&oacute;n">Mostrar Saldo Asignado en Consulta de Vacaciones Autogesti&oacute;n</cf_translate>
			</td>
	    </tr>
		<tr>
				<td>&nbsp;</td>
		  	<td width="40%" nowrap>&nbsp;</td>
			<td>

				<input name="MuestraCC" type="checkbox" tabindex="1" <cfif existeMuestraAsignado and PmuestraCC.Pvalor eq 1 >checked</cfif> >
				<cf_translate key="LB_Mostrar_Cuenta_contable">Mostrar Cuenta Contable en el Reporte de Estructura Organizacional</cf_translate>
			</td>
	    </tr>
		<tr>
		<td>&nbsp;</td>

			<td>
				<cf_translate key="Carga_para_magisterio">Carga para Magisterio:</cf_translate>
			</td>
			<td>
				<cfset va_cambiocargas = ArrayNew(1)>
				<cfif isdefined ('Pcargas') and len(trim(Pcargas.Pvalor)) gt 0>
					<cfquery name="Carga" datasource="#session.dsn#">
						select DCdescripcion,DClinea,ECauto,DCmetodo
							from ECargas a,DCargas b
						where a.ECid=b.ECid
						and b.DClinea=#Pcargas.Pvalor#
						and a.Ecodigo=#session.Ecodigo#
						and a.ECauto=1
					</cfquery>
				</cfif>
				<cfif isdefined ('Carga') and Carga.recordcount gt 0>
				<cfset ArrayAppend(va_cambiocargas, Carga.DCdescripcion)>
				<cfset ArrayAppend(va_cambiocargas, Carga.DClinea)>
				<cfset ArrayAppend(va_cambiocargas, Carga.ECauto)>
				<cfset ArrayAppend(va_cambiocargas, Carga.DCmetodo)>
				</cfif>
				<cf_conlis
				campos="DCdescripcion,DClinea,ECauto,DCmetodo"
				asignar="DCdescripcion,DClinea,ECauto,DCmetodo"
				size="50,0,0,0"
				desplegables="S,N,N,N"
				modificables="N,N,N,N"
				title="Lista de Cargas Obrero Patronales"
				tabla="DCargas a,ECargas b"
				columnas="a.ECid,ECdescripcion,DClinea,DCdescripcion,ECauto,DCmetodo,a.DCvaloremp,a.DCvalorpat"
				filtro="a.ECid=b.ECid
						and b.Ecodigo= #Session.Ecodigo#
						 and a.Ecodigo=#Session.Ecodigo#
						and b.ECauto=1
						order by a.ECid, DCdescripcion"
				filtrar_por="DCdescripcion"
				desplegar="DCdescripcion"
				etiquetas="Descripcion"
				formatos="S"
				align="left"
				asignarFormatos="S,S,S,S"
				form="form1"
				showEmptyListMsg="true"
				Cortes="ECdescripcion"
				funcion="funcPreCarga"
				fparams="DCvaloremp,DCvalorpat"
				valuesArray="#va_cambiocargas#"
			/>
			</td>
		</tr>
	  <tr>
	  <td>&nbsp;</td>
			<td>
				<cf_translate key="Indicador_para_reporte">Indicador para Reporte:</cf_translate>
			</td>
			<td>
			<cfif isdefined ('Pletra_cargas') and len(trim(Pletra_cargas.Pvalor)) gt 0>
				<cfoutput><input type="text" name="IndRep" maxlength="1" size="3" value="#Pletra_cargas.Pvalor#"/></cfoutput>
			<cfelse>
				<input type="text" name="IndRep" maxlength="1" size="3" />
			</cfif>
			</td>
		</tr>

		<tr><td colspan="4">&nbsp;</td></tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan="2" bgcolor="#FAFAFA" align="center"><hr size="0">
				<font size="2" color="#000000"><strong><cf_translate key="LB_AdministracionDePuestos">Administraci&oacute;n de Puestos</cf_translate></strong></font>
			</td>
		</tr>

		<tr>
			<td nowrap colspan="2">&nbsp;</td>
			<td>
				<table border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="1%"><input name="benziger" type="checkbox" tabindex="1" <cfif PvalorBenziger.Pvalor eq 1 >checked</cfif> ></td>
						<td width="99%" valign="middle"><cf_translate key="CHK_ActivarBenzigers">Activar Benziger</cf_translate></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan="2" bgcolor="#FAFAFA" align="center"><hr size="0">
				<font size="2" color="#000000"><strong><cf_translate key="CHK_Autogestion">Autogesti&oacute;n</cf_translate></strong></font>
			</td>
		</tr>
		<tr>
			<td nowrap colspan="2">&nbsp;</td>
			<td>
				<table border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="1%"><input name="modifDEAuto" type="checkbox" tabindex="1" <cfif PvalorDatosEmplado.Pvalor eq 1 >checked</cfif> ></td>
						<td width="99%" valign="middle" ><cf_translate key="CHK_PermiteModificarDatosEmpleadoAutogestion">Permite modificar Datos de Empleado en Autogesti&oacute;n</cf_translate></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td nowrap colspan="2">&nbsp;</td>
			<td>
				<table border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="1%"><input name="RejorMarcador" type="checkbox" tabindex="1" <cfif PvalorRelojMarcador.Pvalor eq 1 >checked</cfif> ></td>
						<td width="99%" valign="middle" ><cf_translate key="CHK_RequerirContrasennaRelojMarcador">Requerir Contrase&ntilde;a en Reloj Marcador</cf_translate></td>
					</tr>
				</table>
			</td>
		</tr>

		<!--- OPARRALES 2018-07-02 --->
		<tr>
	  		<td>&nbsp;</td>
			<td>
				<cf_translate key="TXT_Host_Correos">Host para correos:&nbsp;</cf_translate>
			</td>
			<td>
				<input name="txtHostCorreos" type="text" tabindex="1" value="<cfoutput><cfif Trim(PvalorHostCorreos.Pvalor) neq ''>#Trim(PvalorHostCorreos.Pvalor)#</cfif></cfoutput>" size="60">
			</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td colspan="2" bgcolor="#FAFAFA" align="center"><hr size="0">
				<font size="2" color="#000000"><strong><cf_translate key="LB_Traduccion_de_Etiquetas">Traducci&oacute;n de Etiquetas</cf_translate></strong></font>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2">
				<input name="traducir" tabindex="1"
					   type="checkbox"
						<cfif  PvalorTraducir.RecordCount GT 0 and trim(PvalorTraducir.Pvalor) eq '1' >
							checked
						</cfif>>
				<cf_translate key="CHK_Usar_funcionalidad_de_traduccion_de_etiquetas">Usar funcionalidad de traducci&oacute;n de etiquetas</cf_translate>
			</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td colspan="2" bgcolor="#FAFAFA" align="center"><hr size="0">
				<font size="2" color="#000000"><strong><cf_translate key="LB_Listado_Generico_de_Empleados">Listado Gen&eacute;rico de Empleados</cf_translate></strong></font>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2">
				<input 	name="idtarjeta" tabindex="1"
					   	type="checkbox"
						<cfif  PvalorIDTarjeta.RecordCount GT 0 and trim(PvalorIDTarjeta.Pvalor) eq '1' >
							checked
						</cfif>>
				<cf_translate key="CHK_Usar_identificacion_de_empleado">Mostrar Id de tarjeta de empleado</cf_translate>
			</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td colspan="2" bgcolor="#FAFAFA" align="center"><hr size="0">
				<font size="2" color="#000000"><strong><cf_translate key="LB_Medicina_de_Empresa">Medicina de Empresa</cf_translate></strong></font>
			</td>
		</tr>

		<tr>
		  <td>&nbsp;</td>
		  <td><cf_translate key="LB_Tipo_Expediente_Medico">Tipo de Expediente M&eacute;dico</cf_translate>:</td>
		  <td>
			<cfquery name="rs_expedientes" datasource="#session.DSN#">
				select TEid, TEcodigo, TEdescripcion
				from TipoExpediente
				where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
				order by TEdescripcion
			</cfquery>
		  	<select name="tipoExpediente" onchange="javascript:cambiar_expediente(this.value);">
				<option value="">-<cf_translate key="LB_seleccionar" xmlfile="/rh/generales.xml">seleccionar</cf_translate> -</option>
				<cfoutput query="rs_expedientes">
					<option value="#rs_expedientes.TEid#" <cfif rs_expedientes.TEid eq PvalorTipoExp.Pvalor >selected</cfif> >#rs_expedientes.TEdescripcion#</option>
				</cfoutput>
			</select>
		  </td>
		</tr>

		<cfif len(trim(PvalorTipoExp.Pvalor))>
			<cfquery name="rs_formatos" datasource="#session.DSN#">
				select EFEid, EFEdescripcion
				from EFormatosExpediente
				where TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PvalorTipoExp.Pvalor#">
				order by EFEdescripcion
			</cfquery>
		</cfif>
		<tr>
			<td>&nbsp;</td>
		  	<td><cf_translate key="LB_Tipo_Formato_Expediente">Tipo de Formato de Expediente M&eacute;dico</cf_translate>:</td>
		  	<td>
				<select name="tipoFormato">
					<option value="">-<cf_translate key="LB_seleccionar" xmlfile="/rh/generales.xml">seleccionar</cf_translate> -</option>
					<cfif isdefined("rs_formatos") and rs_formatos.recordcount gt 0>
						<cfoutput query="rs_formatos">
							<option value="#rs_formatos.EFEid#" <cfif rs_formatos.EFEid eq PvalorTipoFormatoExp.Pvalor >selected</cfif> >#rs_formatos.EFEdescripcion#</option>
						</cfoutput>
					</cfif>
				</select>
				<iframe name="expediente" id="expediente" frameborder="0" width="0" height="0" style="display:none; visibility:hidden;"></iframe>
			</td>
		</tr>
		<script language="javascript1.2" type="text/javascript">
			function cambiar_expediente(id){
				document.getElementById('expediente').src = '/cfmx/rh/Utiles/traerFormatosExpediente.cfm?id='+id;
			}

			<cfif isdefined('form.EFEid') and LEN(TRIM(form.EFEid))>
			cambiar_expediente(document.form1.TEid.value,'<cfoutput>#form.EFEid#</cfoutput>');
			</cfif>
		</script>


<!---
--->

		<cfif rsDatos.RecordCount eq 0 >
			<tr>
				<td colspan="4" align="center">
					<font color="#FF0000">
						<cf_translate key="MSG_NoSeHanDefinidoLosParametrosGeneralesDebeDefinirlosMedianteElBotonDeAceptar">No se han definido los parmetros generales! <br>Debe definirlos mediante el bot&oacute;n de Aceptar</cf_translate>
					</font>
				</td>
			</tr>
			<tr><td colspan="3">&nbsp;</td></tr>
		</cfif>

		<tr><td colspan="4">&nbsp;</td></tr>
		<tr>
			<td colspan="4" align="center">
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Agregar"
					Default="Agregar"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Agregar"/>
				<input type="submit" name="btnAceptar" value="<cfoutput>#BTN_Agregar#</cfoutput>" tabindex="1">
			</td>
		</tr>
</table>
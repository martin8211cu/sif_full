<cfinclude template="../../Utiles/sifConcat.cfm">
<!--- Usuarios de los Compradores de todos los procesos de compra que se están viendo --->
<cfquery name="rsUsuariosPC" datasource="sifpublica">
	select distinct a.UsucodigoC
	from ProcesoCompraProveedor a, InvitadosProcesoCompra b
	where a.PCPid = b.PCPid
	and b.UsuarioP = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	and a.CMPfmaxofertas >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
</cfquery>

<cfif rsUsuariosPC.recordCount>
	<!--- Obtener los nombre de los usuarios Compradores --->
	<cfquery name="rsUsuariosFiltro" datasource="asp">
	  select a.Usucodigo, b.Pnombre #_Cat# ' ' #_Cat# b.Papellido1 #_Cat# ' ' #_Cat# b.Papellido2 as NombreCompleto
	  from Usuario a, DatosPersonales b
	  where a.Usucodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(rsUsuariosPC.UsucodigoC, ',')#" list="yes" separator=",">)
	  and a.datos_personales = b.datos_personales
	</cfquery>
</cfif>

<cfquery name="rsProcesosCompra" datasource="sifpublica">
	select a.PCPid, a.CMPid, a.CMPdescripcion, a.CEcodigo, 
		   a.Ecodigo, a.EcodigoASP, a.UsucodigoC, a.CMPfechapublica, 
		   a.CMPfmaxofertas, a.cncache, a.Usucodigo, a.fechaalta, a.PCPestado,
		   a.CMPnumero, a.CMFPid, a.CMIid
	from ProcesoCompraProveedor a, InvitadosProcesoCompra b
	where a.PCPid = b.PCPid
	 and b.UsuarioP = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	 and a.CMPfmaxofertas >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">  
	<cfif isdefined("Form.fCMPnumero") and Len(Trim(Form.fCMPnumero))>
		and a.CMPnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.fCMPnumero#">
	</cfif>
	<cfif isdefined("Form.fCMPfechapublica") and Len(Trim(Form.fCMPfechapublica))>
		and a.CMPfechapublica between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.fCMPfechapublica)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(Form.fCMPfechapublica)))#">
	</cfif>
	<cfif isdefined("Form.fCMPfmaxofertas") and Len(Trim(Form.fCMPfmaxofertas))>
		and a.CMPfmaxofertas between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.fCMPfmaxofertas)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(Form.fCMPfmaxofertas)))#">
	</cfif>
	<!--- <cfif isdefined("Form.fComprador") and Len(Trim(Form.fComprador))>
		and a.UsucodigoC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.fComprador#">
	</cfif> --->
</cfquery>

<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="javascript" type="text/javascript">
	function Cotizar(codigo) {
		document.form1.PCPid.value = codigo;
		document.form1.submit();
	}
	
	function verProceso(codigo) {
		document.form1.action = "ConsultaProceso.cfm";
		document.form1.PCPid.value = codigo;
		document.form1.submit();
	}
</script>

<cfoutput>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
	  <tr>
	    <td colspan="7"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">Lista de Procesos de Compra Publicados</strong></td>
      </tr>
	  <tr>
	    <td colspan="7">
			<form name="filtroProcesos" method="post" action="#GetFileFromPath(GetTemplatePath())#" style="margin: 0; ">
				<table width="100%"  border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
				  <tr>
					<td class="FileLabel">No. Proceso Compra</td>
					<td class="FileLabel">Fecha Publicaci&oacute;n</td>
					<td class="FileLabel">Fecha M&aacute;xima Cotizaci&oacute;n</td>
					<td class="FileLabel">Comprador</td>
					<td rowspan="2" align="center">
						<input type="submit" name="btnFiltrar" value="Filtrar">
					</td>
				  </tr>
				  <tr>
					<td>
						<input name="fCMPnumero" type="text" size="20" maxlength="20"  onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);"  onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif isdefined('Form.fCMPnumero') and Len(Trim(Form.fCMPnumero))>#Form.fCMPnumero#</cfif>">
					</td>
					<td>
						<cfif isdefined("Form.fCMPfechapublica") and Len(Trim(Form.fCMPfechapublica))>
							<cfset fechaPub = Form.fCMPfechapublica>
						<cfelse>
							<cfset fechaPub = "">
						</cfif>
						<cf_sifcalendario form="filtroProcesos" name="fCMPfechapublica" value="#fechaPub#">
					</td>
					<td>
						<cfif isdefined("Form.fCMPfmaxofertas") and Len(Trim(Form.fCMPfmaxofertas))>
							<cfset fechaMax = Form.fCMPfmaxofertas>
						<cfelse>
							<cfset fechaMax = "">
						</cfif>
						<cf_sifcalendario form="filtroProcesos" name="fCMPfmaxofertas" value="#fechaMax#">
					</td>
					<td>
						<select name="fComprador">
							<option value="">--- TODOS ---</option>
							<cfif isdefined("rsUsuariosFiltro")>
							<cfloop query="rsUsuariosFiltro">
								<option value="#rsUsuariosFiltro.Usucodigo#"<cfif isdefined("Form.fComprador") and Form.fComprador EQ rsUsuariosFiltro.Usucodigo> selected</cfif>>#rsUsuariosFiltro.NombreCompleto#</option>
							</cfloop>
							</cfif>
						</select>
					</td>
				  </tr>
				</table>
			</form>
		</td>
      </tr>
	  <tr>
	    <td colspan="7">&nbsp;</td>
      </tr>
	  <tr>
		<td class="tituloListas" align="center">Empresa</td>
		<td class="tituloListas" align="center">No. Proc. Compra</td>
		<td class="tituloListas">Descripci&oacute;n</td>
		<td class="tituloListas" align="center">Fecha de Publicaci&oacute;n </td>
		<td class="tituloListas" align="center">Fecha M&aacute;xima Cotizaci&oacute;n </td>
		<td class="tituloListas">Comprador</td>
		<td class="tituloListas">&nbsp;</td>
	  </tr>
	  <cfloop query="rsProcesosCompra">
		  <cfquery name="rsComprador" datasource="asp">
			  select b.Pnombre #_Cat# ' ' #_Cat# b.Papellido1 #_Cat# ' ' #_Cat# b.Papellido2 as NombreCompleto
			  from Usuario a, DatosPersonales b
			  where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsProcesosCompra.UsucodigoC#">
			  and a.datos_personales = b.datos_personales
		  </cfquery>
		  <cfset LvarListaNon = (CurrentRow MOD 2)>
		  <tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="<cfif NOT LvarListaNon>LvarListaNonColor = style.backgroundColor;</cfif>style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor=<cfif CurrentRow MOD 2>'##FFFFFF'<cfelse>LvarListaNonColor</cfif>;" style="cursor: pointer;">
			<td onClick="javascript: verProceso('#rsProcesosCompra.PCPid#');" align="center"><img src="/cfmx/home/public/logo_empresa.cfm?EcodigoSDC=#rsProcesosCompra.EcodigoASP#&ts=#LSTimeFormat(Now(),'hhmmss')#" height="30" border="0"></td>
			<td onClick="javascript: verProceso('#rsProcesosCompra.PCPid#');" align="center">#rsProcesosCompra.CMPnumero#</td>
			<td onClick="javascript: verProceso('#rsProcesosCompra.PCPid#');">#rsProcesosCompra.CMPdescripcion#</td>
			<td onClick="javascript: verProceso('#rsProcesosCompra.PCPid#');" align="center">#LSDateFormat(rsProcesosCompra.CMPfechapublica, 'dd/mm/yyyy')#</td>
			<td onClick="javascript: verProceso('#rsProcesosCompra.PCPid#');" align="center">#LSDateFormat(rsProcesosCompra.CMPfmaxofertas,'dd/mm/yyyy')# #LSTimeFormat(rsProcesosCompra.CMPfmaxofertas, 'hh:mm tt')#</td>
			<td onClick="javascript: verProceso('#rsProcesosCompra.PCPid#');">#rsComprador.NombreCompleto#</td>
			<td align="center">
				<input type="button" name="btnCotizar" value="Cotizar" onClick="javascript: Cotizar('#rsProcesosCompra.PCPid#');">
			</td>
		  </tr>
	  </cfloop>
		  <tr>
		    <td colspan="7">&nbsp;</td>
		  </tr>
		  <tr>
		    <td colspan="7" align="center">
				<input type="button" name="btnRegresar" value="Regresar" onClick="javascript: location.href='/cfmx/sif/B2B/MenuB2B.cfm';">
			</td>
	      </tr>
		  <tr>
		    <td colspan="7">&nbsp;</td>
		  </tr>
	</table>
	<form name="form1" method="post" action="RegCotizaciones.cfm">
		<input type="hidden" name="PCPid" value="">
	</form>
	
</cfoutput>


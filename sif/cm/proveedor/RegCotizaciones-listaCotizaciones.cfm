<cfoutput>
	<script language="javascript" type="text/javascript">
		function funcNuevo() {
			document.form1.PCPID.value = '#Form.PCPid#';
			document.form1.CPID.value = '';
		}
		
		function funcRegresar() {
			location.href = 'RegCotizaciones.cfm';
			return false;
		}
	</script>

	<form name="filtroCotizaciones" method="post" action="#GetFileFromPath(GetTemplatePath())#" style="margin: 0; ">
		<input type="hidden" name="returnLista" value="1">
		<input type="hidden" name="PCPid" value="#Form.PCPid#">
		<table width="100%"  border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
		  <tr>
			<td align="right"><strong>No. Cotizaci&oacute;n:&nbsp;</strong></td>
			<td>
				<input name="fCPnumero" type="text" size="15" maxlength="10" value="<cfif isdefined('Form.fCPnumero')>#Form.fCPnumero#</cfif>" style="text-align:right;">
			</td>
			<td align="right"><strong>Fecha de Cotizaci&oacute;n:&nbsp;</strong></td>
			<td>
				<cfif isdefined("Form.fCPfechacoti") and Len(Trim(Form.fCPfechacoti))>
					<cfset fechacoti = Form.fCPfechacoti>
				<cfelse>
					<cfset fechacoti = "">
				</cfif>
				<cf_sifcalendario form="filtroCotizaciones" name="fCPfechacoti" value="#fechacoti#">
			</td>
			<td align="right"><strong>Procesado por:&nbsp;</strong></td>
			<td>
				<input name="fCPprocesado" type="text" size="40" maxlength="120" value="<cfif isdefined('Form.fCPprocesado')>#Form.fCPprocesado#</cfif>">
			</td>
			<td align="center"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar"></td>
		  </tr>
		</table>
	</form>
</cfoutput>

<cfquery name="rsCotizaciones" datasource="sifpublica">
	select 	a.CPid, a.UsucodigoP, a.CPnumero, a.PCPid, 
			a.CPfechacoti, a.CPdescripcion, a.CPobs, a.CPprocesado, 
			a.CPsubtotal, a.CPtotdesc, a.CPtotimp, a.CPtotal, a.CPfechaaplica, a.CPestado,
			'1' as returnLista
	from CotizacionesProveedor a
	where a.PCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCPid#">
	and a.UsucodigoP = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	and a.CPestado = 0
	<cfif isdefined("Form.fCPnumero") and Len(Trim(Form.fCPnumero))>
		and upper(a.CPnumero) like <cfqueryparam cfsqltype="cf_sql_char" value="%#UCase(Trim(Form.fCPnumero))#%">
	</cfif>
	<cfif isdefined("Form.fCPprocesado") and Len(Trim(Form.fCPprocesado))>
		and upper(a.CPprocesado) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Trim(Form.fCPprocesado))#%">
	</cfif>
	<cfif isdefined("Form.fCPfechacoti") and Len(Trim(Form.fCPfechacoti))>
		and a.CPfechacoti = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fCPfechacoti)#">
	</cfif>
</cfquery>


<cfinvoke 
 component="sif.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaRet">
	<cfinvokeargument name="query" value="#rsCotizaciones#"/>
	<cfinvokeargument name="desplegar" value="CPnumero, CPfechacoti, CPdescripcion, CPprocesado "/>
	<cfinvokeargument name="etiquetas" value="N&uacute;mero, Fecha de Cotizaci&oacute;n, Descripci&oacute;n, Procesado por "/>
	<cfinvokeargument name="formatos" value="V, D, V, V"/>
	<cfinvokeargument name="align" value="left, center, left, left"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
	<cfinvokeargument name="keys" value="CPid, PCPid"/>
	<cfinvokeargument name="MaxRows" value="0"/>
	<cfinvokeargument name="formName" value="form1"/>
	<cfinvokeargument name="botones" value="Nuevo, Regresar"/>
	<cfinvokeargument name="conexion" value="sifpublica"/>
</cfinvoke>

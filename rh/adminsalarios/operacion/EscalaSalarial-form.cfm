<!---
	Estados de las Escalas
	0: En Proceso
	10: Aplicada
	20: Pasada
--->

<cfset modo = "ALTA">
<cfset titulo = "Nueva Escala Salarial">
<cfif isdefined("Form.ESid") and Len(Trim(Form.ESid))>
	<cfset modo = "CAMBIO">
</cfif>

<cfquery name="rsLista" datasource="#Session.DSN#">
	select ESid, Ecodigo, EScodigo, ESdescripcion, ESestado, ESfdesde, ESfhasta, ESreferencia, ESporcinc, ESdescaumento, fechaalta, BMUsucodigo,
		   case when ESestado = 0 then 'En Proceso' when ESestado = 10 then 'Aplicada' when ESestado = 20 then 'Pasada' else '' end as EstadoEscala
	from RHEscalaSalHAY 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by ESfdesde, EScodigo
</cfquery>

<cfif modo EQ "ALTA">

	<cfquery name="ultimaFechaTipo0" datasource="#Session.DSN#">
		select coalesce(max(ESfdesde), <cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(1900, 01, 01)#">) as fecha
		from RHEscalaSalHAY 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	
<cfelseif modo EQ "CAMBIO">
	<cfquery name="data" datasource="#Session.DSN#">
		select ESid, Ecodigo, EScodigo, ESdescripcion, ESestado, ESfdesde, ESfhasta, ESreferencia, ESporcinc, ESdescaumento, fechaalta, BMUsucodigo,
		   	   case when ESestado = 0 then 'En Proceso' when ESestado = 10 then 'Aplicada' when ESestado = 20 then 'Pasada' else '' end as EstadoEscala
		from RHEscalaSalHAY 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and ESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ESid#">
	</cfquery>
	<cfset titulo = data.EScodigo & " &nbsp; " & data.ESdescripcion>
</cfif>

<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="48%" valign="top">
		<cfinvoke 
		 component="rh.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="desplegar" value="EScodigo, ESdescripcion, ESfdesde, EstadoEscala"/>
			<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n, Rige, Estado"/>
			<cfinvokeargument name="formatos" value="V,V,D,V"/>
			<cfinvokeargument name="align" value="left, left, center, center"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
			<cfinvokeargument name="keys" value="ESid"/>
			<cfinvokeargument name="MaxRows" value="0"/>
			<cfinvokeargument name="formName" value="lista"/>
			<cfinvokeargument name="PageIndex" value="1"/>
			<cfinvokeargument name="debug" value="N"/>
		</cfinvoke>
	</td>
    <td width="52%" valign="top" style="padding-left: 5px;">
		<cfoutput>
			<form name="form1" method="post" action="EscalaSalarial-sql.cfm" style="margin: 0;">
				<cfif modo EQ "CAMBIO">
					<input type="hidden" name="ESid" id="ESid" value="#Form.ESid#">
				</cfif>
				<cfif isdefined("Form.PageNum1") and Len(Trim(Form.PageNum1))>
					<input type="hidden" name="PageNum1" id="PageNum1" value="#Form.PageNum1#">
				</cfif>
				<table width="100%"  border="0" cellspacing="0" cellpadding="2">
				  <tr>
					<td align="center" colspan="4" nowrap class="tituloAlterno">#titulo#</td>
				  </tr>
				  <tr>
					<td align="right" nowrap class="fileLabel">C&oacute;digo:</td>
					<td>
						<cfif modo EQ "CAMBIO" and data.ESestado NEQ 0>
							#Trim(data.EScodigo)#
							<input name="EScodigo" type="hidden" id="EScodigo" value="#Trim(data.EScodigo)#">
						<cfelse>
							<input name="EScodigo" type="text" id="EScodigo" size="12" maxlength="10" value="<cfif modo EQ "CAMBIO">#Trim(data.EScodigo)#</cfif>">
						</cfif>
					</td>
					<td align="right" nowrap class="fileLabel">Fecha Rige: </td>
					<td>
						<cfif modo EQ "CAMBIO">
							#LSDateFormat(data.ESfdesde, 'dd/mm/yyyy')#
							<input type="hidden" name="ESfdesde" id="ESfdesde" value="#LSDateFormat(data.ESfdesde, 'dd/mm/yyyy')#">
						<cfelse>
							<cf_sifcalendario form="form1" name="ESfdesde">
						</cfif>
					</td>
				  </tr>
				  <tr>
					<td align="right" nowrap class="fileLabel">Descripci&oacute;n:</td>
					<td colspan="3">
					  	<cfif modo EQ "CAMBIO" and data.ESestado NEQ 0>
							#Trim(data.ESdescripcion)#
							<input name="ESdescripcion" type="hidden" id="ESdescripcion" value="#Trim(data.ESdescripcion)#">
						<cfelse>
						  <input name="ESdescripcion" type="text" id="ESdescripcion" size="60" maxlength="80" value="<cfif modo EQ "CAMBIO">#data.ESdescripcion#</cfif>">
					  	</cfif>
					</td>
				  </tr>
				  <tr>
					<td align="center" colspan="4">
						<cfif modo EQ "CAMBIO" and data.ESestado NEQ 0>
							<cf_botones modo="#modo#" exclude="Cambio,Baja" include="Copiar">
						<cfelseif modo EQ "CAMBIO" and data.ESestado EQ 0>
							<cf_botones modo="#modo#" include="Aplicar,Copiar">
						<cfelse>
							<cf_botones modo="#modo#">
						</cfif>
					</td>
				  </tr>
				</table>
			</form>
		</cfoutput>
		<!--- NIVELES SALARIALES --->
		<cfif modo EQ "CAMBIO">
			<cfinclude template="EscalaSalarial-formNivel.cfm">
		</cfif>
	</td>
  </tr>
</table>

<cf_qforms form="form1" objForm="objForm1">

<script language="javascript" type="text/javascript">
	<cfif modo EQ "CAMBIO">
	function reloadPage(id) {
		inhabilitarValidaciones();
		document.form1.ESid.value = id;
		document.form1.submit();
	}
	
	function funcCopiar() {
		var width = 700;
		var height = 130;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		var nuevo = window.open('conlisCopiaEscala.cfm?ESid=<cfoutput>#data.ESid#</cfoutput>','Vacaciones','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
		nuevo.focus();
		return false;
	}
	</cfif>

	<cfif modo EQ "ALTA">
		var valFechas = '<cfoutput>#LSDateFormat(ultimaFechaTipo0.fecha, 'dd/mm/yyyy')#</cfoutput>';
	
		function __isFecha() {
			if (this.required) {
				var a = valFechas.split("/");
				var ultimaFecha = new Date(parseInt(a[2], 10), parseInt(a[1], 10)-1, parseInt(a[0], 10));
				var b = this.obj.form.ESfdesde.value.split("/");
				var fechaRige = new Date(parseInt(b[2], 10), parseInt(b[1], 10)-1, parseInt(b[0], 10));
				if (fechaRige <= ultimaFecha) {
					this.error = "La Fecha Rige debe ser mayor a la última Fecha Rige de las escalas existentes que son del mismo tipo seleccionado";
				}
			}
		}

		_addValidator("isFecha", __isFecha);
	
	</cfif>
	
	function funcNuevo() {
		if (window.inhabilitarValidaciones) inhabilitarValidaciones();
	}
	
	function funcCambio() {
		if (window.inhabilitarValidacionesDet) inhabilitarValidacionesDet();
		if (window.inhabilitarValidacionesExc) inhabilitarValidacionesExc();
	}
	
	function funcBaja() {
		if (confirm('¿Está seguro de que desea eliminar esta escala salarial?')) {
			inhabilitarValidaciones();
			return true;
		} else {
			return false;
		}
	}
	
	function funcAplicar() {
		if (confirm('¿Está seguro de que desea proceder a aplicar esta escala salarial?')) {
			inhabilitarValidaciones();
			return true;
		} else {
			return false;
		}
	}
	
	function inhabilitarValidaciones() {
		<!--- Cuando NO sean Escalas Aplicadas o Pasadas --->
		<cfif not (modo EQ "CAMBIO" and data.ESestado NEQ 0)>
			objForm1.EScodigo.required = false;
			objForm1.ESdescripcion.required = false;
		</cfif>
		<!--- Para Escalas en modo alta --->
		<cfif modo EQ "ALTA">
			objForm1.ESfdesde.required = false;
		</cfif>
		if (window.inhabilitarValidacionesDet) inhabilitarValidacionesDet();
		if (window.inhabilitarValidacionesExc) inhabilitarValidacionesExc();
	}
	
	<!--- Cuando NO sean Escalas Aplicadas o Pasadas --->
	<cfif not (modo EQ "CAMBIO" and data.ESestado NEQ 0)>
		objForm1.EScodigo.required = true;
		objForm1.EScodigo.description = "Código";
		objForm1.ESdescripcion.required = true;
		objForm1.ESdescripcion.description = "Descripción";
	</cfif>
	<!--- Para Escalas en modo alta --->
	<cfif modo EQ "ALTA">
		objForm1.ESfdesde.required = true;
		objForm1.ESfdesde.description = "Fecha Rige";
		objForm1.ESfdesde.validateFecha();
	</cfif>
	
</script>
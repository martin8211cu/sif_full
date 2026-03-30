<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
	<cfset form.Pagina = url.Pagina>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
	<cfset form.Pagina = url.PageNum_Lista>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
	<cfset form.Pagina = form.PageNum>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
<cfif isdefined("url.Pagina2") and len(trim(url.Pagina2))>
	<cfset form.Pagina2 = url.Pagina2>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
<cfif isdefined("url.PageNum_Lista2") and len(trim(url.PageNum_Lista2))>
	<cfset form.Pagina2 = url.PageNum_Lista2>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
<cfif isdefined("url.PageNum2") and len(trim(url.PageNum2))>
	<cfset form.Pagina2 = url.PageNum2>
</cfif>

<cfif not isdefined("form.solicitudmanual")>
	<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
	<cf_templateheader title="Mantenimiento de Impresión Órdenes de Pago">
		<cf_web_portlet_start titulo="Mantenimiento de Impresión Órdenes de Pago">
			<cfset fnCarnita()>
		<cf_web_portlet_end>
	<cf_templatefooter>	

<cfelse>
	<cfset fnCarnita()>
</cfif>

<cffunction name="fnCarnita" output="true">
	<style type="text/css">
	<!--
	.style1 {
		color: FF0000;
		font-weight: bold;
	}
	-->
	</style>
	<cfif isdefined("session.tesoreria.TESid") and session.tesoreria.TESid gt 0 and not isdefined("url.nuevo")>
		<cfquery datasource="#session.dsn#" name="data">
			select 
				TESid,
				TESOPidioma,
				TESOPRevisado, 
				TESOPAprobado, 
				TESOPRefrendado,
				ts_rversion
			from TESOPprocEmi 
			where TESid = #session.tesoreria.TESid#
		</cfquery>
		<cfset CAMBIO = data.RecordCount>
	<cfelse>
		<cfset CAMBIO = 0>
	</cfif>
	<cfoutput>
	<form action="OPProcEmi_sql.cfm"  method="post" name="form1">
	<cfif isdefined('form.fTESOPidioma')>
		<input name="fTESOPidioma" type="hidden" value="#form.fTESOPidioma#">
	</cfif>
	<cfif isdefined('form.fTESOPRevisado')>
		<input name="fTESOPRevisado" type="hidden" value="#form.fTESOPRevisado#">
	</cfif>
	<cfif isdefined("form.fTESOPAprobado")>
		<input name="fTESOPAprobado" type="hidden" value="#fTESOPAprobado#">
	</cfif>
	<cfif isdefined("form.fTESOPRefrendado")>
		<input name="fTESOPRefrendado" type="hidden" value="#fTESOPRefrendado#">
	</cfif>
	<cfquery name="rsTesoreria" datasource="#session.DSN#">
		select TESdescripcion 
		from Tesoreria 
		where TESid = #session.tesoreria.TESid#
	</cfquery>
	
	<cfquery name="rsIdioma" datasource="#session.dsn#">
		select Icodigo, Descripcion
		from Idiomas
		order by Descripcion
	</cfquery>
	
	
	<input name="Pagina" type="hidden" value="#form.Pagina#">

		<table summary="Tabla de entrada" border="0" width="60%" align="center">
			<tr>
				<td width="10%" valign="top" colspan="4" nowrap>&nbsp;</td>
			</tr>
			<tr>
				<td class="subTitulo"><strong>Tesorer&iacute;a:&nbsp;</strong></td>
				<td>#rsTesoreria.TESdescripcion#</td>
			</tr>
			
			<tr>
				<td><strong>Idioma:&nbsp;</strong></td>
				<td valign="middle" align="left">
				<select name="TESOPidioma" onChange="cambiarMascara(this.value);" tabindex="1">
					<cfloop query="rsIdioma">
						<option value="#rsIdioma.Icodigo#" <cfif isDefined("data") AND rsIdioma.Icodigo eq data.TESOPidioma>selected</cfif>>#rsIdioma.Descripcion#</option>
					</cfloop>
				</select>
				</td>
			</tr>
			<tr>
				<td><strong>Revisado:&nbsp;</strong></td>
				<td>
					<input type="text" name="TESOPRevisado" style="width:200px" tabindex="1"
						 value="<cfif CAMBIO>#HTMLEditFormat(data.TESOPRevisado)#</cfif>" onfocus="javascript:this.select();" alt="Revisado">
				</td>
			</tr>
			<tr>
				<td><strong>Aprobado:&nbsp;</strong></td>
				<td>
					<input type="text" name="TESOPAprobado" style="width:200px" tabindex="1"
						 value="<cfif CAMBIO>#HTMLEditFormat(data.TESOPAprobado)#</cfif>" onfocus="javascript:this.select();" alt="Aprobado">
				</td>
			</tr><!--- fTESOPidioma fTESOPRevisado fTESOPAprobado fTESOPRefrendado --->
			<tr>
				<td><strong>Refrendado:&nbsp;</strong></td>
				<td>
					<input type="text" name="TESOPRefrendado" style="width:200px" tabindex="1"
						 value="<cfif CAMBIO>#HTMLEditFormat(data.TESOPRefrendado)#</cfif>" onfocus="javascript:this.select();" alt="Refrendado">
				</td>
			</tr>
			<tr>
				<td colspan="5" class="formButtons" align="center">
				<cfif isdefined("data") and data.RecordCount>
					<cf_botones modo='CAMBIO' include="IrLista" includevalues="Regresar" tabindex="1">
				<cfelse>
					<cf_botones modo='ALTA' include="IrLista" includevalues="Regresar" tabindex="1"	>
				</cfif>
				</td>
			</tr>
		</table>
		
		<cfset ts = "">
		<cfif CAMBIO>
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
			  </cfinvoke>
			  <input type="hidden" name="ts_rversion" value="<cfif CAMBIO>#ts#</cfif>" size="32">
		</cfif>
		
	</form>
	</cfoutput>

	<script language="javascript" type="text/javascript">
	<!-- //
		function funcIrLista()
		{ 
			location.href = "OPProcEmi.cfm?<cfoutput>Pagina=#form.Pagina#&fTESOPidioma=<cfif isdefined('form.fTESOPidioma')>#form.fTESOPidioma#</cfif>&fTESOPRevisado=<cfif isdefined('form.fTESOPRevisado')>#form.fTESOPRevisado#</cfif>&fTESOPAprobado=<cfif isdefined('form.fTESOPAprobado')>#form.fTESOPAprobado#</cfif>&fTESOPRefrendado=<cfif isdefined('form.fTESOPRefrendado')>#form.fTESOPRefrendado#</cfif></cfoutput>"
			return false;
		}
	//-->	
	</script>
</cffunction>
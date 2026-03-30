<cf_templateheader title="Dispara Procesos">  
<cf_web_portlet_start titulo="Dispara Procesos">
<cfquery name="rsExt" datasource="sifinterfaces">
	select * 
	from SIFLD_Procesos
	where Tipo_Proceso = 1
</cfquery>
<cfquery name="rsInt" datasource="sifinterfaces">
	select * 
	from SIFLD_Procesos
	where Tipo_Proceso = 2
</cfquery>

	
<cfif isdefined("form.btnextrac") and len(form.ProcExt) and form.ProcExt NEQ -1>
	<!--- Manda Ejecutar la Interfaz Elegida con los Rangos de Fecha deseados --->
	<cfinvoke component="InterfacesLDCOM.Componentes.Extraccion.#form.ProcExt#" method="Ejecuta" />
</cfif>
<cfif isdefined("form.btninter") and len(form.ProcInt) and form.ProcInt NEQ -1>
	<!--- Manda Ejecutar la Interfaz Elegida con los Rangos de Fecha deseados --->
	<cfinvoke component="InterfacesLDCOM.Componentes.#form.ProcInt#" method="Ejecuta" />
</cfif>

<cfoutput>
<form name="DispProc" action="Dispara_Procesos_form.cfm" method="post">
	<h1 align="center"> Procesos de Extraccion </h1>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr> <td colspan="3">&nbsp;  </td> 
		</tr>
		<tr valign="top"> 
			<td align="right"><strong>Fecha desde:</strong></td>
			<td width="50%">
				<cfif isdefined('form.fechaIni') and LEN(TRIM(form.fechaIni))>
					<!--- <cf_sifcalendario name="fechaIni" value="#LSDateFormat(form.fechaIni,'dd/mm/yyyy')#"> --->
					<cf_sifcalendario form="DispProc" name="fechaIni" value="#form.fechaIni#" tabindex="1">
				<cfelse>
					<cfset LvarFecha = createdate(year(now()),month(now()),1)>
					<cf_sifcalendario form="DispProc" value="#DateFormat(LvarFecha, 'dd/mm/yyyy')#" name="fechaIni" tabindex="1"> 
				</cfif>
		  </td>
		</tr>
		<tr>
			<td align="right"><strong>Fecha hasta: </strong></td>    
			<td>
				<cfif isdefined('form.fechaFin') and LEN(TRIM(form.fechaFin))>
					<!--- <cf_sifcalendario name="fechaFin" value="#LSDateFormat(form.fechaFin,'dd/mm/yyyy')#"> --->
					<cf_sifcalendario form="DispProc" name="fechaFin" value="#form.fechaFin#" tabindex="1">
				<cfelse>
					<cf_sifcalendario form="DispProc" value="#DateFormat(Now(),'dd/mm/yyyy')#" name="fechaFin" tabindex="1"> 
				</cfif>
			</td>
		</tr>
		<tr> <td colspan="3">&nbsp;  </td> 
		<tr>
			<td align="right">
				<strong> Proceso de Extracción </strong>
			</td>
			<td colspan="2" align="left">
				<select name="ProcExt">
					<option value="-1">(Ninguna...)</option>
	                <cfloop query="rsExt">
    	                <option value="#rsExt.Proceso#">#rsExt.Descripcion#</option>
	                </cfloop>
				</select>
			</td>
		</tr>
		<tr> <td colspan="3">&nbsp;  </td> 
		<tr>
			<td colspan="3" align="center">
				<input type="submit" value="Ejecuta" name="btnExtrac"/>
			</td>
		</tr>
		<tr> <td colspan="3">&nbsp;  </td> </tr>
	</table>
	<hr width="80%" />
	<h1 align="center"> Interfaz SIF - LD </h1>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr> <td colspan="2">&nbsp;  </td> </tr>
		<tr>
			<td width="50%" align="right">
				<strong> Proceso de Interfaz </strong>			</td>
			<td width="50%" align="left">
				<select name="ProcInt">
					<option value="-1">(Ninguna...)</option>
	                <cfloop query="rsInt">
    	                <option value="#rsInt.Proceso#">#rsInt.Descripcion#</option>
	                </cfloop>
				</select>
		  </td>
		</tr>
		<tr> <td colspan="2">&nbsp;  </td> </tr>
		<tr>
			<td colspan="2" align="center">
				<input type="submit" value="Ejecuta" name="btnInter"/>
			</td>
		</tr>
		<tr> <td colspan="2">&nbsp;  </td> </tr>
	</table>
</form>
</cfoutput>

<cf_web_portlet_end>
<cf_templatefooter> 
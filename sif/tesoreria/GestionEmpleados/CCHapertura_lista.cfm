<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Codigo" default="C&oacute;digo" returnvariable="LB_Codigo" xmlfile="CCHapertura_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Responsable" default="Responsable" returnvariable="LB_Responsable" xmlfile="CCHapertura_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Moneda" default="Moneda" returnvariable="LB_Moneda" xmlfile="CCHapertura_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Filtrar" default="Filtrar" returnvariable="BTN_Filtrar" xmlfile="CCHapertura_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Descripcion" default="Descripci&oacute;n" returnvariable="LB_Descripcion" xmlfile="CCHapertura_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Estado" default="Estado" returnvariable="LB_Estado" xmlfile="CCHapertura_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Disponible" default="Disponible" returnvariable="LB_Disponible" xmlfile="CCHapertura_lista.xml">

<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfoutput>
<cfset navegacion=''>

<cfif isdefined ('url.CCHcodigo') and not isdefined('form.cod')>
	<cfset form.cod=#url.CCHcodigo#>
</cfif>

<cfif isdefined ('url.CCHresponsable') and not isdefined('form.DEid')>
	<cfset form.DEid=#url.CCHresponsable#>
</cfif>

<cfif isdefined ('url.Mcodigo') and not isdefined('form.McodigoOri')>
	<cfset form.McodigoOri=#url.Mcodigo#>
</cfif>

<!---<cfif isdefined ('url.CFunci') and not isdefined('form.CFid')>
	<cfset form.CFid=#url.CFunci#>
</cfif>--->


<cfquery name="rsSQL" datasource="#session.dsn#">
	select 	c.CCHtipo,
			case c.CCHtipo 
				when 1 then 'CAJAS CHICAS PARA COMPRAS MENORES:' 
				when 2 then 'CAJAS ESPECIALES PARA ENTRADA Y SALIDA DE EFECTIVO:' 
				when 3 then 'CAJAS EXTERNAS A GASTO EMPLEADOS:' 
				else 'TIPO DESCONOCIDO:' end as tipo,
		c.CCHcodigo,c.CCHdescripcion,c.CCHid,CCHestado, (select (DEnombre#LvarCNCT#' '#LvarCNCT#DEapellido1#LvarCNCT#' '#LvarCNCT# DEapellido2) from DatosEmpleado where DEid=c.CCHresponsable) as responsable,
		(select coalesce(CCHImontoasignado-(CCHIanticipos+CCHIgastos+CCHIreintegroEnProceso),0)
			from CCHImportes where CCHid=c.CCHid) as disponible,
		(select CFdescripcion from CFuncional where CFid=c.CFid) as funcional,
		(select Miso4217 from Monedas where Mcodigo=c.Mcodigo) as Moneda
	from CCHica c
	where 
		c.Ecodigo=#session.Ecodigo#
	<!---<cfif isdefined ('form.CFid') and len(trim(form.CFid)) gt 0>
		and c.CFid=#form.CFid#
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CFunci=" & form.CFid>
	</cfif>--->
	<cfif isdefined('form.McodigoOri') and len(trim(form.McodigoOri)) gt 0 and form.McodigoOri gt 0>
		and c.Mcodigo=#form.McodigoOri#
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Mcodigo=" & form.McodigoOri>
	</cfif>
	<cfif isdefined ('form.DEid') and len(trim(form.DEid)) gt 0>
		and CCHresponsable=#form.DEid#
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CCHresponsable=" & form.DEid>
	</cfif>
	<cfif (isdefined ('form.cod') and len(trim(form.cod)) gt 0) or (isdefined('url.CCHcodigo') and url.CCHcodigo gt 0)>
		and CCHcodigo like '%#form.cod#%'
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CCHcodigo=" & form.cod>
	</cfif>
	order by CCHtipo desc
</cfquery>
</cfoutput>
<form name="form1" method="post" action="CCHapertura.cfm">
<cfoutput>
	<table width="100%">
		<tr>
			<td align="right">
				<strong>#LB_Codigo#:</strong>
			</td>
			<td>
				<input type="text" name="cod">
			</td>
			<td nowrap="nowrap" align="right">
				<strong>#LB_Responsable#:</strong>
			</td>
			<td>
				<cf_rhempleados tabindex="1" DEid="DEid" Usucodigo="Usucodigo2">
			</td>
		</tr>
		
		<tr>
			<!---<td nowrap="nowrap" align="right">
				<strong>Centro Funcional:</strong>
			</td>
			<td>
				<cf_rhcfuncional  tabindex="1">			
			</td>--->
			<td nowrap="nowrap" align="right">
				<strong>#LB_Moneda#:</strong>
			</td>
			<td>
				<cf_sifmonedas  FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#" 
				form="form1" Mcodigo="McodigoOri"  tabindex="1" Todas="S">
			</td>
	
			<td  align="right">
				<input type="submit" value="#BTN_Filtrar#" name="filtrar">
			</td>
		</tr>
		</form>
		<tr>
			<td colspan="7">
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
					query="#rsSQL#"
					cortes="tipo"
					columnas="CCHid,CCHcodigo,CCHdescripcion,CFid,responsable,CCHestado,disponible,Moneda"
					desplegar="CCHcodigo,CCHdescripcion,responsable,CCHestado,disponible,Moneda"
					etiquetas="#LB_Codigo#,#LB_Descripcion#,#LB_Responsable#,#LB_Estado#,#LB_Disponible#,#LB_Moneda#"
					formatos="S,S,S,S,M,S"
					align="left,left,left,left,right,left"
					ira="CCHapertura.cfm"
					incluyeForm="yes"
					formName="formX"
					form_method="post"
					showEmptyListMsg="yes"
					keys="CCHid"	
					MaxRows="15"
					checkboxes="N"
					botones="Nuevo"
					navegacion="#navegacion#"
				/>		
				
				
			</td>
		</tr>
	</cfoutput>
	</table>


<cfoutput>
	<cfif isdefined ('url.speriodo') and not isdefined('form.Speriodo')>
		<cfset form.speriodo=#url.speriodo#>
	</cfif>
	
	<cfif isdefined ('url.smes') and not isdefined('form.Smes')>
		<cfset form.smes=#url.smes#>
	</cfif>
	
	<cfquery name="rsClasificaciones" datasource="#session.dsn#">
		Select  a.PCCEclaid,			
				a.PCCEcodigo,
				a.PCCEdescripcion,
				((
					select count (1) 
					from PCClasificacionD 
					where PCCEclaid= a.PCCEclaid
				)) as cantidad, 
				((
					select   count (1)  from PCClasificacionE e
						inner join PCClasificacionD d
							inner join OficinasxClasificacion o
							on o.PCCDclaid=d.PCCDclaid
							and CGCperiodo=#form.speriodo#
							and CGCmes=#form.smes#
						on d.PCCEclaid=e.PCCEclaid
					where e. PCCEclaid=a.PCCEclaid
				)) as valor
		from PCClasificacionE a			
	</cfquery>
	
	<table width="100%" cellpadding="0" cellspacing="0">
		<cfif isdefined ('form.speriodo') and len(trim(form.speriodo)) gt 0>
			<tr >
			<td><strong>Periodo:</strong>#form.speriodo#	
		</cfif>
		
		<cfif isdefined ('form.smes') and len(trim(form.smes)) gt 0>
			&nbsp;&nbsp; <strong>Mes:</strong>#form.smes#</td>
			</tr>
		</cfif>		
			<form name="form1" method="post" action="SQLPorcentajesOficinas.cfm">
				<tr>
					<td align="right">
					<input name="reg3" id="reg3" value="Regresar" type="submit" />
					</td>
				</tr>
			</form>
		<tr bgcolor="CCCCCC" >
			<td colspan="4">&nbsp;</td>
		</tr>
		<tr>
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#rsClasificaciones#"
			columnas="PCCEclaid,PCCEcodigo,PCCEdescripcion,cantidad,valor"
			desplegar="PCCEcodigo,PCCEdescripcion,cantidad,valor"		
			etiquetas="C&oacute;digo,Descripci&oacute;n,Total Detalles,Valores Registrados"
			formatos="S,S,S,S"
			align="left,left,right,right"
			ira="ListaDetalles.cfm?speriodo=#form.speriodo#&smes=#form.smes#"
			form_method="post"
			showEmptyListMsg="yes"
			incluyeForm="yes"
			formName="formEnca"
			PageIndex="1"
			keys="PCCEclaid"	
			MaxRows="12"
			showLink="yes"
			navegacion="speriodo=#form.speriodo#&smes=#form.smes#"/>		
		</tr>
	</table>
</cfoutput>
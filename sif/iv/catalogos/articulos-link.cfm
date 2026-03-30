<cfset params="">
<cfif isdefined('form.filtro_Acodigo') and form.filtro_Acodigo NEQ ''>
	<cfset params= params&'&filtro_Acodigo='&form.filtro_Acodigo>	
</cfif>
<cfif isdefined('form.filtro_Acodalterno') and form.filtro_Acodalterno NEQ ''>
	<cfset params= params&'&filtro_Acodalterno='&form.filtro_Acodalterno>	
</cfif>
<cfif isdefined('form.filtro_Adescripcion') and form.filtro_Adescripcion NEQ ''>
	<cfset params= params&'&filtro_Adescripcion='&form.filtro_Adescripcion>	
</cfif>
<cfif isdefined('form.Pagina') and form.Pagina NEQ ''>
	<cfset params= params&'&Pagina='&form.Pagina>	
</cfif>

<style type="text/css">
	.fuente {
		font-weight:bold;
	}
</style> 

<cfoutput>
<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td align="center">
			<table width="60%" cellpadding="4" cellspacing="0" align="center" bgcolor="##F5F5F5">
				<tr>
					<td class="fuente" nowrap align="center" ><a title="Trabajar con Art&iacute;culo" href="articulos-lista.cfm?<cfif isdefined ('form.Aid') and form.Aid neq '' >Aid=#form.Aid#</cfif>#params#">Datos Generales</a>
					<td align="center" width="1%">|</td>
					<td class="fuente" nowrap align="center"><a title="Trabajar con Caratcter&iacute;sticas del Art&iacute;culo" href="Caracteristicas.cfm?<cfif isdefined ('form.Aid') and form.Aid neq '' >Aid=#form.Aid#</cfif>#params#">Caracter&iacute;sticas</a>
					<td align="center" width="1%">|</td>
					<td class="fuente" nowrap align="center"><a title="Trabajar con Existencias del Art&iacute;culo" href="Existencias.cfm?<cfif isdefined ('form.Aid') and form.Aid neq '' >Aid=#form.Aid#</cfif>#params#">Existencias</a></td>
					<td align="center" width="1%">|</td>
					<td class="fuente" nowrap align="center"><a title="Trabajar con Im&aacute;genes del Art&iacute;culo" href="ImgArticulos.cfm?<cfif isdefined ('form.Aid') and form.Aid neq '' >Aid=#form.Aid#</cfif>#params#">Im&aacute;genes</a></td>
					<td align="center" width="1%">|</td>
					<td class="fuente" nowrap align="center"><a title="Trabajar con Conversi&oacute;n de Unidades" href="ConversionUnidadesArticulo.cfm?<cfif isdefined ('form.Aid') and form.Aid neq '' >Aid=#form.Aid#</cfif>#params#">Conversiones</a></td>
					<td align="center" width="1%">|</td>
					<td class="fuente" nowrap align="center"><a title="Trabajar Número de Partes" href="NumerosParte.cfm?<cfif isdefined ('form.Aid') and form.Aid neq '' >Aid=#form.Aid#</cfif>#params#">N&uacute;meros de parte</a></td>
					<td align="center" width="1%">|</td>					
					<td class="fuente" nowrap align="center"><a title="Trabajar con Costos de producción" href="CostosProduccion-Articulo.cfm?<cfif isdefined ('form.Aid') and form.Aid neq '' >Aid=#form.Aid#</cfif>#params#">Costos de Producci&oacute;n</a></td>
					<!---<td align="center" width="1%">|</td>			
					 <td class="fuente" nowrap align="center"><a title="Trabajar con otro Art&iacute;culo" href="articulos-lista.cfm?Aid=all#params#">Seleccionar Art&iacute;culo</a></td></tr> --->
			</table>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>
</cfoutput>
<!---CONSULTA PARA EL PLISTAS--->
<cfquery datasource="#session.dsn#" name="lista" maxrows="300">
select 	Speriodo,
		Smes,
		0 as valor
  from CGPeriodosProcesados pp 
  where Ecodigo = #session.ecodigo#
group by Speriodo,Smes
order by Speriodo desc, Smes desc
</cfquery>
<cfloop query="lista">
	<cfquery name="ActulizarCantidad" datasource="#session.dsn#">
		select count(1) cantidad  
			from  OficinasxClasificacion o
			where o.CGCperiodo= #lista.Speriodo#
			    and o.CGCmes= #lista.Smes#
	</cfquery>
	<cfset querysetcell(#lista#, 'valor',#ActulizarCantidad.cantidad#,#currentRow#)>
</cfloop>

<table width="100%" border="0" cellspacing="6">	
	<!---Consulta sin resultados--->
	<cfif lista.recordcount eq 0>
		<tr>
			<td align="center" bgcolor="CCCCCC">
				<strong>No existen datos en peri&oacute;dos procesados</strong><BR>
			</td>
		</tr>
	</cfif>
	<tr>
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#lista#"
			desplegar="Speriodo,Smes,valor"
			etiquetas="Peri&oacute;do,&nbsp;&nbsp;Mes,Valores Registrados"
			formatos="S,S,S"
			align="left,right,right"
			ira="PorcentajesOficinas.cfm"
			form_method="post"
			showEmptyListMsg="yes"
			keys="Speriodo,Smes"	
			MaxRows="12"
			showLink="yes"
		/>		
	</tr>
</table>